"""
Feed Products AI Agent
Uses Google Gemini for natural language understanding and SQL generation
Supports Arabic and English queries
"""

import os
import json
import sqlite3
from typing import Dict, Any, List, Optional, Tuple
from datetime import datetime

# Import configuration
from config import (
    GOOGLE_API_KEY, 
    GEMINI_MODEL, 
    DATABASE_SCHEMA, 
    EXAMPLE_QUERIES,
    ARABIC_TRANSLATIONS,
    PRODUCT_TRANSLATIONS,
    COUNTRY_TRANSLATIONS
)
from database import initialize_database, execute_query, get_database_stats
from language_utils import (
    detect_language, 
    translate_arabic_to_english,
    translate_english_to_arabic,
    extract_product_from_query,
    extract_country_from_query,
    BilingualFormatter
)

# Try to import Google Generative AI
try:
    import google.generativeai as genai
    GENAI_AVAILABLE = True
except ImportError:
    GENAI_AVAILABLE = False
    print("Warning: google-generativeai not installed. Using fallback SQL generation.")


class FeedProductsAgent:
    """
    AI Agent for querying feed products data
    Supports natural language queries in Arabic and English
    """
    
    def __init__(self, db_connection: sqlite3.Connection = None):
        """Initialize the agent with database connection and AI model"""
        
        # Initialize database
        if db_connection:
            self.db = db_connection
        else:
            self.db = initialize_database()
        
        # Initialize Google Gemini if API key is available
        self.model = None
        if GENAI_AVAILABLE and GOOGLE_API_KEY:
            try:
                genai.configure(api_key=GOOGLE_API_KEY)
                self.model = genai.GenerativeModel(GEMINI_MODEL)
                print(f"✓ Gemini model ({GEMINI_MODEL}) initialized successfully")
            except Exception as e:
                print(f"Warning: Could not initialize Gemini: {e}")
        elif not GOOGLE_API_KEY:
            print("Warning: GOOGLE_API_KEY not set. Using pattern-based SQL generation.")
        
        # Build system prompt for the AI
        self.system_prompt = self._build_system_prompt()
    
    def _build_system_prompt(self) -> str:
        """Build the system prompt for the AI model"""
        examples_text = "\n\n".join([
            f"Question: {ex['question']}\nSQL: {ex['sql']}\nExplanation: {ex['explanation']}"
            for ex in EXAMPLE_QUERIES
        ])
        
        return f"""You are a helpful AI assistant that converts natural language questions about feed products into SQL queries.
You work with a SQLite database containing feed products data for the MENA region (Middle East and North Africa).

{DATABASE_SCHEMA}

IMPORTANT RULES:
1. Always return valid SQLite SQL (not PostgreSQL)
2. Use LIKE with % for fuzzy matching on product names
3. For current prices, filter by is_active = 1
4. For historical data, look for product_code containing 'HIST'
5. When asked about "cheapest" or "best price", ORDER BY cost_per_kg ASC
6. When asked about suppliers, filter where supplier IS NOT NULL
7. Include relevant columns in SELECT for useful response
8. Use strftime for date formatting from Unix timestamps
9. Limit results to prevent huge outputs (LIMIT 10-20)
10. Handle both exact and partial product name matches

EXAMPLE QUERIES:
{examples_text}

RESPONSE FORMAT:
Return ONLY a JSON object with this structure:
{{
    "sql": "YOUR SQL QUERY HERE",
    "explanation": "Brief explanation of what the query does",
    "response_template": "Template for human-readable response"
}}

Do not include any text before or after the JSON object.
"""
    
    def _generate_sql_with_gemini(self, query: str, language: str) -> Dict[str, Any]:
        """Use Gemini to generate SQL from natural language query"""
        if not self.model:
            return self._generate_sql_fallback(query, language)
        
        try:
            # Prepare the prompt
            user_prompt = f"""Convert this question to SQL: "{query}"
            
The user's language is: {language}
If the question is in Arabic, it has been translated to: {query}

Return only the JSON response with sql, explanation, and response_template fields."""
            
            # Generate response
            response = self.model.generate_content(
                [self.system_prompt, user_prompt],
                generation_config={
                    "temperature": 0.1,
                    "max_output_tokens": 1000,
                }
            )
            
            # Parse the response
            response_text = response.text.strip()
            
            # Extract JSON from response
            if "```json" in response_text:
                response_text = response_text.split("```json")[1].split("```")[0]
            elif "```" in response_text:
                response_text = response_text.split("```")[1].split("```")[0]
            
            result = json.loads(response_text)
            return result
            
        except Exception as e:
            print(f"Gemini error: {e}")
            return self._generate_sql_fallback(query, language)
    
    def _generate_sql_fallback(self, query: str, language: str) -> Dict[str, Any]:
        """Fallback SQL generation using pattern matching"""
        query_lower = query.lower()
        
        # Extract product and country from query
        product = extract_product_from_query(query)
        country = extract_country_from_query(query)
        
        # Determine query type and generate appropriate SQL
        sql = ""
        explanation = ""
        response_template = ""
        
        # Check for "cheapest" queries
        if any(word in query_lower for word in ['cheapest', 'lowest price', 'best price', 'أرخص']):
            product_filter = f"LOWER(product_name) LIKE '%{product.lower()}%'" if product else "1=1"
            country_filter = f"supplier_country = '{country}'" if country else "1=1"
            
            sql = f"""
SELECT product_name, supplier, supplier_country, cost_per_kg, cost_currency, 
       supplier_email, supplier_phone
FROM feed_products_sample
WHERE {product_filter}
  AND {country_filter}
  AND is_active = 1
  AND supplier IS NOT NULL
ORDER BY cost_per_kg ASC
LIMIT 10
"""
            explanation = f"Finding cheapest suppliers for {product or 'products'}"
            response_template = "Here are the cheapest suppliers:"
        
        # Check for "average price" queries
        elif any(word in query_lower for word in ['average', 'mean', 'متوسط']):
            product_filter = f"LOWER(product_name) LIKE '%{product.lower()}%'" if product else "1=1"
            country_filter = f"supplier_country = '{country}'" if country else "1=1"
            
            sql = f"""
SELECT supplier_country, cost_currency,
       ROUND(AVG(cost_per_kg), 2) as avg_price,
       ROUND(MIN(cost_per_kg), 2) as min_price,
       ROUND(MAX(cost_per_kg), 2) as max_price,
       COUNT(*) as supplier_count
FROM feed_products_sample
WHERE {product_filter}
  AND {country_filter}
  AND is_active = 1
GROUP BY supplier_country, cost_currency
ORDER BY avg_price ASC
"""
            explanation = f"Calculating average prices for {product or 'products'}"
            response_template = "Average prices by country:"
        
        # Check for "best time to buy" / historical queries
        elif any(word in query_lower for word in ['best time', 'when to buy', 'historical', 'price trend', 'أفضل وقت', 'تاريخي']):
            product_filter = f"LOWER(product_name) LIKE '%{product.lower()}%'" if product else "1=1"
            country_filter = f"supplier_country = '{country}'" if country else "1=1"
            
            sql = f"""
SELECT strftime('%Y-%m', created_at, 'unixepoch') as month,
       ROUND(AVG(cost_per_kg), 2) as avg_price,
       cost_currency,
       supplier_country
FROM feed_products_sample
WHERE {product_filter}
  AND product_code LIKE '%HIST%'
  {f"AND {country_filter}" if country else ""}
GROUP BY month, supplier_country, cost_currency
ORDER BY avg_price ASC
LIMIT 10
"""
            explanation = f"Finding best time to buy {product or 'products'}"
            response_template = "Best months to buy (lowest prices):"
        
        # Check for "who sells" / "suppliers" queries
        elif any(word in query_lower for word in ['who sell', 'supplier', 'من يبيع', 'المورد']):
            product_filter = f"LOWER(product_name) LIKE '%{product.lower()}%'" if product else "1=1"
            country_filter = f"supplier_country = '{country}'" if country else "1=1"
            
            sql = f"""
SELECT DISTINCT supplier, supplier_country, supplier_email, supplier_phone,
       product_name, cost_per_kg, cost_currency
FROM feed_products_sample
WHERE {product_filter}
  AND {country_filter}
  AND is_active = 1
  AND supplier IS NOT NULL
ORDER BY supplier_country, cost_per_kg ASC
LIMIT 15
"""
            explanation = f"Finding suppliers for {product or 'products'}"
            response_template = "Here are the suppliers:"
        
        # Check for product list queries
        elif any(word in query_lower for word in ['list', 'show', 'what products', 'available', 'أظهر', 'قائمة']):
            product_type = None
            if 'fodder' in query_lower or 'علف خشن' in query_lower:
                product_type = 'Fodder'
            elif 'concentrate' in query_lower or 'علف مركز' in query_lower:
                product_type = 'Concentrate'
            elif 'additive' in query_lower or 'مضاف' in query_lower:
                product_type = 'Additive'
            
            type_filter = f"type = '{product_type}'" if product_type else "1=1"
            country_filter = f"supplier_country = '{country}'" if country else "1=1"
            
            sql = f"""
SELECT DISTINCT product_name, type, 
       ROUND(AVG(cost_per_kg), 2) as avg_price, 
       cost_currency
FROM feed_products_sample
WHERE {type_filter}
  AND {country_filter}
  AND is_active = 1
GROUP BY product_name, type, cost_currency
ORDER BY type, product_name
LIMIT 30
"""
            explanation = f"Listing {product_type or 'all'} products"
            response_template = "Available products:"
        
        # Check for restrictions queries
        elif any(word in query_lower for word in ['restriction', 'limit', 'قيود', 'حدود']):
            product_filter = f"LOWER(p.product_name) LIKE '%{product.lower()}%'" if product else "1=1"
            
            sql = f"""
SELECT p.product_name, p.type, r.species, r.sex,
       r.min_age_months, r.max_age_months,
       r.max_perc_feed, r.max_perc_conc,
       r.production_focus, r.lactation_cycle
FROM feed_products_sample p
JOIN feed_product_restrictions r ON p.id = r.product_id
WHERE {product_filter}
  AND r.is_active = 1
ORDER BY p.product_name, r.species
LIMIT 20
"""
            explanation = "Finding feeding restrictions"
            response_template = "Product restrictions:"
        
        # Default: general product search
        else:
            product_filter = f"LOWER(product_name) LIKE '%{product.lower()}%'" if product else "1=1"
            country_filter = f"supplier_country = '{country}'" if country else "1=1"
            
            sql = f"""
SELECT product_name, type, supplier, supplier_country,
       cost_per_kg, cost_currency
FROM feed_products_sample
WHERE {product_filter}
  AND {country_filter}
  AND is_active = 1
ORDER BY product_name, cost_per_kg
LIMIT 15
"""
            explanation = "General product search"
            response_template = "Search results:"
        
        return {
            "sql": sql.strip(),
            "explanation": explanation,
            "response_template": response_template
        }
    
    def _format_results(self, results: List[Dict], template: str, language: str) -> str:
        """Format query results into a human-readable response"""
        if not results:
            if language == 'ar':
                return "لم يتم العثور على نتائج"
            return "No results found"
        
        formatter = BilingualFormatter(language)
        
        # Build response
        lines = [formatter.format_header(template.replace(":", "")) + ":"]
        lines.append("")
        
        for i, row in enumerate(results, 1):
            line_parts = []
            
            # Format based on available columns
            if 'supplier' in row and row['supplier']:
                line_parts.append(f"{row['supplier']}")
            if 'product_name' in row:
                line_parts.append(f"{row['product_name']}")
            if 'supplier_country' in row:
                country = row['supplier_country']
                if language == 'ar':
                    country = COUNTRY_TRANSLATIONS.get(country, country)
                line_parts.append(f"({country})")
            if 'cost_per_kg' in row and row['cost_per_kg']:
                currency = row.get('cost_currency', 'USD')
                line_parts.append(f"- {currency} {row['cost_per_kg']:.2f}/kg")
            if 'avg_price' in row:
                currency = row.get('cost_currency', 'USD')
                line_parts.append(f"Avg: {currency} {row['avg_price']:.2f}")
            if 'min_price' in row:
                line_parts.append(f"Min: {row['min_price']:.2f}")
            if 'max_price' in row:
                line_parts.append(f"Max: {row['max_price']:.2f}")
            if 'month' in row:
                line_parts.insert(0, f"{row['month']}")
            if 'type' in row:
                ptype = row['type']
                if language == 'ar':
                    type_trans = {'Fodder': 'علف خشن', 'Concentrate': 'علف مركز', 'Additive': 'مضافات'}
                    ptype = type_trans.get(ptype, ptype)
                line_parts.append(f"[{ptype}]")
            if 'species' in row:
                line_parts.append(f"Species: {row['species']}")
            if 'max_perc_feed' in row and row['max_perc_feed']:
                line_parts.append(f"Max feed %: {row['max_perc_feed']}")
            if 'supplier_email' in row and row['supplier_email']:
                line_parts.append(f"📧 {row['supplier_email']}")
            if 'supplier_phone' in row and row['supplier_phone']:
                line_parts.append(f"📞 {row['supplier_phone']}")
            
            lines.append(f"{i}. " + " ".join(line_parts))
        
        response = "\n".join(lines)
        
        # Translate to Arabic if needed
        if language == 'ar':
            # Keep the data but translate labels
            for en, ar in ARABIC_TRANSLATIONS.items():
                response = response.replace(en, ar)
        
        return response
    
    def process_query(self, user_query: str) -> Dict[str, Any]:
        """
        Process a natural language query and return results
        
        Args:
            user_query: The user's question in English or Arabic
            
        Returns:
            Dict with keys: success, response, sql, data, language, error
        """
        result = {
            "success": False,
            "response": "",
            "sql": "",
            "data": [],
            "language": "en",
            "error": None
        }
        
        try:
            # Detect language
            language = detect_language(user_query)
            result["language"] = language
            
            # Translate Arabic to English for processing
            processed_query = user_query
            if language == 'ar':
                processed_query = translate_arabic_to_english(user_query)
            
            # Generate SQL query
            sql_result = self._generate_sql_with_gemini(processed_query, language)
            result["sql"] = sql_result.get("sql", "")
            
            # Execute the SQL query
            data, error = execute_query(self.db, result["sql"])
            
            if error:
                result["error"] = error
                result["response"] = f"Database error: {error}" if language == 'en' else f"خطأ في قاعدة البيانات: {error}"
                return result
            
            result["data"] = data
            result["success"] = True
            
            # Format the response
            result["response"] = self._format_results(
                data, 
                sql_result.get("response_template", "Results"),
                language
            )
            
        except Exception as e:
            result["error"] = str(e)
            result["response"] = f"Error processing query: {e}"
        
        return result
    
    def get_stats(self) -> Dict[str, Any]:
        """Get database statistics"""
        return get_database_stats(self.db)
    
    def close(self):
        """Close database connection"""
        if self.db:
            self.db.close()


def create_agent() -> FeedProductsAgent:
    """Factory function to create an agent instance"""
    return FeedProductsAgent()


# Example usage
if __name__ == "__main__":
    # Create agent
    agent = create_agent()
    
    # Print stats
    print("\n📊 Database Statistics:")
    stats = agent.get_stats()
    for key, value in stats.items():
        print(f"  {key}: {value}")
    
    # Test queries
    test_queries = [
        "Who is selling the cheapest Wheat Straw?",
        "من يبيع أرخص قش القمح؟",
        "What is the average price of Barley in UAE?",
        "Which suppliers sell Alfalfa hay in Saudi Arabia?",
        "When is the best time to buy Wheat Straw?",
    ]
    
    print("\n" + "="*60)
    print("🧪 Testing Queries")
    print("="*60)
    
    for query in test_queries:
        print(f"\n❓ Query: {query}")
        result = agent.process_query(query)
        print(f"🌐 Language: {result['language']}")
        print(f"💾 SQL: {result['sql'][:100]}...")
        print(f"✅ Success: {result['success']}")
        print(f"📝 Response:\n{result['response'][:500]}")
        if result['error']:
            print(f"❌ Error: {result['error']}")
        print("-"*60)
    
    agent.close()

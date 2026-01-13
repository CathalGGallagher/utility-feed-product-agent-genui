/**
 * Feed Products AI Agent
 * Uses Google Gemini for natural language understanding and SQL generation
 * Supports Arabic and English queries
 */

import { GoogleGenerativeAI } from '@google/generative-ai';
import { GOOGLE_API_KEY, GEMINI_MODEL, DATABASE_SCHEMA, EXAMPLE_QUERIES, COUNTRY_TRANSLATIONS } from './config.js';
import { getDatabase, executeQuery, getStats } from './database.js';
import { detectLanguage, translateArabicToEnglish, extractProduct, extractCountry, BilingualFormatter } from './language.js';

let genAI = null;
let model = null;

/**
 * Initialize Google Gemini
 */
function initializeGemini() {
  if (!GOOGLE_API_KEY) {
    console.log('Warning: GOOGLE_API_KEY not set. Using pattern-based SQL generation.');
    return false;
  }
  
  try {
    genAI = new GoogleGenerativeAI(GOOGLE_API_KEY);
    model = genAI.getGenerativeModel({ model: GEMINI_MODEL });
    console.log(`✓ Gemini model (${GEMINI_MODEL}) initialized successfully`);
    return true;
  } catch (error) {
    console.log(`Warning: Could not initialize Gemini: ${error.message}`);
    return false;
  }
}

/**
 * Build the system prompt for the AI model
 */
function buildSystemPrompt() {
  const examplesText = EXAMPLE_QUERIES.map(ex => 
    `Question: ${ex.question}\nSQL: ${ex.sql}\nExplanation: ${ex.explanation}`
  ).join('\n\n');
  
  return `You are a helpful AI assistant that converts natural language questions about feed products into SQL queries.
You work with a SQLite database containing feed products data for the MENA region.

${DATABASE_SCHEMA}

IMPORTANT RULES:
1. Always return valid SQLite SQL
2. Use LIKE with % for fuzzy matching on product names
3. For current prices, filter by is_active = 1
4. For historical data, look for product_code containing 'HIST'
5. When asked about "cheapest", ORDER BY cost_per_kg ASC
6. When asked about suppliers, filter where supplier IS NOT NULL
7. Use strftime for date formatting from Unix timestamps
8. Limit results (LIMIT 10-20)

EXAMPLE QUERIES:
${examplesText}

RESPONSE FORMAT:
Return ONLY a JSON object:
{
    "sql": "YOUR SQL QUERY HERE",
    "explanation": "Brief explanation",
    "response_template": "Template for human-readable response"
}`;
}

/**
 * Generate SQL using Gemini AI
 */
async function generateSqlWithGemini(query, language) {
  if (!model) {
    return generateSqlFallback(query, language);
  }
  
  try {
    const systemPrompt = buildSystemPrompt();
    const userPrompt = `Convert this question to SQL: "${query}"
The user's language is: ${language}
Return only the JSON response.`;
    
    const result = await model.generateContent([systemPrompt, userPrompt]);
    const response = result.response;
    let text = response.text().trim();
    
    // Extract JSON from response
    if (text.includes('```json')) {
      text = text.split('```json')[1].split('```')[0];
    } else if (text.includes('```')) {
      text = text.split('```')[1].split('```')[0];
    }
    
    return JSON.parse(text);
  } catch (error) {
    console.log(`Gemini error: ${error.message}`);
    return generateSqlFallback(query, language);
  }
}

/**
 * Fallback SQL generation using pattern matching
 */
function generateSqlFallback(query, language) {
  const queryLower = query.toLowerCase();
  const product = extractProduct(query);
  const country = extractCountry(query);
  
  let sql = '';
  let explanation = '';
  let responseTemplate = '';
  
  const productFilter = product ? `LOWER(product_name) LIKE '%${product.toLowerCase()}%'` : '1=1';
  const countryFilter = country ? `supplier_country = '${country}'` : '1=1';
  
  // Check for "cheapest" queries
  if (['cheapest', 'lowest price', 'best price', 'أرخص'].some(w => queryLower.includes(w))) {
    sql = `
SELECT product_name, supplier, supplier_country, cost_per_kg, cost_currency, 
       supplier_email, supplier_phone
FROM feed_products_sample
WHERE ${productFilter}
  AND ${countryFilter}
  AND is_active = 1
  AND supplier IS NOT NULL
ORDER BY cost_per_kg ASC
LIMIT 10`;
    explanation = `Finding cheapest suppliers for ${product || 'products'}`;
    responseTemplate = 'Here are the cheapest suppliers:';
  }
  // Check for "average price" queries
  else if (['average', 'mean', 'متوسط'].some(w => queryLower.includes(w))) {
    sql = `
SELECT supplier_country, cost_currency,
       ROUND(AVG(cost_per_kg), 2) as avg_price,
       ROUND(MIN(cost_per_kg), 2) as min_price,
       ROUND(MAX(cost_per_kg), 2) as max_price,
       COUNT(*) as supplier_count
FROM feed_products_sample
WHERE ${productFilter}
  AND ${countryFilter}
  AND is_active = 1
GROUP BY supplier_country, cost_currency
ORDER BY avg_price ASC`;
    explanation = `Calculating average prices for ${product || 'products'}`;
    responseTemplate = 'Average prices by country:';
  }
  // Check for "best time to buy" / historical queries
  else if (['best time', 'when to buy', 'historical', 'price trend', 'أفضل وقت', 'تاريخي'].some(w => queryLower.includes(w))) {
    sql = `
SELECT strftime('%Y-%m', created_at, 'unixepoch') as month,
       ROUND(AVG(cost_per_kg), 2) as avg_price,
       cost_currency,
       supplier_country
FROM feed_products_sample
WHERE ${productFilter}
  AND product_code LIKE '%HIST%'
  ${country ? `AND supplier_country = '${country}'` : ''}
GROUP BY month, supplier_country, cost_currency
ORDER BY avg_price ASC
LIMIT 10`;
    explanation = `Finding best time to buy ${product || 'products'}`;
    responseTemplate = 'Best months to buy (lowest prices):';
  }
  // Check for "who sells" / "suppliers" queries
  else if (['who sell', 'supplier', 'من يبيع', 'المورد'].some(w => queryLower.includes(w))) {
    sql = `
SELECT DISTINCT supplier, supplier_country, supplier_email, supplier_phone,
       product_name, cost_per_kg, cost_currency
FROM feed_products_sample
WHERE ${productFilter}
  AND ${countryFilter}
  AND is_active = 1
  AND supplier IS NOT NULL
ORDER BY supplier_country, cost_per_kg ASC
LIMIT 15`;
    explanation = `Finding suppliers for ${product || 'products'}`;
    responseTemplate = 'Here are the suppliers:';
  }
  // Check for product list queries
  else if (['list', 'show', 'what products', 'available', 'أظهر', 'قائمة'].some(w => queryLower.includes(w))) {
    let productType = null;
    if (queryLower.includes('fodder') || queryLower.includes('علف خشن')) productType = 'Fodder';
    else if (queryLower.includes('concentrate') || queryLower.includes('علف مركز')) productType = 'Concentrate';
    else if (queryLower.includes('additive') || queryLower.includes('مضاف')) productType = 'Additive';
    
    const typeFilter = productType ? `type = '${productType}'` : '1=1';
    
    sql = `
SELECT DISTINCT product_name, type, 
       ROUND(AVG(cost_per_kg), 2) as avg_price, 
       cost_currency
FROM feed_products_sample
WHERE ${typeFilter}
  AND ${countryFilter}
  AND is_active = 1
GROUP BY product_name, type, cost_currency
ORDER BY type, product_name
LIMIT 30`;
    explanation = `Listing ${productType || 'all'} products`;
    responseTemplate = 'Available products:';
  }
  // Check for restrictions queries
  else if (['restriction', 'limit', 'قيود', 'حدود'].some(w => queryLower.includes(w))) {
    const pFilter = product ? `LOWER(p.product_name) LIKE '%${product.toLowerCase()}%'` : '1=1';
    
    sql = `
SELECT p.product_name, p.type, r.species, r.sex,
       r.min_age_months, r.max_age_months,
       r.max_perc_feed, r.max_perc_conc,
       r.production_focus, r.lactation_cycle
FROM feed_products_sample p
JOIN feed_product_restrictions r ON p.id = r.product_id
WHERE ${pFilter}
  AND r.is_active = 1
ORDER BY p.product_name, r.species
LIMIT 20`;
    explanation = 'Finding feeding restrictions';
    responseTemplate = 'Product restrictions:';
  }
  // Default: general product search
  else {
    sql = `
SELECT product_name, type, supplier, supplier_country,
       cost_per_kg, cost_currency
FROM feed_products_sample
WHERE ${productFilter}
  AND ${countryFilter}
  AND is_active = 1
ORDER BY product_name, cost_per_kg
LIMIT 15`;
    explanation = 'General product search';
    responseTemplate = 'Search results:';
  }
  
  return { sql: sql.trim(), explanation, response_template: responseTemplate };
}

/**
 * Format query results into a human-readable response
 */
function formatResults(results, template, language) {
  if (!results || results.length === 0) {
    return language === 'ar' ? 'لم يتم العثور على نتائج' : 'No results found';
  }
  
  const formatter = new BilingualFormatter(language);
  const lines = [formatter.formatHeader(template.replace(':', '')) + ':', ''];
  
  results.forEach((row, index) => {
    const parts = [];
    
    if (row.supplier) parts.push(row.supplier);
    if (row.product_name) parts.push(row.product_name);
    if (row.supplier_country && row.supplier_country !== 'true' && row.supplier_country !== 'false') {
      const country = language === 'ar' ? 
        (COUNTRY_TRANSLATIONS[row.supplier_country] || row.supplier_country) : 
        row.supplier_country;
      parts.push(`(${country})`);
    }
    if (row.cost_per_kg != null) {
      const currency = row.cost_currency || 'USD';
      parts.push(`- ${currency} ${row.cost_per_kg.toFixed(2)}/kg`);
    }
    if (row.avg_price != null) {
      const currency = row.cost_currency || 'USD';
      parts.push(`Avg: ${currency} ${row.avg_price.toFixed(2)}`);
    }
    if (row.min_price != null) parts.push(`Min: ${row.min_price.toFixed(2)}`);
    if (row.max_price != null) parts.push(`Max: ${row.max_price.toFixed(2)}`);
    if (row.month && row.month.length > 3) parts.unshift(row.month);
    if (row.type) {
      const typeTrans = { 'Fodder': 'علف خشن', 'Concentrate': 'علف مركز', 'Additive': 'مضافات' };
      const ptype = language === 'ar' ? (typeTrans[row.type] || row.type) : row.type;
      parts.push(`[${ptype}]`);
    }
    if (row.species) parts.push(`Species: ${row.species}`);
    if (row.max_perc_feed != null) parts.push(`Max feed %: ${row.max_perc_feed}`);
    if (row.supplier_email) parts.push(`📧 ${row.supplier_email}`);
    if (row.supplier_phone) parts.push(`📞 ${row.supplier_phone}`);
    
    lines.push(`${index + 1}. ${parts.join(' ')}`);
  });
  
  return lines.join('\n');
}

/**
 * Main class for the Feed Products AI Agent
 */
export class FeedProductsAgent {
  constructor() {
    this.geminiAvailable = initializeGemini();
    // Ensure database is initialized
    getDatabase();
  }
  
  /**
   * Process a natural language query
   */
  async processQuery(userQuery) {
    const result = {
      success: false,
      response: '',
      sql: '',
      data: [],
      language: 'en',
      error: null
    };
    
    try {
      // Detect language
      const language = detectLanguage(userQuery);
      result.language = language;
      
      // Translate Arabic to English for processing
      let processedQuery = userQuery;
      if (language === 'ar') {
        processedQuery = translateArabicToEnglish(userQuery);
      }
      
      // Generate SQL query
      const sqlResult = await generateSqlWithGemini(processedQuery, language);
      result.sql = sqlResult.sql || '';
      
      // Execute the SQL query
      const { data, error } = executeQuery(result.sql);
      
      if (error) {
        result.error = error;
        result.response = language === 'en' 
          ? `Database error: ${error}` 
          : `خطأ في قاعدة البيانات: ${error}`;
        return result;
      }
      
      result.data = data;
      result.success = true;
      
      // Format the response
      result.response = formatResults(
        data,
        sqlResult.response_template || 'Results',
        language
      );
      
    } catch (error) {
      result.error = error.message;
      result.response = `Error processing query: ${error.message}`;
    }
    
    return result;
  }
  
  /**
   * Get database statistics
   */
  getStats() {
    return getStats();
  }
}

/**
 * Create an agent instance
 */
export function createAgent() {
  return new FeedProductsAgent();
}

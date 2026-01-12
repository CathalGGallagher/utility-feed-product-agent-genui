"""
Configuration settings for the Feed Products AI Agent
"""

import os
from pathlib import Path
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

# Base paths
BASE_DIR = Path(__file__).parent
DB_DIR = BASE_DIR.parent / "db"
DATABASE_PATH = BASE_DIR / "feed_products.db"

# Google Gemini API Configuration
GOOGLE_API_KEY = os.getenv("GOOGLE_API_KEY", "")
GEMINI_MODEL = os.getenv("GEMINI_MODEL", "gemini-1.5-flash")

# Supported languages
SUPPORTED_LANGUAGES = {
    "ar": "Arabic",
    "en": "English"
}

# Default language
DEFAULT_LANGUAGE = "en"

# Database schema information for the AI model
DATABASE_SCHEMA = """
-- Feed Products Database Schema

Table: feed_products_sample
Columns:
  - id: INTEGER PRIMARY KEY
  - product_name: TEXT (e.g., 'Alfalfa hay (mid-bloom)', 'Wheat Straw', 'Barley')
  - product_code: TEXT (e.g., 'FP-001', 'MP-UAE-001')
  - name: TEXT (same as product_name)
  - type: TEXT (one of: 'Fodder', 'Concentrate', 'Additive')
  - cost_per_kg: REAL (price per kilogram)
  - cost_currency: TEXT (e.g., 'AED', 'SAR', 'QAR', 'EGP', 'USD')
  - supplier: TEXT (supplier company name, NULL for standard products)
  - supplier_country: TEXT (e.g., 'UAE', 'Saudi Arabia', 'Egypt', 'Qatar')
  - supplier_email: TEXT
  - supplier_phone: TEXT
  - supplier_address: TEXT
  - is_standard_product: BOOLEAN (true for standard/reference products, false for market products)
  - created_at: INTEGER (Unix timestamp - used for historical price tracking)
  - is_active: BOOLEAN (true for current prices, false for historical)

Table: feed_product_restrictions
Columns:
  - id: INTEGER PRIMARY KEY
  - product_id: INTEGER (foreign key to feed_products_sample.id)
  - species: TEXT (e.g., 'cattle', 'sheep', 'goat')
  - sex: TEXT (e.g., 'male', 'female', NULL for both)
  - min_age_months: INTEGER (minimum age in months)
  - max_age_months: INTEGER (maximum age in months)
  - breeding_cycle: TEXT (e.g., 'early', 'mid', 'late')
  - lactation_cycle: TEXT (e.g., 'early', 'mid', 'late')
  - production_focus: TEXT (e.g., 'dairy', 'beef')
  - is_eligible: BOOLEAN
  - max_perc_feed: REAL (maximum percentage in total feed)
  - max_perc_conc: REAL (maximum percentage in concentrate)
  - is_active: BOOLEAN

Key Information:
- Prices are stored in local currencies (AED for UAE, SAR for Saudi Arabia, EGP for Egypt, QAR for Qatar, USD for others)
- Historical prices have is_active = false and different created_at timestamps
- Standard products (is_standard_product = true) are reference prices without supplier info
- Market products (is_standard_product = false) have supplier details
- Product types: Fodder (roughage), Concentrate (energy-dense feeds), Additive (supplements)
- created_at is Unix timestamp (seconds since Jan 1, 1970)

Currency Conversion Rates (approximate):
- 1 USD = 3.67 AED
- 1 USD = 3.75 SAR
- 1 USD = 3.64 QAR
- 1 USD = 30.9 EGP

Common Products:
- Fodders: Alfalfa hay, Wheat Straw, Barley, Corn, Soybean, Oat Hay, Triticale Silage, Wheat Bran, Cotton Seed, Beet Pulp
- Concentrates: Barley Flakes, Soya Bean Meal, Steamed Corn Flake, Corn Gluten Meal, Maize grain
- Additives: Molasses, Limestone, Salt, Urea

Note: DM (Dry Matter) values are not directly stored but fodders typically have higher DM content than silages.
"""

# Example queries for the AI to learn from
EXAMPLE_QUERIES = [
    {
        "question": "Who is selling the cheapest Wheat Straw?",
        "sql": """
SELECT supplier, supplier_country, cost_per_kg, cost_currency
FROM feed_products_sample
WHERE LOWER(product_name) LIKE '%wheat straw%'
  AND is_active = 1
  AND supplier IS NOT NULL
ORDER BY cost_per_kg ASC
LIMIT 5
""",
        "explanation": "Find market products (with suppliers) for wheat straw, ordered by price ascending"
    },
    {
        "question": "Which supplier is selling Alfalfa hay?",
        "sql": """
SELECT DISTINCT supplier, supplier_country, supplier_email, supplier_phone, cost_per_kg, cost_currency
FROM feed_products_sample
WHERE LOWER(product_name) LIKE '%alfalfa%'
  AND is_active = 1
  AND supplier IS NOT NULL
ORDER BY supplier_country, cost_per_kg
""",
        "explanation": "Find all suppliers selling alfalfa products"
    },
    {
        "question": "What is the average price of Barley?",
        "sql": """
SELECT 
  supplier_country,
  cost_currency,
  ROUND(AVG(cost_per_kg), 2) as avg_price,
  ROUND(MIN(cost_per_kg), 2) as min_price,
  ROUND(MAX(cost_per_kg), 2) as max_price,
  COUNT(*) as supplier_count
FROM feed_products_sample
WHERE LOWER(product_name) LIKE '%barley%'
  AND type = 'Fodder'
  AND is_active = 1
GROUP BY supplier_country, cost_currency
ORDER BY supplier_country
""",
        "explanation": "Calculate average, min, max prices for barley by country"
    },
    {
        "question": "When has been the best time to buy Alfalfa hay?",
        "sql": """
SELECT 
  DATE(created_at, 'unixepoch') as date,
  strftime('%Y-%m', created_at, 'unixepoch') as month,
  cost_per_kg,
  cost_currency,
  supplier_country
FROM feed_products_sample
WHERE LOWER(product_name) LIKE '%alfalfa%'
  AND product_code LIKE '%HIST%'
  AND supplier_country = 'UAE'
ORDER BY cost_per_kg ASC
LIMIT 5
""",
        "explanation": "Find historical months with lowest prices"
    },
    {
        "question": "Which products have feeding restrictions for young cattle?",
        "sql": """
SELECT 
  p.product_name,
  p.type,
  r.species,
  r.min_age_months,
  r.max_age_months,
  r.max_perc_feed,
  r.max_perc_conc
FROM feed_products_sample p
JOIN feed_product_restrictions r ON p.id = r.product_id
WHERE r.species = 'cattle'
  AND r.max_age_months <= 12
  AND r.is_active = 1
""",
        "explanation": "Find products with restrictions for young cattle (up to 12 months)"
    },
    {
        "question": "What concentrates are available in Saudi Arabia?",
        "sql": """
SELECT 
  product_name,
  supplier,
  cost_per_kg,
  cost_currency
FROM feed_products_sample
WHERE type = 'Concentrate'
  AND supplier_country = 'Saudi Arabia'
  AND is_active = 1
ORDER BY product_name, cost_per_kg
""",
        "explanation": "List all concentrate products available in Saudi Arabia"
    },
    {
        "question": "Show price trends for Wheat Straw in Saudi Arabia",
        "sql": """
SELECT 
  strftime('%Y-%m', created_at, 'unixepoch') as month,
  cost_per_kg,
  cost_currency
FROM feed_products_sample
WHERE LOWER(product_name) = 'wheat straw'
  AND supplier_country = 'Saudi Arabia'
  AND product_code LIKE '%HIST%'
ORDER BY created_at ASC
""",
        "explanation": "Get historical price data for wheat straw in Saudi Arabia"
    }
]

# Arabic translations for common responses
ARABIC_TRANSLATIONS = {
    "no_results": "لم يتم العثور على نتائج",
    "error": "حدث خطأ",
    "cheapest": "الأرخص",
    "supplier": "المورد",
    "price": "السعر",
    "country": "البلد",
    "product": "المنتج",
    "average": "المتوسط",
    "minimum": "الحد الأدنى",
    "maximum": "الحد الأقصى",
    "date": "التاريخ",
    "type": "النوع",
    "fodder": "علف خشن",
    "concentrate": "علف مركز",
    "additive": "مضافات",
    "restrictions": "القيود",
    "currency": "العملة",
    "best_time": "أفضل وقت للشراء"
}

# Product name translations (English to Arabic)
PRODUCT_TRANSLATIONS = {
    "Alfalfa hay": "تبن البرسيم",
    "Wheat Straw": "قش القمح",
    "Barley": "الشعير",
    "Corn": "الذرة",
    "Soybean": "فول الصويا",
    "Oat Hay": "تبن الشوفان",
    "Wheat Bran": "نخالة القمح",
    "Cotton Seed": "بذور القطن",
    "Molasses": "دبس السكر",
    "Limestone": "الحجر الجيري",
    "Salt": "الملح",
    "Urea": "اليوريا"
}

# Country name translations
COUNTRY_TRANSLATIONS = {
    "UAE": "الإمارات",
    "Saudi Arabia": "السعودية",
    "Egypt": "مصر",
    "Qatar": "قطر",
    "Bahrain": "البحرين",
    "Kuwait": "الكويت",
    "Oman": "عمان",
    "Jordan": "الأردن",
    "Morocco": "المغرب",
    "Tunisia": "تونس"
}

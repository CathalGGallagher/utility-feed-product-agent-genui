/**
 * Configuration settings for the Feed Products AI Agent
 */

import { config } from 'dotenv';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';

// Load environment variables
config();

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

// Base paths
export const BASE_DIR = __dirname;
export const PROJECT_DIR = join(__dirname, '..');
export const DB_DIR = join(PROJECT_DIR, '..', 'db');
export const DATABASE_PATH = join(PROJECT_DIR, 'feed_products.db');

// Google Gemini API Configuration
export const GOOGLE_API_KEY = process.env.GOOGLE_API_KEY || '';
export const GEMINI_MODEL = process.env.GEMINI_MODEL || 'gemini-1.5-flash';

// API Configuration
export const API_PORT = parseInt(process.env.API_PORT || '3000', 10);
export const API_HOST = process.env.API_HOST || '0.0.0.0';

// Supported languages
export const SUPPORTED_LANGUAGES = {
  ar: 'Arabic',
  en: 'English'
};

// Database schema information for the AI model
export const DATABASE_SCHEMA = `
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
  - is_standard_product: INTEGER (1 for standard/reference products, 0 for market products)
  - created_at: INTEGER (Unix timestamp - used for historical price tracking)
  - is_active: INTEGER (1 for current prices, 0 for historical)

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
  - is_eligible: INTEGER
  - max_perc_feed: REAL (maximum percentage in total feed)
  - max_perc_conc: REAL (maximum percentage in concentrate)
  - is_active: INTEGER

Key Information:
- Prices are stored in local currencies (AED for UAE, SAR for Saudi Arabia, EGP for Egypt, QAR for Qatar, USD for others)
- Historical prices have is_active = 0 and different created_at timestamps
- Standard products (is_standard_product = 1) are reference prices without supplier info
- Market products (is_standard_product = 0) have supplier details
- Product types: Fodder (roughage), Concentrate (energy-dense feeds), Additive (supplements)
- created_at is Unix timestamp (seconds since Jan 1, 1970)

Currency Conversion Rates (approximate):
- 1 USD = 3.67 AED
- 1 USD = 3.75 SAR
- 1 USD = 3.64 QAR
- 1 USD = 30.9 EGP
`;

// Example queries for the AI to learn from
export const EXAMPLE_QUERIES = [
  {
    question: "Who is selling the cheapest Wheat Straw?",
    sql: `SELECT supplier, supplier_country, cost_per_kg, cost_currency
FROM feed_products_sample
WHERE LOWER(product_name) LIKE '%wheat straw%'
  AND is_active = 1
  AND supplier IS NOT NULL
ORDER BY cost_per_kg ASC
LIMIT 5`,
    explanation: "Find market products (with suppliers) for wheat straw, ordered by price ascending"
  },
  {
    question: "What is the average price of Barley?",
    sql: `SELECT 
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
GROUP BY supplier_country, cost_currency`,
    explanation: "Calculate average, min, max prices for barley by country"
  },
  {
    question: "When has been the best time to buy Alfalfa hay?",
    sql: `SELECT 
  strftime('%Y-%m', created_at, 'unixepoch') as month,
  cost_per_kg,
  cost_currency,
  supplier_country
FROM feed_products_sample
WHERE LOWER(product_name) LIKE '%alfalfa%'
  AND product_code LIKE '%HIST%'
ORDER BY cost_per_kg ASC
LIMIT 5`,
    explanation: "Find historical months with lowest prices"
  }
];

// Arabic translations
export const ARABIC_TRANSLATIONS = {
  no_results: "لم يتم العثور على نتائج",
  error: "حدث خطأ",
  cheapest: "الأرخص",
  supplier: "المورد",
  price: "السعر",
  country: "البلد",
  product: "المنتج",
  average: "المتوسط",
  date: "التاريخ"
};

// Product name translations (English to Arabic)
export const PRODUCT_TRANSLATIONS = {
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
};

// Country name translations
export const COUNTRY_TRANSLATIONS = {
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
};

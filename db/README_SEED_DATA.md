# Seed Data Files for Feed Products

This directory contains SQL seed data files for populating the `feed_products_sample` and `feed_product_restrictions` tables.

## Files Overview

### 1. `seed_data.sql`
**Purpose**: Base seed data with standard products and initial market products
**Contents**:
- Standard products (`is_standard_product = true`) for all MENA countries
- Basic market products with suppliers (UAE, Saudi Arabia, Egypt, Qatar)
- Sample historical pricing for a few key products
- Initial restrictions for concentrates and additives

**Usage**: Run this first to establish baseline data

### 2. `seed_data_market_products.sql`
**Purpose**: Extended market products with more suppliers
**Contents**:
- Additional suppliers (5 UAE, 5 Saudi Arabia, etc.)
- Each supplier has 10-50 products with a mix of fodders, concentrates, and additives
- More detailed supplier information

**Usage**: Run after `seed_data.sql` to add more market products

### 3. `seed_data_market_products_extended.sql`
**Purpose**: Comprehensive generated data (programmatically created)
**Contents**:
- **30+ suppliers** across all MENA countries (UAE, Saudi Arabia, Qatar, Egypt, Bahrain, Kuwait, Oman, Jordan, Morocco, Tunisia)
- Each supplier has **10-50 products** randomly selected from available fodders, concentrates, and additives
- **Historical pricing for ALL standard products** (25 months: Jan 2024 - Jan 2026)
- **Seasonal price variations**:
  - Wheat Straw: Cheaper during harvest season (May-July)
  - Barley: Higher prices in winter (Dec-Feb)
  - Alfalfa: Higher prices in summer (Jun-Aug)
- **Additional restrictions** for concentrates and additives

**Usage**: Run after the other files to add comprehensive market data and historical pricing

### 4. `generate_market_data.py`
**Purpose**: Python script to generate extended market data
**Usage**: 
```bash
python3 db/generate_market_data.py
```
This will regenerate `seed_data_market_products_extended.sql` with fresh random data.

## Data Structure

### Product Types
- **Fodders** (17 products): Price range $0.25 - $0.50 per kg
- **Concentrates** (14 products): Price range $0.50 - $0.75 per kg  
- **Additives** (4 products): Price range $0.75 - $1.50 per kg

### Countries and Currencies
- **UAE**: AED (3.67 AED = 1 USD)
- **Saudi Arabia**: SAR (3.75 SAR = 1 USD)
- **Qatar**: QAR (3.64 QAR = 1 USD)
- **Egypt**: EGP (30.9 EGP = 1 USD)
- **Others**: USD (Bahrain, Kuwait, Oman, Jordan, Lebanon, Iraq, Morocco, Tunisia, Algeria, Libya)

### Historical Data
- **Time Period**: 25 months (January 2024 - January 2026)
- **Format**: Unix timestamps (monthly intervals)
- **Seasonal Variations**: Prices vary by month based on harvest seasons and market conditions

## Usage Instructions

### Option 1: Run All Files Sequentially
```sql
-- Step 1: Base data
\i db/seed_data.sql

-- Step 2: Extended market products
\i db/seed_data_market_products.sql

-- Step 3: Comprehensive generated data
\i db/seed_data_market_products_extended.sql
```

### Option 2: Run Only Base + Extended (Recommended)
```sql
-- Step 1: Base data
\i db/seed_data.sql

-- Step 2: Comprehensive generated data (includes everything)
\i db/seed_data_market_products_extended.sql
```

## Data Statistics

After running all files, you should have:
- **~500+ standard products** (all products × all countries)
- **~1000+ market products** (from 30+ suppliers)
- **~12,500+ historical price records** (500 products × 25 months)
- **~100+ restrictions** (for concentrates and additives)

## Query Examples

### Find cheapest wheat straw in Egypt
```sql
SELECT product_name, cost_per_kg, cost_currency, supplier, supplier_country
FROM feed_products_sample
WHERE product_name = 'Wheat Straw' 
  AND supplier_country = 'Egypt'
  AND is_active = true
ORDER BY cost_per_kg ASC
LIMIT 10;
```

### Price trends for barley over 2 years
```sql
SELECT 
  TO_TIMESTAMP(created_at) as month,
  cost_per_kg,
  cost_currency,
  supplier_country
FROM feed_products_sample
WHERE product_name = 'Barley'
  AND product_code LIKE 'FP-005-HIST%'
  AND supplier_country = 'Egypt'
ORDER BY created_at;
```

### Suppliers with best range of concentrates
```sql
SELECT 
  supplier,
  supplier_country,
  COUNT(*) as concentrate_count
FROM feed_products_sample
WHERE type = 'Concentrate'
  AND supplier IS NOT NULL
  AND is_active = true
GROUP BY supplier, supplier_country
ORDER BY concentrate_count DESC
LIMIT 10;
```

### Products with restrictions
```sql
SELECT 
  p.product_name,
  p.type,
  r.species,
  r.sex,
  r.min_age_months,
  r.max_age_months,
  r.max_perc_feed,
  r.max_perc_conc
FROM feed_products_sample p
JOIN feed_product_restrictions r ON p.id = r.product_id
WHERE r.is_active = true
ORDER BY p.product_name, r.species;
```

## Notes

- All prices are in local currencies where specified
- Historical data shows realistic seasonal price variations
- Restrictions are applied to concentrates and additives only
- Market products have unique product codes (MP-XXX-XXX-XXX format)
- Standard products use FP-XXX format
- Historical products use FP-XXX-HIST format

## Regenerating Data

To regenerate the extended data with different random values:
```bash
python3 db/generate_market_data.py
```

This will create a new `seed_data_market_products_extended.sql` file with fresh random data while maintaining the same structure and seasonal patterns.

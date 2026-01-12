CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE IF NOT EXISTS public.suppliers (
  id SERIAL PRIMARY KEY,
  external_id TEXT UNIQUE NOT NULL,
  country_code CHAR(3) NOT NULL,
  supplier_name TEXT NOT NULL,
  supplier_email TEXT,
  phone_number TEXT,
  address TEXT,
  supplier_region TEXT,
  supplier_website TEXT,
  metadata JSONB,
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT now() NOT NULL,
  updated_at TIMESTAMPTZ
);
CREATE INDEX IF NOT EXISTS idx_suppliers_active ON public.suppliers (is_active) WHERE is_active = TRUE;
CREATE INDEX IF NOT EXISTS idx_suppliers_country ON public.suppliers (country_code);


CREATE INDEX IF NOT EXISTS idx_suppliers_country ON suppliers_list (country_code);

CREATE TABLE IF NOT EXISTS suppliers_standard_product_prices (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  supplier_id INTEGER NOT NULL REFERENCES scraped_suppliers (id),
  product_id INTEGER NOT NULL,
  product_name_en TEXT NOT NULL,
  price_raw TEXT,
  currency TEXT,
  unit_size TEXT,
  instructions_en TEXT,
  instructions_local TEXT,
  cost_per_kg NUMERIC(18, 6),
  is_latest BOOLEAN NOT NULL DEFAULT TRUE,
  data_source_url TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_prices_supplier_product ON suppliers_standard_product_prices (supplier_id, product_id);
CREATE INDEX IF NOT EXISTS idx_prices_latest ON suppliers_standard_product_prices (product_id, is_latest);

CREATE TABLE IF NOT EXISTS country_product_prices (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  product_id INTEGER NOT NULL,
  product_name_en TEXT NOT NULL,
  country_code CHAR(3) NOT NULL,
  price_per_kg NUMERIC(18, 6) NOT NULL,
  currency TEXT,
  is_latest BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE UNIQUE INDEX IF NOT EXISTS idx_country_prices_latest ON country_product_prices (product_id, country_code, is_latest) WHERE is_latest = true;


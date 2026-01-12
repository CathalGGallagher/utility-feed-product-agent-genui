-- Seed Data for feed_products_sample and feed_product_restrictions
-- Generated for AI Shopping Agent testing
-- Includes standard products, market products, historical pricing, and restrictions

-- MENA Countries: UAE, Saudi Arabia, Qatar, Egypt, Bahrain, Kuwait, Oman, Jordan, Lebanon, Iraq, Morocco, Tunisia, Algeria, Libya

-- Currency conversion rates (approximate):
-- AED: 1 USD = 3.67 AED
-- SAR: 1 USD = 3.75 SAR  
-- QAR: 1 USD = 3.64 QAR
-- EGP: 1 USD = 30.9 EGP

-- Price ranges:
-- Fodders: $0.25 - $0.50 per kg
-- Concentrates: $0.50 - $0.75 per kg
-- Additives: $0.75 - $1.50 per kg

-- Historical data: 25 months from Jan 2024 to Jan 2026
-- Unix timestamps (monthly intervals starting from Jan 1, 2024)

-- ============================================================================
-- STANDARD PRODUCTS (is_standard_product = true)
-- ============================================================================

-- FODDERS (Products 1-16, 25)
-- Standard products for all MENA countries

-- UAE (AED currency)
INSERT INTO public.feed_products_sample (product_name, product_code, "name", "type", cost_per_kg, cost_currency, supplier_country, is_standard_product, created_at, is_active) VALUES
('Alfalfa hay (mid-bloom)', 'FP-001', 'Alfalfa hay (mid-bloom)', 'Fodder', 1.47, 'AED', 'UAE', true, 1704067200, true),
('Wheat Straw', 'FP-002', 'Wheat Straw', 'Fodder', 0.92, 'AED', 'UAE', true, 1704067200, true),
('Triticale Silage', 'FP-003', 'Triticale Silage', 'Fodder', 1.10, 'AED', 'UAE', true, 1704067200, true),
('Oat Hay', 'FP-004', 'Oat Hay', 'Fodder', 1.28, 'AED', 'UAE', true, 1704067200, true),
('Barley', 'FP-005', 'Barley', 'Fodder', 1.38, 'AED', 'UAE', true, 1704067200, true),
('Corn', 'FP-006', 'Corn', 'Fodder', 1.32, 'AED', 'UAE', true, 1704067200, true),
('Soybean', 'FP-007', 'Soybean', 'Fodder', 1.65, 'AED', 'UAE', true, 1704067200, true),
('Wheat', 'FP-008', 'Wheat', 'Fodder', 1.35, 'AED', 'UAE', true, 1704067200, true),
('Cotton Seed', 'FP-009', 'Cotton Seed', 'Fodder', 1.47, 'AED', 'UAE', true, 1704067200, true),
('Beet Pulp', 'FP-010', 'Beet Pulp', 'Fodder', 1.20, 'AED', 'UAE', true, 1704067200, true),
('Wheat Bran', 'FP-011', 'Wheat Bran', 'Fodder', 0.92, 'AED', 'UAE', true, 1704067200, true),
('White Hay', 'FP-012', 'White Hay', 'Fodder', 1.10, 'AED', 'UAE', true, 1704067200, true),
('Red Hay', 'FP-013', 'Red Hay', 'Fodder', 1.10, 'AED', 'UAE', true, 1704067200, true),
('Alfalfa', 'FP-014', 'Alfalfa', 'Fodder', 1.47, 'AED', 'UAE', true, 1704067200, true),
('Fermented Corn', 'FP-015', 'Fermented Corn', 'Fodder', 1.38, 'AED', 'UAE', true, 1704067200, true),
('Soybean Hulls', 'FP-016', 'Soybean Hulls', 'Fodder', 1.20, 'AED', 'UAE', true, 1704067200, true),
('Alfalfa Hay', 'FP-025', 'Alfalfa Hay', 'Fodder', 1.47, 'AED', 'UAE', true, 1704067200, true);

-- Saudi Arabia (SAR currency)
INSERT INTO public.feed_products_sample (product_name, product_code, "name", "type", cost_per_kg, cost_currency, supplier_country, is_standard_product, created_at, is_active) VALUES
('Alfalfa hay (mid-bloom)', 'FP-001', 'Alfalfa hay (mid-bloom)', 'Fodder', 1.50, 'SAR', 'Saudi Arabia', true, 1704067200, true),
('Wheat Straw', 'FP-002', 'Wheat Straw', 'Fodder', 0.94, 'SAR', 'Saudi Arabia', true, 1704067200, true),
('Triticale Silage', 'FP-003', 'Triticale Silage', 'Fodder', 1.13, 'SAR', 'Saudi Arabia', true, 1704067200, true),
('Oat Hay', 'FP-004', 'Oat Hay', 'Fodder', 1.31, 'SAR', 'Saudi Arabia', true, 1704067200, true),
('Barley', 'FP-005', 'Barley', 'Fodder', 1.41, 'SAR', 'Saudi Arabia', true, 1704067200, true),
('Corn', 'FP-006', 'Corn', 'Fodder', 1.35, 'SAR', 'Saudi Arabia', true, 1704067200, true),
('Soybean', 'FP-007', 'Soybean', 'Fodder', 1.69, 'SAR', 'Saudi Arabia', true, 1704067200, true),
('Wheat', 'FP-008', 'Wheat', 'Fodder', 1.38, 'SAR', 'Saudi Arabia', true, 1704067200, true),
('Cotton Seed', 'FP-009', 'Cotton Seed', 'Fodder', 1.50, 'SAR', 'Saudi Arabia', true, 1704067200, true),
('Beet Pulp', 'FP-010', 'Beet Pulp', 'Fodder', 1.23, 'SAR', 'Saudi Arabia', true, 1704067200, true),
('Wheat Bran', 'FP-011', 'Wheat Bran', 'Fodder', 0.94, 'SAR', 'Saudi Arabia', true, 1704067200, true),
('White Hay', 'FP-012', 'White Hay', 'Fodder', 1.13, 'SAR', 'Saudi Arabia', true, 1704067200, true),
('Red Hay', 'FP-013', 'Red Hay', 'Fodder', 1.13, 'SAR', 'Saudi Arabia', true, 1704067200, true),
('Alfalfa', 'FP-014', 'Alfalfa', 'Fodder', 1.50, 'SAR', 'Saudi Arabia', true, 1704067200, true),
('Fermented Corn', 'FP-015', 'Fermented Corn', 'Fodder', 1.41, 'SAR', 'Saudi Arabia', true, 1704067200, true),
('Soybean Hulls', 'FP-016', 'Soybean Hulls', 'Fodder', 1.23, 'SAR', 'Saudi Arabia', true, 1704067200, true),
('Alfalfa Hay', 'FP-025', 'Alfalfa Hay', 'Fodder', 1.50, 'SAR', 'Saudi Arabia', true, 1704067200, true);

-- Qatar (QAR currency)
INSERT INTO public.feed_products_sample (product_name, product_code, "name", "type", cost_per_kg, cost_currency, supplier_country, is_standard_product, created_at, is_active) VALUES
('Alfalfa hay (mid-bloom)', 'FP-001', 'Alfalfa hay (mid-bloom)', 'Fodder', 1.46, 'QAR', 'Qatar', true, 1704067200, true),
('Wheat Straw', 'FP-002', 'Wheat Straw', 'Fodder', 0.91, 'QAR', 'Qatar', true, 1704067200, true),
('Triticale Silage', 'FP-003', 'Triticale Silage', 'Fodder', 1.09, 'QAR', 'Qatar', true, 1704067200, true),
('Oat Hay', 'FP-004', 'Oat Hay', 'Fodder', 1.27, 'QAR', 'Qatar', true, 1704067200, true),
('Barley', 'FP-005', 'Barley', 'Fodder', 1.37, 'QAR', 'Qatar', true, 1704067200, true),
('Corn', 'FP-006', 'Corn', 'Fodder', 1.31, 'QAR', 'Qatar', true, 1704067200, true),
('Soybean', 'FP-007', 'Soybean', 'Fodder', 1.64, 'QAR', 'Qatar', true, 1704067200, true),
('Wheat', 'FP-008', 'Wheat', 'Fodder', 1.34, 'QAR', 'Qatar', true, 1704067200, true),
('Cotton Seed', 'FP-009', 'Cotton Seed', 'Fodder', 1.46, 'QAR', 'Qatar', true, 1704067200, true),
('Beet Pulp', 'FP-010', 'Beet Pulp', 'Fodder', 1.19, 'QAR', 'Qatar', true, 1704067200, true),
('Wheat Bran', 'FP-011', 'Wheat Bran', 'Fodder', 0.91, 'QAR', 'Qatar', true, 1704067200, true),
('White Hay', 'FP-012', 'White Hay', 'Fodder', 1.09, 'QAR', 'Qatar', true, 1704067200, true),
('Red Hay', 'FP-013', 'Red Hay', 'Fodder', 1.09, 'QAR', 'Qatar', true, 1704067200, true),
('Alfalfa', 'FP-014', 'Alfalfa', 'Fodder', 1.46, 'QAR', 'Qatar', true, 1704067200, true),
('Fermented Corn', 'FP-015', 'Fermented Corn', 'Fodder', 1.37, 'QAR', 'Qatar', true, 1704067200, true),
('Soybean Hulls', 'FP-016', 'Soybean Hulls', 'Fodder', 1.19, 'QAR', 'Qatar', true, 1704067200, true),
('Alfalfa Hay', 'FP-025', 'Alfalfa Hay', 'Fodder', 1.46, 'QAR', 'Qatar', true, 1704067200, true);

-- Egypt (EGP currency)
INSERT INTO public.feed_products_sample (product_name, product_code, "name", "type", cost_per_kg, cost_currency, supplier_country, is_standard_product, created_at, is_active) VALUES
('Alfalfa hay (mid-bloom)', 'FP-001', 'Alfalfa hay (mid-bloom)', 'Fodder', 12.36, 'EGP', 'Egypt', true, 1704067200, true),
('Wheat Straw', 'FP-002', 'Wheat Straw', 'Fodder', 7.73, 'EGP', 'Egypt', true, 1704067200, true),
('Triticale Silage', 'FP-003', 'Triticale Silage', 'Fodder', 9.27, 'EGP', 'Egypt', true, 1704067200, true),
('Oat Hay', 'FP-004', 'Oat Hay', 'Fodder', 10.82, 'EGP', 'Egypt', true, 1704067200, true),
('Barley', 'FP-005', 'Barley', 'Fodder', 11.64, 'EGP', 'Egypt', true, 1704067200, true),
('Corn', 'FP-006', 'Corn', 'Fodder', 11.13, 'EGP', 'Egypt', true, 1704067200, true),
('Soybean', 'FP-007', 'Soybean', 'Fodder', 13.87, 'EGP', 'Egypt', true, 1704067200, true),
('Wheat', 'FP-008', 'Wheat', 'Fodder', 11.36, 'EGP', 'Egypt', true, 1704067200, true),
('Cotton Seed', 'FP-009', 'Cotton Seed', 'Fodder', 12.36, 'EGP', 'Egypt', true, 1704067200, true),
('Beet Pulp', 'FP-010', 'Beet Pulp', 'Fodder', 10.09, 'EGP', 'Egypt', true, 1704067200, true),
('Wheat Bran', 'FP-011', 'Wheat Bran', 'Fodder', 7.73, 'EGP', 'Egypt', true, 1704067200, true),
('White Hay', 'FP-012', 'White Hay', 'Fodder', 9.27, 'EGP', 'Egypt', true, 1704067200, true),
('Red Hay', 'FP-013', 'Red Hay', 'Fodder', 9.27, 'EGP', 'Egypt', true, 1704067200, true),
('Alfalfa', 'FP-014', 'Alfalfa', 'Fodder', 12.36, 'EGP', 'Egypt', true, 1704067200, true),
('Fermented Corn', 'FP-015', 'Fermented Corn', 'Fodder', 11.64, 'EGP', 'Egypt', true, 1704067200, true),
('Soybean Hulls', 'FP-016', 'Soybean Hulls', 'Fodder', 10.09, 'EGP', 'Egypt', true, 1704067200, true),
('Alfalfa Hay', 'FP-025', 'Alfalfa Hay', 'Fodder', 12.36, 'EGP', 'Egypt', true, 1704067200, true);

-- Other MENA countries (USD currency): Bahrain, Kuwait, Oman, Jordan, Lebanon, Iraq, Morocco, Tunisia, Algeria, Libya
INSERT INTO public.feed_products_sample (product_name, product_code, "name", "type", cost_per_kg, cost_currency, supplier_country, is_standard_product, created_at, is_active) VALUES
('Alfalfa hay (mid-bloom)', 'FP-001', 'Alfalfa hay (mid-bloom)', 'Fodder', 0.40, 'USD', 'Bahrain', true, 1704067200, true),
('Wheat Straw', 'FP-002', 'Wheat Straw', 'Fodder', 0.25, 'USD', 'Bahrain', true, 1704067200, true),
('Barley', 'FP-005', 'Barley', 'Fodder', 0.38, 'USD', 'Bahrain', true, 1704067200, true),
('Alfalfa hay (mid-bloom)', 'FP-001', 'Alfalfa hay (mid-bloom)', 'Fodder', 0.40, 'USD', 'Kuwait', true, 1704067200, true),
('Wheat Straw', 'FP-002', 'Wheat Straw', 'Fodder', 0.25, 'USD', 'Kuwait', true, 1704067200, true),
('Barley', 'FP-005', 'Barley', 'Fodder', 0.38, 'USD', 'Kuwait', true, 1704067200, true),
('Alfalfa hay (mid-bloom)', 'FP-001', 'Alfalfa hay (mid-bloom)', 'Fodder', 0.40, 'USD', 'Oman', true, 1704067200, true),
('Wheat Straw', 'FP-002', 'Wheat Straw', 'Fodder', 0.25, 'USD', 'Oman', true, 1704067200, true),
('Barley', 'FP-005', 'Barley', 'Fodder', 0.38, 'USD', 'Oman', true, 1704067200, true),
('Alfalfa hay (mid-bloom)', 'FP-001', 'Alfalfa hay (mid-bloom)', 'Fodder', 0.40, 'USD', 'Jordan', true, 1704067200, true),
('Wheat Straw', 'FP-002', 'Wheat Straw', 'Fodder', 0.25, 'USD', 'Jordan', true, 1704067200, true),
('Barley', 'FP-005', 'Barley', 'Fodder', 0.38, 'USD', 'Jordan', true, 1704067200, true),
('Alfalfa hay (mid-bloom)', 'FP-001', 'Alfalfa hay (mid-bloom)', 'Fodder', 0.40, 'USD', 'Lebanon', true, 1704067200, true),
('Wheat Straw', 'FP-002', 'Wheat Straw', 'Fodder', 0.25, 'USD', 'Lebanon', true, 1704067200, true),
('Barley', 'FP-005', 'Barley', 'Fodder', 0.38, 'USD', 'Lebanon', true, 1704067200, true),
('Alfalfa hay (mid-bloom)', 'FP-001', 'Alfalfa hay (mid-bloom)', 'Fodder', 0.40, 'USD', 'Iraq', true, 1704067200, true),
('Wheat Straw', 'FP-002', 'Wheat Straw', 'Fodder', 0.25, 'USD', 'Iraq', true, 1704067200, true),
('Barley', 'FP-005', 'Barley', 'Fodder', 0.38, 'USD', 'Iraq', true, 1704067200, true),
('Alfalfa hay (mid-bloom)', 'FP-001', 'Alfalfa hay (mid-bloom)', 'Fodder', 0.40, 'USD', 'Morocco', true, 1704067200, true),
('Wheat Straw', 'FP-002', 'Wheat Straw', 'Fodder', 0.25, 'USD', 'Morocco', true, 1704067200, true),
('Barley', 'FP-005', 'Barley', 'Fodder', 0.38, 'USD', 'Morocco', true, 1704067200, true),
('Alfalfa hay (mid-bloom)', 'FP-001', 'Alfalfa hay (mid-bloom)', 'Fodder', 0.40, 'USD', 'Tunisia', true, 1704067200, true),
('Wheat Straw', 'FP-002', 'Wheat Straw', 'Fodder', 0.25, 'USD', 'Tunisia', true, 1704067200, true),
('Barley', 'FP-005', 'Barley', 'Fodder', 0.38, 'USD', 'Tunisia', true, 1704067200, true),
('Alfalfa hay (mid-bloom)', 'FP-001', 'Alfalfa hay (mid-bloom)', 'Fodder', 0.40, 'USD', 'Algeria', true, 1704067200, true),
('Wheat Straw', 'FP-002', 'Wheat Straw', 'Fodder', 0.25, 'USD', 'Algeria', true, 1704067200, true),
('Barley', 'FP-005', 'Barley', 'Fodder', 0.38, 'USD', 'Algeria', true, 1704067200, true),
('Alfalfa hay (mid-bloom)', 'FP-001', 'Alfalfa hay (mid-bloom)', 'Fodder', 0.40, 'USD', 'Libya', true, 1704067200, true),
('Wheat Straw', 'FP-002', 'Wheat Straw', 'Fodder', 0.25, 'USD', 'Libya', true, 1704067200, true),
('Barley', 'FP-005', 'Barley', 'Fodder', 0.38, 'USD', 'Libya', true, 1704067200, true);

-- CONCENTRATES (Products 17-23, 26-33)
-- Standard products for key MENA countries

-- UAE Concentrates
INSERT INTO public.feed_products_sample (product_name, product_code, "name", "type", cost_per_kg, cost_currency, supplier_country, is_standard_product, created_at, is_active) VALUES
('Barley - raw', 'FP-017', 'Barley - raw', 'Concentrate', 2.20, 'AED', 'UAE', true, 1704067200, true),
('Barley - Flakes', 'FP-018', 'Barley - Flakes', 'Concentrate', 2.38, 'AED', 'UAE', true, 1704067200, true),
('Soya Bean Meal', 'FP-019', 'Soya Bean Meal', 'Concentrate', 2.57, 'AED', 'UAE', true, 1704067200, true),
('Steamed Corn Flake', 'FP-020', 'Steamed Corn Flake', 'Concentrate', 2.45, 'AED', 'UAE', true, 1704067200, true),
('Steamed Barley Flakes', 'FP-021', 'Steamed Barley Flakes', 'Concentrate', 2.50, 'AED', 'UAE', true, 1704067200, true),
('Barley grain', 'FP-022', 'Barley grain', 'Concentrate', 2.20, 'AED', 'UAE', true, 1704067200, true),
('Soybean husk', 'FP-023', 'Soybean husk', 'Concentrate', 2.20, 'AED', 'UAE', true, 1704067200, true),
('Wheat grain', 'FP-026', 'Wheat grain', 'Concentrate', 2.38, 'AED', 'UAE', true, 1704067200, true),
('Cotton meal', 'FP-027', 'Cotton meal', 'Concentrate', 2.45, 'AED', 'UAE', true, 1704067200, true),
('Beetroot pellets', 'FP-028', 'Beetroot pellets', 'Concentrate', 2.38, 'AED', 'UAE', true, 1704067200, true),
('Maize grain', 'FP-030', 'Maize grain', 'Concentrate', 2.35, 'AED', 'UAE', true, 1704067200, true),
('Corn Silage', 'FP-031', 'Corn Silage', 'Concentrate', 2.45, 'AED', 'UAE', true, 1704067200, true),
('Corn Gluten Meal', 'FP-032', 'Corn Gluten Meal', 'Concentrate', 2.57, 'AED', 'UAE', true, 1704067200, true),
('Sesame seed husk', 'FP-033', 'Sesame seed husk', 'Concentrate', 2.20, 'AED', 'UAE', true, 1704067200, true);

-- Saudi Arabia Concentrates
INSERT INTO public.feed_products_sample (product_name, product_code, "name", "type", cost_per_kg, cost_currency, supplier_country, is_standard_product, created_at, is_active) VALUES
('Barley - raw', 'FP-017', 'Barley - raw', 'Concentrate', 2.25, 'SAR', 'Saudi Arabia', true, 1704067200, true),
('Barley - Flakes', 'FP-018', 'Barley - Flakes', 'Concentrate', 2.44, 'SAR', 'Saudi Arabia', true, 1704067200, true),
('Soya Bean Meal', 'FP-019', 'Soya Bean Meal', 'Concentrate', 2.63, 'SAR', 'Saudi Arabia', true, 1704067200, true),
('Steamed Corn Flake', 'FP-020', 'Steamed Corn Flake', 'Concentrate', 2.50, 'SAR', 'Saudi Arabia', true, 1704067200, true),
('Steamed Barley Flakes', 'FP-021', 'Steamed Barley Flakes', 'Concentrate', 2.56, 'SAR', 'Saudi Arabia', true, 1704067200, true),
('Barley grain', 'FP-022', 'Barley grain', 'Concentrate', 2.25, 'SAR', 'Saudi Arabia', true, 1704067200, true),
('Soybean husk', 'FP-023', 'Soybean husk', 'Concentrate', 2.25, 'SAR', 'Saudi Arabia', true, 1704067200, true),
('Wheat grain', 'FP-026', 'Wheat grain', 'Concentrate', 2.44, 'SAR', 'Saudi Arabia', true, 1704067200, true),
('Cotton meal', 'FP-027', 'Cotton meal', 'Concentrate', 2.50, 'SAR', 'Saudi Arabia', true, 1704067200, true),
('Beetroot pellets', 'FP-028', 'Beetroot pellets', 'Concentrate', 2.44, 'SAR', 'Saudi Arabia', true, 1704067200, true),
('Maize grain', 'FP-030', 'Maize grain', 'Concentrate', 2.40, 'SAR', 'Saudi Arabia', true, 1704067200, true),
('Corn Silage', 'FP-031', 'Corn Silage', 'Concentrate', 2.50, 'SAR', 'Saudi Arabia', true, 1704067200, true),
('Corn Gluten Meal', 'FP-032', 'Corn Gluten Meal', 'Concentrate', 2.63, 'SAR', 'Saudi Arabia', true, 1704067200, true),
('Sesame seed husk', 'FP-033', 'Sesame seed husk', 'Concentrate', 2.25, 'SAR', 'Saudi Arabia', true, 1704067200, true);

-- Egypt Concentrates
INSERT INTO public.feed_products_sample (product_name, product_code, "name", "type", cost_per_kg, cost_currency, supplier_country, is_standard_product, created_at, is_active) VALUES
('Barley - raw', 'FP-017', 'Barley - raw', 'Concentrate', 18.54, 'EGP', 'Egypt', true, 1704067200, true),
('Barley - Flakes', 'FP-018', 'Barley - Flakes', 'Concentrate', 20.05, 'EGP', 'Egypt', true, 1704067200, true),
('Soya Bean Meal', 'FP-019', 'Soya Bean Meal', 'Concentrate', 21.68, 'EGP', 'Egypt', true, 1704067200, true),
('Steamed Corn Flake', 'FP-020', 'Steamed Corn Flake', 'Concentrate', 20.63, 'EGP', 'Egypt', true, 1704067200, true),
('Steamed Barley Flakes', 'FP-021', 'Steamed Barley Flakes', 'Concentrate', 21.05, 'EGP', 'Egypt', true, 1704067200, true),
('Barley grain', 'FP-022', 'Barley grain', 'Concentrate', 18.54, 'EGP', 'Egypt', true, 1704067200, true),
('Soybean husk', 'FP-023', 'Soybean husk', 'Concentrate', 18.54, 'EGP', 'Egypt', true, 1704067200, true),
('Wheat grain', 'FP-026', 'Wheat grain', 'Concentrate', 20.05, 'EGP', 'Egypt', true, 1704067200, true),
('Cotton meal', 'FP-027', 'Cotton meal', 'Concentrate', 20.63, 'EGP', 'Egypt', true, 1704067200, true),
('Beetroot pellets', 'FP-028', 'Beetroot pellets', 'Concentrate', 20.05, 'EGP', 'Egypt', true, 1704067200, true),
('Maize grain', 'FP-030', 'Maize grain', 'Concentrate', 19.82, 'EGP', 'Egypt', true, 1704067200, true),
('Corn Silage', 'FP-031', 'Corn Silage', 'Concentrate', 20.63, 'EGP', 'Egypt', true, 1704067200, true),
('Corn Gluten Meal', 'FP-032', 'Corn Gluten Meal', 'Concentrate', 21.68, 'EGP', 'Egypt', true, 1704067200, true),
('Sesame seed husk', 'FP-033', 'Sesame seed husk', 'Concentrate', 18.54, 'EGP', 'Egypt', true, 1704067200, true);

-- ADDITIVES (Products 24, 29, 34, 35)
-- Standard products for key MENA countries

-- UAE Additives
INSERT INTO public.feed_products_sample (product_name, product_code, "name", "type", cost_per_kg, cost_currency, supplier_country, is_standard_product, created_at, is_active) VALUES
('Molasses', 'FP-024', 'Molasses', 'Additive', 3.30, 'AED', 'UAE', true, 1704067200, true),
('Limestone', 'FP-029', 'Limestone', 'Additive', 2.94, 'AED', 'UAE', true, 1704067200, true),
('Salt', 'FP-034', 'Salt', 'Additive', 2.75, 'AED', 'UAE', true, 1704067200, true),
('Urea', 'FP-035', 'Urea', 'Additive', 4.41, 'AED', 'UAE', true, 1704067200, true);

-- Saudi Arabia Additives
INSERT INTO public.feed_products_sample (product_name, product_code, "name", "type", cost_per_kg, cost_currency, supplier_country, is_standard_product, created_at, is_active) VALUES
('Molasses', 'FP-024', 'Molasses', 'Additive', 3.38, 'SAR', 'Saudi Arabia', true, 1704067200, true),
('Limestone', 'FP-029', 'Limestone', 'Additive', 3.00, 'SAR', 'Saudi Arabia', true, 1704067200, true),
('Salt', 'FP-034', 'Salt', 'Additive', 2.81, 'SAR', 'Saudi Arabia', true, 1704067200, true),
('Urea', 'FP-035', 'Urea', 'Additive', 4.50, 'SAR', 'Saudi Arabia', true, 1704067200, true);

-- Egypt Additives
INSERT INTO public.feed_products_sample (product_name, product_code, "name", "type", cost_per_kg, cost_currency, supplier_country, is_standard_product, created_at, is_active) VALUES
('Molasses', 'FP-024', 'Molasses', 'Additive', 27.81, 'EGP', 'Egypt', true, 1704067200, true),
('Limestone', 'FP-029', 'Limestone', 'Additive', 24.72, 'EGP', 'Egypt', true, 1704067200, true),
('Salt', 'FP-034', 'Salt', 'Additive', 23.18, 'EGP', 'Egypt', true, 1704067200, true),
('Urea', 'FP-035', 'Urea', 'Additive', 37.35, 'EGP', 'Egypt', true, 1704067200, true);

-- ============================================================================
-- MARKET PRODUCTS (is_standard_product = false) - With Suppliers
-- ============================================================================

-- Market products for UAE
INSERT INTO public.feed_products_sample (product_name, product_code, "name", "type", cost_per_kg, cost_currency, supplier, supplier_country, supplier_email, supplier_phone, supplier_address, is_standard_product, created_at, is_active) VALUES
('Premium Alfalfa Hay', 'MP-UAE-001', 'Premium Alfalfa Hay', 'Fodder', 1.65, 'AED', 'Al Ain Feed Company', 'UAE', 'info@alainfeed.ae', '+971-3-123-4567', 'Al Ain Industrial Area, UAE', false, 1704067200, true),
('Organic Wheat Straw', 'MP-UAE-002', 'Organic Wheat Straw', 'Fodder', 1.10, 'AED', 'Dubai Agricultural Supplies', 'UAE', 'sales@dubaiagri.ae', '+971-4-234-5678', 'Dubai, UAE', false, 1704067200, true),
('Premium Barley Concentrate', 'MP-UAE-003', 'Premium Barley Concentrate', 'Concentrate', 2.75, 'AED', 'Sharjah Feed Mills', 'UAE', 'contact@sharjahfeed.ae', '+971-6-345-6789', 'Sharjah, UAE', false, 1704067200, true),
('High-Grade Molasses', 'MP-UAE-004', 'High-Grade Molasses', 'Additive', 3.67, 'AED', 'Abu Dhabi Feed Solutions', 'UAE', 'info@adfeedsolutions.ae', '+971-2-456-7890', 'Abu Dhabi, UAE', false, 1704067200, true);

-- Market products for Saudi Arabia
INSERT INTO public.feed_products_sample (product_name, product_code, "name", "type", cost_per_kg, cost_currency, supplier, supplier_country, supplier_email, supplier_phone, supplier_address, is_standard_product, created_at, is_active) VALUES
('Riyadh Premium Alfalfa', 'MP-SA-001', 'Riyadh Premium Alfalfa', 'Fodder', 1.69, 'SAR', 'Riyadh Feed Corporation', 'Saudi Arabia', 'sales@riyadhfeed.sa', '+966-11-123-4567', 'Riyadh, Saudi Arabia', false, 1704067200, true),
('Jeddah Wheat Straw', 'MP-SA-002', 'Jeddah Wheat Straw', 'Fodder', 0.98, 'SAR', 'Jeddah Agricultural Co', 'Saudi Arabia', 'info@jeddahagri.sa', '+966-12-234-5678', 'Jeddah, Saudi Arabia', false, 1704067200, true),
('Dammam Barley Flakes', 'MP-SA-003', 'Dammam Barley Flakes', 'Concentrate', 2.81, 'SAR', 'Dammam Feed Industries', 'Saudi Arabia', 'contact@dammamfeed.sa', '+966-13-345-6789', 'Dammam, Saudi Arabia', false, 1704067200, true),
('Saudi Premium Salt', 'MP-SA-004', 'Saudi Premium Salt', 'Additive', 3.00, 'SAR', 'Saudi Mineral Products', 'Saudi Arabia', 'sales@saudiminerals.sa', '+966-11-456-7890', 'Riyadh, Saudi Arabia', false, 1704067200, true);

-- Market products for Egypt
INSERT INTO public.feed_products_sample (product_name, product_code, "name", "type", cost_per_kg, cost_currency, supplier, supplier_country, supplier_email, supplier_phone, supplier_address, is_standard_product, created_at, is_active) VALUES
('Cairo Premium Alfalfa', 'MP-EG-001', 'Cairo Premium Alfalfa', 'Fodder', 13.87, 'EGP', 'Cairo Feed Company', 'Egypt', 'info@cairofeed.eg', '+20-2-1234-5678', 'Cairo, Egypt', false, 1704067200, true),
('Alexandria Wheat Straw', 'MP-EG-002', 'Alexandria Wheat Straw', 'Fodder', 8.66, 'EGP', 'Alexandria Agricultural Supplies', 'Egypt', 'sales@alexagri.eg', '+20-3-2345-6789', 'Alexandria, Egypt', false, 1704067200, true),
('Giza Barley Concentrate', 'MP-EG-003', 'Giza Barley Concentrate', 'Concentrate', 22.75, 'EGP', 'Giza Feed Mills', 'Egypt', 'contact@gizafeed.eg', '+20-2-3456-7890', 'Giza, Egypt', false, 1704067200, true),
('Delta Molasses', 'MP-EG-004', 'Delta Molasses', 'Additive', 30.90, 'EGP', 'Nile Delta Feed Solutions', 'Egypt', 'info@niledelta.eg', '+20-40-4567-8901', 'Mansoura, Egypt', false, 1704067200, true);

-- Market products for Qatar
INSERT INTO public.feed_products_sample (product_name, product_code, "name", "type", cost_per_kg, cost_currency, supplier, supplier_country, supplier_email, supplier_phone, supplier_address, is_standard_product, created_at, is_active) VALUES
('Doha Premium Alfalfa', 'MP-QA-001', 'Doha Premium Alfalfa', 'Fodder', 1.64, 'QAR', 'Doha Feed Company', 'Qatar', 'info@dohafeed.qa', '+974-4-123-4567', 'Doha, Qatar', false, 1704067200, true),
('Qatar Wheat Straw', 'MP-QA-002', 'Qatar Wheat Straw', 'Fodder', 0.91, 'QAR', 'Qatar Agricultural Supplies', 'Qatar', 'sales@qataragri.qa', '+974-4-234-5678', 'Doha, Qatar', false, 1704067200, true);

-- ============================================================================
-- HISTORICAL PRICING DATA (25 months: Jan 2024 - Jan 2026)
-- ============================================================================

-- Historical prices for key products showing price movements
-- Using monthly Unix timestamps starting from Jan 1, 2024 (1704067200)

-- Note: We'll create historical entries by inserting products with different created_at timestamps
-- For demonstration, we'll add historical data for a few key products in major countries

-- UAE Alfalfa Hay - Historical pricing (showing price trend)
-- Note: Only the latest price (Jan 2026) is active; all historical prices are inactive
INSERT INTO public.feed_products_sample (product_name, product_code, "name", "type", cost_per_kg, cost_currency, supplier_country, is_standard_product, created_at, is_active) VALUES
('Alfalfa hay (mid-bloom)', 'FP-001-HIST', 'Alfalfa hay (mid-bloom)', 'Fodder', 1.40, 'AED', 'UAE', true, 1704067200, false),  -- Jan 2024
('Alfalfa hay (mid-bloom)', 'FP-001-HIST', 'Alfalfa hay (mid-bloom)', 'Fodder', 1.42, 'AED', 'UAE', true, 1706745600, false),  -- Feb 2024
('Alfalfa hay (mid-bloom)', 'FP-001-HIST', 'Alfalfa hay (mid-bloom)', 'Fodder', 1.45, 'AED', 'UAE', true, 1709251200, false),  -- Mar 2024
('Alfalfa hay (mid-bloom)', 'FP-001-HIST', 'Alfalfa hay (mid-bloom)', 'Fodder', 1.48, 'AED', 'UAE', true, 1711929600, false),  -- Apr 2024
('Alfalfa hay (mid-bloom)', 'FP-001-HIST', 'Alfalfa hay (mid-bloom)', 'Fodder', 1.50, 'AED', 'UAE', true, 1714521600, false),  -- May 2024
('Alfalfa hay (mid-bloom)', 'FP-001-HIST', 'Alfalfa hay (mid-bloom)', 'Fodder', 1.52, 'AED', 'UAE', true, 1717200000, false),  -- Jun 2024
('Alfalfa hay (mid-bloom)', 'FP-001-HIST', 'Alfalfa hay (mid-bloom)', 'Fodder', 1.55, 'AED', 'UAE', true, 1719792000, false),  -- Jul 2024
('Alfalfa hay (mid-bloom)', 'FP-001-HIST', 'Alfalfa hay (mid-bloom)', 'Fodder', 1.53, 'AED', 'UAE', true, 1722470400, false),  -- Aug 2024
('Alfalfa hay (mid-bloom)', 'FP-001-HIST', 'Alfalfa hay (mid-bloom)', 'Fodder', 1.50, 'AED', 'UAE', true, 1725148800, false),  -- Sep 2024
('Alfalfa hay (mid-bloom)', 'FP-001-HIST', 'Alfalfa hay (mid-bloom)', 'Fodder', 1.48, 'AED', 'UAE', true, 1727740800, false),  -- Oct 2024
('Alfalfa hay (mid-bloom)', 'FP-001-HIST', 'Alfalfa hay (mid-bloom)', 'Fodder', 1.46, 'AED', 'UAE', true, 1730419200, false),  -- Nov 2024
('Alfalfa hay (mid-bloom)', 'FP-001-HIST', 'Alfalfa hay (mid-bloom)', 'Fodder', 1.47, 'AED', 'UAE', true, 1733011200, false),  -- Dec 2024
('Alfalfa hay (mid-bloom)', 'FP-001-HIST', 'Alfalfa hay (mid-bloom)', 'Fodder', 1.49, 'AED', 'UAE', true, 1735689600, false),  -- Jan 2025
('Alfalfa hay (mid-bloom)', 'FP-001-HIST', 'Alfalfa hay (mid-bloom)', 'Fodder', 1.51, 'AED', 'UAE', true, 1738368000, false),  -- Feb 2025
('Alfalfa hay (mid-bloom)', 'FP-001-HIST', 'Alfalfa hay (mid-bloom)', 'Fodder', 1.54, 'AED', 'UAE', true, 1740787200, false),  -- Mar 2025
('Alfalfa hay (mid-bloom)', 'FP-001-HIST', 'Alfalfa hay (mid-bloom)', 'Fodder', 1.56, 'AED', 'UAE', true, 1743465600, false),  -- Apr 2025
('Alfalfa hay (mid-bloom)', 'FP-001-HIST', 'Alfalfa hay (mid-bloom)', 'Fodder', 1.58, 'AED', 'UAE', true, 1746057600, false),  -- May 2025
('Alfalfa hay (mid-bloom)', 'FP-001-HIST', 'Alfalfa hay (mid-bloom)', 'Fodder', 1.60, 'AED', 'UAE', true, 1748736000, false),  -- Jun 2025
('Alfalfa hay (mid-bloom)', 'FP-001-HIST', 'Alfalfa hay (mid-bloom)', 'Fodder', 1.62, 'AED', 'UAE', true, 1751328000, false),  -- Jul 2025
('Alfalfa hay (mid-bloom)', 'FP-001-HIST', 'Alfalfa hay (mid-bloom)', 'Fodder', 1.60, 'AED', 'UAE', true, 1754006400, false),  -- Aug 2025
('Alfalfa hay (mid-bloom)', 'FP-001-HIST', 'Alfalfa hay (mid-bloom)', 'Fodder', 1.58, 'AED', 'UAE', true, 1756684800, false),  -- Sep 2025
('Alfalfa hay (mid-bloom)', 'FP-001-HIST', 'Alfalfa hay (mid-bloom)', 'Fodder', 1.56, 'AED', 'UAE', true, 1759276800, false),  -- Oct 2025
('Alfalfa hay (mid-bloom)', 'FP-001-HIST', 'Alfalfa hay (mid-bloom)', 'Fodder', 1.54, 'AED', 'UAE', true, 1761955200, false),  -- Nov 2025
('Alfalfa hay (mid-bloom)', 'FP-001-HIST', 'Alfalfa hay (mid-bloom)', 'Fodder', 1.52, 'AED', 'UAE', true, 1764547200, false),  -- Dec 2025
('Alfalfa hay (mid-bloom)', 'FP-001-HIST', 'Alfalfa hay (mid-bloom)', 'Fodder', 1.50, 'AED', 'UAE', true, 1767225600, true);  -- Jan 2026 (CURRENT - ACTIVE)

-- Egypt Barley - Historical pricing (showing seasonal variations)
-- Note: Only the latest price (Jan 2026) is active; all historical prices are inactive
INSERT INTO public.feed_products_sample (product_name, product_code, "name", "type", cost_per_kg, cost_currency, supplier_country, is_standard_product, created_at, is_active) VALUES
('Barley', 'FP-005-HIST', 'Barley', 'Fodder', 11.20, 'EGP', 'Egypt', true, 1704067200, false),  -- Jan 2024
('Barley', 'FP-005-HIST', 'Barley', 'Fodder', 11.40, 'EGP', 'Egypt', true, 1706745600, false),  -- Feb 2024
('Barley', 'FP-005-HIST', 'Barley', 'Fodder', 11.60, 'EGP', 'Egypt', true, 1709251200, false),  -- Mar 2024
('Barley', 'FP-005-HIST', 'Barley', 'Fodder', 11.80, 'EGP', 'Egypt', true, 1711929600, false),  -- Apr 2024
('Barley', 'FP-005-HIST', 'Barley', 'Fodder', 12.00, 'EGP', 'Egypt', true, 1714521600, false),  -- May 2024
('Barley', 'FP-005-HIST', 'Barley', 'Fodder', 12.20, 'EGP', 'Egypt', true, 1717200000, false),  -- Jun 2024
('Barley', 'FP-005-HIST', 'Barley', 'Fodder', 12.40, 'EGP', 'Egypt', true, 1719792000, false),  -- Jul 2024
('Barley', 'FP-005-HIST', 'Barley', 'Fodder', 12.30, 'EGP', 'Egypt', true, 1722470400, false),  -- Aug 2024
('Barley', 'FP-005-HIST', 'Barley', 'Fodder', 12.10, 'EGP', 'Egypt', true, 1725148800, false),  -- Sep 2024
('Barley', 'FP-005-HIST', 'Barley', 'Fodder', 11.90, 'EGP', 'Egypt', true, 1727740800, false),  -- Oct 2024
('Barley', 'FP-005-HIST', 'Barley', 'Fodder', 11.70, 'EGP', 'Egypt', true, 1730419200, false),  -- Nov 2024
('Barley', 'FP-005-HIST', 'Barley', 'Fodder', 11.64, 'EGP', 'Egypt', true, 1733011200, false),  -- Dec 2024
('Barley', 'FP-005-HIST', 'Barley', 'Fodder', 11.80, 'EGP', 'Egypt', true, 1735689600, false),  -- Jan 2025
('Barley', 'FP-005-HIST', 'Barley', 'Fodder', 12.00, 'EGP', 'Egypt', true, 1738368000, false),  -- Feb 2025
('Barley', 'FP-005-HIST', 'Barley', 'Fodder', 12.20, 'EGP', 'Egypt', true, 1740787200, false),  -- Mar 2025
('Barley', 'FP-005-HIST', 'Barley', 'Fodder', 12.40, 'EGP', 'Egypt', true, 1743465600, false),  -- Apr 2025
('Barley', 'FP-005-HIST', 'Barley', 'Fodder', 12.60, 'EGP', 'Egypt', true, 1746057600, false),  -- May 2025
('Barley', 'FP-005-HIST', 'Barley', 'Fodder', 12.80, 'EGP', 'Egypt', true, 1748736000, false),  -- Jun 2025
('Barley', 'FP-005-HIST', 'Barley', 'Fodder', 13.00, 'EGP', 'Egypt', true, 1751328000, false),  -- Jul 2025
('Barley', 'FP-005-HIST', 'Barley', 'Fodder', 12.90, 'EGP', 'Egypt', true, 1754006400, false),  -- Aug 2025
('Barley', 'FP-005-HIST', 'Barley', 'Fodder', 12.70, 'EGP', 'Egypt', true, 1756684800, false),  -- Sep 2025
('Barley', 'FP-005-HIST', 'Barley', 'Fodder', 12.50, 'EGP', 'Egypt', true, 1759276800, false),  -- Oct 2025
('Barley', 'FP-005-HIST', 'Barley', 'Fodder', 12.30, 'EGP', 'Egypt', true, 1761955200, false),  -- Nov 2025
('Barley', 'FP-005-HIST', 'Barley', 'Fodder', 12.10, 'EGP', 'Egypt', true, 1764547200, false),  -- Dec 2025
('Barley', 'FP-005-HIST', 'Barley', 'Fodder', 11.95, 'EGP', 'Egypt', true, 1767225600, true);  -- Jan 2026 (CURRENT - ACTIVE)

-- Saudi Arabia Wheat Straw - Historical pricing
-- Note: Only the latest price (Jan 2026) is active; all historical prices are inactive
INSERT INTO public.feed_products_sample (product_name, product_code, "name", "type", cost_per_kg, cost_currency, supplier_country, is_standard_product, created_at, is_active) VALUES
('Wheat Straw', 'FP-002-HIST', 'Wheat Straw', 'Fodder', 0.90, 'SAR', 'Saudi Arabia', true, 1704067200, false),  -- Jan 2024
('Wheat Straw', 'FP-002-HIST', 'Wheat Straw', 'Fodder', 0.92, 'SAR', 'Saudi Arabia', true, 1706745600, false),  -- Feb 2024
('Wheat Straw', 'FP-002-HIST', 'Wheat Straw', 'Fodder', 0.94, 'SAR', 'Saudi Arabia', true, 1709251200, false),  -- Mar 2024
('Wheat Straw', 'FP-002-HIST', 'Wheat Straw', 'Fodder', 0.96, 'SAR', 'Saudi Arabia', true, 1711929600, false),  -- Apr 2024
('Wheat Straw', 'FP-002-HIST', 'Wheat Straw', 'Fodder', 0.98, 'SAR', 'Saudi Arabia', true, 1714521600, false),  -- May 2024
('Wheat Straw', 'FP-002-HIST', 'Wheat Straw', 'Fodder', 1.00, 'SAR', 'Saudi Arabia', true, 1717200000, false),  -- Jun 2024
('Wheat Straw', 'FP-002-HIST', 'Wheat Straw', 'Fodder', 1.02, 'SAR', 'Saudi Arabia', true, 1719792000, false),  -- Jul 2024
('Wheat Straw', 'FP-002-HIST', 'Wheat Straw', 'Fodder', 1.00, 'SAR', 'Saudi Arabia', true, 1722470400, false),  -- Aug 2024
('Wheat Straw', 'FP-002-HIST', 'Wheat Straw', 'Fodder', 0.98, 'SAR', 'Saudi Arabia', true, 1725148800, false),  -- Sep 2024
('Wheat Straw', 'FP-002-HIST', 'Wheat Straw', 'Fodder', 0.96, 'SAR', 'Saudi Arabia', true, 1727740800, false),  -- Oct 2024
('Wheat Straw', 'FP-002-HIST', 'Wheat Straw', 'Fodder', 0.94, 'SAR', 'Saudi Arabia', true, 1730419200, false),  -- Nov 2024
('Wheat Straw', 'FP-002-HIST', 'Wheat Straw', 'Fodder', 0.94, 'SAR', 'Saudi Arabia', true, 1733011200, false),  -- Dec 2024
('Wheat Straw', 'FP-002-HIST', 'Wheat Straw', 'Fodder', 0.95, 'SAR', 'Saudi Arabia', true, 1735689600, false),  -- Jan 2025
('Wheat Straw', 'FP-002-HIST', 'Wheat Straw', 'Fodder', 0.97, 'SAR', 'Saudi Arabia', true, 1738368000, false),  -- Feb 2025
('Wheat Straw', 'FP-002-HIST', 'Wheat Straw', 'Fodder', 0.99, 'SAR', 'Saudi Arabia', true, 1740787200, false),  -- Mar 2025
('Wheat Straw', 'FP-002-HIST', 'Wheat Straw', 'Fodder', 1.01, 'SAR', 'Saudi Arabia', true, 1743465600, false),  -- Apr 2025
('Wheat Straw', 'FP-002-HIST', 'Wheat Straw', 'Fodder', 1.03, 'SAR', 'Saudi Arabia', true, 1746057600, false),  -- May 2025
('Wheat Straw', 'FP-002-HIST', 'Wheat Straw', 'Fodder', 1.05, 'SAR', 'Saudi Arabia', true, 1748736000, false),  -- Jun 2025
('Wheat Straw', 'FP-002-HIST', 'Wheat Straw', 'Fodder', 1.07, 'SAR', 'Saudi Arabia', true, 1751328000, false),  -- Jul 2025
('Wheat Straw', 'FP-002-HIST', 'Wheat Straw', 'Fodder', 1.05, 'SAR', 'Saudi Arabia', true, 1754006400, false),  -- Aug 2025
('Wheat Straw', 'FP-002-HIST', 'Wheat Straw', 'Fodder', 1.03, 'SAR', 'Saudi Arabia', true, 1756684800, false),  -- Sep 2025
('Wheat Straw', 'FP-002-HIST', 'Wheat Straw', 'Fodder', 1.01, 'SAR', 'Saudi Arabia', true, 1759276800, false),  -- Oct 2025
('Wheat Straw', 'FP-002-HIST', 'Wheat Straw', 'Fodder', 0.99, 'SAR', 'Saudi Arabia', true, 1761955200, false),  -- Nov 2025
('Wheat Straw', 'FP-002-HIST', 'Wheat Straw', 'Fodder', 0.97, 'SAR', 'Saudi Arabia', true, 1764547200, false),  -- Dec 2025
('Wheat Straw', 'FP-002-HIST', 'Wheat Straw', 'Fodder', 0.95, 'SAR', 'Saudi Arabia', true, 1767225600, true);  -- Jan 2026 (CURRENT - ACTIVE)

-- ============================================================================
-- FEED PRODUCT RESTRICTIONS
-- ============================================================================

-- Restrictions for Concentrates and Additives
-- Note: We need to reference product_id from feed_products_sample
-- For this seed data, we'll use a pattern where restrictions are added after products are inserted
-- In practice, you would need to query the product IDs first or use a subquery

-- Example restrictions for concentrates (Barley - raw, Soya Bean Meal, etc.)
-- These will need to be updated with actual product_id values after products are inserted

-- Restriction: Barley - raw should not exceed 30% of feed for young cattle (0-12 months)
-- Restriction: Soya Bean Meal should not exceed 25% of concentrate for lactating cows
-- Restriction: Urea should not exceed 1% of feed and only for adult cattle
-- Restriction: Molasses should not exceed 10% of feed

-- Since we can't reference product IDs directly in INSERT without subqueries,
-- we'll create a template that can be run after products are inserted
-- Or use a more complex INSERT with subqueries

-- Example using subquery to find product IDs:
INSERT INTO public.feed_product_restrictions (product_id, species, sex, min_age_months, max_age_months, breeding_cycle, lactation_cycle, production_focus, is_eligible, max_perc_feed, max_perc_conc, is_active)
SELECT id, 'cattle', NULL, 0, 12, NULL, NULL, NULL, true, 30.00, NULL, true
FROM public.feed_products_sample
WHERE product_code = 'FP-017' AND supplier_country = 'UAE'
LIMIT 1;

INSERT INTO public.feed_product_restrictions (product_id, species, sex, min_age_months, max_age_months, breeding_cycle, lactation_cycle, production_focus, is_eligible, max_perc_feed, max_perc_conc, is_active)
SELECT id, 'cattle', 'female', NULL, NULL, NULL, 'early', 'dairy', true, NULL, 25.00, true
FROM public.feed_products_sample
WHERE product_code = 'FP-019' AND supplier_country = 'UAE'
LIMIT 1;

INSERT INTO public.feed_product_restrictions (product_id, species, sex, min_age_months, max_age_months, breeding_cycle, lactation_cycle, production_focus, is_eligible, max_perc_feed, max_perc_conc, is_active)
SELECT id, 'cattle', NULL, 12, NULL, NULL, NULL, NULL, true, 1.00, NULL, true
FROM public.feed_products_sample
WHERE product_code = 'FP-035' AND supplier_country = 'UAE'
LIMIT 1;

INSERT INTO public.feed_product_restrictions (product_id, species, sex, min_age_months, max_age_months, breeding_cycle, lactation_cycle, production_focus, is_eligible, max_perc_feed, max_perc_conc, is_active)
SELECT id, 'cattle', NULL, NULL, NULL, NULL, NULL, NULL, true, 10.00, NULL, true
FROM public.feed_products_sample
WHERE product_code = 'FP-024' AND supplier_country = 'UAE'
LIMIT 1;

-- Saudi Arabia restrictions
INSERT INTO public.feed_product_restrictions (product_id, species, sex, min_age_months, max_age_months, breeding_cycle, lactation_cycle, production_focus, is_eligible, max_perc_feed, max_perc_conc, is_active)
SELECT id, 'cattle', NULL, 0, 12, NULL, NULL, NULL, true, 30.00, NULL, true
FROM public.feed_products_sample
WHERE product_code = 'FP-017' AND supplier_country = 'Saudi Arabia'
LIMIT 1;

INSERT INTO public.feed_product_restrictions (product_id, species, sex, min_age_months, max_age_months, breeding_cycle, lactation_cycle, production_focus, is_eligible, max_perc_feed, max_perc_conc, is_active)
SELECT id, 'cattle', 'female', NULL, NULL, NULL, 'early', 'dairy', true, NULL, 25.00, true
FROM public.feed_products_sample
WHERE product_code = 'FP-019' AND supplier_country = 'Saudi Arabia'
LIMIT 1;

INSERT INTO public.feed_product_restrictions (product_id, species, sex, min_age_months, max_age_months, breeding_cycle, lactation_cycle, production_focus, is_eligible, max_perc_feed, max_perc_conc, is_active)
SELECT id, 'cattle', NULL, 12, NULL, NULL, NULL, NULL, true, 1.00, NULL, true
FROM public.feed_products_sample
WHERE product_code = 'FP-035' AND supplier_country = 'Saudi Arabia'
LIMIT 1;

-- Egypt restrictions
INSERT INTO public.feed_product_restrictions (product_id, species, sex, min_age_months, max_age_months, breeding_cycle, lactation_cycle, production_focus, is_eligible, max_perc_feed, max_perc_conc, is_active)
SELECT id, 'cattle', NULL, 0, 12, NULL, NULL, NULL, true, 30.00, NULL, true
FROM public.feed_products_sample
WHERE product_code = 'FP-017' AND supplier_country = 'Egypt'
LIMIT 1;

INSERT INTO public.feed_product_restrictions (product_id, species, sex, min_age_months, max_age_months, breeding_cycle, lactation_cycle, production_focus, is_eligible, max_perc_feed, max_perc_conc, is_active)
SELECT id, 'cattle', 'female', NULL, NULL, NULL, 'early', 'dairy', true, NULL, 25.00, true
FROM public.feed_products_sample
WHERE product_code = 'FP-019' AND supplier_country = 'Egypt'
LIMIT 1;

INSERT INTO public.feed_product_restrictions (product_id, species, sex, min_age_months, max_age_months, breeding_cycle, lactation_cycle, production_focus, is_eligible, max_perc_feed, max_perc_conc, is_active)
SELECT id, 'cattle', NULL, 12, NULL, NULL, NULL, NULL, true, 1.00, NULL, true
FROM public.feed_products_sample
WHERE product_code = 'FP-035' AND supplier_country = 'Egypt'
LIMIT 1;

-- Additional restrictions for sheep/goats
INSERT INTO public.feed_product_restrictions (product_id, species, sex, min_age_months, max_age_months, breeding_cycle, lactation_cycle, production_focus, is_eligible, max_perc_feed, max_perc_conc, is_active)
SELECT id, 'sheep', NULL, NULL, NULL, NULL, NULL, NULL, true, 20.00, NULL, true
FROM public.feed_products_sample
WHERE product_code = 'FP-017' AND supplier_country = 'UAE'
LIMIT 1;

INSERT INTO public.feed_product_restrictions (product_id, species, sex, min_age_months, max_age_months, breeding_cycle, lactation_cycle, production_focus, is_eligible, max_perc_feed, max_perc_conc, is_active)
SELECT id, 'goat', NULL, NULL, NULL, NULL, NULL, NULL, true, 20.00, NULL, true
FROM public.feed_products_sample
WHERE product_code = 'FP-017' AND supplier_country = 'UAE'
LIMIT 1;

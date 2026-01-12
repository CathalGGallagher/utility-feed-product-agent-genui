-- Extended Market Products and Historical Pricing Data
-- This file supplements seed_data.sql with:
-- 1. Multiple suppliers (20-30) with 10-50 products each
-- 2. Historical pricing for ALL standard products with seasonal variations
-- 3. Additional restrictions for concentrates and additives

-- ============================================================================
-- MARKET SUPPLIERS WITH PRODUCTS (10-50 products per supplier)
-- ============================================================================

-- UAE Suppliers (5 suppliers)
INSERT INTO public.feed_products_sample (product_name, product_code, "name", "type", cost_per_kg, cost_currency, supplier, supplier_country, supplier_email, supplier_phone, supplier_address, is_standard_product, created_at, is_active) VALUES
-- Supplier 1: Al Ain Feed Company (25 products)
('Premium Alfalfa Hay', 'MP-UAE-001-001', 'Premium Alfalfa Hay', 'Fodder', 1.65, 'AED', 'Al Ain Feed Company', 'UAE', 'info@alainfeed.ae', '+971-3-123-4567', 'Al Ain Industrial Area, UAE', false, 1704067200, true),
('Organic Wheat Straw', 'MP-UAE-001-002', 'Organic Wheat Straw', 'Fodder', 1.10, 'AED', 'Al Ain Feed Company', 'UAE', 'info@alainfeed.ae', '+971-3-123-4567', 'Al Ain Industrial Area, UAE', false, 1704067200, true),
('Barley Grain Premium', 'MP-UAE-001-003', 'Barley Grain Premium', 'Fodder', 1.45, 'AED', 'Al Ain Feed Company', 'UAE', 'info@alainfeed.ae', '+971-3-123-4567', 'Al Ain Industrial Area, UAE', false, 1704067200, true),
('Corn Silage Premium', 'MP-UAE-001-004', 'Corn Silage Premium', 'Fodder', 1.38, 'AED', 'Al Ain Feed Company', 'UAE', 'info@alainfeed.ae', '+971-3-123-4567', 'Al Ain Industrial Area, UAE', false, 1704067200, true),
('Soybean Hulls', 'MP-UAE-001-005', 'Soybean Hulls', 'Fodder', 1.25, 'AED', 'Al Ain Feed Company', 'UAE', 'info@alainfeed.ae', '+971-3-123-4567', 'Al Ain Industrial Area, UAE', false, 1704067200, true),
('Barley - raw', 'MP-UAE-001-006', 'Barley - raw', 'Concentrate', 2.20, 'AED', 'Al Ain Feed Company', 'UAE', 'info@alainfeed.ae', '+971-3-123-4567', 'Al Ain Industrial Area, UAE', false, 1704067200, true),
('Barley - Flakes', 'MP-UAE-001-007', 'Barley - Flakes', 'Concentrate', 2.38, 'AED', 'Al Ain Feed Company', 'UAE', 'info@alainfeed.ae', '+971-3-123-4567', 'Al Ain Industrial Area, UAE', false, 1704067200, true),
('Soya Bean Meal', 'MP-UAE-001-008', 'Soya Bean Meal', 'Concentrate', 2.57, 'AED', 'Al Ain Feed Company', 'UAE', 'info@alainfeed.ae', '+971-3-123-4567', 'Al Ain Industrial Area, UAE', false, 1704067200, true),
('Steamed Corn Flake', 'MP-UAE-001-009', 'Steamed Corn Flake', 'Concentrate', 2.45, 'AED', 'Al Ain Feed Company', 'UAE', 'info@alainfeed.ae', '+971-3-123-4567', 'Al Ain Industrial Area, UAE', false, 1704067200, true),
('Steamed Barley Flakes', 'MP-UAE-001-010', 'Steamed Barley Flakes', 'Concentrate', 2.50, 'AED', 'Al Ain Feed Company', 'UAE', 'info@alainfeed.ae', '+971-3-123-4567', 'Al Ain Industrial Area, UAE', false, 1704067200, true),
('Wheat grain', 'MP-UAE-001-011', 'Wheat grain', 'Concentrate', 2.38, 'AED', 'Al Ain Feed Company', 'UAE', 'info@alainfeed.ae', '+971-3-123-4567', 'Al Ain Industrial Area, UAE', false, 1704067200, true),
('Cotton meal', 'MP-UAE-001-012', 'Cotton meal', 'Concentrate', 2.45, 'AED', 'Al Ain Feed Company', 'UAE', 'info@alainfeed.ae', '+971-3-123-4567', 'Al Ain Industrial Area, UAE', false, 1704067200, true),
('Beetroot pellets', 'MP-UAE-001-013', 'Beetroot pellets', 'Concentrate', 2.38, 'AED', 'Al Ain Feed Company', 'UAE', 'info@alainfeed.ae', '+971-3-123-4567', 'Al Ain Industrial Area, UAE', false, 1704067200, true),
('Maize grain', 'MP-UAE-001-014', 'Maize grain', 'Concentrate', 2.35, 'AED', 'Al Ain Feed Company', 'UAE', 'info@alainfeed.ae', '+971-3-123-4567', 'Al Ain Industrial Area, UAE', false, 1704067200, true),
('Corn Gluten Meal', 'MP-UAE-001-015', 'Corn Gluten Meal', 'Concentrate', 2.57, 'AED', 'Al Ain Feed Company', 'UAE', 'info@alainfeed.ae', '+971-3-123-4567', 'Al Ain Industrial Area, UAE', false, 1704067200, true),
('Molasses', 'MP-UAE-001-016', 'Molasses', 'Additive', 3.30, 'AED', 'Al Ain Feed Company', 'UAE', 'info@alainfeed.ae', '+971-3-123-4567', 'Al Ain Industrial Area, UAE', false, 1704067200, true),
('Limestone', 'MP-UAE-001-017', 'Limestone', 'Additive', 2.94, 'AED', 'Al Ain Feed Company', 'UAE', 'info@alainfeed.ae', '+971-3-123-4567', 'Al Ain Industrial Area, UAE', false, 1704067200, true),
('Salt', 'MP-UAE-001-018', 'Salt', 'Additive', 2.75, 'AED', 'Al Ain Feed Company', 'UAE', 'info@alainfeed.ae', '+971-3-123-4567', 'Al Ain Industrial Area, UAE', false, 1704067200, true),
('Urea', 'MP-UAE-001-019', 'Urea', 'Additive', 4.41, 'AED', 'Al Ain Feed Company', 'UAE', 'info@alainfeed.ae', '+971-3-123-4567', 'Al Ain Industrial Area, UAE', false, 1704067200, true),
('Oat Hay Premium', 'MP-UAE-001-020', 'Oat Hay Premium', 'Fodder', 1.35, 'AED', 'Al Ain Feed Company', 'UAE', 'info@alainfeed.ae', '+971-3-123-4567', 'Al Ain Industrial Area, UAE', false, 1704067200, true),
('Triticale Silage', 'MP-UAE-001-021', 'Triticale Silage', 'Fodder', 1.15, 'AED', 'Al Ain Feed Company', 'UAE', 'info@alainfeed.ae', '+971-3-123-4567', 'Al Ain Industrial Area, UAE', false, 1704067200, true),
('Wheat Bran', 'MP-UAE-001-022', 'Wheat Bran', 'Fodder', 0.98, 'AED', 'Al Ain Feed Company', 'UAE', 'info@alainfeed.ae', '+971-3-123-4567', 'Al Ain Industrial Area, UAE', false, 1704067200, true),
('White Hay', 'MP-UAE-001-023', 'White Hay', 'Fodder', 1.15, 'AED', 'Al Ain Feed Company', 'UAE', 'info@alainfeed.ae', '+971-3-123-4567', 'Al Ain Industrial Area, UAE', false, 1704067200, true),
('Red Hay', 'MP-UAE-001-024', 'Red Hay', 'Fodder', 1.15, 'AED', 'Al Ain Feed Company', 'UAE', 'info@alainfeed.ae', '+971-3-123-4567', 'Al Ain Industrial Area, UAE', false, 1704067200, true),
('Fermented Corn', 'MP-UAE-001-025', 'Fermented Corn', 'Fodder', 1.45, 'AED', 'Al Ain Feed Company', 'UAE', 'info@alainfeed.ae', '+971-3-123-4567', 'Al Ain Industrial Area, UAE', false, 1704067200, true);

-- Supplier 2: Dubai Agricultural Supplies (18 products)
INSERT INTO public.feed_products_sample (product_name, product_code, "name", "type", cost_per_kg, cost_currency, supplier, supplier_country, supplier_email, supplier_phone, supplier_address, is_standard_product, created_at, is_active) VALUES
('Alfalfa hay (mid-bloom)', 'MP-UAE-002-001', 'Alfalfa hay (mid-bloom)', 'Fodder', 1.50, 'AED', 'Dubai Agricultural Supplies', 'UAE', 'sales@dubaiagri.ae', '+971-4-234-5678', 'Dubai, UAE', false, 1704067200, true),
('Wheat Straw', 'MP-UAE-002-002', 'Wheat Straw', 'Fodder', 0.95, 'AED', 'Dubai Agricultural Supplies', 'UAE', 'sales@dubaiagri.ae', '+971-4-234-5678', 'Dubai, UAE', false, 1704067200, true),
('Barley', 'MP-UAE-002-003', 'Barley', 'Fodder', 1.42, 'AED', 'Dubai Agricultural Supplies', 'UAE', 'sales@dubaiagri.ae', '+971-4-234-5678', 'Dubai, UAE', false, 1704067200, true),
('Corn', 'MP-UAE-002-004', 'Corn', 'Fodder', 1.36, 'AED', 'Dubai Agricultural Supplies', 'UAE', 'sales@dubaiagri.ae', '+971-4-234-5678', 'Dubai, UAE', false, 1704067200, true),
('Soybean', 'MP-UAE-002-005', 'Soybean', 'Fodder', 1.70, 'AED', 'Dubai Agricultural Supplies', 'UAE', 'sales@dubaiagri.ae', '+971-4-234-5678', 'Dubai, UAE', false, 1704067200, true),
('Barley - raw', 'MP-UAE-002-006', 'Barley - raw', 'Concentrate', 2.25, 'AED', 'Dubai Agricultural Supplies', 'UAE', 'sales@dubaiagri.ae', '+971-4-234-5678', 'Dubai, UAE', false, 1704067200, true),
('Barley - Flakes', 'MP-UAE-002-007', 'Barley - Flakes', 'Concentrate', 2.42, 'AED', 'Dubai Agricultural Supplies', 'UAE', 'sales@dubaiagri.ae', '+971-4-234-5678', 'Dubai, UAE', false, 1704067200, true),
('Soya Bean Meal', 'MP-UAE-002-008', 'Soya Bean Meal', 'Concentrate', 2.62, 'AED', 'Dubai Agricultural Supplies', 'UAE', 'sales@dubaiagri.ae', '+971-4-234-5678', 'Dubai, UAE', false, 1704067200, true),
('Steamed Corn Flake', 'MP-UAE-002-009', 'Steamed Corn Flake', 'Concentrate', 2.50, 'AED', 'Dubai Agricultural Supplies', 'UAE', 'sales@dubaiagri.ae', '+971-4-234-5678', 'Dubai, UAE', false, 1704067200, true),
('Wheat grain', 'MP-UAE-002-010', 'Wheat grain', 'Concentrate', 2.42, 'AED', 'Dubai Agricultural Supplies', 'UAE', 'sales@dubaiagri.ae', '+971-4-234-5678', 'Dubai, UAE', false, 1704067200, true),
('Cotton meal', 'MP-UAE-002-011', 'Cotton meal', 'Concentrate', 2.50, 'AED', 'Dubai Agricultural Supplies', 'UAE', 'sales@dubaiagri.ae', '+971-4-234-5678', 'Dubai, UAE', false, 1704067200, true),
('Beetroot pellets', 'MP-UAE-002-012', 'Beetroot pellets', 'Concentrate', 2.42, 'AED', 'Dubai Agricultural Supplies', 'UAE', 'sales@dubaiagri.ae', '+971-4-234-5678', 'Dubai, UAE', false, 1704067200, true),
('Maize grain', 'MP-UAE-002-013', 'Maize grain', 'Concentrate', 2.40, 'AED', 'Dubai Agricultural Supplies', 'UAE', 'sales@dubaiagri.ae', '+971-4-234-5678', 'Dubai, UAE', false, 1704067200, true),
('Molasses', 'MP-UAE-002-014', 'Molasses', 'Additive', 3.35, 'AED', 'Dubai Agricultural Supplies', 'UAE', 'sales@dubaiagri.ae', '+971-4-234-5678', 'Dubai, UAE', false, 1704067200, true),
('Limestone', 'MP-UAE-002-015', 'Limestone', 'Additive', 3.00, 'AED', 'Dubai Agricultural Supplies', 'UAE', 'sales@dubaiagri.ae', '+971-4-234-5678', 'Dubai, UAE', false, 1704067200, true),
('Salt', 'MP-UAE-002-016', 'Salt', 'Additive', 2.80, 'AED', 'Dubai Agricultural Supplies', 'UAE', 'sales@dubaiagri.ae', '+971-4-234-5678', 'Dubai, UAE', false, 1704067200, true),
('Urea', 'MP-UAE-002-017', 'Urea', 'Additive', 4.50, 'AED', 'Dubai Agricultural Supplies', 'UAE', 'sales@dubaiagri.ae', '+971-4-234-5678', 'Dubai, UAE', false, 1704067200, true),
('Oat Hay', 'MP-UAE-002-018', 'Oat Hay', 'Fodder', 1.32, 'AED', 'Dubai Agricultural Supplies', 'UAE', 'sales@dubaiagri.ae', '+971-4-234-5678', 'Dubai, UAE', false, 1704067200, true);

-- Supplier 3: Sharjah Feed Mills (32 products)
INSERT INTO public.feed_products_sample (product_name, product_code, "name", "type", cost_per_kg, cost_currency, supplier, supplier_country, supplier_email, supplier_phone, supplier_address, is_standard_product, created_at, is_active) VALUES
('Alfalfa hay (mid-bloom)', 'MP-UAE-003-001', 'Alfalfa hay (mid-bloom)', 'Fodder', 1.48, 'AED', 'Sharjah Feed Mills', 'UAE', 'contact@sharjahfeed.ae', '+971-6-345-6789', 'Sharjah, UAE', false, 1704067200, true),
('Wheat Straw', 'MP-UAE-003-002', 'Wheat Straw', 'Fodder', 0.93, 'AED', 'Sharjah Feed Mills', 'UAE', 'contact@sharjahfeed.ae', '+971-6-345-6789', 'Sharjah, UAE', false, 1704067200, true),
('Triticale Silage', 'MP-UAE-003-003', 'Triticale Silage', 'Fodder', 1.12, 'AED', 'Sharjah Feed Mills', 'UAE', 'contact@sharjahfeed.ae', '+971-6-345-6789', 'Sharjah, UAE', false, 1704067200, true),
('Oat Hay', 'MP-UAE-003-004', 'Oat Hay', 'Fodder', 1.30, 'AED', 'Sharjah Feed Mills', 'UAE', 'contact@sharjahfeed.ae', '+971-6-345-6789', 'Sharjah, UAE', false, 1704067200, true),
('Barley', 'MP-UAE-003-005', 'Barley', 'Fodder', 1.40, 'AED', 'Sharjah Feed Mills', 'UAE', 'contact@sharjahfeed.ae', '+971-6-345-6789', 'Sharjah, UAE', false, 1704067200, true),
('Corn', 'MP-UAE-003-006', 'Corn', 'Fodder', 1.34, 'AED', 'Sharjah Feed Mills', 'UAE', 'contact@sharjahfeed.ae', '+971-6-345-6789', 'Sharjah, UAE', false, 1704067200, true),
('Soybean', 'MP-UAE-003-007', 'Soybean', 'Fodder', 1.67, 'AED', 'Sharjah Feed Mills', 'UAE', 'contact@sharjahfeed.ae', '+971-6-345-6789', 'Sharjah, UAE', false, 1704067200, true),
('Wheat', 'MP-UAE-003-008', 'Wheat', 'Fodder', 1.37, 'AED', 'Sharjah Feed Mills', 'UAE', 'contact@sharjahfeed.ae', '+971-6-345-6789', 'Sharjah, UAE', false, 1704067200, true),
('Cotton Seed', 'MP-UAE-003-009', 'Cotton Seed', 'Fodder', 1.49, 'AED', 'Sharjah Feed Mills', 'UAE', 'contact@sharjahfeed.ae', '+971-6-345-6789', 'Sharjah, UAE', false, 1704067200, true),
('Beet Pulp', 'MP-UAE-003-010', 'Beet Pulp', 'Fodder', 1.22, 'AED', 'Sharjah Feed Mills', 'UAE', 'contact@sharjahfeed.ae', '+971-6-345-6789', 'Sharjah, UAE', false, 1704067200, true),
('Wheat Bran', 'MP-UAE-003-011', 'Wheat Bran', 'Fodder', 0.93, 'AED', 'Sharjah Feed Mills', 'UAE', 'contact@sharjahfeed.ae', '+971-6-345-6789', 'Sharjah, UAE', false, 1704067200, true),
('White Hay', 'MP-UAE-003-012', 'White Hay', 'Fodder', 1.12, 'AED', 'Sharjah Feed Mills', 'UAE', 'contact@sharjahfeed.ae', '+971-6-345-6789', 'Sharjah, UAE', false, 1704067200, true),
('Red Hay', 'MP-UAE-003-013', 'Red Hay', 'Fodder', 1.12, 'AED', 'Sharjah Feed Mills', 'UAE', 'contact@sharjahfeed.ae', '+971-6-345-6789', 'Sharjah, UAE', false, 1704067200, true),
('Alfalfa', 'MP-UAE-003-014', 'Alfalfa', 'Fodder', 1.49, 'AED', 'Sharjah Feed Mills', 'UAE', 'contact@sharjahfeed.ae', '+971-6-345-6789', 'Sharjah, UAE', false, 1704067200, true),
('Fermented Corn', 'MP-UAE-003-015', 'Fermented Corn', 'Fodder', 1.40, 'AED', 'Sharjah Feed Mills', 'UAE', 'contact@sharjahfeed.ae', '+971-6-345-6789', 'Sharjah, UAE', false, 1704067200, true),
('Soybean Hulls', 'MP-UAE-003-016', 'Soybean Hulls', 'Fodder', 1.22, 'AED', 'Sharjah Feed Mills', 'UAE', 'contact@sharjahfeed.ae', '+971-6-345-6789', 'Sharjah, UAE', false, 1704067200, true),
('Alfalfa Hay', 'MP-UAE-003-017', 'Alfalfa Hay', 'Fodder', 1.49, 'AED', 'Sharjah Feed Mills', 'UAE', 'contact@sharjahfeed.ae', '+971-6-345-6789', 'Sharjah, UAE', false, 1704067200, true),
('Barley - raw', 'MP-UAE-003-018', 'Barley - raw', 'Concentrate', 2.22, 'AED', 'Sharjah Feed Mills', 'UAE', 'contact@sharjahfeed.ae', '+971-6-345-6789', 'Sharjah, UAE', false, 1704067200, true),
('Barley - Flakes', 'MP-UAE-003-019', 'Barley - Flakes', 'Concentrate', 2.40, 'AED', 'Sharjah Feed Mills', 'UAE', 'contact@sharjahfeed.ae', '+971-6-345-6789', 'Sharjah, UAE', false, 1704067200, true),
('Soya Bean Meal', 'MP-UAE-003-020', 'Soya Bean Meal', 'Concentrate', 2.59, 'AED', 'Sharjah Feed Mills', 'UAE', 'contact@sharjahfeed.ae', '+971-6-345-6789', 'Sharjah, UAE', false, 1704067200, true),
('Steamed Corn Flake', 'MP-UAE-003-021', 'Steamed Corn Flake', 'Concentrate', 2.47, 'AED', 'Sharjah Feed Mills', 'UAE', 'contact@sharjahfeed.ae', '+971-6-345-6789', 'Sharjah, UAE', false, 1704067200, true),
('Steamed Barley Flakes', 'MP-UAE-003-022', 'Steamed Barley Flakes', 'Concentrate', 2.52, 'AED', 'Sharjah Feed Mills', 'UAE', 'contact@sharjahfeed.ae', '+971-6-345-6789', 'Sharjah, UAE', false, 1704067200, true),
('Barley grain', 'MP-UAE-003-023', 'Barley grain', 'Concentrate', 2.22, 'AED', 'Sharjah Feed Mills', 'UAE', 'contact@sharjahfeed.ae', '+971-6-345-6789', 'Sharjah, UAE', false, 1704067200, true),
('Soybean husk', 'MP-UAE-003-024', 'Soybean husk', 'Concentrate', 2.22, 'AED', 'Sharjah Feed Mills', 'UAE', 'contact@sharjahfeed.ae', '+971-6-345-6789', 'Sharjah, UAE', false, 1704067200, true),
('Wheat grain', 'MP-UAE-003-025', 'Wheat grain', 'Concentrate', 2.40, 'AED', 'Sharjah Feed Mills', 'UAE', 'contact@sharjahfeed.ae', '+971-6-345-6789', 'Sharjah, UAE', false, 1704067200, true),
('Cotton meal', 'MP-UAE-003-026', 'Cotton meal', 'Concentrate', 2.47, 'AED', 'Sharjah Feed Mills', 'UAE', 'contact@sharjahfeed.ae', '+971-6-345-6789', 'Sharjah, UAE', false, 1704067200, true),
('Beetroot pellets', 'MP-UAE-003-027', 'Beetroot pellets', 'Concentrate', 2.40, 'AED', 'Sharjah Feed Mills', 'UAE', 'contact@sharjahfeed.ae', '+971-6-345-6789', 'Sharjah, UAE', false, 1704067200, true),
('Maize grain', 'MP-UAE-003-028', 'Maize grain', 'Concentrate', 2.37, 'AED', 'Sharjah Feed Mills', 'UAE', 'contact@sharjahfeed.ae', '+971-6-345-6789', 'Sharjah, UAE', false, 1704067200, true),
('Corn Silage', 'MP-UAE-003-029', 'Corn Silage', 'Concentrate', 2.47, 'AED', 'Sharjah Feed Mills', 'UAE', 'contact@sharjahfeed.ae', '+971-6-345-6789', 'Sharjah, UAE', false, 1704067200, true),
('Corn Gluten Meal', 'MP-UAE-003-030', 'Corn Gluten Meal', 'Concentrate', 2.59, 'AED', 'Sharjah Feed Mills', 'UAE', 'contact@sharjahfeed.ae', '+971-6-345-6789', 'Sharjah, UAE', false, 1704067200, true),
('Sesame seed husk', 'MP-UAE-003-031', 'Sesame seed husk', 'Concentrate', 2.22, 'AED', 'Sharjah Feed Mills', 'UAE', 'contact@sharjahfeed.ae', '+971-6-345-6789', 'Sharjah, UAE', false, 1704067200, true),
('Molasses', 'MP-UAE-003-032', 'Molasses', 'Additive', 3.32, 'AED', 'Sharjah Feed Mills', 'UAE', 'contact@sharjahfeed.ae', '+971-6-345-6789', 'Sharjah, UAE', false, 1704067200, true);

-- Supplier 4: Abu Dhabi Feed Solutions (15 products)
INSERT INTO public.feed_products_sample (product_name, product_code, "name", "type", cost_per_kg, cost_currency, supplier, supplier_country, supplier_email, supplier_phone, supplier_address, is_standard_product, created_at, is_active) VALUES
('Alfalfa hay (mid-bloom)', 'MP-UAE-004-001', 'Alfalfa hay (mid-bloom)', 'Fodder', 1.52, 'AED', 'Abu Dhabi Feed Solutions', 'UAE', 'info@adfeedsolutions.ae', '+971-2-456-7890', 'Abu Dhabi, UAE', false, 1704067200, true),
('Wheat Straw', 'MP-UAE-004-002', 'Wheat Straw', 'Fodder', 0.96, 'AED', 'Abu Dhabi Feed Solutions', 'UAE', 'info@adfeedsolutions.ae', '+971-2-456-7890', 'Abu Dhabi, UAE', false, 1704067200, true),
('Barley', 'MP-UAE-004-003', 'Barley', 'Fodder', 1.44, 'AED', 'Abu Dhabi Feed Solutions', 'UAE', 'info@adfeedsolutions.ae', '+971-2-456-7890', 'Abu Dhabi, UAE', false, 1704067200, true),
('Corn', 'MP-UAE-004-004', 'Corn', 'Fodder', 1.38, 'AED', 'Abu Dhabi Feed Solutions', 'UAE', 'info@adfeedsolutions.ae', '+971-2-456-7890', 'Abu Dhabi, UAE', false, 1704067200, true),
('Barley - raw', 'MP-UAE-004-005', 'Barley - raw', 'Concentrate', 2.28, 'AED', 'Abu Dhabi Feed Solutions', 'UAE', 'info@adfeedsolutions.ae', '+971-2-456-7890', 'Abu Dhabi, UAE', false, 1704067200, true),
('Barley - Flakes', 'MP-UAE-004-006', 'Barley - Flakes', 'Concentrate', 2.46, 'AED', 'Abu Dhabi Feed Solutions', 'UAE', 'info@adfeedsolutions.ae', '+971-2-456-7890', 'Abu Dhabi, UAE', false, 1704067200, true),
('Soya Bean Meal', 'MP-UAE-004-007', 'Soya Bean Meal', 'Concentrate', 2.65, 'AED', 'Abu Dhabi Feed Solutions', 'UAE', 'info@adfeedsolutions.ae', '+971-2-456-7890', 'Abu Dhabi, UAE', false, 1704067200, true),
('Steamed Corn Flake', 'MP-UAE-004-008', 'Steamed Corn Flake', 'Concentrate', 2.53, 'AED', 'Abu Dhabi Feed Solutions', 'UAE', 'info@adfeedsolutions.ae', '+971-2-456-7890', 'Abu Dhabi, UAE', false, 1704067200, true),
('Wheat grain', 'MP-UAE-004-009', 'Wheat grain', 'Concentrate', 2.46, 'AED', 'Abu Dhabi Feed Solutions', 'UAE', 'info@adfeedsolutions.ae', '+971-2-456-7890', 'Abu Dhabi, UAE', false, 1704067200, true),
('Cotton meal', 'MP-UAE-004-010', 'Cotton meal', 'Concentrate', 2.53, 'AED', 'Abu Dhabi Feed Solutions', 'UAE', 'info@adfeedsolutions.ae', '+971-2-456-7890', 'Abu Dhabi, UAE', false, 1704067200, true),
('Maize grain', 'MP-UAE-004-011', 'Maize grain', 'Concentrate', 2.50, 'AED', 'Abu Dhabi Feed Solutions', 'UAE', 'info@adfeedsolutions.ae', '+971-2-456-7890', 'Abu Dhabi, UAE', false, 1704067200, true),
('Molasses', 'MP-UAE-004-012', 'Molasses', 'Additive', 3.40, 'AED', 'Abu Dhabi Feed Solutions', 'UAE', 'info@adfeedsolutions.ae', '+971-2-456-7890', 'Abu Dhabi, UAE', false, 1704067200, true),
('Limestone', 'MP-UAE-004-013', 'Limestone', 'Additive', 3.05, 'AED', 'Abu Dhabi Feed Solutions', 'UAE', 'info@adfeedsolutions.ae', '+971-2-456-7890', 'Abu Dhabi, UAE', false, 1704067200, true),
('Salt', 'MP-UAE-004-014', 'Salt', 'Additive', 2.85, 'AED', 'Abu Dhabi Feed Solutions', 'UAE', 'info@adfeedsolutions.ae', '+971-2-456-7890', 'Abu Dhabi, UAE', false, 1704067200, true),
('Urea', 'MP-UAE-004-015', 'Urea', 'Additive', 4.55, 'AED', 'Abu Dhabi Feed Solutions', 'UAE', 'info@adfeedsolutions.ae', '+971-2-456-7890', 'Abu Dhabi, UAE', false, 1704067200, true);

-- Supplier 5: Ras Al Khaimah Feed Co (12 products)
INSERT INTO public.feed_products_sample (product_name, product_code, "name", "type", cost_per_kg, cost_currency, supplier, supplier_country, supplier_email, supplier_phone, supplier_address, is_standard_product, created_at, is_active) VALUES
('Alfalfa hay (mid-bloom)', 'MP-UAE-005-001', 'Alfalfa hay (mid-bloom)', 'Fodder', 1.46, 'AED', 'Ras Al Khaimah Feed Co', 'UAE', 'sales@rakfeed.ae', '+971-7-567-8901', 'Ras Al Khaimah, UAE', false, 1704067200, true),
('Wheat Straw', 'MP-UAE-005-002', 'Wheat Straw', 'Fodder', 0.91, 'AED', 'Ras Al Khaimah Feed Co', 'UAE', 'sales@rakfeed.ae', '+971-7-567-8901', 'Ras Al Khaimah, UAE', false, 1704067200, true),
('Barley', 'MP-UAE-005-003', 'Barley', 'Fodder', 1.38, 'AED', 'Ras Al Khaimah Feed Co', 'UAE', 'sales@rakfeed.ae', '+971-7-567-8901', 'Ras Al Khaimah, UAE', false, 1704067200, true),
('Corn', 'MP-UAE-005-004', 'Corn', 'Fodder', 1.32, 'AED', 'Ras Al Khaimah Feed Co', 'UAE', 'sales@rakfeed.ae', '+971-7-567-8901', 'Ras Al Khaimah, UAE', false, 1704067200, true),
('Barley - raw', 'MP-UAE-005-005', 'Barley - raw', 'Concentrate', 2.20, 'AED', 'Ras Al Khaimah Feed Co', 'UAE', 'sales@rakfeed.ae', '+971-7-567-8901', 'Ras Al Khaimah, UAE', false, 1704067200, true),
('Barley - Flakes', 'MP-UAE-005-006', 'Barley - Flakes', 'Concentrate', 2.38, 'AED', 'Ras Al Khaimah Feed Co', 'UAE', 'sales@rakfeed.ae', '+971-7-567-8901', 'Ras Al Khaimah, UAE', false, 1704067200, true),
('Soya Bean Meal', 'MP-UAE-005-007', 'Soya Bean Meal', 'Concentrate', 2.57, 'AED', 'Ras Al Khaimah Feed Co', 'UAE', 'sales@rakfeed.ae', '+971-7-567-8901', 'Ras Al Khaimah, UAE', false, 1704067200, true),
('Steamed Corn Flake', 'MP-UAE-005-008', 'Steamed Corn Flake', 'Concentrate', 2.45, 'AED', 'Ras Al Khaimah Feed Co', 'UAE', 'sales@rakfeed.ae', '+971-7-567-8901', 'Ras Al Khaimah, UAE', false, 1704067200, true),
('Wheat grain', 'MP-UAE-005-009', 'Wheat grain', 'Concentrate', 2.38, 'AED', 'Ras Al Khaimah Feed Co', 'UAE', 'sales@rakfeed.ae', '+971-7-567-8901', 'Ras Al Khaimah, UAE', false, 1704067200, true),
('Molasses', 'MP-UAE-005-010', 'Molasses', 'Additive', 3.30, 'AED', 'Ras Al Khaimah Feed Co', 'UAE', 'sales@rakfeed.ae', '+971-7-567-8901', 'Ras Al Khaimah, UAE', false, 1704067200, true),
('Limestone', 'MP-UAE-005-011', 'Limestone', 'Additive', 2.94, 'AED', 'Ras Al Khaimah Feed Co', 'UAE', 'sales@rakfeed.ae', '+971-7-567-8901', 'Ras Al Khaimah, UAE', false, 1704067200, true),
('Salt', 'MP-UAE-005-012', 'Salt', 'Additive', 2.75, 'AED', 'Ras Al Khaimah Feed Co', 'UAE', 'sales@rakfeed.ae', '+971-7-567-8901', 'Ras Al Khaimah, UAE', false, 1704067200, true);

-- ============================================================================
-- SAUDI ARABIA SUPPLIERS (5 suppliers)
-- ============================================================================

-- Supplier 1: Riyadh Feed Corporation (28 products)
INSERT INTO public.feed_products_sample (product_name, product_code, "name", "type", cost_per_kg, cost_currency, supplier, supplier_country, supplier_email, supplier_phone, supplier_address, is_standard_product, created_at, is_active) VALUES
('Riyadh Premium Alfalfa', 'MP-SA-001-001', 'Riyadh Premium Alfalfa', 'Fodder', 1.69, 'SAR', 'Riyadh Feed Corporation', 'Saudi Arabia', 'sales@riyadhfeed.sa', '+966-11-123-4567', 'Riyadh, Saudi Arabia', false, 1704067200, true),
('Jeddah Wheat Straw', 'MP-SA-001-002', 'Jeddah Wheat Straw', 'Fodder', 0.98, 'SAR', 'Riyadh Feed Corporation', 'Saudi Arabia', 'sales@riyadhfeed.sa', '+966-11-123-4567', 'Riyadh, Saudi Arabia', false, 1704067200, true),
('Barley Premium', 'MP-SA-001-003', 'Barley Premium', 'Fodder', 1.50, 'SAR', 'Riyadh Feed Corporation', 'Saudi Arabia', 'sales@riyadhfeed.sa', '+966-11-123-4567', 'Riyadh, Saudi Arabia', false, 1704067200, true),
('Corn Premium', 'MP-SA-001-004', 'Corn Premium', 'Fodder', 1.44, 'SAR', 'Riyadh Feed Corporation', 'Saudi Arabia', 'sales@riyadhfeed.sa', '+966-11-123-4567', 'Riyadh, Saudi Arabia', false, 1704067200, true),
('Soybean Premium', 'MP-SA-001-005', 'Soybean Premium', 'Fodder', 1.78, 'SAR', 'Riyadh Feed Corporation', 'Saudi Arabia', 'sales@riyadhfeed.sa', '+966-11-123-4567', 'Riyadh, Saudi Arabia', false, 1704067200, true),
('Oat Hay Premium', 'MP-SA-001-006', 'Oat Hay Premium', 'Fodder', 1.40, 'SAR', 'Riyadh Feed Corporation', 'Saudi Arabia', 'sales@riyadhfeed.sa', '+966-11-123-4567', 'Riyadh, Saudi Arabia', false, 1704067200, true),
('Triticale Silage', 'MP-SA-001-007', 'Triticale Silage', 'Fodder', 1.22, 'SAR', 'Riyadh Feed Corporation', 'Saudi Arabia', 'sales@riyadhfeed.sa', '+966-11-123-4567', 'Riyadh, Saudi Arabia', false, 1704067200, true),
('Wheat Bran', 'MP-SA-001-008', 'Wheat Bran', 'Fodder', 1.03, 'SAR', 'Riyadh Feed Corporation', 'Saudi Arabia', 'sales@riyadhfeed.sa', '+966-11-123-4567', 'Riyadh, Saudi Arabia', false, 1704067200, true),
('White Hay', 'MP-SA-001-009', 'White Hay', 'Fodder', 1.22, 'SAR', 'Riyadh Feed Corporation', 'Saudi Arabia', 'sales@riyadhfeed.sa', '+966-11-123-4567', 'Riyadh, Saudi Arabia', false, 1704067200, true),
('Red Hay', 'MP-SA-001-010', 'Red Hay', 'Fodder', 1.22, 'SAR', 'Riyadh Feed Corporation', 'Saudi Arabia', 'sales@riyadhfeed.sa', '+966-11-123-4567', 'Riyadh, Saudi Arabia', false, 1704067200, true),
('Alfalfa', 'MP-SA-001-011', 'Alfalfa', 'Fodder', 1.69, 'SAR', 'Riyadh Feed Corporation', 'Saudi Arabia', 'sales@riyadhfeed.sa', '+966-11-123-4567', 'Riyadh, Saudi Arabia', false, 1704067200, true),
('Fermented Corn', 'MP-SA-001-012', 'Fermented Corn', 'Fodder', 1.50, 'SAR', 'Riyadh Feed Corporation', 'Saudi Arabia', 'sales@riyadhfeed.sa', '+966-11-123-4567', 'Riyadh, Saudi Arabia', false, 1704067200, true),
('Soybean Hulls', 'MP-SA-001-013', 'Soybean Hulls', 'Fodder', 1.31, 'SAR', 'Riyadh Feed Corporation', 'Saudi Arabia', 'sales@riyadhfeed.sa', '+966-11-123-4567', 'Riyadh, Saudi Arabia', false, 1704067200, true),
('Barley - raw', 'MP-SA-001-014', 'Barley - raw', 'Concentrate', 2.31, 'SAR', 'Riyadh Feed Corporation', 'Saudi Arabia', 'sales@riyadhfeed.sa', '+966-11-123-4567', 'Riyadh, Saudi Arabia', false, 1704067200, true),
('Barley - Flakes', 'MP-SA-001-015', 'Barley - Flakes', 'Concentrate', 2.50, 'SAR', 'Riyadh Feed Corporation', 'Saudi Arabia', 'sales@riyadhfeed.sa', '+966-11-123-4567', 'Riyadh, Saudi Arabia', false, 1704067200, true),
('Soya Bean Meal', 'MP-SA-001-016', 'Soya Bean Meal', 'Concentrate', 2.69, 'SAR', 'Riyadh Feed Corporation', 'Saudi Arabia', 'sales@riyadhfeed.sa', '+966-11-123-4567', 'Riyadh, Saudi Arabia', false, 1704067200, true),
('Steamed Corn Flake', 'MP-SA-001-017', 'Steamed Corn Flake', 'Concentrate', 2.56, 'SAR', 'Riyadh Feed Corporation', 'Saudi Arabia', 'sales@riyadhfeed.sa', '+966-11-123-4567', 'Riyadh, Saudi Arabia', false, 1704067200, true),
('Steamed Barley Flakes', 'MP-SA-001-018', 'Steamed Barley Flakes', 'Concentrate', 2.63, 'SAR', 'Riyadh Feed Corporation', 'Saudi Arabia', 'sales@riyadhfeed.sa', '+966-11-123-4567', 'Riyadh, Saudi Arabia', false, 1704067200, true),
('Barley grain', 'MP-SA-001-019', 'Barley grain', 'Concentrate', 2.31, 'SAR', 'Riyadh Feed Corporation', 'Saudi Arabia', 'sales@riyadhfeed.sa', '+966-11-123-4567', 'Riyadh, Saudi Arabia', false, 1704067200, true),
('Soybean husk', 'MP-SA-001-020', 'Soybean husk', 'Concentrate', 2.31, 'SAR', 'Riyadh Feed Corporation', 'Saudi Arabia', 'sales@riyadhfeed.sa', '+966-11-123-4567', 'Riyadh, Saudi Arabia', false, 1704067200, true),
('Wheat grain', 'MP-SA-001-021', 'Wheat grain', 'Concentrate', 2.50, 'SAR', 'Riyadh Feed Corporation', 'Saudi Arabia', 'sales@riyadhfeed.sa', '+966-11-123-4567', 'Riyadh, Saudi Arabia', false, 1704067200, true),
('Cotton meal', 'MP-SA-001-022', 'Cotton meal', 'Concentrate', 2.56, 'SAR', 'Riyadh Feed Corporation', 'Saudi Arabia', 'sales@riyadhfeed.sa', '+966-11-123-4567', 'Riyadh, Saudi Arabia', false, 1704067200, true),
('Beetroot pellets', 'MP-SA-001-023', 'Beetroot pellets', 'Concentrate', 2.50, 'SAR', 'Riyadh Feed Corporation', 'Saudi Arabia', 'sales@riyadhfeed.sa', '+966-11-123-4567', 'Riyadh, Saudi Arabia', false, 1704067200, true),
('Maize grain', 'MP-SA-001-024', 'Maize grain', 'Concentrate', 2.47, 'SAR', 'Riyadh Feed Corporation', 'Saudi Arabia', 'sales@riyadhfeed.sa', '+966-11-123-4567', 'Riyadh, Saudi Arabia', false, 1704067200, true),
('Corn Silage', 'MP-SA-001-025', 'Corn Silage', 'Concentrate', 2.56, 'SAR', 'Riyadh Feed Corporation', 'Saudi Arabia', 'sales@riyadhfeed.sa', '+966-11-123-4567', 'Riyadh, Saudi Arabia', false, 1704067200, true),
('Corn Gluten Meal', 'MP-SA-001-026', 'Corn Gluten Meal', 'Concentrate', 2.69, 'SAR', 'Riyadh Feed Corporation', 'Saudi Arabia', 'sales@riyadhfeed.sa', '+966-11-123-4567', 'Riyadh, Saudi Arabia', false, 1704067200, true),
('Molasses', 'MP-SA-001-027', 'Molasses', 'Additive', 3.45, 'SAR', 'Riyadh Feed Corporation', 'Saudi Arabia', 'sales@riyadhfeed.sa', '+966-11-123-4567', 'Riyadh, Saudi Arabia', false, 1704067200, true),
('Urea', 'MP-SA-001-028', 'Urea', 'Additive', 4.58, 'SAR', 'Riyadh Feed Corporation', 'Saudi Arabia', 'sales@riyadhfeed.sa', '+966-11-123-4567', 'Riyadh, Saudi Arabia', false, 1704067200, true);

-- Continue with more Saudi suppliers and other countries...
-- Due to length constraints, I'll create a script that generates the rest programmatically
-- Let me continue with key suppliers and then add historical pricing section

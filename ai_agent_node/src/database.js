/**
 * Database setup and management for Feed Products AI Agent
 * Uses better-sqlite3 for SQLite operations
 */

import Database from 'better-sqlite3';
import { readFileSync, existsSync, unlinkSync } from 'fs';
import { DATABASE_PATH, DB_DIR } from './config.js';
import { join } from 'path';

let db = null;

/**
 * Create the database schema
 */
function createSchema(database) {
  database.exec(`
    CREATE TABLE IF NOT EXISTS feed_products_sample (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      product_name TEXT NOT NULL,
      product_code TEXT,
      name TEXT,
      type TEXT,
      cost_per_kg REAL,
      cost_currency TEXT,
      supplier TEXT,
      supplier_country TEXT,
      supplier_email TEXT,
      supplier_phone TEXT,
      supplier_address TEXT,
      is_standard_product INTEGER DEFAULT 0,
      created_at INTEGER,
      is_active INTEGER DEFAULT 1
    )
  `);

  database.exec(`
    CREATE TABLE IF NOT EXISTS feed_product_restrictions (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      product_id INTEGER,
      species TEXT,
      sex TEXT,
      min_age_months INTEGER,
      max_age_months INTEGER,
      breeding_cycle TEXT,
      lactation_cycle TEXT,
      production_focus TEXT,
      is_eligible INTEGER DEFAULT 1,
      max_perc_feed REAL,
      max_perc_conc REAL,
      is_active INTEGER DEFAULT 1,
      FOREIGN KEY (product_id) REFERENCES feed_products_sample(id)
    )
  `);

  // Create indexes
  database.exec(`
    CREATE INDEX IF NOT EXISTS idx_product_name ON feed_products_sample(product_name);
    CREATE INDEX IF NOT EXISTS idx_product_type ON feed_products_sample(type);
    CREATE INDEX IF NOT EXISTS idx_supplier_country ON feed_products_sample(supplier_country);
    CREATE INDEX IF NOT EXISTS idx_is_active ON feed_products_sample(is_active);
    CREATE INDEX IF NOT EXISTS idx_supplier ON feed_products_sample(supplier);
    CREATE INDEX IF NOT EXISTS idx_created_at ON feed_products_sample(created_at);
    CREATE INDEX IF NOT EXISTS idx_restrictions_product ON feed_product_restrictions(product_id);
  `);
}

/**
 * Parse comma-separated values from SQL tuples
 */
function parseTupleValues(tupleStr) {
  const values = [];
  let current = '';
  let inQuotes = false;
  let quoteChar = null;

  for (const char of tupleStr) {
    if ((char === "'" || char === '"') && !inQuotes) {
      inQuotes = true;
      quoteChar = char;
    } else if (char === quoteChar && inQuotes) {
      inQuotes = false;
      quoteChar = null;
    } else if (char === ',' && !inQuotes) {
      values.push(current.trim().replace(/^['"]|['"]$/g, ''));
      current = '';
      continue;
    } else {
      current += char;
    }
  }

  if (current.trim()) {
    values.push(current.trim().replace(/^['"]|['"]$/g, ''));
  }

  return values;
}

/**
 * Load seed data from SQL files
 */
function loadSeedData(database) {
  const seedFiles = [
    join(DB_DIR, 'seed_data.sql'),
    join(DB_DIR, 'seed_data_market_products.sql')
  ];

  let totalInserted = 0;
  const insertStmt = database.prepare(`
    INSERT INTO feed_products_sample 
    (product_name, product_code, name, type, cost_per_kg, cost_currency,
     supplier, supplier_country, supplier_email, supplier_phone, supplier_address,
     is_standard_product, created_at, is_active)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
  `);

  const insertStmtNoSupplier = database.prepare(`
    INSERT INTO feed_products_sample 
    (product_name, product_code, name, type, cost_per_kg, cost_currency,
     supplier_country, is_standard_product, created_at, is_active)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
  `);

  for (const seedFile of seedFiles) {
    if (!existsSync(seedFile)) {
      console.log(`Warning: Seed file not found: ${seedFile}`);
      continue;
    }

    console.log(`Loading data from ${seedFile.split('/').pop()}...`);
    const content = readFileSync(seedFile, 'utf-8');

    // Find INSERT statements
    const insertBlocks = content.match(
      /INSERT INTO public\.feed_products_sample\s*\([^)]+\)\s*VALUES\s*([^;]+);/gi
    );

    if (!insertBlocks) continue;

    for (const block of insertBlocks) {
      // Extract VALUES part
      const valuesMatch = block.match(/VALUES\s*(.+);$/is);
      if (!valuesMatch) continue;

      const valuesStr = valuesMatch[1];
      
      // Split by '),\n(' or similar
      const tuples = valuesStr.split(/\),\s*\n?\s*\(/);

      for (let tupleStr of tuples) {
        tupleStr = tupleStr.replace(/^\(/, '').replace(/\)$/, '');
        const values = parseTupleValues(tupleStr);

        if (values.length < 6) continue;

        try {
          if (values.length >= 14) {
            // Full format with supplier
            insertStmt.run(
              values[0], // product_name
              values[1], // product_code
              values[2], // name
              values[3], // type
              parseFloat(values[4]) || null, // cost_per_kg
              values[5], // cost_currency
              values[6] === 'NULL' ? null : values[6], // supplier
              values[7], // supplier_country
              values[8] === 'NULL' ? null : values[8], // supplier_email
              values[9] === 'NULL' ? null : values[9], // supplier_phone
              values[10] === 'NULL' ? null : values[10], // supplier_address
              values[11].toLowerCase() === 'true' ? 1 : 0, // is_standard_product
              parseInt(values[12]) || null, // created_at
              values[13].toLowerCase() === 'true' ? 1 : 0 // is_active
            );
            totalInserted++;
          } else if (values.length >= 10) {
            // Format without supplier
            insertStmtNoSupplier.run(
              values[0], // product_name
              values[1], // product_code
              values[2], // name
              values[3], // type
              parseFloat(values[4]) || null, // cost_per_kg
              values[5], // cost_currency
              values[6], // supplier_country
              values[7].toLowerCase() === 'true' ? 1 : 0, // is_standard_product
              parseInt(values[8]) || null, // created_at
              values[9].toLowerCase() === 'true' ? 1 : 0 // is_active
            );
            totalInserted++;
          }
        } catch (e) {
          // Skip problematic records
        }
      }
    }
  }

  return totalInserted;
}

/**
 * Load historical pricing data
 */
function loadHistoricalData(database) {
  const insertStmt = database.prepare(`
    INSERT INTO feed_products_sample 
    (product_name, product_code, name, type, cost_per_kg, cost_currency,
     supplier_country, is_standard_product, created_at, is_active)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
  `);

  let inserted = 0;

  // Historical data for UAE Alfalfa
  const alfalfaHist = [
    [1704067200, 1.40], [1706745600, 1.42], [1709251200, 1.45], [1711929600, 1.48],
    [1714521600, 1.50], [1717200000, 1.52], [1719792000, 1.55], [1722470400, 1.53],
    [1725148800, 1.50], [1727740800, 1.48], [1730419200, 1.46], [1733011200, 1.47],
    [1735689600, 1.49], [1738368000, 1.51], [1740787200, 1.54], [1743465600, 1.56],
    [1746057600, 1.58], [1748736000, 1.60], [1751328000, 1.62], [1754006400, 1.60],
    [1756684800, 1.58], [1759276800, 1.56], [1761955200, 1.54], [1764547200, 1.52],
    [1767225600, 1.50]
  ];

  for (const [ts, price] of alfalfaHist) {
    const isActive = ts === 1767225600 ? 1 : 0;
    insertStmt.run('Alfalfa hay (mid-bloom)', 'FP-001-HIST', 'Alfalfa hay (mid-bloom)',
      'Fodder', price, 'AED', 'UAE', 1, ts, isActive);
    inserted++;
  }

  // Historical data for Saudi Arabia Wheat Straw
  const wheatHist = [
    [1704067200, 0.90], [1706745600, 0.92], [1709251200, 0.94], [1711929600, 0.96],
    [1714521600, 0.98], [1717200000, 1.00], [1719792000, 1.02], [1722470400, 1.00],
    [1725148800, 0.98], [1727740800, 0.96], [1730419200, 0.94], [1733011200, 0.94],
    [1735689600, 0.95], [1738368000, 0.97], [1740787200, 0.99], [1743465600, 1.01],
    [1746057600, 1.03], [1748736000, 1.05], [1751328000, 1.07], [1754006400, 1.05],
    [1756684800, 1.03], [1759276800, 1.01], [1761955200, 0.99], [1764547200, 0.97],
    [1767225600, 0.95]
  ];

  for (const [ts, price] of wheatHist) {
    const isActive = ts === 1767225600 ? 1 : 0;
    insertStmt.run('Wheat Straw', 'FP-002-HIST', 'Wheat Straw',
      'Fodder', price, 'SAR', 'Saudi Arabia', 1, ts, isActive);
    inserted++;
  }

  // Historical data for Egypt Barley
  const barleyHist = [
    [1704067200, 11.20], [1706745600, 11.40], [1709251200, 11.60], [1711929600, 11.80],
    [1714521600, 12.00], [1717200000, 12.20], [1719792000, 12.40], [1722470400, 12.30],
    [1725148800, 12.10], [1727740800, 11.90], [1730419200, 11.70], [1733011200, 11.64],
    [1735689600, 11.80], [1738368000, 12.00], [1740787200, 12.20], [1743465600, 12.40],
    [1746057600, 12.60], [1748736000, 12.80], [1751328000, 13.00], [1754006400, 12.90],
    [1756684800, 12.70], [1759276800, 12.50], [1761955200, 12.30], [1764547200, 12.10],
    [1767225600, 11.95]
  ];

  for (const [ts, price] of barleyHist) {
    const isActive = ts === 1767225600 ? 1 : 0;
    insertStmt.run('Barley', 'FP-005-HIST', 'Barley',
      'Fodder', price, 'EGP', 'Egypt', 1, ts, isActive);
    inserted++;
  }

  return inserted;
}

/**
 * Load product restrictions
 */
function loadRestrictions(database) {
  let inserted = 0;

  // Get concentrate/additive products
  const products = database.prepare(`
    SELECT id, product_code, product_name, type, supplier_country 
    FROM feed_products_sample 
    WHERE type IN ('Concentrate', 'Additive') AND is_active = 1
    LIMIT 50
  `).all();

  const insertStmt = database.prepare(`
    INSERT INTO feed_product_restrictions 
    (product_id, species, sex, min_age_months, max_age_months, lactation_cycle, 
     production_focus, max_perc_feed, max_perc_conc, is_active)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 1)
  `);

  for (const prod of products) {
    const name = prod.product_name.toLowerCase();

    if (name.includes('barley') && prod.type === 'Concentrate') {
      insertStmt.run(prod.id, 'cattle', null, 0, 12, null, null, 30.0, null);
      insertStmt.run(prod.id, 'sheep', null, null, null, null, null, 20.0, null);
      inserted += 2;
    } else if (name.includes('soya') || name.includes('soybean')) {
      insertStmt.run(prod.id, 'cattle', 'female', null, null, 'early', 'dairy', null, 25.0);
      inserted++;
    } else if (name.includes('urea')) {
      insertStmt.run(prod.id, 'cattle', null, 12, null, null, null, 1.0, null);
      inserted++;
    } else if (name.includes('molasses')) {
      insertStmt.run(prod.id, 'cattle', null, null, null, null, null, 10.0, null);
      inserted++;
    }
  }

  return inserted;
}

/**
 * Initialize the database
 */
export function initializeDatabase(forceRecreate = false) {
  if (forceRecreate && existsSync(DATABASE_PATH)) {
    unlinkSync(DATABASE_PATH);
    console.log('Removed existing database.');
  }

  const dbExists = existsSync(DATABASE_PATH);
  db = new Database(DATABASE_PATH);

  if (!dbExists || forceRecreate) {
    console.log('Creating database schema...');
    createSchema(db);

    console.log('Loading seed data...');
    const productsCount = loadSeedData(db);
    console.log(`Loaded ${productsCount} feed products.`);

    console.log('Loading historical pricing data...');
    const historicalCount = loadHistoricalData(db);
    console.log(`Loaded ${historicalCount} historical price records.`);

    console.log('Loading restrictions...');
    const restrictionsCount = loadRestrictions(db);
    console.log(`Created ${restrictionsCount} product restrictions.`);

    console.log('Database initialization complete!');
  } else {
    console.log('Using existing database.');
  }

  return db;
}

/**
 * Get the database instance
 */
export function getDatabase() {
  if (!db) {
    db = initializeDatabase();
  }
  return db;
}

/**
 * Execute a SQL query
 */
export function executeQuery(query) {
  try {
    const database = getDatabase();
    const stmt = database.prepare(query);
    const results = stmt.all();
    return { data: results, error: null };
  } catch (error) {
    return { data: [], error: error.message };
  }
}

/**
 * Get database statistics
 */
export function getStats() {
  const database = getDatabase();

  const stats = {
    total_products: database.prepare('SELECT COUNT(*) as count FROM feed_products_sample').get().count,
    active_products: database.prepare('SELECT COUNT(*) as count FROM feed_products_sample WHERE is_active = 1').get().count,
    products_by_type: {},
    products_by_country: {},
    unique_suppliers: database.prepare('SELECT COUNT(DISTINCT supplier) as count FROM feed_products_sample WHERE supplier IS NOT NULL AND is_active = 1').get().count,
    total_restrictions: database.prepare('SELECT COUNT(*) as count FROM feed_product_restrictions WHERE is_active = 1').get().count
  };

  // Products by type
  const typeRows = database.prepare('SELECT type, COUNT(*) as count FROM feed_products_sample WHERE is_active = 1 GROUP BY type').all();
  for (const row of typeRows) {
    stats.products_by_type[row.type] = row.count;
  }

  // Products by country
  const countryRows = database.prepare('SELECT supplier_country, COUNT(*) as count FROM feed_products_sample WHERE is_active = 1 GROUP BY supplier_country').all();
  for (const row of countryRows) {
    stats.products_by_country[row.supplier_country] = row.count;
  }

  return stats;
}

/**
 * Close the database connection
 */
export function closeDatabase() {
  if (db) {
    db.close();
    db = null;
  }
}

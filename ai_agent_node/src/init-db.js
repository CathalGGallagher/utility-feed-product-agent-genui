#!/usr/bin/env node
/**
 * Database initialization script
 */

import { initializeDatabase, getStats, closeDatabase } from './database.js';

console.log('🔄 Initializing database...');

try {
  initializeDatabase(true); // Force recreate
  
  console.log('\n📊 Database Statistics:');
  const stats = getStats();
  console.log(`  Total Products: ${stats.total_products}`);
  console.log(`  Active Products: ${stats.active_products}`);
  console.log(`  Unique Suppliers: ${stats.unique_suppliers}`);
  console.log(`  Total Restrictions: ${stats.total_restrictions}`);
  
  console.log('\n  Products by Type:');
  for (const [type, count] of Object.entries(stats.products_by_type)) {
    console.log(`    • ${type}: ${count}`);
  }
  
  console.log('\n✅ Database initialized successfully!');
  
  closeDatabase();
} catch (error) {
  console.error('❌ Error initializing database:', error.message);
  process.exit(1);
}

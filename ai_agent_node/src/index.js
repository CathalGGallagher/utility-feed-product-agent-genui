#!/usr/bin/env node
/**
 * Feed Products AI Agent - Main Entry Point
 */

import { createAgent } from './agent.js';
import { initializeDatabase, getStats, closeDatabase } from './database.js';

const args = process.argv.slice(2);

function showHelp() {
  console.log(`
Feed Products AI Agent - Query feed products using natural language

Usage:
  npm start                     Start interactive CLI
  npm run cli                   Start interactive CLI
  npm run api                   Start REST API server
  npm run init-db               Initialize/reset database

  node src/index.js --query "Who sells cheapest wheat straw?"
  node src/index.js --stats
  node src/index.js --help

Options:
  --help, -h          Show this help message
  --query, -q <text>  Run a single query
  --stats             Show database statistics
  --init-db           Initialize database

Environment Variables:
  GOOGLE_API_KEY      Google Gemini API key for AI-powered queries
  GEMINI_MODEL        Gemini model (default: gemini-1.5-flash)
  API_PORT            API server port (default: 3000)
`);
}

async function runQuery(query) {
  console.log(`\n❓ Query: ${query}\n`);
  
  const agent = createAgent();
  const result = await agent.processQuery(query);
  
  console.log(`🌐 Language: ${result.language}`);
  
  if (result.success) {
    console.log(`\n📝 Response:\n${result.response}`);
  } else {
    console.log(`❌ Error: ${result.error}`);
  }
  
  closeDatabase();
}

function showStats() {
  initializeDatabase();
  const stats = getStats();
  
  console.log('\n📊 Database Statistics:');
  console.log('─'.repeat(40));
  console.log(`Total Products: ${stats.total_products}`);
  console.log(`Active Products: ${stats.active_products}`);
  console.log(`Unique Suppliers: ${stats.unique_suppliers}`);
  console.log(`Total Restrictions: ${stats.total_restrictions}`);
  
  console.log('\nProducts by Type:');
  for (const [type, count] of Object.entries(stats.products_by_type)) {
    console.log(`  ${type}: ${count}`);
  }
  
  console.log('\nProducts by Country:');
  const sorted = Object.entries(stats.products_by_country).sort((a, b) => b[1] - a[1]);
  for (const [country, count] of sorted) {
    console.log(`  ${country}: ${count}`);
  }
  
  closeDatabase();
}

// Parse arguments
async function main() {
  if (args.includes('--help') || args.includes('-h')) {
    showHelp();
    return;
  }
  
  if (args.includes('--stats')) {
    showStats();
    return;
  }
  
  if (args.includes('--init-db')) {
    console.log('🔄 Initializing database...');
    initializeDatabase(true);
    console.log('✅ Database initialized!');
    closeDatabase();
    return;
  }
  
  const queryIndex = args.findIndex(a => a === '--query' || a === '-q');
  if (queryIndex !== -1 && args[queryIndex + 1]) {
    await runQuery(args[queryIndex + 1]);
    return;
  }
  
  // Default: show help
  showHelp();
  console.log('\nTo start the CLI, run: npm run cli');
  console.log('To start the API, run: npm run api');
}

main().catch(console.error);

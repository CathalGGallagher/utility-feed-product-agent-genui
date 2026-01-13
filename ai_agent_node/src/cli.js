#!/usr/bin/env node
/**
 * Command Line Interface for Feed Products AI Agent
 * Interactive chat interface supporting Arabic and English
 */

import { createAgent } from './agent.js';
import { getStats, closeDatabase } from './database.js';
import chalk from 'chalk';
import { createInterface } from 'readline';

let agent = null;
let lastSql = '';

/**
 * Print welcome message
 */
function showWelcome() {
  console.log(chalk.green.bold(`
╔══════════════════════════════════════════════════════════════════════════════╗
║                                                                              ║
║  🌾 Feed Products AI Agent | وكيل الذكاء الاصطناعي لمنتجات الأعلاف           ║
║                                                                              ║
║  An intelligent assistant for querying feed products data.                   ║
║  Supports English and Arabic (العربية)                                       ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝
`));

  console.log(chalk.cyan('Example queries | أمثلة:'));
  console.log('  • Who is selling the cheapest Wheat Straw?');
  console.log('  • من يبيع أرخص قش القمح؟');
  console.log('  • What is the average price of Barley in UAE?');
  console.log('  • When is the best time to buy Corn?');
  console.log();
  console.log(chalk.yellow('Commands: help, stats, sql, clear, exit'));
  console.log();
}

/**
 * Show help
 */
function showHelp() {
  console.log(chalk.cyan.bold(`
╔═══════════════════════════════════════════════════════════════╗
║                         HELP                                  ║
╚═══════════════════════════════════════════════════════════════╝
`));
  console.log(`
${chalk.bold('Query Types:')}

${chalk.green('Price Queries:')}
  • "Who is selling the cheapest Wheat Straw?"
  • "What is the average price of Barley?"
  • "من يبيع أرخص قش القمح؟"

${chalk.green('Supplier Queries:')}
  • "Which suppliers sell Alfalfa hay in UAE?"
  • "Who sells Corn in Saudi Arabia?"

${chalk.green('Historical Data:')}
  • "When is the best time to buy Wheat?"
  • "Show price trends for Barley"

${chalk.green('Product Information:')}
  • "List all concentrates in Egypt"
  • "What restrictions apply to Urea?"

${chalk.bold('Commands:')}
  help   - Show this help
  stats  - Show database statistics
  sql    - Show last SQL query
  clear  - Clear screen
  exit   - Exit program
`);
}

/**
 * Show stats
 */
function showStats() {
  const stats = getStats();
  
  console.log(chalk.blue.bold(`
╔═══════════════════════════════════════════════════════════════╗
║                    DATABASE STATISTICS                        ║
╚═══════════════════════════════════════════════════════════════╝
`));
  
  console.log(chalk.white(`
  Total Products:     ${stats.total_products}
  Active Products:    ${stats.active_products}
  Unique Suppliers:   ${stats.unique_suppliers}
  Total Restrictions: ${stats.total_restrictions}
`));
  
  console.log(chalk.cyan('  Products by Type:'));
  for (const [type, count] of Object.entries(stats.products_by_type)) {
    console.log(`    • ${type}: ${count}`);
  }
  
  console.log(chalk.cyan('\n  Top Countries:'));
  const sortedCountries = Object.entries(stats.products_by_country)
    .sort((a, b) => b[1] - a[1])
    .slice(0, 8);
  for (const [country, count] of sortedCountries) {
    console.log(`    • ${country}: ${count}`);
  }
  console.log();
}

/**
 * Process a command
 */
function processCommand(input) {
  const cmd = input.trim().toLowerCase();
  
  switch (cmd) {
    case 'help':
      showHelp();
      return true;
    case 'stats':
      showStats();
      return true;
    case 'sql':
      if (lastSql) {
        console.log(chalk.yellow('\nLast SQL Query:'));
        console.log(chalk.gray(lastSql));
        console.log();
      } else {
        console.log(chalk.yellow('No SQL query has been executed yet.'));
      }
      return true;
    case 'clear':
      console.clear();
      return true;
    case 'exit':
    case 'quit':
    case 'bye':
    case 'خروج':
      console.log(chalk.green('\n👋 Goodbye! | مع السلامة!\n'));
      closeDatabase();
      process.exit(0);
    default:
      return false;
  }
}

/**
 * Main CLI function
 */
async function main() {
  showWelcome();
  
  console.log(chalk.yellow('⏳ Initializing agent...'));
  agent = createAgent();
  console.log(chalk.green('✅ Agent ready!\n'));
  
  const rl = createInterface({
    input: process.stdin,
    output: process.stdout
  });
  
  const prompt = () => {
    rl.question(chalk.blue.bold('\n🔍 Your question: '), async (input) => {
      if (!input.trim()) {
        prompt();
        return;
      }
      
      // Check for commands
      if (processCommand(input)) {
        prompt();
        return;
      }
      
      // Process query
      console.log(chalk.yellow('\n⏳ Processing...'));
      
      try {
        const result = await agent.processQuery(input);
        
        lastSql = result.sql;
        
        const langIndicator = result.language === 'ar' ? '🇸🇦' : '🇬🇧';
        console.log(chalk.dim(`\n${langIndicator} Language: ${result.language}`));
        
        if (result.success) {
          console.log(chalk.green.bold('\n📝 Response:'));
          console.log(result.response);
        } else {
          console.log(chalk.red(`\n❌ Error: ${result.error}`));
          console.log(result.response);
        }
        
      } catch (error) {
        console.log(chalk.red(`\n❌ Error: ${error.message}`));
      }
      
      prompt();
    });
  };
  
  prompt();
  
  rl.on('close', () => {
    console.log(chalk.green('\n👋 Goodbye! | مع السلامة!\n'));
    closeDatabase();
    process.exit(0);
  });
}

main().catch(console.error);

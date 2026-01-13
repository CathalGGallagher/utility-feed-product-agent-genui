#!/usr/bin/env node
/**
 * Test script for the Feed Products AI Agent
 */

import { createAgent } from './agent.js';
import { closeDatabase } from './database.js';

const testQueries = [
  "Who is selling the cheapest Wheat Straw?",
  "من يبيع أرخص قش القمح؟",
  "What is the average price of Barley in UAE?",
  "Which suppliers sell Alfalfa in Saudi Arabia?",
  "When is the best time to buy Wheat Straw?",
  "ما هو أفضل وقت لشراء الشعير؟"
];

async function runTests() {
  console.log('🧪 Testing Feed Products AI Agent\n');
  console.log('═'.repeat(60));
  
  const agent = createAgent();
  
  for (const query of testQueries) {
    console.log(`\n❓ Query: ${query}`);
    console.log('─'.repeat(60));
    
    try {
      const result = await agent.processQuery(query);
      
      console.log(`🌐 Language: ${result.language}`);
      console.log(`✅ Success: ${result.success}`);
      console.log(`📊 Results: ${result.data.length} items`);
      console.log(`\n📝 Response:\n${result.response.substring(0, 500)}${result.response.length > 500 ? '...' : ''}`);
      
      if (result.error) {
        console.log(`❌ Error: ${result.error}`);
      }
    } catch (error) {
      console.log(`❌ Error: ${error.message}`);
    }
    
    console.log('─'.repeat(60));
  }
  
  console.log('\n✅ Tests complete!');
  closeDatabase();
}

runTests().catch(console.error);

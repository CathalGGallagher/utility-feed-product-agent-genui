#!/usr/bin/env node
/**
 * Express REST API for Feed Products AI Agent
 * Provides endpoints for the AI agent
 * Ready for integration with React/Flutter UI
 */

import express from 'express';
import cors from 'cors';
import { createAgent } from './agent.js';
import { getStats, executeQuery, closeDatabase } from './database.js';
import { API_PORT, API_HOST } from './config.js';

const app = express();
let agent = null;

// Middleware
app.use(cors());
app.use(express.json());

// Root endpoint
app.get('/', (req, res) => {
  res.json({
    message: 'Feed Products AI Agent API | وكيل الذكاء الاصطناعي لمنتجات الأعلاف',
    version: '1.0.0',
    endpoints: {
      query: 'POST /query - Natural language query',
      queryGet: 'GET /query?q=... - Simple query',
      stats: 'GET /stats - Database statistics',
      search: 'POST /search/products - Structured search',
      types: 'GET /products/types - Product types',
      countries: 'GET /products/countries - Available countries',
      suppliers: 'GET /products/suppliers - Suppliers list',
      history: 'GET /products/:name/history - Price history',
      examples: 'GET /examples - Example queries',
      health: 'GET /health - Health check'
    }
  });
});

// Health check
app.get('/health', (req, res) => {
  res.json({
    status: 'healthy',
    database_connected: true,
    ai_model_available: agent?.geminiAvailable || false,
    timestamp: new Date().toISOString()
  });
});

// Process natural language query (POST)
app.post('/query', async (req, res) => {
  try {
    const { query, language } = req.body;
    
    if (!query) {
      return res.status(400).json({ error: 'Query is required' });
    }
    
    const result = await agent.processQuery(query);
    
    res.json({
      success: result.success,
      query,
      detected_language: language || result.language,
      response: result.response,
      sql_query: result.sql,
      data: result.data,
      result_count: result.data.length,
      error: result.error,
      timestamp: new Date().toISOString()
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Process query (GET for simple testing)
app.get('/query', async (req, res) => {
  try {
    const query = req.query.q;
    
    if (!query) {
      return res.status(400).json({ error: 'Query parameter q is required' });
    }
    
    const result = await agent.processQuery(query);
    
    res.json({
      success: result.success,
      query,
      detected_language: result.language,
      response: result.response,
      sql_query: result.sql,
      data: result.data,
      result_count: result.data.length,
      error: result.error,
      timestamp: new Date().toISOString()
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Database statistics
app.get('/stats', (req, res) => {
  try {
    const stats = getStats();
    res.json(stats);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Structured product search
app.post('/search/products', (req, res) => {
  try {
    const { product_name, product_type, country, supplier, min_price, max_price, limit = 20 } = req.body;
    
    const conditions = ['is_active = 1'];
    
    if (product_name) conditions.push(`LOWER(product_name) LIKE '%${product_name.toLowerCase()}%'`);
    if (product_type) conditions.push(`type = '${product_type}'`);
    if (country) conditions.push(`supplier_country = '${country}'`);
    if (supplier) conditions.push(`LOWER(supplier) LIKE '%${supplier.toLowerCase()}%'`);
    if (min_price) conditions.push(`cost_per_kg >= ${min_price}`);
    if (max_price) conditions.push(`cost_per_kg <= ${max_price}`);
    
    const sql = `
      SELECT product_name, type, supplier, supplier_country, 
             cost_per_kg, cost_currency, supplier_email, supplier_phone
      FROM feed_products_sample
      WHERE ${conditions.join(' AND ')}
      ORDER BY cost_per_kg ASC
      LIMIT ${Math.min(limit, 100)}
    `;
    
    const { data, error } = executeQuery(sql);
    
    if (error) {
      return res.status(400).json({ error });
    }
    
    res.json({
      success: true,
      data,
      count: data.length,
      filters_applied: { product_name, product_type, country, supplier, min_price, max_price }
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Get product types
app.get('/products/types', (req, res) => {
  try {
    const { data } = executeQuery('SELECT DISTINCT type FROM feed_products_sample WHERE is_active = 1 ORDER BY type');
    res.json({ types: data.map(r => r.type) });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Get countries
app.get('/products/countries', (req, res) => {
  try {
    const { data } = executeQuery(`
      SELECT DISTINCT supplier_country, COUNT(*) as product_count 
      FROM feed_products_sample 
      WHERE is_active = 1 
      GROUP BY supplier_country 
      ORDER BY product_count DESC
    `);
    res.json({ countries: data });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Get suppliers
app.get('/products/suppliers', (req, res) => {
  try {
    const country = req.query.country;
    const countryFilter = country ? `AND supplier_country = '${country}'` : '';
    
    const { data } = executeQuery(`
      SELECT DISTINCT supplier, supplier_country, supplier_email, supplier_phone,
             COUNT(*) as product_count
      FROM feed_products_sample 
      WHERE is_active = 1 
        AND supplier IS NOT NULL
        ${countryFilter}
      GROUP BY supplier, supplier_country
      ORDER BY supplier_country, supplier
    `);
    res.json({ suppliers: data });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Get price history for a product
app.get('/products/:name/history', (req, res) => {
  try {
    const productName = req.params.name;
    const country = req.query.country;
    const countryFilter = country ? `AND supplier_country = '${country}'` : '';
    
    const { data, error } = executeQuery(`
      SELECT 
        strftime('%Y-%m', created_at, 'unixepoch') as month,
        ROUND(AVG(cost_per_kg), 2) as avg_price,
        ROUND(MIN(cost_per_kg), 2) as min_price,
        ROUND(MAX(cost_per_kg), 2) as max_price,
        cost_currency,
        supplier_country
      FROM feed_products_sample
      WHERE LOWER(product_name) LIKE '%${productName.toLowerCase()}%'
        AND product_code LIKE '%HIST%'
        ${countryFilter}
      GROUP BY month, supplier_country, cost_currency
      ORDER BY month ASC
    `);
    
    if (error) {
      return res.status(400).json({ error });
    }
    
    res.json({
      product: productName,
      history: data,
      count: data.length
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Example queries
app.get('/examples', (req, res) => {
  res.json({
    examples: [
      { en: "Who is selling the cheapest Wheat Straw?", ar: "من يبيع أرخص قش القمح؟", category: "price" },
      { en: "What is the average price of Barley in UAE?", ar: "ما هو متوسط سعر الشعير في الإمارات؟", category: "average" },
      { en: "Which suppliers sell Alfalfa hay in Saudi Arabia?", ar: "من يبيع تبن البرسيم في السعودية؟", category: "supplier" },
      { en: "When is the best time to buy Corn?", ar: "ما هو أفضل وقت لشراء الذرة؟", category: "historical" },
      { en: "List all concentrates in Egypt", ar: "قائمة بجميع المركزات في مصر", category: "list" },
      { en: "What restrictions apply to Urea for cattle?", ar: "ما هي قيود استخدام اليوريا للماشية؟", category: "restrictions" }
    ]
  });
});

// Start server
function startServer() {
  console.log('🚀 Starting Feed Products AI Agent API...');
  
  agent = createAgent();
  
  app.listen(API_PORT, API_HOST, () => {
    console.log(`✅ API server running at http://${API_HOST}:${API_PORT}`);
    console.log(`📚 Documentation: http://localhost:${API_PORT}`);
  });
}

// Handle shutdown
process.on('SIGINT', () => {
  console.log('\n👋 Shutting down...');
  closeDatabase();
  process.exit(0);
});

startServer();

# 🌾 Feed Products AI Agent (Node.js)

An intelligent AI agent for querying feed products data across the MENA region. Supports natural language queries in both **Arabic** and **English**.

## Features

- 🤖 **AI-Powered Queries**: Uses Google Gemini for natural language understanding
- 🌍 **Bilingual Support**: Query in English or Arabic (العربية)
- 💰 **Price Analysis**: Find cheapest suppliers, average prices, price trends
- 📊 **Historical Data**: Analyze 25 months of historical pricing
- 🏢 **Supplier Discovery**: Find suppliers by product and region
- 📋 **Feeding Restrictions**: Get product usage restrictions for livestock
- 🔌 **REST API**: Ready for frontend integration (React, Flutter)

## Quick Start

### 1. Install Dependencies

```bash
cd ai_agent_node
npm install
```

### 2. Configure API Key (Optional)

```bash
# Copy the example environment file
cp .env.example .env

# Edit .env and add your Google API key
# Get your key at: https://ai.google.dev/
```

**Note**: The agent works without an API key using pattern-based SQL generation.

### 3. Initialize Database

```bash
npm run init-db
```

### 4. Run the Agent

**Interactive CLI:**
```bash
npm run cli
```

**REST API Server:**
```bash
npm run api
# API available at: http://localhost:3000
```

**Single Query:**
```bash
node src/index.js --query "Who sells the cheapest Wheat Straw?"
```

**Run Tests:**
```bash
npm test
```

## Usage Examples

### CLI Examples

```
🔍 Your question: Who is selling the cheapest Wheat Straw?

📝 Response:
Here are the cheapest suppliers:
1. Ras Al Khaimah Feed Co Wheat Straw (UAE) - AED 0.91/kg
2. Qatar Agricultural Supplies Qatar Wheat Straw (Qatar) - QAR 0.91/kg
3. Sharjah Feed Mills Wheat Straw (UAE) - AED 0.93/kg
```

```
🔍 Your question: من يبيع أرخص قش القمح؟

📝 Response:
أرخص الموردين:
1. Ras Al Khaimah Feed Co Wheat Straw (الإمارات) - AED 0.91/kg
2. Qatar Agricultural Supplies Qatar Wheat Straw (قطر) - QAR 0.91/kg
```

### API Examples

**Natural Language Query:**
```bash
curl -X POST http://localhost:3000/query \
  -H "Content-Type: application/json" \
  -d '{"query": "Who sells the cheapest Wheat Straw?"}'
```

**Product Search:**
```bash
curl -X POST http://localhost:3000/search/products \
  -H "Content-Type: application/json" \
  -d '{"product_type": "Fodder", "country": "UAE", "max_price": 1.5}'
```

**Price History:**
```bash
curl "http://localhost:3000/products/Wheat%20Straw/history"
```

## Query Types

| Query Type | English Example | Arabic Example |
|------------|----------------|----------------|
| **Cheapest** | Who sells cheapest Wheat Straw? | من يبيع أرخص قش القمح؟ |
| **Average Price** | What is the average price of Barley? | ما هو متوسط سعر الشعير؟ |
| **Suppliers** | Which suppliers sell Alfalfa in UAE? | من يبيع البرسيم في الإمارات؟ |
| **Best Time** | When is the best time to buy Corn? | ما أفضل وقت لشراء الذرة؟ |
| **Product List** | List all concentrates in Egypt | قائمة المركزات في مصر |
| **Restrictions** | What restrictions apply to Urea? | ما قيود اليوريا؟ |

## API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/query` | Process natural language query |
| GET | `/query?q=...` | Simple query (GET method) |
| GET | `/stats` | Database statistics |
| POST | `/search/products` | Structured product search |
| GET | `/products/types` | List product types |
| GET | `/products/countries` | List countries |
| GET | `/products/suppliers` | List suppliers |
| GET | `/products/:name/history` | Price history |
| GET | `/examples` | Example queries |
| GET | `/health` | Health check |

## Project Structure

```
ai_agent_node/
├── src/
│   ├── index.js         # Main entry point
│   ├── agent.js         # AI Agent core logic
│   ├── database.js      # SQLite database operations
│   ├── language.js      # Bilingual support
│   ├── cli.js           # Command-line interface
│   ├── api.js           # REST API (Express)
│   ├── config.js        # Configuration
│   ├── init-db.js       # Database initialization
│   └── test.js          # Test script
├── package.json         # Dependencies
├── .env.example         # Environment template
└── README.md            # This file
```

## Configuration

| Variable | Description | Default |
|----------|-------------|---------|
| `GOOGLE_API_KEY` | Google Gemini API key | Optional |
| `GEMINI_MODEL` | Gemini model to use | `gemini-1.5-flash` |
| `API_PORT` | API server port | `3000` |
| `API_HOST` | API server host | `0.0.0.0` |

## Product Types

- **Fodder** (علف خشن): Alfalfa hay, Wheat Straw, Barley, Corn, Oat Hay, etc.
- **Concentrate** (علف مركز): Barley Flakes, Soya Bean Meal, Corn Gluten Meal, etc.
- **Additive** (مضافات): Molasses, Limestone, Salt, Urea

## Supported Countries

UAE, Saudi Arabia, Qatar, Egypt, Bahrain, Kuwait, Oman, Jordan, Morocco, Tunisia, Algeria, Libya

## Next Steps (UI Integration)

This agent is designed for easy integration with:

### React/Next.js Integration
```javascript
const response = await fetch('http://localhost:3000/query', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({ query: 'Who sells cheapest wheat straw?' })
});
const data = await response.json();
console.log(data.response);
```

### Flutter Integration
```dart
final response = await http.post(
  Uri.parse('http://localhost:3000/query'),
  headers: {'Content-Type': 'application/json'},
  body: jsonEncode({'query': 'Who sells cheapest wheat straw?'}),
);
```

Consider using generative UI frameworks:
- [AgenticGenUI](https://github.com/vivek100/AgenticGenUI)
- [ag-ui](https://docs.ag-ui.com/drafts/generative-ui)

## License

MIT License

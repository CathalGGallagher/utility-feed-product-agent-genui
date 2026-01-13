# 🌾 Feed Products AI Agent

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
cd ai_agent
pip install -r requirements.txt
```

### 2. Configure API Key

```bash
# Copy the example environment file
cp .env.example .env

# Edit .env and add your Google API key
# Get your key at: https://ai.google.dev/
```

### 3. Initialize Database

```bash
python main.py --init-db
```

### 4. Run the Agent

**Interactive CLI:**
```bash
python main.py
# or
python main.py --cli
```

**REST API Server:**
```bash
python main.py --api
# API docs available at: http://localhost:8000/docs
```

**Single Query:**
```bash
python main.py --query "Who sells the cheapest Wheat Straw?"
```

## Usage Examples

### CLI Examples

```
🔍 Your question: Who is selling the cheapest Wheat Straw?

📝 Response:
Cheapest suppliers:
1. Ras Al Khaimah Feed Co (UAE) - AED 0.91/kg
2. Qatar Agricultural Supplies (Qatar) - QAR 0.91/kg
3. Sharjah Feed Mills (UAE) - AED 0.93/kg
```

```
🔍 Your question: من يبيع أرخص قش القمح؟

📝 النتائج:
أرخص الموردين:
1. Ras Al Khaimah Feed Co (الإمارات) - 0.91 AED
2. Qatar Agricultural Supplies (قطر) - 0.91 QAR
```

### API Examples

**Natural Language Query:**
```bash
curl -X POST "http://localhost:8000/query" \
  -H "Content-Type: application/json" \
  -d '{"query": "Who sells the cheapest Wheat Straw?"}'
```

**Product Search:**
```bash
curl -X POST "http://localhost:8000/search/products" \
  -H "Content-Type: application/json" \
  -d '{"product_type": "Fodder", "country": "UAE", "max_price": 1.5}'
```

**Price History:**
```bash
curl "http://localhost:8000/products/Wheat%20Straw/history?country=Saudi%20Arabia"
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

## Product Types

- **Fodder** (علف خشن): Alfalfa hay, Wheat Straw, Barley, Corn, Oat Hay, etc.
- **Concentrate** (علف مركز): Barley Flakes, Soya Bean Meal, Corn Gluten Meal, etc.
- **Additive** (مضافات): Molasses, Limestone, Salt, Urea

## Supported Countries

UAE, Saudi Arabia, Qatar, Egypt, Bahrain, Kuwait, Oman, Jordan, Morocco, Tunisia, Algeria, Libya

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
| GET | `/products/{name}/history` | Price history |
| GET | `/examples` | Example queries |
| GET | `/health` | Health check |

## Project Structure

```
ai_agent/
├── main.py              # Main entry point
├── agent.py             # AI Agent core logic
├── database.py          # Database operations
├── language_utils.py    # Bilingual support
├── cli.py               # Command-line interface
├── api.py               # REST API (FastAPI)
├── config.py            # Configuration
├── requirements.txt     # Dependencies
├── .env.example         # Environment template
└── README.md            # This file
```

## Configuration

| Variable | Description | Default |
|----------|-------------|---------|
| `GOOGLE_API_KEY` | Google Gemini API key | Required |
| `GEMINI_MODEL` | Gemini model to use | `gemini-1.5-flash` |
| `API_HOST` | API server host | `0.0.0.0` |
| `API_PORT` | API server port | `8000` |

## Next Steps (Future UI Integration)

This agent is designed to work with generative UI frameworks:

### React/Next.js Integration
- Use the REST API endpoints
- Consider frameworks like:
  - [AgenticGenUI](https://github.com/vivek100/AgenticGenUI)
  - [ag-ui](https://docs.ag-ui.com/drafts/generative-ui)

### Flutter Integration
- Use the REST API with `http` or `dio` packages
- Implement Material Design UI
- Support RTL layout for Arabic

## Development

```bash
# Run tests
python -m pytest tests/

# Format code
black .

# Lint
flake8 .

# Type check
mypy .
```

## License

MIT License

## Author

AI Shopping Agent for Feed Products - MENA Region

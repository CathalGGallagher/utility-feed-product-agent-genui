#!/usr/bin/env python3
"""
FastAPI Web API for Feed Products AI Agent
Provides REST endpoints for the AI agent
Ready for integration with React/Flutter UI
"""

import os
from typing import Optional, List, Dict, Any
from datetime import datetime
from contextlib import asynccontextmanager

from fastapi import FastAPI, HTTPException, Query
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field

from agent import FeedProductsAgent, create_agent
from language_utils import detect_language


# Pydantic models for request/response
class QueryRequest(BaseModel):
    """Request model for query endpoint"""
    query: str = Field(..., description="Natural language query in English or Arabic")
    language: Optional[str] = Field(None, description="Force language (en/ar). Auto-detected if not provided")

    class Config:
        json_schema_extra = {
            "example": {
                "query": "Who is selling the cheapest Wheat Straw?",
                "language": None
            }
        }


class QueryResponse(BaseModel):
    """Response model for query endpoint"""
    success: bool
    query: str
    detected_language: str
    response: str
    sql_query: str
    data: List[Dict[str, Any]]
    result_count: int
    error: Optional[str] = None
    timestamp: str


class StatsResponse(BaseModel):
    """Response model for stats endpoint"""
    total_products: int
    active_products: int
    unique_suppliers: int
    total_restrictions: int
    products_by_type: Dict[str, int]
    products_by_country: Dict[str, int]


class ProductSearchRequest(BaseModel):
    """Request model for product search"""
    product_name: Optional[str] = None
    product_type: Optional[str] = Field(None, description="Fodder, Concentrate, or Additive")
    country: Optional[str] = None
    supplier: Optional[str] = None
    min_price: Optional[float] = None
    max_price: Optional[float] = None
    limit: int = Field(20, ge=1, le=100)


class HealthResponse(BaseModel):
    """Health check response"""
    status: str
    database_connected: bool
    ai_model_available: bool
    timestamp: str


# Global agent instance
agent: Optional[FeedProductsAgent] = None


@asynccontextmanager
async def lifespan(app: FastAPI):
    """Manage application lifecycle"""
    global agent
    # Startup
    print("🚀 Starting Feed Products AI Agent API...")
    agent = create_agent()
    print("✅ Agent initialized successfully")
    yield
    # Shutdown
    if agent:
        agent.close()
        print("👋 Agent shutdown complete")


# Create FastAPI app
app = FastAPI(
    title="Feed Products AI Agent API",
    description="""
    ## AI-Powered Feed Products Query API
    
    This API provides intelligent querying of feed products data for the MENA region.
    
    ### Features:
    - **Natural Language Queries**: Ask questions in plain English or Arabic
    - **Bilingual Support**: Automatic language detection and response
    - **Smart SQL Generation**: Converts natural language to optimized SQL
    - **Historical Analysis**: Price trends and best time to buy insights
    - **Supplier Discovery**: Find suppliers by product and region
    
    ### Supported Languages:
    - English (en)
    - Arabic (ar) - العربية
    
    ### Example Queries:
    - "Who is selling the cheapest Wheat Straw?"
    - "من يبيع أرخص قش القمح؟"
    - "What is the average price of Barley in UAE?"
    - "When is the best time to buy Alfalfa hay?"
    """,
    version="1.0.0",
    lifespan=lifespan
)

# Add CORS middleware for frontend integration
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Configure appropriately for production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/", response_model=Dict[str, str])
async def root():
    """API root endpoint"""
    return {
        "message": "Feed Products AI Agent API | وكيل الذكاء الاصطناعي لمنتجات الأعلاف",
        "docs": "/docs",
        "health": "/health",
        "version": "1.0.0"
    }


@app.get("/health", response_model=HealthResponse)
async def health_check():
    """Health check endpoint"""
    db_connected = agent is not None and agent.db is not None
    ai_available = agent is not None and agent.model is not None
    
    return HealthResponse(
        status="healthy" if db_connected else "degraded",
        database_connected=db_connected,
        ai_model_available=ai_available,
        timestamp=datetime.utcnow().isoformat()
    )


@app.post("/query", response_model=QueryResponse)
async def process_query(request: QueryRequest):
    """
    Process a natural language query about feed products.
    
    Supports both English and Arabic queries.
    
    Example queries:
    - "Who is selling the cheapest Wheat Straw?"
    - "من يبيع أرخص قش القمح؟"
    - "What is the average price of Barley in UAE?"
    """
    if not agent:
        raise HTTPException(status_code=503, detail="Agent not initialized")
    
    try:
        # Override language detection if specified
        query = request.query
        
        # Process the query
        result = agent.process_query(query)
        
        return QueryResponse(
            success=result["success"],
            query=query,
            detected_language=request.language or result["language"],
            response=result["response"],
            sql_query=result["sql"],
            data=result["data"],
            result_count=len(result["data"]),
            error=result.get("error"),
            timestamp=datetime.utcnow().isoformat()
        )
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@app.get("/query", response_model=QueryResponse)
async def process_query_get(
    q: str = Query(..., description="Natural language query"),
    lang: Optional[str] = Query(None, description="Language (en/ar)")
):
    """
    Process a natural language query (GET method for simple testing).
    
    Example: /query?q=Who%20sells%20cheapest%20wheat%20straw
    """
    request = QueryRequest(query=q, language=lang)
    return await process_query(request)


@app.get("/stats", response_model=StatsResponse)
async def get_statistics():
    """Get database statistics"""
    if not agent:
        raise HTTPException(status_code=503, detail="Agent not initialized")
    
    stats = agent.get_stats()
    
    return StatsResponse(
        total_products=stats.get("total_products", 0),
        active_products=stats.get("active_products", 0),
        unique_suppliers=stats.get("unique_suppliers", 0),
        total_restrictions=stats.get("total_restrictions", 0),
        products_by_type=stats.get("products_by_type", {}),
        products_by_country=stats.get("products_by_country", {})
    )


@app.post("/search/products")
async def search_products(request: ProductSearchRequest):
    """
    Direct product search with filters.
    
    More structured than natural language queries.
    """
    if not agent:
        raise HTTPException(status_code=503, detail="Agent not initialized")
    
    # Build SQL query from filters
    conditions = ["is_active = 1"]
    
    if request.product_name:
        conditions.append(f"LOWER(product_name) LIKE '%{request.product_name.lower()}%'")
    if request.product_type:
        conditions.append(f"type = '{request.product_type}'")
    if request.country:
        conditions.append(f"supplier_country = '{request.country}'")
    if request.supplier:
        conditions.append(f"LOWER(supplier) LIKE '%{request.supplier.lower()}%'")
    if request.min_price:
        conditions.append(f"cost_per_kg >= {request.min_price}")
    if request.max_price:
        conditions.append(f"cost_per_kg <= {request.max_price}")
    
    where_clause = " AND ".join(conditions)
    
    sql = f"""
    SELECT product_name, type, supplier, supplier_country, 
           cost_per_kg, cost_currency, supplier_email, supplier_phone
    FROM feed_products_sample
    WHERE {where_clause}
    ORDER BY cost_per_kg ASC
    LIMIT {request.limit}
    """
    
    from database import execute_query
    data, error = execute_query(agent.db, sql)
    
    if error:
        raise HTTPException(status_code=400, detail=error)
    
    return {
        "success": True,
        "data": data,
        "count": len(data),
        "filters_applied": {
            k: v for k, v in request.model_dump().items() if v is not None
        }
    }


@app.get("/products/types")
async def get_product_types():
    """Get all product types"""
    if not agent:
        raise HTTPException(status_code=503, detail="Agent not initialized")
    
    from database import execute_query
    sql = "SELECT DISTINCT type FROM feed_products_sample WHERE is_active = 1 ORDER BY type"
    data, error = execute_query(agent.db, sql)
    
    if error:
        raise HTTPException(status_code=400, detail=error)
    
    return {"types": [row["type"] for row in data]}


@app.get("/products/countries")
async def get_countries():
    """Get all available countries"""
    if not agent:
        raise HTTPException(status_code=503, detail="Agent not initialized")
    
    from database import execute_query
    sql = """
    SELECT DISTINCT supplier_country, COUNT(*) as product_count 
    FROM feed_products_sample 
    WHERE is_active = 1 
    GROUP BY supplier_country 
    ORDER BY product_count DESC
    """
    data, error = execute_query(agent.db, sql)
    
    if error:
        raise HTTPException(status_code=400, detail=error)
    
    return {"countries": data}


@app.get("/products/suppliers")
async def get_suppliers(
    country: Optional[str] = Query(None, description="Filter by country")
):
    """Get all suppliers, optionally filtered by country"""
    if not agent:
        raise HTTPException(status_code=503, detail="Agent not initialized")
    
    from database import execute_query
    
    country_filter = f"AND supplier_country = '{country}'" if country else ""
    
    sql = f"""
    SELECT DISTINCT supplier, supplier_country, supplier_email, supplier_phone,
           COUNT(*) as product_count
    FROM feed_products_sample 
    WHERE is_active = 1 
      AND supplier IS NOT NULL
      {country_filter}
    GROUP BY supplier, supplier_country
    ORDER BY supplier_country, supplier
    """
    data, error = execute_query(agent.db, sql)
    
    if error:
        raise HTTPException(status_code=400, detail=error)
    
    return {"suppliers": data}


@app.get("/products/{product_name}/history")
async def get_price_history(
    product_name: str,
    country: Optional[str] = Query(None, description="Filter by country")
):
    """Get historical prices for a product"""
    if not agent:
        raise HTTPException(status_code=503, detail="Agent not initialized")
    
    from database import execute_query
    
    country_filter = f"AND supplier_country = '{country}'" if country else ""
    
    sql = f"""
    SELECT 
        strftime('%Y-%m', created_at, 'unixepoch') as month,
        ROUND(AVG(cost_per_kg), 2) as avg_price,
        ROUND(MIN(cost_per_kg), 2) as min_price,
        ROUND(MAX(cost_per_kg), 2) as max_price,
        cost_currency,
        supplier_country
    FROM feed_products_sample
    WHERE LOWER(product_name) LIKE '%{product_name.lower()}%'
      AND product_code LIKE '%HIST%'
      {country_filter}
    GROUP BY month, supplier_country, cost_currency
    ORDER BY month ASC
    """
    data, error = execute_query(agent.db, sql)
    
    if error:
        raise HTTPException(status_code=400, detail=error)
    
    return {
        "product": product_name,
        "history": data,
        "count": len(data)
    }


# Example queries endpoint for UI
@app.get("/examples")
async def get_example_queries():
    """Get example queries for UI suggestions"""
    return {
        "examples": [
            {
                "en": "Who is selling the cheapest Wheat Straw?",
                "ar": "من يبيع أرخص قش القمح؟",
                "category": "price"
            },
            {
                "en": "What is the average price of Barley in UAE?",
                "ar": "ما هو متوسط سعر الشعير في الإمارات؟",
                "category": "average"
            },
            {
                "en": "Which suppliers sell Alfalfa hay in Saudi Arabia?",
                "ar": "من يبيع تبن البرسيم في السعودية؟",
                "category": "supplier"
            },
            {
                "en": "When is the best time to buy Corn?",
                "ar": "ما هو أفضل وقت لشراء الذرة؟",
                "category": "historical"
            },
            {
                "en": "List all concentrates in Egypt",
                "ar": "قائمة بجميع المركزات في مصر",
                "category": "list"
            },
            {
                "en": "What restrictions apply to Urea for cattle?",
                "ar": "ما هي قيود استخدام اليوريا للماشية؟",
                "category": "restrictions"
            }
        ]
    }


def run_server(host: str = "0.0.0.0", port: int = 8000):
    """Run the API server"""
    import uvicorn
    uvicorn.run(app, host=host, port=port)


if __name__ == "__main__":
    run_server()

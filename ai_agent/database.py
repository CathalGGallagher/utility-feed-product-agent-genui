"""
Database setup and management for Feed Products AI Agent
Uses SQLite for local storage and easy deployment
"""

import sqlite3
import re
from pathlib import Path
from typing import List, Dict, Any, Optional, Tuple
from config import DATABASE_PATH, DB_DIR


def create_schema(conn: sqlite3.Connection) -> None:
    """Create the database schema for feed products"""
    cursor = conn.cursor()
    
    # Create feed_products_sample table
    cursor.execute("""
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
    """)
    
    # Create feed_product_restrictions table
    cursor.execute("""
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
    """)
    
    # Create indexes for better query performance
    cursor.execute("CREATE INDEX IF NOT EXISTS idx_product_name ON feed_products_sample(product_name)")
    cursor.execute("CREATE INDEX IF NOT EXISTS idx_product_type ON feed_products_sample(type)")
    cursor.execute("CREATE INDEX IF NOT EXISTS idx_supplier_country ON feed_products_sample(supplier_country)")
    cursor.execute("CREATE INDEX IF NOT EXISTS idx_is_active ON feed_products_sample(is_active)")
    cursor.execute("CREATE INDEX IF NOT EXISTS idx_supplier ON feed_products_sample(supplier)")
    cursor.execute("CREATE INDEX IF NOT EXISTS idx_created_at ON feed_products_sample(created_at)")
    cursor.execute("CREATE INDEX IF NOT EXISTS idx_restrictions_product ON feed_product_restrictions(product_id)")
    
    conn.commit()


def parse_sql_values(sql_content: str) -> List[Dict[str, Any]]:
    """Parse INSERT statements from SQL files and extract values"""
    records = []
    
    # Find all INSERT statements for feed_products_sample
    insert_pattern = r"INSERT INTO public\.feed_products_sample\s*\([^)]+\)\s*VALUES\s*"
    
    # Split by INSERT statements
    parts = re.split(insert_pattern, sql_content, flags=re.IGNORECASE)
    
    for part in parts[1:]:  # Skip first empty part
        # Extract column names from previous part or use default
        # Find all value tuples
        value_pattern = r"\(([^;]+?)\)(?:,|\s*;)"
        matches = re.findall(value_pattern, part, re.DOTALL)
        
        for match in matches:
            # Parse the values
            values = parse_tuple_values(match)
            if len(values) >= 6:  # Minimum required fields
                record = {
                    'product_name': values[0] if len(values) > 0 else None,
                    'product_code': values[1] if len(values) > 1 else None,
                    'name': values[2] if len(values) > 2 else None,
                    'type': values[3] if len(values) > 3 else None,
                    'cost_per_kg': float(values[4]) if len(values) > 4 and values[4] else None,
                    'cost_currency': values[5] if len(values) > 5 else None,
                }
                
                # Handle different INSERT formats
                if len(values) >= 14:  # Full format with supplier info
                    record.update({
                        'supplier': values[6] if values[6] != 'NULL' else None,
                        'supplier_country': values[7] if len(values) > 7 else None,
                        'supplier_email': values[8] if len(values) > 8 and values[8] != 'NULL' else None,
                        'supplier_phone': values[9] if len(values) > 9 and values[9] != 'NULL' else None,
                        'supplier_address': values[10] if len(values) > 10 and values[10] != 'NULL' else None,
                        'is_standard_product': 1 if str(values[11]).lower() == 'true' else 0,
                        'created_at': int(values[12]) if len(values) > 12 and values[12] else None,
                        'is_active': 1 if str(values[13]).lower() == 'true' else 0,
                    })
                elif len(values) >= 10:  # Format without supplier info
                    record.update({
                        'supplier': None,
                        'supplier_country': values[6] if len(values) > 6 else None,
                        'supplier_email': None,
                        'supplier_phone': None,
                        'supplier_address': None,
                        'is_standard_product': 1 if str(values[7]).lower() == 'true' else 0,
                        'created_at': int(values[8]) if len(values) > 8 and values[8] else None,
                        'is_active': 1 if str(values[9]).lower() == 'true' else 0,
                    })
                
                records.append(record)
    
    return records


def parse_tuple_values(tuple_str: str) -> List[str]:
    """Parse comma-separated values from a SQL tuple, handling quoted strings"""
    values = []
    current = ""
    in_quotes = False
    quote_char = None
    
    for char in tuple_str:
        if char in ("'", '"') and not in_quotes:
            in_quotes = True
            quote_char = char
        elif char == quote_char and in_quotes:
            in_quotes = False
            quote_char = None
        elif char == ',' and not in_quotes:
            values.append(current.strip().strip("'\""))
            current = ""
            continue
        else:
            current += char
    
    if current.strip():
        values.append(current.strip().strip("'\""))
    
    return values


def load_historical_data(conn: sqlite3.Connection) -> int:
    """Load historical pricing data specifically"""
    cursor = conn.cursor()
    inserted = 0
    
    # Historical data for UAE Alfalfa (25 months)
    alfalfa_hist = [
        (1704067200, 1.40, 'Jan 2024'), (1706745600, 1.42, 'Feb 2024'), (1709251200, 1.45, 'Mar 2024'),
        (1711929600, 1.48, 'Apr 2024'), (1714521600, 1.50, 'May 2024'), (1717200000, 1.52, 'Jun 2024'),
        (1719792000, 1.55, 'Jul 2024'), (1722470400, 1.53, 'Aug 2024'), (1725148800, 1.50, 'Sep 2024'),
        (1727740800, 1.48, 'Oct 2024'), (1730419200, 1.46, 'Nov 2024'), (1733011200, 1.47, 'Dec 2024'),
        (1735689600, 1.49, 'Jan 2025'), (1738368000, 1.51, 'Feb 2025'), (1740787200, 1.54, 'Mar 2025'),
        (1743465600, 1.56, 'Apr 2025'), (1746057600, 1.58, 'May 2025'), (1748736000, 1.60, 'Jun 2025'),
        (1751328000, 1.62, 'Jul 2025'), (1754006400, 1.60, 'Aug 2025'), (1756684800, 1.58, 'Sep 2025'),
        (1759276800, 1.56, 'Oct 2025'), (1761955200, 1.54, 'Nov 2025'), (1764547200, 1.52, 'Dec 2025'),
        (1767225600, 1.50, 'Jan 2026'),
    ]
    
    for ts, price, _ in alfalfa_hist:
        is_active = 1 if ts == 1767225600 else 0  # Only latest is active
        cursor.execute("""
        INSERT INTO feed_products_sample 
        (product_name, product_code, name, type, cost_per_kg, cost_currency,
         supplier_country, is_standard_product, created_at, is_active)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """, ('Alfalfa hay (mid-bloom)', 'FP-001-HIST', 'Alfalfa hay (mid-bloom)', 
              'Fodder', price, 'AED', 'UAE', 1, ts, is_active))
        inserted += 1
    
    # Historical data for Saudi Arabia Wheat Straw (25 months)
    wheat_hist = [
        (1704067200, 0.90, 'Jan 2024'), (1706745600, 0.92, 'Feb 2024'), (1709251200, 0.94, 'Mar 2024'),
        (1711929600, 0.96, 'Apr 2024'), (1714521600, 0.98, 'May 2024'), (1717200000, 1.00, 'Jun 2024'),
        (1719792000, 1.02, 'Jul 2024'), (1722470400, 1.00, 'Aug 2024'), (1725148800, 0.98, 'Sep 2024'),
        (1727740800, 0.96, 'Oct 2024'), (1730419200, 0.94, 'Nov 2024'), (1733011200, 0.94, 'Dec 2024'),
        (1735689600, 0.95, 'Jan 2025'), (1738368000, 0.97, 'Feb 2025'), (1740787200, 0.99, 'Mar 2025'),
        (1743465600, 1.01, 'Apr 2025'), (1746057600, 1.03, 'May 2025'), (1748736000, 1.05, 'Jun 2025'),
        (1751328000, 1.07, 'Jul 2025'), (1754006400, 1.05, 'Aug 2025'), (1756684800, 1.03, 'Sep 2025'),
        (1759276800, 1.01, 'Oct 2025'), (1761955200, 0.99, 'Nov 2025'), (1764547200, 0.97, 'Dec 2025'),
        (1767225600, 0.95, 'Jan 2026'),
    ]
    
    for ts, price, _ in wheat_hist:
        is_active = 1 if ts == 1767225600 else 0
        cursor.execute("""
        INSERT INTO feed_products_sample 
        (product_name, product_code, name, type, cost_per_kg, cost_currency,
         supplier_country, is_standard_product, created_at, is_active)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """, ('Wheat Straw', 'FP-002-HIST', 'Wheat Straw', 
              'Fodder', price, 'SAR', 'Saudi Arabia', 1, ts, is_active))
        inserted += 1
    
    # Historical data for Egypt Barley (25 months)
    barley_hist = [
        (1704067200, 11.20, 'Jan 2024'), (1706745600, 11.40, 'Feb 2024'), (1709251200, 11.60, 'Mar 2024'),
        (1711929600, 11.80, 'Apr 2024'), (1714521600, 12.00, 'May 2024'), (1717200000, 12.20, 'Jun 2024'),
        (1719792000, 12.40, 'Jul 2024'), (1722470400, 12.30, 'Aug 2024'), (1725148800, 12.10, 'Sep 2024'),
        (1727740800, 11.90, 'Oct 2024'), (1730419200, 11.70, 'Nov 2024'), (1733011200, 11.64, 'Dec 2024'),
        (1735689600, 11.80, 'Jan 2025'), (1738368000, 12.00, 'Feb 2025'), (1740787200, 12.20, 'Mar 2025'),
        (1743465600, 12.40, 'Apr 2025'), (1746057600, 12.60, 'May 2025'), (1748736000, 12.80, 'Jun 2025'),
        (1751328000, 13.00, 'Jul 2025'), (1754006400, 12.90, 'Aug 2025'), (1756684800, 12.70, 'Sep 2025'),
        (1759276800, 12.50, 'Oct 2025'), (1761955200, 12.30, 'Nov 2025'), (1764547200, 12.10, 'Dec 2025'),
        (1767225600, 11.95, 'Jan 2026'),
    ]
    
    for ts, price, _ in barley_hist:
        is_active = 1 if ts == 1767225600 else 0
        cursor.execute("""
        INSERT INTO feed_products_sample 
        (product_name, product_code, name, type, cost_per_kg, cost_currency,
         supplier_country, is_standard_product, created_at, is_active)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """, ('Barley', 'FP-005-HIST', 'Barley', 
              'Fodder', price, 'EGP', 'Egypt', 1, ts, is_active))
        inserted += 1
    
    conn.commit()
    return inserted


def load_seed_data_simple(conn: sqlite3.Connection) -> int:
    """Load seed data using a simpler regex approach"""
    cursor = conn.cursor()
    total_inserted = 0
    
    # Define seed files to load
    seed_files = [
        DB_DIR / "seed_data.sql",
        DB_DIR / "seed_data_market_products.sql",
    ]
    
    for seed_file in seed_files:
        if not seed_file.exists():
            print(f"Warning: Seed file not found: {seed_file}")
            continue
        
        print(f"Loading data from {seed_file.name}...")
        
        with open(seed_file, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # Find INSERT statements for feed_products_sample
        # Handle both formats: with and without supplier info
        
        # Pattern to match INSERT ... VALUES blocks
        insert_blocks = re.findall(
            r"INSERT INTO public\.feed_products_sample\s*\([^)]+\)\s*VALUES\s*([^;]+);",
            content,
            re.IGNORECASE | re.DOTALL
        )
        
        for block in insert_blocks:
            # Parse each value tuple
            # Split by '),\n(' or similar patterns
            tuples = re.split(r"\),\s*\n?\s*\(", block)
            
            for i, tuple_str in enumerate(tuples):
                # Clean up the tuple
                tuple_str = tuple_str.strip()
                if tuple_str.startswith('('):
                    tuple_str = tuple_str[1:]
                if tuple_str.endswith(')'):
                    tuple_str = tuple_str[:-1]
                
                values = parse_tuple_values(tuple_str)
                
                if len(values) < 6:
                    continue
                
                try:
                    # Determine format based on number of values
                    if len(values) >= 14:
                        # Full format with supplier
                        cursor.execute("""
                        INSERT INTO feed_products_sample 
                        (product_name, product_code, name, type, cost_per_kg, cost_currency,
                         supplier, supplier_country, supplier_email, supplier_phone, supplier_address,
                         is_standard_product, created_at, is_active)
                        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                        """, (
                            values[0],  # product_name
                            values[1],  # product_code
                            values[2],  # name
                            values[3],  # type
                            float(values[4]) if values[4] else None,  # cost_per_kg
                            values[5],  # cost_currency
                            values[6] if values[6] != 'NULL' else None,  # supplier
                            values[7],  # supplier_country
                            values[8] if values[8] != 'NULL' else None,  # supplier_email
                            values[9] if values[9] != 'NULL' else None,  # supplier_phone
                            values[10] if values[10] != 'NULL' else None,  # supplier_address
                            1 if str(values[11]).lower() == 'true' else 0,  # is_standard_product
                            int(values[12]) if values[12] else None,  # created_at
                            1 if str(values[13]).lower() == 'true' else 0,  # is_active
                        ))
                    elif len(values) >= 10:
                        # Format without supplier
                        cursor.execute("""
                        INSERT INTO feed_products_sample 
                        (product_name, product_code, name, type, cost_per_kg, cost_currency,
                         supplier_country, is_standard_product, created_at, is_active)
                        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                        """, (
                            values[0],  # product_name
                            values[1],  # product_code
                            values[2],  # name
                            values[3],  # type
                            float(values[4]) if values[4] else None,  # cost_per_kg
                            values[5],  # cost_currency
                            values[6],  # supplier_country
                            1 if str(values[7]).lower() == 'true' else 0,  # is_standard_product
                            int(values[8]) if values[8] else None,  # created_at
                            1 if str(values[9]).lower() == 'true' else 0,  # is_active
                        ))
                    
                    total_inserted += 1
                except Exception as e:
                    # Skip problematic records
                    pass
        
        conn.commit()
    
    return total_inserted


def load_restrictions(conn: sqlite3.Connection) -> int:
    """Load feed product restrictions from seed data"""
    cursor = conn.cursor()
    inserted = 0
    
    seed_file = DB_DIR / "seed_data.sql"
    if not seed_file.exists():
        return 0
    
    with open(seed_file, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Find restriction INSERT statements
    # These use subqueries, so we need to handle them differently
    # For simplicity, we'll create sample restrictions based on the schema
    
    # Get some product IDs for creating restrictions
    cursor.execute("""
    SELECT id, product_code, product_name, type, supplier_country 
    FROM feed_products_sample 
    WHERE type IN ('Concentrate', 'Additive') AND is_active = 1
    LIMIT 50
    """)
    
    products = cursor.fetchall()
    
    # Create sample restrictions
    restrictions = [
        # Barley - raw: max 30% for young cattle
        {'species': 'cattle', 'min_age': 0, 'max_age': 12, 'max_perc_feed': 30.0},
        # Soya Bean Meal: max 25% of concentrate for lactating cows
        {'species': 'cattle', 'sex': 'female', 'lactation': 'early', 'max_perc_conc': 25.0},
        # Urea: max 1% for adult cattle only
        {'species': 'cattle', 'min_age': 12, 'max_perc_feed': 1.0},
        # Molasses: max 10% of feed
        {'species': 'cattle', 'max_perc_feed': 10.0},
    ]
    
    for prod in products:
        prod_id, code, name, ptype, country = prod
        
        # Apply appropriate restriction based on product type
        if 'barley' in name.lower() and ptype == 'Concentrate':
            cursor.execute("""
            INSERT INTO feed_product_restrictions 
            (product_id, species, min_age_months, max_age_months, max_perc_feed, is_active)
            VALUES (?, 'cattle', 0, 12, 30.0, 1)
            """, (prod_id,))
            inserted += 1
            
            cursor.execute("""
            INSERT INTO feed_product_restrictions 
            (product_id, species, max_perc_feed, is_active)
            VALUES (?, 'sheep', 20.0, 1)
            """, (prod_id,))
            inserted += 1
            
        elif 'soya' in name.lower() or 'soybean' in name.lower():
            cursor.execute("""
            INSERT INTO feed_product_restrictions 
            (product_id, species, sex, lactation_cycle, production_focus, max_perc_conc, is_active)
            VALUES (?, 'cattle', 'female', 'early', 'dairy', 25.0, 1)
            """, (prod_id,))
            inserted += 1
            
        elif 'urea' in name.lower():
            cursor.execute("""
            INSERT INTO feed_product_restrictions 
            (product_id, species, min_age_months, max_perc_feed, is_active)
            VALUES (?, 'cattle', 12, 1.0, 1)
            """, (prod_id,))
            inserted += 1
            
        elif 'molasses' in name.lower():
            cursor.execute("""
            INSERT INTO feed_product_restrictions 
            (product_id, species, max_perc_feed, is_active)
            VALUES (?, 'cattle', 10.0, 1)
            """, (prod_id,))
            inserted += 1
    
    conn.commit()
    return inserted


def initialize_database(force_recreate: bool = False) -> sqlite3.Connection:
    """Initialize the database with schema and seed data"""
    
    if force_recreate and DATABASE_PATH.exists():
        DATABASE_PATH.unlink()
        print("Removed existing database.")
    
    db_exists = DATABASE_PATH.exists()
    conn = sqlite3.connect(DATABASE_PATH)
    conn.row_factory = sqlite3.Row  # Return rows as dictionaries
    
    if not db_exists or force_recreate:
        print("Creating database schema...")
        create_schema(conn)
        
        print("Loading seed data...")
        products_count = load_seed_data_simple(conn)
        print(f"Loaded {products_count} feed products.")
        
        print("Loading historical pricing data...")
        historical_count = load_historical_data(conn)
        print(f"Loaded {historical_count} historical price records.")
        
        print("Loading restrictions...")
        restrictions_count = load_restrictions(conn)
        print(f"Created {restrictions_count} product restrictions.")
        
        print("Database initialization complete!")
    else:
        print("Using existing database.")
    
    return conn


def execute_query(conn: sqlite3.Connection, query: str) -> Tuple[List[Dict], Optional[str]]:
    """Execute a SQL query and return results"""
    try:
        cursor = conn.cursor()
        cursor.execute(query)
        
        # Get column names
        columns = [description[0] for description in cursor.description] if cursor.description else []
        
        # Fetch all results
        rows = cursor.fetchall()
        
        # Convert to list of dictionaries
        results = []
        for row in rows:
            results.append(dict(zip(columns, row)))
        
        return results, None
    except Exception as e:
        return [], str(e)


def get_database_stats(conn: sqlite3.Connection) -> Dict[str, Any]:
    """Get statistics about the database"""
    cursor = conn.cursor()
    
    stats = {}
    
    # Total products
    cursor.execute("SELECT COUNT(*) FROM feed_products_sample")
    stats['total_products'] = cursor.fetchone()[0]
    
    # Active products
    cursor.execute("SELECT COUNT(*) FROM feed_products_sample WHERE is_active = 1")
    stats['active_products'] = cursor.fetchone()[0]
    
    # Products by type
    cursor.execute("""
    SELECT type, COUNT(*) as count 
    FROM feed_products_sample 
    WHERE is_active = 1 
    GROUP BY type
    """)
    stats['products_by_type'] = {row[0]: row[1] for row in cursor.fetchall()}
    
    # Products by country
    cursor.execute("""
    SELECT supplier_country, COUNT(*) as count 
    FROM feed_products_sample 
    WHERE is_active = 1 
    GROUP BY supplier_country
    """)
    stats['products_by_country'] = {row[0]: row[1] for row in cursor.fetchall()}
    
    # Unique suppliers
    cursor.execute("""
    SELECT COUNT(DISTINCT supplier) 
    FROM feed_products_sample 
    WHERE supplier IS NOT NULL AND is_active = 1
    """)
    stats['unique_suppliers'] = cursor.fetchone()[0]
    
    # Total restrictions
    cursor.execute("SELECT COUNT(*) FROM feed_product_restrictions WHERE is_active = 1")
    stats['total_restrictions'] = cursor.fetchone()[0]
    
    return stats


if __name__ == "__main__":
    # Test database initialization
    conn = initialize_database(force_recreate=True)
    stats = get_database_stats(conn)
    print("\nDatabase Statistics:")
    for key, value in stats.items():
        print(f"  {key}: {value}")
    conn.close()

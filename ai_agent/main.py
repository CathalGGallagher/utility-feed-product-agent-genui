#!/usr/bin/env python3
"""
Feed Products AI Agent - Main Entry Point
Run the CLI or API server
"""

import sys
import argparse


def main():
    parser = argparse.ArgumentParser(
        description="Feed Products AI Agent - Query feed products data using natural language",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  python main.py                    # Start interactive CLI
  python main.py --cli              # Start interactive CLI
  python main.py --api              # Start REST API server
  python main.py --api --port 8080  # Start API on custom port
  python main.py --init-db          # Initialize/reset database
  python main.py --query "Who sells cheapest wheat straw?"

Environment Variables:
  GOOGLE_API_KEY    - Google Gemini API key for AI-powered queries
  GEMINI_MODEL      - Gemini model to use (default: gemini-1.5-flash)
        """
    )
    
    parser.add_argument(
        "--cli", "-c",
        action="store_true",
        help="Start interactive CLI mode (default)"
    )
    
    parser.add_argument(
        "--api", "-a",
        action="store_true",
        help="Start REST API server"
    )
    
    parser.add_argument(
        "--port", "-p",
        type=int,
        default=8000,
        help="API server port (default: 8000)"
    )
    
    parser.add_argument(
        "--host",
        type=str,
        default="0.0.0.0",
        help="API server host (default: 0.0.0.0)"
    )
    
    parser.add_argument(
        "--init-db",
        action="store_true",
        help="Initialize or reset the database"
    )
    
    parser.add_argument(
        "--query", "-q",
        type=str,
        help="Run a single query and exit"
    )
    
    parser.add_argument(
        "--stats",
        action="store_true",
        help="Show database statistics and exit"
    )
    
    args = parser.parse_args()
    
    # Initialize database if requested
    if args.init_db:
        print("🔄 Initializing database...")
        from database import initialize_database
        conn = initialize_database(force_recreate=True)
        conn.close()
        print("✅ Database initialized successfully!")
        return
    
    # Show stats if requested
    if args.stats:
        from agent import create_agent
        agent = create_agent()
        stats = agent.get_stats()
        print("\n📊 Database Statistics:")
        print("-" * 40)
        for key, value in stats.items():
            if isinstance(value, dict):
                print(f"\n{key}:")
                for k, v in value.items():
                    print(f"  {k}: {v}")
            else:
                print(f"{key}: {value}")
        agent.close()
        return
    
    # Run single query if provided
    if args.query:
        from agent import create_agent
        agent = create_agent()
        print(f"\n❓ Query: {args.query}\n")
        result = agent.process_query(args.query)
        print(f"🌐 Language: {result['language']}")
        if result['success']:
            print(f"\n📝 Response:\n{result['response']}")
        else:
            print(f"❌ Error: {result.get('error', 'Unknown error')}")
        agent.close()
        return
    
    # Start API server if requested
    if args.api:
        print(f"🚀 Starting API server on {args.host}:{args.port}...")
        print(f"📚 API Documentation: http://{args.host if args.host != '0.0.0.0' else 'localhost'}:{args.port}/docs")
        from api import run_server
        run_server(host=args.host, port=args.port)
        return
    
    # Default: Start CLI
    from cli import main as cli_main
    cli_main()


if __name__ == "__main__":
    main()

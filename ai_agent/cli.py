#!/usr/bin/env python3
"""
Command Line Interface for Feed Products AI Agent
Interactive chat interface for querying feed products data
Supports Arabic and English
"""

import sys
import os

# Try to use rich for better terminal output
try:
    from rich.console import Console
    from rich.panel import Panel
    from rich.table import Table
    from rich.markdown import Markdown
    from rich.prompt import Prompt
    from rich import print as rprint
    RICH_AVAILABLE = True
except ImportError:
    RICH_AVAILABLE = False
    print("Note: Install 'rich' for better terminal formatting: pip install rich")

from agent import create_agent, FeedProductsAgent
from language_utils import detect_language


class FeedProductsCLI:
    """Interactive CLI for the Feed Products AI Agent"""
    
    def __init__(self):
        if RICH_AVAILABLE:
            self.console = Console()
        self.agent = None
        
    def _print(self, text: str, style: str = None):
        """Print with optional rich formatting"""
        if RICH_AVAILABLE:
            self.console.print(text, style=style)
        else:
            print(text)
    
    def _print_panel(self, text: str, title: str = None, style: str = "blue"):
        """Print a panel with optional title"""
        if RICH_AVAILABLE:
            self.console.print(Panel(text, title=title, border_style=style))
        else:
            if title:
                print(f"\n{'='*50}")
                print(f" {title}")
                print('='*50)
            print(text)
            print('='*50 if title else '')
    
    def _print_table(self, data: list, title: str = None):
        """Print data as a formatted table"""
        if not data:
            self._print("No data to display", style="yellow")
            return
        
        if RICH_AVAILABLE:
            table = Table(title=title, show_header=True, header_style="bold cyan")
            
            # Add columns from first row
            columns = list(data[0].keys())
            for col in columns:
                table.add_column(col)
            
            # Add rows
            for row in data[:20]:  # Limit to 20 rows
                table.add_row(*[str(row.get(col, '')) for col in columns])
            
            self.console.print(table)
        else:
            if title:
                print(f"\n{title}")
                print("-" * len(title))
            
            # Simple text table
            if data:
                headers = list(data[0].keys())
                print(" | ".join(headers))
                print("-" * (len(" | ".join(headers))))
                for row in data[:20]:
                    print(" | ".join(str(row.get(h, '')) for h in headers))
    
    def show_welcome(self):
        """Display welcome message"""
        welcome_text = """
🌾 Feed Products AI Agent | وكيل الذكاء الاصطناعي لمنتجات الأعلاف

An intelligent assistant for querying feed products data across the MENA region.
مساعد ذكي للاستعلام عن بيانات منتجات الأعلاف في منطقة الشرق الأوسط وشمال أفريقيا

Supported Languages | اللغات المدعومة: English, العربية

Example queries | أمثلة على الاستعلامات:
• Who is selling the cheapest Wheat Straw?
• من يبيع أرخص قش القمح؟
• What is the average price of Barley in UAE?
• ما هو متوسط سعر الشعير في الإمارات؟
• Which suppliers sell Alfalfa hay in Saudi Arabia?
• When is the best time to buy Corn?

Commands | الأوامر:
• help   - Show this help message | عرض رسالة المساعدة
• stats  - Show database statistics | عرض إحصائيات قاعدة البيانات
• sql    - Show the last generated SQL | عرض آخر استعلام SQL
• clear  - Clear the screen | مسح الشاشة
• exit   - Exit the program | الخروج من البرنامج

Type your question below | اكتب سؤالك أدناه
"""
        self._print_panel(welcome_text, title="Welcome | مرحبا", style="green")
    
    def show_stats(self):
        """Display database statistics"""
        if not self.agent:
            self._print("Agent not initialized", style="red")
            return
        
        stats = self.agent.get_stats()
        
        stats_text = f"""
📊 Database Statistics | إحصائيات قاعدة البيانات

Total Products | إجمالي المنتجات: {stats.get('total_products', 0)}
Active Products | المنتجات النشطة: {stats.get('active_products', 0)}
Unique Suppliers | الموردون الفريدون: {stats.get('unique_suppliers', 0)}
Total Restrictions | القيود الإجمالية: {stats.get('total_restrictions', 0)}

Products by Type | المنتجات حسب النوع:
"""
        for ptype, count in stats.get('products_by_type', {}).items():
            stats_text += f"  • {ptype}: {count}\n"
        
        stats_text += "\nProducts by Country | المنتجات حسب البلد:\n"
        for country, count in sorted(stats.get('products_by_country', {}).items(), key=lambda x: -x[1])[:10]:
            stats_text += f"  • {country}: {count}\n"
        
        self._print_panel(stats_text, title="Statistics | الإحصائيات", style="blue")
    
    def show_help(self):
        """Display help information"""
        help_text = """
🔍 Query Examples | أمثلة على الاستعلامات

Price Queries | استعلامات الأسعار:
• "Who is selling the cheapest Wheat Straw?" - Find lowest prices
• "What is the average price of Barley?" - Get average prices
• "من يبيع أرخص قش القمح؟" - البحث عن أقل الأسعار

Supplier Queries | استعلامات الموردين:
• "Which suppliers sell Alfalfa hay in UAE?" - Find suppliers
• "Who sells Corn in Saudi Arabia?" - Country-specific search

Historical Data | البيانات التاريخية:
• "When is the best time to buy Wheat?" - Price trends
• "Show price history for Barley" - Historical prices

Product Information | معلومات المنتج:
• "List all concentrates in Egypt" - Product listings
• "What restrictions apply to Urea?" - Feeding restrictions

Tips | نصائح:
• You can ask in English or Arabic | يمكنك السؤال بالإنجليزية أو العربية
• Specify country for regional results | حدد البلد للحصول على نتائج إقليمية
• Use product names like: Wheat Straw, Barley, Alfalfa, Corn
"""
        self._print_panel(help_text, title="Help | المساعدة", style="cyan")
    
    def process_command(self, user_input: str, last_sql: str = "") -> tuple:
        """Process special commands, return (handled, last_sql)"""
        cmd = user_input.strip().lower()
        
        if cmd == 'help':
            self.show_help()
            return True, last_sql
        
        if cmd == 'stats':
            self.show_stats()
            return True, last_sql
        
        if cmd == 'sql':
            if last_sql:
                self._print_panel(last_sql, title="Last SQL Query", style="yellow")
            else:
                self._print("No SQL query has been executed yet", style="yellow")
            return True, last_sql
        
        if cmd == 'clear':
            os.system('cls' if os.name == 'nt' else 'clear')
            return True, last_sql
        
        if cmd in ['exit', 'quit', 'bye', 'خروج']:
            self._print("\n👋 Goodbye! | مع السلامة!\n", style="green")
            return 'exit', last_sql
        
        return False, last_sql
    
    def run(self):
        """Run the interactive CLI"""
        self.show_welcome()
        
        # Initialize agent
        self._print("\n⏳ Initializing agent...", style="yellow")
        try:
            self.agent = create_agent()
            self._print("✅ Agent ready!\n", style="green")
        except Exception as e:
            self._print(f"❌ Failed to initialize agent: {e}", style="red")
            return
        
        last_sql = ""
        
        # Main interaction loop
        while True:
            try:
                # Get user input
                if RICH_AVAILABLE:
                    user_input = Prompt.ask("\n[bold blue]🔍 Your question[/]")
                else:
                    user_input = input("\n🔍 Your question: ")
                
                if not user_input.strip():
                    continue
                
                # Check for commands
                handled, last_sql = self.process_command(user_input, last_sql)
                if handled == 'exit':
                    break
                if handled:
                    continue
                
                # Process the query
                self._print("\n⏳ Processing...", style="yellow")
                result = self.agent.process_query(user_input)
                
                # Store SQL for 'sql' command
                last_sql = result.get('sql', '')
                
                # Display results
                if result['success']:
                    lang_indicator = "🇬🇧" if result['language'] == 'en' else "🇸🇦"
                    self._print(f"\n{lang_indicator} Language detected: {result['language']}", style="dim")
                    
                    # Show response
                    self._print_panel(result['response'], title="Results | النتائج", style="green")
                    
                    # Optionally show data as table
                    if result['data'] and len(result['data']) > 0:
                        show_table = False
                        if RICH_AVAILABLE:
                            show_table = Prompt.ask(
                                "Show detailed table?", 
                                choices=["y", "n"], 
                                default="n"
                            ) == "y"
                        
                        if show_table:
                            self._print_table(result['data'], "Detailed Results")
                else:
                    self._print_panel(
                        f"Error: {result.get('error', 'Unknown error')}\n\nResponse: {result['response']}",
                        title="Error | خطأ",
                        style="red"
                    )
                
            except KeyboardInterrupt:
                self._print("\n\n👋 Interrupted. Goodbye! | مع السلامة!", style="yellow")
                break
            except EOFError:
                break
            except Exception as e:
                self._print(f"\n❌ Error: {e}", style="red")
        
        # Cleanup
        if self.agent:
            self.agent.close()


def main():
    """Main entry point"""
    cli = FeedProductsCLI()
    cli.run()


if __name__ == "__main__":
    main()

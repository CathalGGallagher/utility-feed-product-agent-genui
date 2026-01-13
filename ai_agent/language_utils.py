"""
Language detection and translation utilities for bilingual support (Arabic/English)
"""

from typing import Tuple, Optional
import re

# Try to import language detection library
try:
    from langdetect import detect, DetectorFactory
    # Make language detection deterministic
    DetectorFactory.seed = 0
    LANGDETECT_AVAILABLE = True
except ImportError:
    LANGDETECT_AVAILABLE = False

# Try to import translation library
try:
    from deep_translator import GoogleTranslator
    TRANSLATOR_AVAILABLE = True
except ImportError:
    TRANSLATOR_AVAILABLE = False


# Arabic product name mappings
ARABIC_TO_ENGLISH_PRODUCTS = {
    "برسيم": "Alfalfa",
    "تبن البرسيم": "Alfalfa hay",
    "قش القمح": "Wheat Straw",
    "قش": "Straw",
    "القمح": "Wheat",
    "الشعير": "Barley",
    "شعير": "Barley",
    "الذرة": "Corn",
    "ذرة": "Corn",
    "فول الصويا": "Soybean",
    "صويا": "Soybean",
    "الشوفان": "Oat",
    "شوفان": "Oat",
    "نخالة القمح": "Wheat Bran",
    "نخالة": "Bran",
    "بذور القطن": "Cotton Seed",
    "قطن": "Cotton",
    "دبس السكر": "Molasses",
    "دبس": "Molasses",
    "الحجر الجيري": "Limestone",
    "الملح": "Salt",
    "ملح": "Salt",
    "اليوريا": "Urea",
    "علف": "Feed",
    "علف مركز": "Concentrate",
    "علف خشن": "Fodder",
    "مضافات": "Additive",
}

ENGLISH_TO_ARABIC_PRODUCTS = {v: k for k, v in ARABIC_TO_ENGLISH_PRODUCTS.items()}

# Country name mappings
ARABIC_TO_ENGLISH_COUNTRIES = {
    "الإمارات": "UAE",
    "الامارات": "UAE",
    "دبي": "UAE",
    "أبوظبي": "UAE",
    "السعودية": "Saudi Arabia",
    "المملكة العربية السعودية": "Saudi Arabia",
    "مصر": "Egypt",
    "قطر": "Qatar",
    "البحرين": "Bahrain",
    "الكويت": "Kuwait",
    "عمان": "Oman",
    "الأردن": "Jordan",
    "الاردن": "Jordan",
    "المغرب": "Morocco",
    "تونس": "Tunisia",
    "الجزائر": "Algeria",
    "ليبيا": "Libya",
}

ENGLISH_TO_ARABIC_COUNTRIES = {v: k for k, v in ARABIC_TO_ENGLISH_COUNTRIES.items()}

# Common Arabic query patterns
ARABIC_QUERY_PATTERNS = {
    "من يبيع": "who is selling",
    "من الذي يبيع": "who is selling",
    "اين اجد": "where can I find",
    "أين أجد": "where can I find",
    "ما هو سعر": "what is the price of",
    "ما سعر": "what is the price of",
    "كم سعر": "what is the price of",
    "الأرخص": "cheapest",
    "ارخص": "cheapest",
    "أرخص": "cheapest",
    "الأغلى": "most expensive",
    "متوسط السعر": "average price",
    "متوسط سعر": "average price",
    "أفضل وقت": "best time",
    "افضل وقت": "best time",
    "للشراء": "to buy",
    "المورد": "supplier",
    "الموردين": "suppliers",
    "في": "in",
    "من": "from",
    "ما هي": "what are",
    "ماهي": "what are",
    "أظهر": "show",
    "اظهر": "show",
    "قائمة": "list",
    "اسعار": "prices",
    "أسعار": "prices",
    "تاريخي": "historical",
    "التاريخي": "historical",
}


def detect_language(text: str) -> str:
    """
    Detect if text is Arabic or English
    Returns 'ar' for Arabic, 'en' for English
    """
    # Check for Arabic characters using Unicode ranges
    arabic_pattern = re.compile(r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF]+')
    
    if arabic_pattern.search(text):
        return 'ar'
    
    # Use langdetect if available for more accuracy
    if LANGDETECT_AVAILABLE:
        try:
            detected = detect(text)
            if detected == 'ar':
                return 'ar'
        except:
            pass
    
    return 'en'


def translate_arabic_to_english(text: str) -> str:
    """
    Translate Arabic text to English for query processing
    Uses pattern matching first, then falls back to API translation
    """
    result = text
    
    # Replace Arabic product names with English equivalents
    for ar, en in ARABIC_TO_ENGLISH_PRODUCTS.items():
        result = result.replace(ar, en)
    
    # Replace Arabic country names
    for ar, en in ARABIC_TO_ENGLISH_COUNTRIES.items():
        result = result.replace(ar, en)
    
    # Replace common query patterns
    for ar, en in ARABIC_QUERY_PATTERNS.items():
        result = result.replace(ar, en)
    
    # If still contains Arabic, use translator API
    if re.search(r'[\u0600-\u06FF]', result) and TRANSLATOR_AVAILABLE:
        try:
            translator = GoogleTranslator(source='ar', target='en')
            result = translator.translate(result)
        except Exception as e:
            pass  # Keep partial translation
    
    return result


def translate_english_to_arabic(text: str) -> str:
    """
    Translate English text to Arabic for response
    Uses pattern matching first, then falls back to API translation
    """
    if not text:
        return text
    
    # For simple translations, use our dictionaries
    result = text
    
    # Try API translation if available
    if TRANSLATOR_AVAILABLE:
        try:
            translator = GoogleTranslator(source='en', target='ar')
            result = translator.translate(text)
        except Exception as e:
            # Fall back to simple replacements
            for en, ar in ENGLISH_TO_ARABIC_PRODUCTS.items():
                result = re.sub(rf'\b{en}\b', ar, result, flags=re.IGNORECASE)
            for en, ar in ENGLISH_TO_ARABIC_COUNTRIES.items():
                result = re.sub(rf'\b{en}\b', ar, result, flags=re.IGNORECASE)
    
    return result


def extract_product_from_query(query: str) -> Optional[str]:
    """Extract product name from a query (works for both languages)"""
    query_lower = query.lower()
    
    # English products
    products = [
        "alfalfa hay", "alfalfa", "wheat straw", "barley", "corn", "soybean",
        "oat hay", "wheat bran", "cotton seed", "beet pulp", "triticale",
        "molasses", "limestone", "salt", "urea", "wheat grain", "maize",
        "soya bean meal", "barley flakes", "corn silage", "corn gluten"
    ]
    
    for product in products:
        if product in query_lower:
            return product
    
    # Arabic products
    for ar, en in ARABIC_TO_ENGLISH_PRODUCTS.items():
        if ar in query:
            return en
    
    return None


def extract_country_from_query(query: str) -> Optional[str]:
    """Extract country name from a query (works for both languages)"""
    query_lower = query.lower()
    
    # English countries
    countries = {
        "uae": "UAE",
        "emirates": "UAE",
        "dubai": "UAE",
        "abu dhabi": "UAE",
        "saudi": "Saudi Arabia",
        "saudi arabia": "Saudi Arabia",
        "egypt": "Egypt",
        "qatar": "Qatar",
        "bahrain": "Bahrain",
        "kuwait": "Kuwait",
        "oman": "Oman",
        "jordan": "Jordan",
        "morocco": "Morocco",
        "tunisia": "Tunisia",
    }
    
    for key, value in countries.items():
        if key in query_lower:
            return value
    
    # Arabic countries
    for ar, en in ARABIC_TO_ENGLISH_COUNTRIES.items():
        if ar in query:
            return en
    
    return None


def format_response_bilingual(response: str, target_language: str) -> str:
    """
    Format response in the target language
    """
    if target_language == 'ar':
        return translate_english_to_arabic(response)
    return response


class BilingualFormatter:
    """Format query results in both languages"""
    
    def __init__(self, language: str = 'en'):
        self.language = language
    
    def format_price(self, price: float, currency: str) -> str:
        """Format price with currency"""
        if self.language == 'ar':
            return f"{price:.2f} {currency}"
        return f"{currency} {price:.2f}"
    
    def format_supplier(self, name: str, country: str, price: float = None, currency: str = None) -> str:
        """Format supplier information"""
        if self.language == 'ar':
            country_ar = ENGLISH_TO_ARABIC_COUNTRIES.get(country, country)
            result = f"المورد: {name} ({country_ar})"
            if price is not None and currency:
                result += f" - السعر: {price:.2f} {currency}"
            return result
        else:
            result = f"Supplier: {name} ({country})"
            if price is not None and currency:
                result += f" - Price: {currency} {price:.2f}"
            return result
    
    def format_no_results(self) -> str:
        """Format no results message"""
        if self.language == 'ar':
            return "لم يتم العثور على نتائج"
        return "No results found"
    
    def format_error(self, error: str) -> str:
        """Format error message"""
        if self.language == 'ar':
            return f"حدث خطأ: {error}"
        return f"Error: {error}"
    
    def format_header(self, text: str) -> str:
        """Format section header"""
        translations = {
            "Results": "النتائج",
            "Cheapest suppliers": "أرخص الموردين",
            "Average prices": "متوسط الأسعار",
            "Price trends": "اتجاهات الأسعار",
            "Best time to buy": "أفضل وقت للشراء",
            "Suppliers": "الموردين",
            "Products": "المنتجات",
            "Restrictions": "القيود",
        }
        
        if self.language == 'ar':
            return translations.get(text, text)
        return text


if __name__ == "__main__":
    # Test language detection
    test_queries = [
        "Who is selling the cheapest wheat straw?",
        "من يبيع أرخص قش القمح؟",
        "What is the average price of barley in UAE?",
        "ما هو متوسط سعر الشعير في الإمارات؟",
    ]
    
    for query in test_queries:
        lang = detect_language(query)
        print(f"Query: {query}")
        print(f"Detected language: {lang}")
        
        if lang == 'ar':
            translated = translate_arabic_to_english(query)
            print(f"Translated: {translated}")
        
        product = extract_product_from_query(query)
        country = extract_country_from_query(query)
        print(f"Product: {product}, Country: {country}")
        print("-" * 50)

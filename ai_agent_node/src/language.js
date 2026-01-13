/**
 * Language detection and translation utilities for bilingual support (Arabic/English)
 */

import { COUNTRY_TRANSLATIONS, PRODUCT_TRANSLATIONS } from './config.js';

// Arabic to English product mappings
const ARABIC_TO_ENGLISH_PRODUCTS = {
  'برسيم': 'Alfalfa',
  'تبن البرسيم': 'Alfalfa hay',
  'قش القمح': 'Wheat Straw',
  'قش': 'Straw',
  'القمح': 'Wheat',
  'الشعير': 'Barley',
  'شعير': 'Barley',
  'الذرة': 'Corn',
  'ذرة': 'Corn',
  'فول الصويا': 'Soybean',
  'صويا': 'Soybean',
  'الشوفان': 'Oat',
  'شوفان': 'Oat',
  'نخالة القمح': 'Wheat Bran',
  'نخالة': 'Bran',
  'بذور القطن': 'Cotton Seed',
  'قطن': 'Cotton',
  'دبس السكر': 'Molasses',
  'دبس': 'Molasses',
  'الحجر الجيري': 'Limestone',
  'الملح': 'Salt',
  'ملح': 'Salt',
  'اليوريا': 'Urea',
  'علف': 'Feed',
  'علف مركز': 'Concentrate',
  'علف خشن': 'Fodder',
  'مضافات': 'Additive'
};

// Arabic to English country mappings
const ARABIC_TO_ENGLISH_COUNTRIES = {
  'الإمارات': 'UAE',
  'الامارات': 'UAE',
  'دبي': 'UAE',
  'أبوظبي': 'UAE',
  'السعودية': 'Saudi Arabia',
  'المملكة العربية السعودية': 'Saudi Arabia',
  'مصر': 'Egypt',
  'قطر': 'Qatar',
  'البحرين': 'Bahrain',
  'الكويت': 'Kuwait',
  'عمان': 'Oman',
  'الأردن': 'Jordan',
  'الاردن': 'Jordan',
  'المغرب': 'Morocco',
  'تونس': 'Tunisia',
  'الجزائر': 'Algeria',
  'ليبيا': 'Libya'
};

// Arabic query patterns
const ARABIC_QUERY_PATTERNS = {
  'من يبيع': 'who is selling',
  'من الذي يبيع': 'who is selling',
  'اين اجد': 'where can I find',
  'أين أجد': 'where can I find',
  'ما هو سعر': 'what is the price of',
  'ما سعر': 'what is the price of',
  'كم سعر': 'what is the price of',
  'الأرخص': 'cheapest',
  'ارخص': 'cheapest',
  'أرخص': 'cheapest',
  'الأغلى': 'most expensive',
  'متوسط السعر': 'average price',
  'متوسط سعر': 'average price',
  'أفضل وقت': 'best time',
  'افضل وقت': 'best time',
  'للشراء': 'to buy',
  'المورد': 'supplier',
  'الموردين': 'suppliers',
  'في': 'in',
  'من': 'from',
  'ما هي': 'what are',
  'ماهي': 'what are',
  'أظهر': 'show',
  'اظهر': 'show',
  'قائمة': 'list',
  'اسعار': 'prices',
  'أسعار': 'prices',
  'تاريخي': 'historical',
  'التاريخي': 'historical'
};

/**
 * Detect if text is Arabic or English
 */
export function detectLanguage(text) {
  // Check for Arabic characters using Unicode ranges
  const arabicPattern = /[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF]+/;
  
  if (arabicPattern.test(text)) {
    return 'ar';
  }
  
  return 'en';
}

/**
 * Translate Arabic text to English for query processing
 */
export function translateArabicToEnglish(text) {
  let result = text;
  
  // Replace Arabic product names with English equivalents
  for (const [ar, en] of Object.entries(ARABIC_TO_ENGLISH_PRODUCTS)) {
    result = result.replace(new RegExp(ar, 'g'), en);
  }
  
  // Replace Arabic country names
  for (const [ar, en] of Object.entries(ARABIC_TO_ENGLISH_COUNTRIES)) {
    result = result.replace(new RegExp(ar, 'g'), en);
  }
  
  // Replace common query patterns
  for (const [ar, en] of Object.entries(ARABIC_QUERY_PATTERNS)) {
    result = result.replace(new RegExp(ar, 'g'), en);
  }
  
  return result;
}

/**
 * Extract product name from a query
 */
export function extractProduct(query) {
  const queryLower = query.toLowerCase();
  
  // English products
  const products = [
    'alfalfa hay', 'alfalfa', 'wheat straw', 'barley', 'corn', 'soybean',
    'oat hay', 'wheat bran', 'cotton seed', 'beet pulp', 'triticale',
    'molasses', 'limestone', 'salt', 'urea', 'wheat grain', 'maize',
    'soya bean meal', 'barley flakes', 'corn silage', 'corn gluten'
  ];
  
  for (const product of products) {
    if (queryLower.includes(product)) {
      return product;
    }
  }
  
  // Arabic products
  for (const [ar, en] of Object.entries(ARABIC_TO_ENGLISH_PRODUCTS)) {
    if (query.includes(ar)) {
      return en.toLowerCase();
    }
  }
  
  return null;
}

/**
 * Extract country from a query
 */
export function extractCountry(query) {
  const queryLower = query.toLowerCase();
  
  // English countries
  const countries = {
    'uae': 'UAE',
    'emirates': 'UAE',
    'dubai': 'UAE',
    'abu dhabi': 'UAE',
    'saudi': 'Saudi Arabia',
    'saudi arabia': 'Saudi Arabia',
    'egypt': 'Egypt',
    'qatar': 'Qatar',
    'bahrain': 'Bahrain',
    'kuwait': 'Kuwait',
    'oman': 'Oman',
    'jordan': 'Jordan',
    'morocco': 'Morocco',
    'tunisia': 'Tunisia'
  };
  
  for (const [key, value] of Object.entries(countries)) {
    if (queryLower.includes(key)) {
      return value;
    }
  }
  
  // Arabic countries
  for (const [ar, en] of Object.entries(ARABIC_TO_ENGLISH_COUNTRIES)) {
    if (query.includes(ar)) {
      return en;
    }
  }
  
  return null;
}

/**
 * Format results with bilingual support
 */
export class BilingualFormatter {
  constructor(language = 'en') {
    this.language = language;
  }
  
  formatPrice(price, currency) {
    if (this.language === 'ar') {
      return `${price.toFixed(2)} ${currency}`;
    }
    return `${currency} ${price.toFixed(2)}`;
  }
  
  formatCountry(country) {
    if (this.language === 'ar') {
      return COUNTRY_TRANSLATIONS[country] || country;
    }
    return country;
  }
  
  formatNoResults() {
    return this.language === 'ar' ? 'لم يتم العثور على نتائج' : 'No results found';
  }
  
  formatError(error) {
    return this.language === 'ar' ? `حدث خطأ: ${error}` : `Error: ${error}`;
  }
  
  formatHeader(text) {
    const translations = {
      'Results': 'النتائج',
      'Cheapest suppliers': 'أرخص الموردين',
      'Average prices': 'متوسط الأسعار',
      'Price trends': 'اتجاهات الأسعار',
      'Best time to buy': 'أفضل وقت للشراء',
      'Suppliers': 'الموردين',
      'Products': 'المنتجات'
    };
    
    if (this.language === 'ar') {
      return translations[text] || text;
    }
    return text;
  }
}

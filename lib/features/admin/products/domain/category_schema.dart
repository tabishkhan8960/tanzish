import 'package:flutter/material.dart';

enum ProductType {
  clothing,
  electronics,
  jewelry,
  beauty,
  homeAndKitchen,
  grocery,
  sportsAndFitness,
  personalCare,
  stationery,
  books,
  toys,
}

enum CategoryFieldType { text, number, dropdown, chips, boolean }

class CategoryField {
  const CategoryField({
    required this.name,
    required this.label,
    required this.type,
    this.options = const [],
    this.isRequired = false,
  });

  final String name; 
  final String label; 
  final CategoryFieldType type;
  final List<String> options;
  final bool isRequired;
}

class CategorySchema {
  // CLOTHING
  static const List<CategoryField> clothingFields = [
    CategoryField(name: 'category', label: 'Category', type: CategoryFieldType.dropdown, options: ['Men', 'Women', 'Kids', 'Unisex'], isRequired: true),
    CategoryField(name: 'clothing_category', label: 'Clothing Category', type: CategoryFieldType.dropdown, options: ['T-Shirt', 'Shirt', 'Jeans', 'Pants', 'Shorts', 'Jacket', 'Hoodie', 'Sweatshirt', 'Sweater', 'Kurta', 'Dress', 'Skirt', 'Blazer', 'Coat', 'Ethnic Wear', 'Innerwear', 'Sportswear', 'Sleepwear']),
    CategoryField(name: 'gender', label: 'Gender', type: CategoryFieldType.dropdown, options: ['Men', 'Women', 'Kids', 'Unisex']),
    CategoryField(name: 'brand', label: 'Brand', type: CategoryFieldType.text),
    CategoryField(name: 'material', label: 'Material', type: CategoryFieldType.text),
    CategoryField(name: 'fabric', label: 'Fabric', type: CategoryFieldType.text),
    CategoryField(name: 'sleeve_type', label: 'Sleeve Type', type: CategoryFieldType.text),
    CategoryField(name: 'neck_type', label: 'Neck Type', type: CategoryFieldType.text),
    CategoryField(name: 'pattern', label: 'Pattern', type: CategoryFieldType.text),
    CategoryField(name: 'fit', label: 'Fit', type: CategoryFieldType.text),
    CategoryField(name: 'occasion', label: 'Occasion', type: CategoryFieldType.text),
    CategoryField(name: 'wash_care', label: 'Wash Care', type: CategoryFieldType.text),
  ];

  // ELECTRONICS
  static const List<CategoryField> electronicsFields = [
    CategoryField(name: 'brand', label: 'Brand', type: CategoryFieldType.text, isRequired: true),
    CategoryField(name: 'electronics_category', label: 'Electronics Category', type: CategoryFieldType.dropdown, options: ['Mobile', 'Laptop', 'Tablet', 'Monitor', 'Desktop', 'Television', 'Camera', 'Speaker', 'Headphone', 'Smart Watch', 'Accessories']),
    CategoryField(name: 'processor', label: 'Processor', type: CategoryFieldType.text),
    CategoryField(name: 'ram', label: 'RAM', type: CategoryFieldType.dropdown, options: ['4GB', '6GB', '8GB', '12GB', '16GB']),
    CategoryField(name: 'storage', label: 'Storage', type: CategoryFieldType.dropdown, options: ['64GB', '128GB', '256GB', '512GB', '1TB']),
    CategoryField(name: 'os', label: 'Operating System', type: CategoryFieldType.text),
    CategoryField(name: 'battery', label: 'Battery', type: CategoryFieldType.text),
    CategoryField(name: 'display_size', label: 'Display Size', type: CategoryFieldType.text),
    CategoryField(name: 'camera', label: 'Camera', type: CategoryFieldType.text),
    CategoryField(name: 'resolution', label: 'Resolution', type: CategoryFieldType.text),
    CategoryField(name: 'refresh_rate', label: 'Refresh Rate', type: CategoryFieldType.text),
    CategoryField(name: 'connectivity', label: 'Connectivity', type: CategoryFieldType.text),
    CategoryField(name: 'bluetooth', label: 'Bluetooth', type: CategoryFieldType.text),
    CategoryField(name: 'wifi', label: 'WiFi', type: CategoryFieldType.text),
    CategoryField(name: 'usb_type', label: 'USB Type', type: CategoryFieldType.text),
    CategoryField(name: 'hdmi', label: 'HDMI', type: CategoryFieldType.text),
    CategoryField(name: 'power_consumption', label: 'Power Consumption', type: CategoryFieldType.text),
    CategoryField(name: 'voltage', label: 'Voltage', type: CategoryFieldType.text),
    CategoryField(name: 'warranty', label: 'Warranty', type: CategoryFieldType.text),
    CategoryField(name: 'included_accessories', label: 'Included Accessories', type: CategoryFieldType.text),
  ];

  // JEWELRY
  static const List<CategoryField> jewelryFields = [
    CategoryField(name: 'jewelry_category', label: 'Jewelry Category', type: CategoryFieldType.dropdown, options: ['Ring', 'Necklace', 'Bracelet', 'Pendant', 'Chain', 'Earrings']),
    CategoryField(name: 'brand', label: 'Brand', type: CategoryFieldType.text),
    CategoryField(name: 'material', label: 'Material', type: CategoryFieldType.dropdown, options: ['Gold', 'Silver', 'Diamond', 'Platinum', 'Brass']),
    CategoryField(name: 'metal_purity', label: 'Metal Purity', type: CategoryFieldType.text),
    CategoryField(name: 'weight', label: 'Weight', type: CategoryFieldType.text),
    CategoryField(name: 'stone_type', label: 'Stone Type', type: CategoryFieldType.text),
    CategoryField(name: 'stone_weight', label: 'Stone Weight', type: CategoryFieldType.text),
    CategoryField(name: 'ring_size', label: 'Ring Size', type: CategoryFieldType.text),
    CategoryField(name: 'certification', label: 'Certification', type: CategoryFieldType.text),
    CategoryField(name: 'occasion', label: 'Occasion', type: CategoryFieldType.text),
    CategoryField(name: 'warranty', label: 'Warranty', type: CategoryFieldType.text),
  ];

  // BEAUTY
  static const List<CategoryField> beautyFields = [
    CategoryField(name: 'beauty_category', label: 'Beauty Category', type: CategoryFieldType.text),
    CategoryField(name: 'brand', label: 'Brand', type: CategoryFieldType.text, isRequired: true),
    CategoryField(name: 'skin_type', label: 'Skin Type', type: CategoryFieldType.text),
    CategoryField(name: 'hair_type', label: 'Hair Type', type: CategoryFieldType.text),
    CategoryField(name: 'shade', label: 'Shade', type: CategoryFieldType.text),
    CategoryField(name: 'ingredients', label: 'Ingredients', type: CategoryFieldType.text),
    CategoryField(name: 'volume', label: 'Volume', type: CategoryFieldType.text),
    CategoryField(name: 'fragrance', label: 'Fragrance', type: CategoryFieldType.text),
    CategoryField(name: 'benefits', label: 'Benefits', type: CategoryFieldType.text),
    CategoryField(name: 'usage_instructions', label: 'Usage Instructions', type: CategoryFieldType.text),
    CategoryField(name: 'mfg_date', label: 'Manufacturing Date', type: CategoryFieldType.text),
    CategoryField(name: 'expiry_date', label: 'Expiry Date', type: CategoryFieldType.text),
    CategoryField(name: 'country_of_origin', label: 'Country Of Origin', type: CategoryFieldType.text),
    CategoryField(name: 'dermatologically_tested', label: 'Dermatologically Tested', type: CategoryFieldType.boolean),
    CategoryField(name: 'organic', label: 'Organic', type: CategoryFieldType.boolean),
    CategoryField(name: 'vegan', label: 'Vegan', type: CategoryFieldType.boolean),
    CategoryField(name: 'cruelty_free', label: 'Cruelty Free', type: CategoryFieldType.boolean),
  ];

  // GROCERY
  static const List<CategoryField> groceryFields = [
    CategoryField(name: 'category', label: 'Category', type: CategoryFieldType.text),
    CategoryField(name: 'brand', label: 'Brand', type: CategoryFieldType.text, isRequired: true),
    CategoryField(name: 'weight', label: 'Weight', type: CategoryFieldType.text),
    CategoryField(name: 'quantity', label: 'Quantity', type: CategoryFieldType.text),
    CategoryField(name: 'unit', label: 'Unit', type: CategoryFieldType.dropdown, options: ['Gram', 'Kg', 'ML', 'Liter', 'Pack', 'Bottle']),
    CategoryField(name: 'expiry_date', label: 'Expiry Date', type: CategoryFieldType.text),
    CategoryField(name: 'mfg_date', label: 'Manufacturing Date', type: CategoryFieldType.text),
    CategoryField(name: 'shelf_life', label: 'Shelf Life', type: CategoryFieldType.text),
    CategoryField(name: 'storage_instructions', label: 'Storage Instructions', type: CategoryFieldType.text),
    CategoryField(name: 'ingredients', label: 'Ingredients', type: CategoryFieldType.text),
    CategoryField(name: 'nutrition_facts', label: 'Nutrition Facts', type: CategoryFieldType.text),
    CategoryField(name: 'vegetarian', label: 'Vegetarian', type: CategoryFieldType.boolean),
    CategoryField(name: 'organic', label: 'Organic', type: CategoryFieldType.boolean),
    CategoryField(name: 'country_of_origin', label: 'Country Of Origin', type: CategoryFieldType.text),
  ];

  // HOME & KITCHEN
  static const List<CategoryField> homeAndKitchenFields = [
    CategoryField(name: 'category', label: 'Category', type: CategoryFieldType.text),
    CategoryField(name: 'brand', label: 'Brand', type: CategoryFieldType.text, isRequired: true),
    CategoryField(name: 'material', label: 'Material', type: CategoryFieldType.text),
    CategoryField(name: 'dimensions', label: 'Dimensions', type: CategoryFieldType.text),
    CategoryField(name: 'weight', label: 'Weight', type: CategoryFieldType.text),
    CategoryField(name: 'capacity', label: 'Capacity', type: CategoryFieldType.text),
    CategoryField(name: 'color', label: 'Color', type: CategoryFieldType.text),
    CategoryField(name: 'power_rating', label: 'Power Rating', type: CategoryFieldType.text),
    CategoryField(name: 'voltage', label: 'Voltage', type: CategoryFieldType.text),
    CategoryField(name: 'warranty', label: 'Warranty', type: CategoryFieldType.text),
    CategoryField(name: 'assembly_required', label: 'Assembly Required', type: CategoryFieldType.boolean),
    CategoryField(name: 'package_contents', label: 'Package Contents', type: CategoryFieldType.text),
  ];

  // SPORTS
  static const List<CategoryField> sportsFields = [
    CategoryField(name: 'category', label: 'Category', type: CategoryFieldType.text),
    CategoryField(name: 'brand', label: 'Brand', type: CategoryFieldType.text),
    CategoryField(name: 'sport_type', label: 'Sport Type', type: CategoryFieldType.text),
    CategoryField(name: 'material', label: 'Material', type: CategoryFieldType.text),
    CategoryField(name: 'weight', label: 'Weight', type: CategoryFieldType.text),
    CategoryField(name: 'dimensions', label: 'Dimensions', type: CategoryFieldType.text),
    CategoryField(name: 'skill_level', label: 'Skill Level', type: CategoryFieldType.text),
    CategoryField(name: 'indoor', label: 'Indoor', type: CategoryFieldType.boolean),
    CategoryField(name: 'outdoor', label: 'Outdoor', type: CategoryFieldType.boolean),
    CategoryField(name: 'target_age', label: 'Target Age', type: CategoryFieldType.text),
    CategoryField(name: 'warranty', label: 'Warranty', type: CategoryFieldType.text),
  ];

  // PERSONAL CARE
  static const List<CategoryField> personalCareFields = [
    CategoryField(name: 'category', label: 'Category', type: CategoryFieldType.text),
    CategoryField(name: 'brand', label: 'Brand', type: CategoryFieldType.text),
    CategoryField(name: 'skin_type', label: 'Skin Type', type: CategoryFieldType.text),
    CategoryField(name: 'hair_type', label: 'Hair Type', type: CategoryFieldType.text),
    CategoryField(name: 'gender', label: 'Gender', type: CategoryFieldType.text),
    CategoryField(name: 'ingredients', label: 'Ingredients', type: CategoryFieldType.text),
    CategoryField(name: 'volume', label: 'Volume', type: CategoryFieldType.text),
    CategoryField(name: 'fragrance', label: 'Fragrance', type: CategoryFieldType.text),
    CategoryField(name: 'usage', label: 'Usage', type: CategoryFieldType.text),
    CategoryField(name: 'expiry_date', label: 'Expiry Date', type: CategoryFieldType.text),
    CategoryField(name: 'country_of_origin', label: 'Country of Origin', type: CategoryFieldType.text),
  ];

  // STATIONERY
  static const List<CategoryField> stationeryFields = [
    CategoryField(name: 'category', label: 'Category', type: CategoryFieldType.text),
    CategoryField(name: 'brand', label: 'Brand', type: CategoryFieldType.text),
    CategoryField(name: 'material', label: 'Material', type: CategoryFieldType.text),
    CategoryField(name: 'paper_size', label: 'Paper Size', type: CategoryFieldType.text),
    CategoryField(name: 'binding_type', label: 'Binding Type', type: CategoryFieldType.text),
    CategoryField(name: 'pages', label: 'Pages', type: CategoryFieldType.text),
    CategoryField(name: 'ink_color', label: 'Ink Color', type: CategoryFieldType.text),
    CategoryField(name: 'pack_size', label: 'Pack Size', type: CategoryFieldType.text),
    CategoryField(name: 'refillable', label: 'Refillable', type: CategoryFieldType.boolean),
  ];

  // BOOKS
  static const List<CategoryField> booksFields = [
    CategoryField(name: 'book_title', label: 'Book Title', type: CategoryFieldType.text),
    CategoryField(name: 'author', label: 'Author', type: CategoryFieldType.text),
    CategoryField(name: 'publisher', label: 'Publisher', type: CategoryFieldType.text),
    CategoryField(name: 'isbn', label: 'ISBN', type: CategoryFieldType.text),
    CategoryField(name: 'language', label: 'Language', type: CategoryFieldType.text),
    CategoryField(name: 'genre', label: 'Genre', type: CategoryFieldType.text),
    CategoryField(name: 'edition', label: 'Edition', type: CategoryFieldType.text),
    CategoryField(name: 'publication_date', label: 'Publication Date', type: CategoryFieldType.text),
    CategoryField(name: 'pages', label: 'Pages', type: CategoryFieldType.text),
    CategoryField(name: 'format', label: 'Format', type: CategoryFieldType.dropdown, options: ['Paperback', 'Hardcover', 'eBook']),
    CategoryField(name: 'age_group', label: 'Age Group', type: CategoryFieldType.text),
  ];


  static List<CategoryField> getFieldsForType(ProductType type) {
    switch (type) {
      case ProductType.clothing: return clothingFields;
      case ProductType.electronics: return electronicsFields;
      case ProductType.jewelry: return jewelryFields;
      case ProductType.beauty: return beautyFields;
      case ProductType.grocery: return groceryFields;
      case ProductType.homeAndKitchen: return homeAndKitchenFields;
      case ProductType.sportsAndFitness: return sportsFields;
      case ProductType.personalCare: return personalCareFields;
      case ProductType.stationery: return stationeryFields;
      case ProductType.books: return booksFields;
      default: return [];
    }
  }

  static List<String> getVariantColumnsForType(ProductType type) {
    switch (type) {
      case ProductType.clothing: return ['Size', 'Color'];
      case ProductType.electronics: return ['Storage', 'RAM', 'Color'];
      case ProductType.jewelry: return ['Ring Size', 'Color'];
      case ProductType.sportsAndFitness: return ['Size', 'Color'];
      default: return ['Variant'];
    }
  }

  static String getLabelForType(ProductType type) {
    switch (type) {
      case ProductType.clothing: return 'Clothing';
      case ProductType.electronics: return 'Electronics';
      case ProductType.jewelry: return 'Jewelry';
      case ProductType.beauty: return 'Beauty';
      case ProductType.homeAndKitchen: return 'Home & Kitchen';
      case ProductType.grocery: return 'Grocery';
      case ProductType.sportsAndFitness: return 'Sports & Fitness';
      case ProductType.personalCare: return 'Personal Care';
      case ProductType.stationery: return 'Stationery';
      case ProductType.books: return 'Books';
      case ProductType.toys: return 'Toys';
    }
  }
}

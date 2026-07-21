import 'package:flutter/material.dart';

enum CategoryFieldType { text, number, dropdown }

class CategoryField {
  const CategoryField({
    required this.name,
    required this.label,
    required this.type,
    this.options = const [],
    this.isRequired = false,
  });

  final String name; // e.g., 'ram'
  final String label; // e.g., 'RAM'
  final CategoryFieldType type;
  final List<String> options; // For dropdowns
  final bool isRequired;
}

class CategorySchema {
  static const List<CategoryField> electronicsFields = [
    CategoryField(name: 'brand', label: 'Brand', type: CategoryFieldType.text, isRequired: true),
    CategoryField(name: 'model', label: 'Model', type: CategoryFieldType.text),
    CategoryField(name: 'color', label: 'Color', type: CategoryFieldType.text),
    CategoryField(name: 'warranty', label: 'Warranty', type: CategoryFieldType.text),
    CategoryField(name: 'power_consumption', label: 'Power Consumption', type: CategoryFieldType.text),
    CategoryField(name: 'voltage', label: 'Voltage', type: CategoryFieldType.text),
    CategoryField(name: 'dimensions', label: 'Dimensions', type: CategoryFieldType.text),
  ];

  static const List<CategoryField> mobilePhonesFields = [
    CategoryField(name: 'brand', label: 'Brand', type: CategoryFieldType.text, isRequired: true),
    CategoryField(name: 'model', label: 'Model', type: CategoryFieldType.text, isRequired: true),
    CategoryField(name: 'processor', label: 'Processor', type: CategoryFieldType.text),
    CategoryField(name: 'display_size', label: 'Display Size', type: CategoryFieldType.text),
    CategoryField(name: 'battery', label: 'Battery Capacity', type: CategoryFieldType.text),
    CategoryField(name: 'camera', label: 'Camera Details', type: CategoryFieldType.text),
    CategoryField(name: 'os', label: 'Operating System', type: CategoryFieldType.text),
    CategoryField(name: 'warranty', label: 'Warranty', type: CategoryFieldType.text),
    CategoryField(name: 'imei', label: 'IMEI', type: CategoryFieldType.text),
  ];

  static const List<CategoryField> clothingFields = [
    CategoryField(name: 'gender', label: 'Gender', type: CategoryFieldType.dropdown, options: ['Men', 'Women', 'Kids', 'Unisex']),
    CategoryField(name: 'fabric', label: 'Fabric', type: CategoryFieldType.text),
    CategoryField(name: 'material', label: 'Material', type: CategoryFieldType.text),
    CategoryField(name: 'sleeve_type', label: 'Sleeve Type', type: CategoryFieldType.text),
    CategoryField(name: 'neck_type', label: 'Neck Type', type: CategoryFieldType.text),
    CategoryField(name: 'fit', label: 'Fit', type: CategoryFieldType.text),
    CategoryField(name: 'pattern', label: 'Pattern', type: CategoryFieldType.text),
    CategoryField(name: 'occasion', label: 'Occasion', type: CategoryFieldType.text),
  ];

  static const List<CategoryField> jewelryFields = [
    CategoryField(name: 'material', label: 'Material', type: CategoryFieldType.text),
    CategoryField(name: 'metal_type', label: 'Metal Type', type: CategoryFieldType.text),
    CategoryField(name: 'stone_type', label: 'Stone Type', type: CategoryFieldType.text),
    CategoryField(name: 'purity', label: 'Purity', type: CategoryFieldType.text),
    CategoryField(name: 'occasion', label: 'Occasion', type: CategoryFieldType.text),
  ];

  static const List<CategoryField> beautyFields = [
    CategoryField(name: 'skin_type', label: 'Skin Type', type: CategoryFieldType.text),
    CategoryField(name: 'hair_type', label: 'Hair Type', type: CategoryFieldType.text),
    CategoryField(name: 'shade', label: 'Shade', type: CategoryFieldType.text),
    CategoryField(name: 'volume', label: 'Volume', type: CategoryFieldType.text),
    CategoryField(name: 'ingredients', label: 'Ingredients', type: CategoryFieldType.text),
    CategoryField(name: 'expiry_date', label: 'Expiry Date', type: CategoryFieldType.text),
    CategoryField(name: 'mfg_date', label: 'Manufacturing Date', type: CategoryFieldType.text),
  ];

  static List<CategoryField> getFieldsForCategory(String categoryName) {
    final lower = categoryName.toLowerCase();
    if (lower.contains('mobile') || lower.contains('phone')) {
      return mobilePhonesFields;
    } else if (lower.contains('laptop') || lower.contains('computer')) {
      return mobilePhonesFields; // Mostly similar, can define explicitly later
    } else if (lower.contains('electronic')) {
      return electronicsFields;
    } else if (lower.contains('cloth') || lower.contains('fashion') || lower.contains('men') || lower.contains('women') || lower.contains('kid')) {
      return clothingFields;
    } else if (lower.contains('jewel')) {
      return jewelryFields;
    } else if (lower.contains('beauty') || lower.contains('makeup')) {
      return beautyFields;
    }
    return []; // Generic category, no extra fields
  }
}

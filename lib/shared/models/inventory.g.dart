// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Inventory _$InventoryFromJson(Map<String, dynamic> json) => _Inventory(
  id: json['id'] as String,
  productId: json['product_id'] as String,
  variantAttributes:
      json['variant_attributes'] as Map<String, dynamic>? ?? const {},
  quantity: (json['quantity'] as num?)?.toInt() ?? 0,
  lowStockThreshold: (json['low_stock_threshold'] as num?)?.toInt() ?? 5,
  updatedAt: DateTime.parse(json['updated_at'] as String),
  product: json['product'] == null
      ? null
      : Product.fromJson(json['product'] as Map<String, dynamic>),
);

Map<String, dynamic> _$InventoryToJson(_Inventory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'product_id': instance.productId,
      'variant_attributes': instance.variantAttributes,
      'quantity': instance.quantity,
      'low_stock_threshold': instance.lowStockThreshold,
      'updated_at': instance.updatedAt.toIso8601String(),
      'product': instance.product,
    };

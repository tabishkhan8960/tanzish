// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CartItem _$CartItemFromJson(Map<String, dynamic> json) => _CartItem(
  id: json['id'] as String,
  userId: json['user_id'] as String,
  productId: json['product_id'] as String,
  variantAttributes:
      json['variant_attributes'] as Map<String, dynamic>? ?? const {},
  quantity: (json['quantity'] as num?)?.toInt() ?? 1,
  product: json['product'] == null
      ? null
      : Product.fromJson(json['product'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CartItemToJson(_CartItem instance) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.userId,
  'product_id': instance.productId,
  'variant_attributes': instance.variantAttributes,
  'quantity': instance.quantity,
  'product': instance.product,
};

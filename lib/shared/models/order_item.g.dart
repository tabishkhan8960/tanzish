// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OrderItem _$OrderItemFromJson(Map<String, dynamic> json) => _OrderItem(
  id: json['id'] as String,
  orderId: json['order_id'] as String,
  productId: json['product_id'] as String?,
  productName: json['product_name'] as String,
  variantAttributes:
      json['variant_attributes'] as Map<String, dynamic>? ?? const {},
  unitPrice: json['unit_price'] as num,
  quantity: (json['quantity'] as num).toInt(),
  subtotal: json['subtotal'] as num,
  product: json['product'] == null
      ? null
      : Product.fromJson(json['product'] as Map<String, dynamic>),
);

Map<String, dynamic> _$OrderItemToJson(_OrderItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'order_id': instance.orderId,
      'product_id': instance.productId,
      'product_name': instance.productName,
      'variant_attributes': instance.variantAttributes,
      'unit_price': instance.unitPrice,
      'quantity': instance.quantity,
      'subtotal': instance.subtotal,
      'product': instance.product,
    };

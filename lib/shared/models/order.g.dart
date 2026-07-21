// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Order _$OrderFromJson(Map<String, dynamic> json) => _Order(
  id: json['id'] as String,
  orderNumber: json['order_number'] as String,
  userId: json['user_id'] as String,
  status:
      $enumDecodeNullable(_$OrderStatusEnumMap, json['status']) ??
      OrderStatus.pending,
  shippingAddressId: json['shipping_address_id'] as String?,
  billingAddressId: json['billing_address_id'] as String?,
  couponId: json['coupon_id'] as String?,
  subtotal: json['subtotal'] as num? ?? 0,
  shippingFee: json['shipping_fee'] as num? ?? 0,
  discount: json['discount'] as num? ?? 0,
  total: json['total'] as num? ?? 0,
  currency: json['currency'] as String? ?? 'USD',
  placedAt: DateTime.parse(json['placed_at'] as String),
  items:
      (json['order_items'] as List<dynamic>?)
          ?.map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  shippingAddress: json['shipping_address'] == null
      ? null
      : Address.fromJson(json['shipping_address'] as Map<String, dynamic>),
  payments:
      (json['payments'] as List<dynamic>?)
          ?.map((e) => Payment.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$OrderToJson(_Order instance) => <String, dynamic>{
  'id': instance.id,
  'order_number': instance.orderNumber,
  'user_id': instance.userId,
  'status': _$OrderStatusEnumMap[instance.status]!,
  'shipping_address_id': instance.shippingAddressId,
  'billing_address_id': instance.billingAddressId,
  'coupon_id': instance.couponId,
  'subtotal': instance.subtotal,
  'shipping_fee': instance.shippingFee,
  'discount': instance.discount,
  'total': instance.total,
  'currency': instance.currency,
  'placed_at': instance.placedAt.toIso8601String(),
  'order_items': instance.items,
  'shipping_address': instance.shippingAddress,
  'payments': instance.payments,
};

const _$OrderStatusEnumMap = {
  OrderStatus.pending: 'pending',
  OrderStatus.confirmed: 'confirmed',
  OrderStatus.processing: 'processing',
  OrderStatus.shipped: 'shipped',
  OrderStatus.delivered: 'delivered',
  OrderStatus.cancelled: 'cancelled',
  OrderStatus.refunded: 'refunded',
};

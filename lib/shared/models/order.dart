import 'package:freezed_annotation/freezed_annotation.dart';

import 'address.dart';
import 'order_item.dart';
import 'payment.dart';

part 'order.freezed.dart';
part 'order.g.dart';

enum OrderStatus { pending, confirmed, processing, shipped, delivered, cancelled, refunded }

@freezed
abstract class Order with _$Order {
  const factory Order({
    required String id,
    required String orderNumber,
    required String userId,
    @Default(OrderStatus.pending) OrderStatus status,
    String? shippingAddressId,
    String? billingAddressId,
    String? couponId,
    @Default(0) num subtotal,
    @Default(0) num shippingFee,
    @Default(0) num discount,
    @Default(0) num total,
    @Default('USD') String currency,
    required DateTime placedAt,
    @JsonKey(name: 'order_items') @Default([]) List<OrderItem> items,
    Address? shippingAddress,
    @Default([]) List<Payment> payments,
  }) = _Order;

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
}

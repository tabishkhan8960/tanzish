import 'package:freezed_annotation/freezed_annotation.dart';

import 'product.dart';

part 'order_item.freezed.dart';
part 'order_item.g.dart';

@freezed
abstract class OrderItem with _$OrderItem {
  const factory OrderItem({
    required String id,
    required String orderId,
    String? productId,
    required String productName,
    @Default({}) Map<String, dynamic> variantAttributes,
    required num unitPrice,
    required int quantity,
    required num subtotal,
    Product? product,
  }) = _OrderItem;

  factory OrderItem.fromJson(Map<String, dynamic> json) => _$OrderItemFromJson(json);
}

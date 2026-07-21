import 'package:freezed_annotation/freezed_annotation.dart';

import 'product.dart';

part 'cart_item.freezed.dart';
part 'cart_item.g.dart';

@freezed
abstract class CartItem with _$CartItem {
  const factory CartItem({
    required String id,
    required String userId,
    required String productId,
    @Default({}) Map<String, dynamic> variantAttributes,
    @Default(1) int quantity,
    Product? product,
  }) = _CartItem;

  const CartItem._();

  factory CartItem.fromJson(Map<String, dynamic> json) => _$CartItemFromJson(json);

  num get lineTotal => (product?.price ?? 0) * quantity;
}

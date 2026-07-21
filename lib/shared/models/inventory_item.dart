import 'package:freezed_annotation/freezed_annotation.dart';

import 'product.dart';

part 'inventory_item.freezed.dart';
part 'inventory_item.g.dart';

@freezed
abstract class InventoryItem with _$InventoryItem {
  const factory InventoryItem({
    required String id,
    required String productId,
    @Default({}) Map<String, dynamic> variantAttributes,
    @Default(0) int quantity,
    @Default(5) int lowStockThreshold,
    Product? product,
  }) = _InventoryItem;

  const InventoryItem._();

  factory InventoryItem.fromJson(Map<String, dynamic> json) => _$InventoryItemFromJson(json);

  bool get isLowStock => quantity <= lowStockThreshold;
}

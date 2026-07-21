import 'package:freezed_annotation/freezed_annotation.dart';

import 'product.dart';

part 'inventory.freezed.dart';
part 'inventory.g.dart';

@freezed
abstract class Inventory with _$Inventory {
  const factory Inventory({
    required String id,
    required String productId,
    @Default({}) Map<String, dynamic> variantAttributes,
    @Default(0) int quantity,
    @Default(5) int lowStockThreshold,
    num? price,
    num? compareAtPrice,
    String? sku,
    String? barcode,
    num? weightGrams,
    @Default([]) List<String> imageUrls,
    required DateTime updatedAt,
    // Embedded
    Product? product,
  }) = _Inventory;

  factory Inventory.fromJson(Map<String, dynamic> json) => _$InventoryFromJson(json);
}

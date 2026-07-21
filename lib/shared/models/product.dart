import 'package:freezed_annotation/freezed_annotation.dart';

import 'brand.dart';
import 'category.dart';
import 'product_image.dart';

part 'product.freezed.dart';
part 'product.g.dart';

@freezed
abstract class Product with _$Product {
  const factory Product({
    required String id,
    required String name,
    required String slug,
    String? description,
    String? brandId,
    String? categoryId,
    String? sku,
    required num price,
    num? compareAtPrice,
    num? costPrice,
    String? barcode,
    num? weightGrams,
    @Default({}) Map<String, dynamic> attributes,
    @Default(0) num ratingAvg,
    @Default(0) int ratingCount,
    @Default(true) bool isActive,
    @Default(false) bool isFeatured,
    // Populated only when the query embeds related rows, e.g.
    // `.select('*, brand:brands(*), category:categories(*), product_images(*)')`
    Brand? brand,
    Category? category,
    @JsonKey(name: 'product_images') @Default([]) List<ProductImage> images,
  }) = _Product;

  const Product._();

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);

  String? get primaryImageUrl {
    if (images.isEmpty) return null;
    final primary = images.where((i) => i.isPrimary).toList();
    return (primary.isNotEmpty ? primary.first : images.first).imageUrl;
  }

  bool get isOnSale => compareAtPrice != null && compareAtPrice! > price;

  int? get discountPercent {
    if (!isOnSale) return null;
    return (((compareAtPrice! - price) / compareAtPrice!) * 100).round();
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Product _$ProductFromJson(Map<String, dynamic> json) => _Product(
  id: json['id'] as String,
  name: json['name'] as String,
  slug: json['slug'] as String,
  description: json['description'] as String?,
  brandId: json['brand_id'] as String?,
  categoryId: json['category_id'] as String?,
  sku: json['sku'] as String?,
  price: json['price'] as num,
  compareAtPrice: json['compare_at_price'] as num?,
  attributes: json['attributes'] as Map<String, dynamic>? ?? const {},
  ratingAvg: json['rating_avg'] as num? ?? 0,
  ratingCount: (json['rating_count'] as num?)?.toInt() ?? 0,
  isActive: json['is_active'] as bool? ?? true,
  isFeatured: json['is_featured'] as bool? ?? false,
  brand: json['brand'] == null
      ? null
      : Brand.fromJson(json['brand'] as Map<String, dynamic>),
  category: json['category'] == null
      ? null
      : Category.fromJson(json['category'] as Map<String, dynamic>),
  images:
      (json['product_images'] as List<dynamic>?)
          ?.map((e) => ProductImage.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$ProductToJson(_Product instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'slug': instance.slug,
  'description': instance.description,
  'brand_id': instance.brandId,
  'category_id': instance.categoryId,
  'sku': instance.sku,
  'price': instance.price,
  'compare_at_price': instance.compareAtPrice,
  'attributes': instance.attributes,
  'rating_avg': instance.ratingAvg,
  'rating_count': instance.ratingCount,
  'is_active': instance.isActive,
  'is_featured': instance.isFeatured,
  'brand': instance.brand,
  'category': instance.category,
  'product_images': instance.images,
};

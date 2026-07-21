// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Review _$ReviewFromJson(Map<String, dynamic> json) => _Review(
  id: json['id'] as String,
  productId: json['product_id'] as String,
  customerName: json['customer_name'] as String,
  rating: (json['rating'] as num).toInt(),
  reviewTitle: json['review_title'] as String?,
  reviewDescription: json['review_description'] as String?,
  customerAvatar: json['customer_avatar'] as String?,
  verifiedPurchase: json['verified_purchase'] as bool? ?? false,
  status: json['status'] as String? ?? 'Published',
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$ReviewToJson(_Review instance) => <String, dynamic>{
  'id': instance.id,
  'product_id': instance.productId,
  'customer_name': instance.customerName,
  'rating': instance.rating,
  'review_title': instance.reviewTitle,
  'review_description': instance.reviewDescription,
  'customer_avatar': instance.customerAvatar,
  'verified_purchase': instance.verifiedPurchase,
  'status': instance.status,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
};

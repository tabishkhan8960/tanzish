// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Review _$ReviewFromJson(Map<String, dynamic> json) => _Review(
  id: json['id'] as String,
  productId: json['product_id'] as String,
  userId: json['user_id'] as String,
  orderItemId: json['order_item_id'] as String?,
  rating: (json['rating'] as num).toInt(),
  comment: json['comment'] as String?,
  images:
      (json['images'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  isApproved: json['is_approved'] as bool? ?? true,
  createdAt: DateTime.parse(json['created_at'] as String),
  profile: json['profile'] == null
      ? null
      : Profile.fromJson(json['profile'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ReviewToJson(_Review instance) => <String, dynamic>{
  'id': instance.id,
  'product_id': instance.productId,
  'user_id': instance.userId,
  'order_item_id': instance.orderItemId,
  'rating': instance.rating,
  'comment': instance.comment,
  'images': instance.images,
  'is_approved': instance.isApproved,
  'created_at': instance.createdAt.toIso8601String(),
  'profile': instance.profile,
};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coupon.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Coupon _$CouponFromJson(Map<String, dynamic> json) => _Coupon(
  id: json['id'] as String,
  code: json['code'] as String,
  description: json['description'] as String?,
  discountType: $enumDecode(_$DiscountTypeEnumMap, json['discount_type']),
  discountValue: json['discount_value'] as num,
  minOrderAmount: json['min_order_amount'] as num? ?? 0,
  maxDiscountAmount: json['max_discount_amount'] as num?,
  usageLimit: (json['usage_limit'] as num?)?.toInt(),
  usedCount: (json['used_count'] as num?)?.toInt() ?? 0,
  startsAt: json['starts_at'] == null
      ? null
      : DateTime.parse(json['starts_at'] as String),
  expiresAt: json['expires_at'] == null
      ? null
      : DateTime.parse(json['expires_at'] as String),
  isActive: json['is_active'] as bool? ?? true,
);

Map<String, dynamic> _$CouponToJson(_Coupon instance) => <String, dynamic>{
  'id': instance.id,
  'code': instance.code,
  'description': instance.description,
  'discount_type': _$DiscountTypeEnumMap[instance.discountType]!,
  'discount_value': instance.discountValue,
  'min_order_amount': instance.minOrderAmount,
  'max_discount_amount': instance.maxDiscountAmount,
  'usage_limit': instance.usageLimit,
  'used_count': instance.usedCount,
  'starts_at': instance.startsAt?.toIso8601String(),
  'expires_at': instance.expiresAt?.toIso8601String(),
  'is_active': instance.isActive,
};

const _$DiscountTypeEnumMap = {
  DiscountType.percentage: 'percentage',
  DiscountType.fixed: 'fixed',
};

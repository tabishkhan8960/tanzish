import 'package:freezed_annotation/freezed_annotation.dart';

part 'coupon.freezed.dart';
part 'coupon.g.dart';

enum DiscountType { percentage, fixed }

@freezed
abstract class Coupon with _$Coupon {
  const factory Coupon({
    required String id,
    required String code,
    String? description,
    required DiscountType discountType,
    required num discountValue,
    @Default(0) num minOrderAmount,
    num? maxDiscountAmount,
    int? usageLimit,
    @Default(0) int usedCount,
    DateTime? startsAt,
    DateTime? expiresAt,
    @Default(true) bool isActive,
  }) = _Coupon;

  const Coupon._();

  factory Coupon.fromJson(Map<String, dynamic> json) => _$CouponFromJson(json);

  num discountFor(num subtotal) {
    if (subtotal < minOrderAmount) return 0;
    final raw = discountType == DiscountType.percentage
        ? subtotal * (discountValue / 100)
        : discountValue;
    if (maxDiscountAmount != null && raw > maxDiscountAmount!) {
      return maxDiscountAmount!;
    }
    return raw;
  }
}

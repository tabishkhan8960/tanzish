import 'package:freezed_annotation/freezed_annotation.dart';

part 'review.freezed.dart';
part 'review.g.dart';

@freezed
abstract class Review with _$Review {
  const factory Review({
    required String id,
    @JsonKey(name: 'product_id') required String productId,
    @JsonKey(name: 'customer_name') required String customerName,
    required int rating,
    @JsonKey(name: 'review_title') String? reviewTitle,
    @JsonKey(name: 'review_description') String? reviewDescription,
    @JsonKey(name: 'customer_avatar') String? customerAvatar,
    @JsonKey(name: 'verified_purchase') @Default(false) bool verifiedPurchase,
    @Default('Published') String status,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _Review;

  factory Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);
}

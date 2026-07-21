import 'package:freezed_annotation/freezed_annotation.dart';

import 'profile.dart';

part 'review.freezed.dart';
part 'review.g.dart';

@freezed
abstract class Review with _$Review {
  const factory Review({
    required String id,
    required String productId,
    required String userId,
    String? orderItemId,
    required int rating,
    String? comment,
    @Default([]) List<String> images,
    @Default(true) bool isApproved,
    required DateTime createdAt,
    Profile? profile,
  }) = _Review;

  factory Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);
}

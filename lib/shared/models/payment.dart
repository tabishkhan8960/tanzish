import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment.freezed.dart';
part 'payment.g.dart';

enum PaymentStatus { pending, paid, failed, refunded }

@freezed
abstract class Payment with _$Payment {
  const factory Payment({
    required String id,
    required String orderId,
    required String provider,
    @Default(PaymentStatus.pending) PaymentStatus status,
    required num amount,
    @Default('USD') String currency,
    String? transactionRef,
    DateTime? paidAt,
  }) = _Payment;

  factory Payment.fromJson(Map<String, dynamic> json) => _$PaymentFromJson(json);
}

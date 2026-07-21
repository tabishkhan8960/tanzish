// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Payment _$PaymentFromJson(Map<String, dynamic> json) => _Payment(
  id: json['id'] as String,
  orderId: json['order_id'] as String,
  provider: json['provider'] as String,
  status:
      $enumDecodeNullable(_$PaymentStatusEnumMap, json['status']) ??
      PaymentStatus.pending,
  amount: json['amount'] as num,
  currency: json['currency'] as String? ?? 'USD',
  transactionRef: json['transaction_ref'] as String?,
  paidAt: json['paid_at'] == null
      ? null
      : DateTime.parse(json['paid_at'] as String),
);

Map<String, dynamic> _$PaymentToJson(_Payment instance) => <String, dynamic>{
  'id': instance.id,
  'order_id': instance.orderId,
  'provider': instance.provider,
  'status': _$PaymentStatusEnumMap[instance.status]!,
  'amount': instance.amount,
  'currency': instance.currency,
  'transaction_ref': instance.transactionRef,
  'paid_at': instance.paidAt?.toIso8601String(),
};

const _$PaymentStatusEnumMap = {
  PaymentStatus.pending: 'pending',
  PaymentStatus.paid: 'paid',
  PaymentStatus.failed: 'failed',
  PaymentStatus.refunded: 'refunded',
};

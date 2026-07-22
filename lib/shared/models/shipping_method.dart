import 'package:freezed_annotation/freezed_annotation.dart';

part 'shipping_method.freezed.dart';
part 'shipping_method.g.dart';

@freezed
abstract class ShippingMethod with _$ShippingMethod {
  const factory ShippingMethod({
    required String id,
    required String name,
    String? description,
    @Default(0) num price,
    @Default(1) int minDays,
    @Default(3) int maxDays,
    @Default(true) bool isActive,
  }) = _ShippingMethod;

  const ShippingMethod._();

  factory ShippingMethod.fromJson(Map<String, dynamic> json) => _$ShippingMethodFromJson(json);

  String get etaLabel => minDays == maxDays ? '$minDays day${minDays == 1 ? '' : 's'}' : '$minDays-$maxDays days';
}

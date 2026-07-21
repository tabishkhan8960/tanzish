import 'package:freezed_annotation/freezed_annotation.dart';

part 'address.freezed.dart';
part 'address.g.dart';

enum AddressType { shipping, billing }

@freezed
abstract class Address with _$Address {
  const factory Address({
    required String id,
    required String userId,
    @Default(AddressType.shipping) AddressType type,
    required String fullName,
    String? phone,
    required String addressLine1,
    String? addressLine2,
    required String city,
    String? state,
    String? postalCode,
    required String country,
    @Default(false) bool isDefault,
  }) = _Address;

  const Address._();

  factory Address.fromJson(Map<String, dynamic> json) => _$AddressFromJson(json);

  String get formatted => [
        addressLine1,
        if (addressLine2 != null && addressLine2!.isNotEmpty) addressLine2,
        city,
        if (state != null && state!.isNotEmpty) state,
        postalCode,
        country,
      ].where((e) => e != null && e.toString().isNotEmpty).join(', ');
}

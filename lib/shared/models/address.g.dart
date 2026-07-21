// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Address _$AddressFromJson(Map<String, dynamic> json) => _Address(
  id: json['id'] as String,
  userId: json['user_id'] as String,
  type:
      $enumDecodeNullable(_$AddressTypeEnumMap, json['type']) ??
      AddressType.shipping,
  fullName: json['full_name'] as String,
  phone: json['phone'] as String?,
  addressLine1: json['address_line1'] as String,
  addressLine2: json['address_line2'] as String?,
  city: json['city'] as String,
  state: json['state'] as String?,
  postalCode: json['postal_code'] as String?,
  country: json['country'] as String,
  isDefault: json['is_default'] as bool? ?? false,
);

Map<String, dynamic> _$AddressToJson(_Address instance) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.userId,
  'type': _$AddressTypeEnumMap[instance.type]!,
  'full_name': instance.fullName,
  'phone': instance.phone,
  'address_line1': instance.addressLine1,
  'address_line2': instance.addressLine2,
  'city': instance.city,
  'state': instance.state,
  'postal_code': instance.postalCode,
  'country': instance.country,
  'is_default': instance.isDefault,
};

const _$AddressTypeEnumMap = {
  AddressType.shipping: 'shipping',
  AddressType.billing: 'billing',
};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Profile _$ProfileFromJson(Map<String, dynamic> json) => _Profile(
  id: json['id'] as String,
  role: $enumDecodeNullable(_$AppRoleEnumMap, json['role']) ?? AppRole.customer,
  fullName: json['full_name'] as String?,
  phone: json['phone'] as String?,
  avatarUrl: json['avatar_url'] as String?,
);

Map<String, dynamic> _$ProfileToJson(_Profile instance) => <String, dynamic>{
  'id': instance.id,
  'role': _$AppRoleEnumMap[instance.role]!,
  'full_name': instance.fullName,
  'phone': instance.phone,
  'avatar_url': instance.avatarUrl,
};

const _$AppRoleEnumMap = {
  AppRole.admin: 'admin',
  AppRole.customer: 'customer',
  AppRole.storeManager: 'store_manager',
  AppRole.deliveryBoy: 'delivery_boy',
};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'role_permission.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RolePermission _$RolePermissionFromJson(Map<String, dynamic> json) =>
    _RolePermission(
      id: json['id'] as String,
      role: $enumDecode(_$AppRoleEnumMap, json['role']),
      permission: json['permission'] as String,
      allowed: json['allowed'] as bool? ?? true,
    );

Map<String, dynamic> _$RolePermissionToJson(_RolePermission instance) =>
    <String, dynamic>{
      'id': instance.id,
      'role': _$AppRoleEnumMap[instance.role]!,
      'permission': instance.permission,
      'allowed': instance.allowed,
    };

const _$AppRoleEnumMap = {
  AppRole.admin: 'admin',
  AppRole.customer: 'customer',
  AppRole.storeManager: 'store_manager',
  AppRole.deliveryBoy: 'delivery_boy',
};

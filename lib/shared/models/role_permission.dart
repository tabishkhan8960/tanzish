import 'package:freezed_annotation/freezed_annotation.dart';

import 'profile.dart';

part 'role_permission.freezed.dart';
part 'role_permission.g.dart';

@freezed
abstract class RolePermission with _$RolePermission {
  const factory RolePermission({
    required String id,
    required AppRole role,
    required String permission,
    @Default(true) bool allowed,
  }) = _RolePermission;

  factory RolePermission.fromJson(Map<String, dynamic> json) => _$RolePermissionFromJson(json);
}

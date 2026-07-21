// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'role_permission.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RolePermission {

 String get id; AppRole get role; String get permission; bool get allowed;
/// Create a copy of RolePermission
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RolePermissionCopyWith<RolePermission> get copyWith => _$RolePermissionCopyWithImpl<RolePermission>(this as RolePermission, _$identity);

  /// Serializes this RolePermission to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RolePermission&&(identical(other.id, id) || other.id == id)&&(identical(other.role, role) || other.role == role)&&(identical(other.permission, permission) || other.permission == permission)&&(identical(other.allowed, allowed) || other.allowed == allowed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,role,permission,allowed);

@override
String toString() {
  return 'RolePermission(id: $id, role: $role, permission: $permission, allowed: $allowed)';
}


}

/// @nodoc
abstract mixin class $RolePermissionCopyWith<$Res>  {
  factory $RolePermissionCopyWith(RolePermission value, $Res Function(RolePermission) _then) = _$RolePermissionCopyWithImpl;
@useResult
$Res call({
 String id, AppRole role, String permission, bool allowed
});




}
/// @nodoc
class _$RolePermissionCopyWithImpl<$Res>
    implements $RolePermissionCopyWith<$Res> {
  _$RolePermissionCopyWithImpl(this._self, this._then);

  final RolePermission _self;
  final $Res Function(RolePermission) _then;

/// Create a copy of RolePermission
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? role = null,Object? permission = null,Object? allowed = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as AppRole,permission: null == permission ? _self.permission : permission // ignore: cast_nullable_to_non_nullable
as String,allowed: null == allowed ? _self.allowed : allowed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [RolePermission].
extension RolePermissionPatterns on RolePermission {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RolePermission value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RolePermission() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RolePermission value)  $default,){
final _that = this;
switch (_that) {
case _RolePermission():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RolePermission value)?  $default,){
final _that = this;
switch (_that) {
case _RolePermission() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  AppRole role,  String permission,  bool allowed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RolePermission() when $default != null:
return $default(_that.id,_that.role,_that.permission,_that.allowed);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  AppRole role,  String permission,  bool allowed)  $default,) {final _that = this;
switch (_that) {
case _RolePermission():
return $default(_that.id,_that.role,_that.permission,_that.allowed);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  AppRole role,  String permission,  bool allowed)?  $default,) {final _that = this;
switch (_that) {
case _RolePermission() when $default != null:
return $default(_that.id,_that.role,_that.permission,_that.allowed);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RolePermission implements RolePermission {
  const _RolePermission({required this.id, required this.role, required this.permission, this.allowed = true});
  factory _RolePermission.fromJson(Map<String, dynamic> json) => _$RolePermissionFromJson(json);

@override final  String id;
@override final  AppRole role;
@override final  String permission;
@override@JsonKey() final  bool allowed;

/// Create a copy of RolePermission
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RolePermissionCopyWith<_RolePermission> get copyWith => __$RolePermissionCopyWithImpl<_RolePermission>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RolePermissionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RolePermission&&(identical(other.id, id) || other.id == id)&&(identical(other.role, role) || other.role == role)&&(identical(other.permission, permission) || other.permission == permission)&&(identical(other.allowed, allowed) || other.allowed == allowed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,role,permission,allowed);

@override
String toString() {
  return 'RolePermission(id: $id, role: $role, permission: $permission, allowed: $allowed)';
}


}

/// @nodoc
abstract mixin class _$RolePermissionCopyWith<$Res> implements $RolePermissionCopyWith<$Res> {
  factory _$RolePermissionCopyWith(_RolePermission value, $Res Function(_RolePermission) _then) = __$RolePermissionCopyWithImpl;
@override @useResult
$Res call({
 String id, AppRole role, String permission, bool allowed
});




}
/// @nodoc
class __$RolePermissionCopyWithImpl<$Res>
    implements _$RolePermissionCopyWith<$Res> {
  __$RolePermissionCopyWithImpl(this._self, this._then);

  final _RolePermission _self;
  final $Res Function(_RolePermission) _then;

/// Create a copy of RolePermission
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? role = null,Object? permission = null,Object? allowed = null,}) {
  return _then(_RolePermission(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as AppRole,permission: null == permission ? _self.permission : permission // ignore: cast_nullable_to_non_nullable
as String,allowed: null == allowed ? _self.allowed : allowed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on

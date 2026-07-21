import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile.freezed.dart';
part 'profile.g.dart';

enum AppRole {
  admin,
  customer,
  @JsonValue('store_manager')
  storeManager,
  @JsonValue('delivery_boy')
  deliveryBoy,
}

@freezed
abstract class Profile with _$Profile {
  const factory Profile({
    required String id,
    @Default(AppRole.customer) AppRole role,
    String? fullName,
    String? phone,
    String? avatarUrl,
  }) = _Profile;

  factory Profile.fromJson(Map<String, dynamic> json) => _$ProfileFromJson(json);
}

/// Postgres enum values use snake_case; Dart identifiers can't, so this maps
/// each role back to the exact string stored in the `app_role` enum.
extension AppRoleDb on AppRole {
  String get dbValue => switch (this) {
        AppRole.admin => 'admin',
        AppRole.customer => 'customer',
        AppRole.storeManager => 'store_manager',
        AppRole.deliveryBoy => 'delivery_boy',
      };

  String get label => switch (this) {
        AppRole.admin => 'Admin',
        AppRole.customer => 'Customer',
        AppRole.storeManager => 'Store Manager',
        AppRole.deliveryBoy => 'Delivery Boy',
      };
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../../shared/models/address.dart';
import '../../../../../shared/models/coupon.dart';
import '../../../../../shared/models/shipping_method.dart';
import '../../../../../shared/repositories/address_repository.dart';
import '../../../../../shared/repositories/settings_repository.dart';
import '../../../../../shared/repositories/shipping_method_repository.dart';
import '../../../../auth/presentation/providers/auth_providers.dart';

final addressesProvider = FutureProvider<List<Address>>((ref) async {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return [];
  return ref.watch(addressRepositoryProvider).fetchAddresses(userId);
});

final selectedAddressIdProvider = StateProvider<String?>((ref) => null);

final appliedCouponProvider = StateProvider<Coupon?>((ref) => null);

final shippingMethodsProvider = FutureProvider<List<ShippingMethod>>((ref) {
  return ref.watch(shippingMethodRepositoryProvider).fetchActive();
});

final selectedShippingMethodIdProvider = StateProvider<String?>((ref) => null);

/// The store's UPI collection ID, shown to shoppers for the manual-UPI
/// payment flow. Configured via the `settings` table (key `upi_id`).
final upiCollectionIdProvider = FutureProvider<String?>((ref) async {
  final settings = await ref.watch(settingsRepositoryProvider).fetchAll();
  return settings['upi_id'] as String?;
});

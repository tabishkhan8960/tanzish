import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../../shared/models/address.dart';
import '../../../../../shared/models/coupon.dart';
import '../../../../../shared/repositories/address_repository.dart';
import '../../../../auth/presentation/providers/auth_providers.dart';

final addressesProvider = FutureProvider<List<Address>>((ref) async {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return [];
  return ref.watch(addressRepositoryProvider).fetchAddresses(userId);
});

final selectedAddressIdProvider = StateProvider<String?>((ref) => null);

final appliedCouponProvider = StateProvider<Coupon?>((ref) => null);

const shippingFee = 30.0;

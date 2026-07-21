import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../../shared/models/order.dart';
import '../../../../../shared/models/profile.dart';
import '../../../../../shared/repositories/customer_repository.dart';

final customersSearchProvider = StateProvider<String>((ref) => '');

final adminCustomersProvider = FutureProvider<List<Profile>>((ref) {
  final search = ref.watch(customersSearchProvider);
  return ref.watch(customerRepositoryProvider).fetchCustomers(search: search);
});

final customerOrdersProvider = FutureProvider.family<List<Order>, String>((ref, userId) {
  return ref.watch(customerRepositoryProvider).fetchCustomerOrders(userId);
});

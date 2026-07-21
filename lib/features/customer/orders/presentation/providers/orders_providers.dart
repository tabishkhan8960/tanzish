import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../shared/models/order.dart';
import '../../../../../shared/repositories/order_repository.dart';
import '../../../../auth/presentation/providers/auth_providers.dart';

final myOrdersProvider = FutureProvider<List<Order>>((ref) async {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return [];
  return ref.watch(orderRepositoryProvider).fetchOrders(userId);
});

final orderDetailProvider = FutureProvider.family<Order, String>((ref, id) {
  return ref.watch(orderRepositoryProvider).fetchOrder(id);
});

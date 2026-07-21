import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../../shared/models/order.dart';
import '../../../../../shared/repositories/order_repository.dart';

final adminOrderStatusFilterProvider = StateProvider<OrderStatus?>((ref) => null);

final adminOrdersProvider = FutureProvider<List<Order>>((ref) {
  final status = ref.watch(adminOrderStatusFilterProvider);
  return ref.watch(orderRepositoryProvider).fetchAllOrders(status: status);
});

final adminOrderDetailProvider = FutureProvider.family<Order, String>((ref, id) {
  return ref.watch(orderRepositoryProvider).fetchOrder(id);
});

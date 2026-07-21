import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../../shared/models/order.dart';
import '../../../../../shared/repositories/order_repository.dart';
import '../../../../../core/config/supabase_config.dart';

final adminOrderStatusFilterProvider = StateProvider<OrderStatus?>((ref) => null);


final adminOrdersProvider = StreamProvider<List<Order>>((ref) async* {
  final status = ref.watch(adminOrderStatusFilterProvider);
  final repo = ref.watch(orderRepositoryProvider);
  
  yield await repo.fetchAllOrders(status: status);
  
  final stream = SupabaseConfig.client.from('orders').stream(primaryKey: ['id']);
  await for (final _ in stream) {
    yield await repo.fetchAllOrders(status: status);
  }
});

final adminOrderDetailProvider = FutureProvider.family<Order, String>((ref, id) {
  return ref.watch(orderRepositoryProvider).fetchOrder(id);
});

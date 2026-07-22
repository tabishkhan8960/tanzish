import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/config/supabase_config.dart';
import '../../core/constants/supabase_tables.dart';
import '../models/order.dart';

const _orderSelect = '*, order_items(*), shipping_address:addresses!shipping_address_id(*), payments(*)';

class OrderRepository {
  OrderRepository(this._client);

  final SupabaseClient _client;

  Future<List<Order>> fetchOrders(String userId) async {
    final rows = await _client
        .from(SupabaseTables.orders)
        .select(_orderSelect)
        .eq('user_id', userId)
        .order('placed_at', ascending: false);
    return rows.map(Order.fromJson).toList();
  }

  Future<List<Order>> fetchAllOrders({OrderStatus? status, int limit = 50}) async {
    var query = _client.from(SupabaseTables.orders).select(_orderSelect);
    if (status != null) query = query.eq('status', status.name);
    final rows = await query.order('placed_at', ascending: false).limit(limit);
    return rows.map(Order.fromJson).toList();
  }

  Future<Order> fetchOrder(String id) async {
    final row = await _client.from(SupabaseTables.orders).select(_orderSelect).eq('id', id).single();
    return Order.fromJson(row);
  }

  /// Creates the order, its line items, and its (pending) payment record
  /// entirely server-side via the `place_order` Postgres function — it
  /// recomputes the total from live prices, validates the coupon and stock,
  /// and does all of it in one transaction, so a failed check (empty cart,
  /// invalid coupon, out of stock) rolls back everything instead of leaving
  /// a half-created order. Never marks a payment "paid" itself; see
  /// [OrderRepository.updateStatus] / admin's payment verification for that.
  Future<Order> placeOrder({
    required String shippingAddressId,
    required String shippingMethodId,
    String? couponCode,
    required String paymentProvider,
    String? paymentTransactionRef,
  }) async {
    final row = await _client.rpc('place_order', params: {
      'p_shipping_address_id': shippingAddressId,
      'p_shipping_method_id': shippingMethodId,
      'p_coupon_code': couponCode,
      'p_payment_provider': paymentProvider,
      'p_payment_transaction_ref': paymentTransactionRef,
    });
    final orderId = (row as Map<String, dynamic>)['id'] as String;
    return fetchOrder(orderId);
  }

  Future<void> updateStatus(String orderId, OrderStatus status) async {
    await _client.from(SupabaseTables.orders).update({'status': status.name}).eq('id', orderId);
  }
}

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  return OrderRepository(SupabaseConfig.client);
});

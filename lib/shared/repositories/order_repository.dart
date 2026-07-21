import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/config/supabase_config.dart';
import '../../core/constants/supabase_tables.dart';
import '../models/cart_item.dart';
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

  /// Creates an order + its line items from the current cart, then clears the
  /// cart. Runs client-side (no DB function) since RLS already scopes every
  /// statement to the authenticated user.
  Future<Order> placeOrder({
    required String userId,
    required List<CartItem> items,
    required String shippingAddressId,
    required num subtotal,
    required num shippingFee,
    required num discount,
    String? couponId,
  }) async {
    final total = subtotal + shippingFee - discount;

    final orderRow = await _client
        .from(SupabaseTables.orders)
        .insert({
          'user_id': userId,
          'shipping_address_id': shippingAddressId,
          'billing_address_id': shippingAddressId,
          'coupon_id': couponId,
          'subtotal': subtotal,
          'shipping_fee': shippingFee,
          'discount': discount,
          'total': total,
        })
        .select()
        .single();

    final orderId = orderRow['id'] as String;

    await _client.from(SupabaseTables.orderItems).insert([
      for (final item in items)
        {
          'order_id': orderId,
          'product_id': item.productId,
          'product_name': item.product?.name ?? 'Product',
          'variant_attributes': item.variantAttributes,
          'unit_price': item.product?.price ?? 0,
          'quantity': item.quantity,
          'subtotal': item.lineTotal,
        },
    ]);

    await _client.from(SupabaseTables.cart).delete().eq('user_id', userId);

    return fetchOrder(orderId);
  }

  Future<void> recordPayment({
    required String orderId,
    required String provider,
    required num amount,
  }) async {
    await _client.from(SupabaseTables.payments).insert({
      'order_id': orderId,
      'provider': provider,
      'amount': amount,
      'status': 'paid',
      'paid_at': DateTime.now().toIso8601String(),
    });
    await _client.from(SupabaseTables.orders).update({'status': 'confirmed'}).eq('id', orderId);
  }

  Future<void> updateStatus(String orderId, OrderStatus status) async {
    await _client.from(SupabaseTables.orders).update({'status': status.name}).eq('id', orderId);
  }
}

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  return OrderRepository(SupabaseConfig.client);
});

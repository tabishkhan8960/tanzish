import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/config/supabase_config.dart';
import '../../core/constants/supabase_tables.dart';
import 'catalog_repository.dart';
import '../models/cart_item.dart';

class CartRepository {
  CartRepository(this._client);

  final SupabaseClient _client;

  Future<List<CartItem>> fetchCart(String userId) async {
    final rows = await _client
        .from(SupabaseTables.cart)
        .select('*, product:products($productSelect)')
        .eq('user_id', userId)
        .order('created_at');
    return rows.map(CartItem.fromJson).toList();
  }

  Future<void> addOrIncrement({
    required String userId,
    required String productId,
    Map<String, dynamic> variantAttributes = const {},
    int quantity = 1,
  }) async {
    final existing = await _client
        .from(SupabaseTables.cart)
        .select('id, quantity')
        .eq('user_id', userId)
        .eq('product_id', productId)
        .eq('variant_attributes', variantAttributes)
        .maybeSingle();

    if (existing == null) {
      await _client.from(SupabaseTables.cart).insert({
        'user_id': userId,
        'product_id': productId,
        'variant_attributes': variantAttributes,
        'quantity': quantity,
      });
    } else {
      await _client
          .from(SupabaseTables.cart)
          .update({'quantity': (existing['quantity'] as int) + quantity})
          .eq('id', existing['id']);
    }
  }

  Future<void> updateQuantity(String cartItemId, int quantity) async {
    if (quantity <= 0) {
      await remove(cartItemId);
      return;
    }
    await _client.from(SupabaseTables.cart).update({'quantity': quantity}).eq('id', cartItemId);
  }

  Future<void> remove(String cartItemId) async {
    await _client.from(SupabaseTables.cart).delete().eq('id', cartItemId);
  }

  Future<void> clear(String userId) async {
    await _client.from(SupabaseTables.cart).delete().eq('user_id', userId);
  }
}

final cartRepositoryProvider = Provider<CartRepository>((ref) {
  return CartRepository(SupabaseConfig.client);
});

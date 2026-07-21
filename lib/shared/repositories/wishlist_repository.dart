import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/config/supabase_config.dart';
import '../../core/constants/supabase_tables.dart';
import 'catalog_repository.dart';
import '../models/wishlist_item.dart';

class WishlistRepository {
  WishlistRepository(this._client);

  final SupabaseClient _client;

  Future<List<WishlistItem>> fetchWishlist(String userId) async {
    final rows = await _client
        .from(SupabaseTables.wishlist)
        .select('*, product:products($productSelect)')
        .eq('user_id', userId)
        .order('created_at', ascending: false);
    return rows.map(WishlistItem.fromJson).toList();
  }

  Future<Set<String>> fetchWishlistedProductIds(String userId) async {
    final rows = await _client.from(SupabaseTables.wishlist).select('product_id').eq('user_id', userId);
    return rows.map((r) => r['product_id'] as String).toSet();
  }

  Future<void> toggle({required String userId, required String productId, required bool isWishlisted}) async {
    if (isWishlisted) {
      await _client.from(SupabaseTables.wishlist).delete().eq('user_id', userId).eq('product_id', productId);
    } else {
      await _client.from(SupabaseTables.wishlist).insert({'user_id': userId, 'product_id': productId});
    }
  }
}

final wishlistRepositoryProvider = Provider<WishlistRepository>((ref) {
  return WishlistRepository(SupabaseConfig.client);
});

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/config/supabase_config.dart';
import '../../../../../shared/models/inventory.dart';

final adminInventoryProvider = FutureProvider.autoDispose<List<Inventory>>((ref) async {
  final res = await SupabaseConfig.client
      .from('inventory')
      .select('*, product:products(name, sku, image_url)')
      .order('updated_at', ascending: false);
  return (res as List).map((e) => Inventory.fromJson(e)).toList();
});

class AdminInventoryActions {
  static Future<void> upsert(String productId, Map<String, dynamic> variantAttributes, int quantity, int lowStockThreshold) async {
    await SupabaseConfig.client.from('inventory').upsert({
      'product_id': productId,
      'variant_attributes': variantAttributes,
      'quantity': quantity,
      'low_stock_threshold': lowStockThreshold,
      'updated_at': DateTime.now().toIso8601String(),
    }, onConflict: 'product_id,variant_attributes');
  }
}

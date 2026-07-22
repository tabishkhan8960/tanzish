import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/config/supabase_config.dart';
import '../../core/constants/supabase_tables.dart';
import '../models/shipping_method.dart';

class ShippingMethodRepository {
  ShippingMethodRepository(this._client);

  final SupabaseClient _client;

  Future<List<ShippingMethod>> fetchActive() async {
    final rows = await _client.from(SupabaseTables.shippingMethods).select().eq('is_active', true).order('sort_order');
    return rows.map(ShippingMethod.fromJson).toList();
  }
}

final shippingMethodRepositoryProvider = Provider<ShippingMethodRepository>((ref) {
  return ShippingMethodRepository(SupabaseConfig.client);
});

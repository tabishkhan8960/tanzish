import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/config/supabase_config.dart';
import '../../core/constants/supabase_tables.dart';
import '../models/order.dart';
import '../models/profile.dart';

class CustomerRepository {
  CustomerRepository(this._client);

  final SupabaseClient _client;

  Future<List<Profile>> fetchCustomers({String? search}) async {
    var query = _client.from(SupabaseTables.profiles).select().eq('role', 'customer');
    if (search != null && search.trim().isNotEmpty) {
      query = query.ilike('full_name', '%${search.trim()}%');
    }
    final rows = await query.order('created_at', ascending: false);
    return rows.map(Profile.fromJson).toList();
  }

  Future<List<Profile>> fetchStaff() async {
    final rows = await _client.from(SupabaseTables.profiles).select().neq('role', 'customer').order('role');
    return rows.map(Profile.fromJson).toList();
  }

  Future<void> setRole(String userId, AppRole role) async {
    await _client.from(SupabaseTables.profiles).update({'role': role.dbValue}).eq('id', userId);
  }

  Future<List<Order>> fetchCustomerOrders(String userId) async {
    final rows = await _client
        .from(SupabaseTables.orders)
        .select('*, order_items(*)')
        .eq('user_id', userId)
        .order('placed_at', ascending: false);
    return rows.map(Order.fromJson).toList();
  }
}

final customerRepositoryProvider = Provider<CustomerRepository>((ref) {
  return CustomerRepository(SupabaseConfig.client);
});

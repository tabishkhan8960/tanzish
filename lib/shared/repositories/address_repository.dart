import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/config/supabase_config.dart';
import '../../core/constants/supabase_tables.dart';
import '../models/address.dart';

class AddressRepository {
  AddressRepository(this._client);

  final SupabaseClient _client;

  Future<List<Address>> fetchAddresses(String userId) async {
    final rows = await _client
        .from(SupabaseTables.addresses)
        .select()
        .eq('user_id', userId)
        .order('is_default', ascending: false);
    return rows.map(Address.fromJson).toList();
  }

  Future<Address> upsert(Map<String, dynamic> data, {String? id}) async {
    final row = id == null
        ? await _client.from(SupabaseTables.addresses).insert(data).select().single()
        : await _client.from(SupabaseTables.addresses).update(data).eq('id', id).select().single();
    return Address.fromJson(row);
  }

  Future<void> delete(String id) async {
    await _client.from(SupabaseTables.addresses).delete().eq('id', id);
  }

  Future<void> setDefault(String userId, String addressId) async {
    await _client.from(SupabaseTables.addresses).update({'is_default': false}).eq('user_id', userId);
    await _client.from(SupabaseTables.addresses).update({'is_default': true}).eq('id', addressId);
  }
}

final addressRepositoryProvider = Provider<AddressRepository>((ref) {
  return AddressRepository(SupabaseConfig.client);
});

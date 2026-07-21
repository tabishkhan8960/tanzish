import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/config/supabase_config.dart';
import '../../core/constants/supabase_tables.dart';
import '../models/coupon.dart';

class CouponRepository {
  CouponRepository(this._client);

  final SupabaseClient _client;

  Future<List<Coupon>> fetchAll() async {
    final rows = await _client.from(SupabaseTables.coupons).select().order('created_at', ascending: false);
    return rows.map(Coupon.fromJson).toList();
  }

  Future<Coupon?> findByCode(String code) async {
    final row = await _client.from(SupabaseTables.coupons).select().eq('code', code.toUpperCase()).maybeSingle();
    return row == null ? null : Coupon.fromJson(row);
  }

  Future<Coupon> upsert(Map<String, dynamic> data, {String? id}) async {
    final row = id == null
        ? await _client.from(SupabaseTables.coupons).insert(data).select().single()
        : await _client.from(SupabaseTables.coupons).update(data).eq('id', id).select().single();
    return Coupon.fromJson(row);
  }

  Future<void> delete(String id) async {
    await _client.from(SupabaseTables.coupons).delete().eq('id', id);
  }

  Future<void> setActive(String id, bool isActive) async {
    await _client.from(SupabaseTables.coupons).update({'is_active': isActive}).eq('id', id);
  }
}

final couponRepositoryProvider = Provider<CouponRepository>((ref) {
  return CouponRepository(SupabaseConfig.client);
});

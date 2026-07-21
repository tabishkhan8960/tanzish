import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/config/supabase_config.dart';
import '../../core/constants/supabase_tables.dart';
import '../models/payment.dart';

class TransactionRepository {
  TransactionRepository(this._client);

  final SupabaseClient _client;

  Future<List<Payment>> fetchAll({PaymentStatus? status, int limit = 100}) async {
    var query = _client.from(SupabaseTables.payments).select();
    if (status != null) query = query.eq('status', status.name);
    final rows = await query.order('created_at', ascending: false).limit(limit);
    return rows.map(Payment.fromJson).toList();
  }
}

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  return TransactionRepository(SupabaseConfig.client);
});

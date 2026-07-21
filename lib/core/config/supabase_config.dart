import 'package:supabase_flutter/supabase_flutter.dart';

import 'env_config.dart';

/// Initializes the Supabase client. Call after [EnvConfig.load].
class SupabaseConfig {
  SupabaseConfig._();

  static Future<void> initialize() {
    return Supabase.initialize(
      url: EnvConfig.supabaseUrl,
      anonKey: EnvConfig.supabaseAnonKey,
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}

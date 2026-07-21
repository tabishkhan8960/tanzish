import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/config/supabase_config.dart';
import '../../../core/constants/supabase_tables.dart';
import '../../../shared/models/profile.dart';

class AuthRepository {
  AuthRepository(this._client);

  final SupabaseClient _client;

  GoTrueClient get _auth => _client.auth;

  Stream<AuthState> get authStateChanges => _auth.onAuthStateChange;

  User? get currentUser => _auth.currentUser;

  Future<AuthResponse> signIn({required String email, required String password}) {
    return _auth.signInWithPassword(email: email, password: password);
  }

  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String fullName,
  }) {
    return _auth.signUp(
      email: email,
      password: password,
      data: {'full_name': fullName},
    );
  }

  Future<void> sendPasswordResetEmail(String email) {
    return _auth.resetPasswordForEmail(email);
  }

  Future<void> signOut() => _auth.signOut();

  Future<Profile> fetchProfile(String userId) async {
    final row = await _client.from(SupabaseTables.profiles).select().eq('id', userId).single();
    return Profile.fromJson(row);
  }

  Future<Profile> updateProfile(String userId, Map<String, dynamic> patch) async {
    final row = await _client
        .from(SupabaseTables.profiles)
        .update(patch)
        .eq('id', userId)
        .select()
        .single();
    return Profile.fromJson(row);
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(SupabaseConfig.client);
});

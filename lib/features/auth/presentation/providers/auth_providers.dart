import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../shared/models/profile.dart';
import '../../data/auth_repository.dart';

/// Emits every auth event (sign in, sign out, token refresh, ...).
final authStateChangesProvider = StreamProvider<AuthState>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});

/// The current Supabase user id, derived from auth state; null when signed out.
final currentUserIdProvider = Provider<String?>((ref) {
  final authState = ref.watch(authStateChangesProvider).value;
  return authState?.session?.user.id ?? ref.watch(authRepositoryProvider).currentUser?.id;
});

/// The signed-in user's `profiles` row.
final currentProfileProvider = FutureProvider<Profile?>((ref) async {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return null;
  return ref.watch(authRepositoryProvider).fetchProfile(userId);
});

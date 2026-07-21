import 'package:flutter/foundation.dart';

/// A plain [ChangeNotifier] GoRouter's `refreshListenable` can point at.
///
/// Deliberately *not* stream-based: an earlier version subscribed directly to
/// the Supabase auth stream here, racing Riverpod's own subscription to the
/// same stream (`authStateChangesProvider`). Both fire off the same
/// broadcast source, but Riverpod's internal listener lands one microtask
/// later — so `redirect`'s `ref.read(authStateChangesProvider)` would still
/// read stale `AsyncLoading` state at the exact moment this notifier fired,
/// and since the underlying auth stream only emits once per actual state
/// change, redirect never got a second chance to notice the provider had
/// caught up. Net effect: the app hung on `/splash` forever. Driving this
/// notifier from `ref.listen(authStateChangesProvider, ...)` instead (see
/// `app_router.dart`) guarantees redirect only re-runs *after* the provider
/// it reads has actually updated.
class GoRouterRefreshNotifier extends ChangeNotifier {
  void notify() => notifyListeners();
}

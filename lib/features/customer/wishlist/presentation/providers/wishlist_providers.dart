import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../shared/models/wishlist_item.dart';
import '../../../../../shared/repositories/wishlist_repository.dart';
import '../../../../auth/presentation/providers/auth_providers.dart';

class WishlistController extends AsyncNotifier<List<WishlistItem>> {
  @override
  Future<List<WishlistItem>> build() async {
    final userId = ref.watch(currentUserIdProvider);
    if (userId == null) return [];
    return ref.watch(wishlistRepositoryProvider).fetchWishlist(userId);
  }

  Future<void> toggle(String productId) async {
    final userId = ref.read(currentUserIdProvider);
    if (userId == null) return;
    final isWishlisted = state.value?.any((w) => w.productId == productId) ?? false;
    await ref.read(wishlistRepositoryProvider).toggle(userId: userId, productId: productId, isWishlisted: isWishlisted);
    ref.invalidateSelf();
    await future;
  }
}

final wishlistControllerProvider = AsyncNotifierProvider<WishlistController, List<WishlistItem>>(WishlistController.new);

final wishlistedProductIdsProvider = Provider<Set<String>>((ref) {
  final items = ref.watch(wishlistControllerProvider).value ?? [];
  return items.map((w) => w.productId).toSet();
});

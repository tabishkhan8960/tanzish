import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../shared/models/cart_item.dart';
import '../../../../../shared/repositories/cart_repository.dart';
import '../../../../auth/presentation/providers/auth_providers.dart';

class CartController extends AsyncNotifier<List<CartItem>> {
  @override
  Future<List<CartItem>> build() async {
    final userId = ref.watch(currentUserIdProvider);
    if (userId == null) return [];
    return ref.watch(cartRepositoryProvider).fetchCart(userId);
  }

  Future<void> add(String productId, {int quantity = 1, Map<String, dynamic> variant = const {}}) async {
    final userId = ref.read(currentUserIdProvider);
    if (userId == null) return;
    await ref.read(cartRepositoryProvider).addOrIncrement(
          userId: userId,
          productId: productId,
          quantity: quantity,
          variantAttributes: variant,
        );
    ref.invalidateSelf();
    await future;
  }

  Future<void> updateQuantity(String cartItemId, int quantity) async {
    await ref.read(cartRepositoryProvider).updateQuantity(cartItemId, quantity);
    ref.invalidateSelf();
    await future;
  }

  Future<void> remove(String cartItemId) async {
    await ref.read(cartRepositoryProvider).remove(cartItemId);
    ref.invalidateSelf();
    await future;
  }

  Future<void> clear() async {
    final userId = ref.read(currentUserIdProvider);
    if (userId == null) return;
    await ref.read(cartRepositoryProvider).clear(userId);
    ref.invalidateSelf();
    await future;
  }
}

final cartControllerProvider = AsyncNotifierProvider<CartController, List<CartItem>>(CartController.new);

final cartItemCountProvider = Provider<int>((ref) {
  return ref.watch(cartControllerProvider).value?.fold<int>(0, (sum, item) => sum + item.quantity) ?? 0;
});

final cartSubtotalProvider = Provider<num>((ref) {
  return ref.watch(cartControllerProvider).value?.fold<num>(0, (sum, item) => sum + item.lineTotal) ?? 0;
});

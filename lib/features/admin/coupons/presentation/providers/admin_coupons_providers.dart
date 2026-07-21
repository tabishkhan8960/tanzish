import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../shared/models/coupon.dart';
import '../../../../../shared/repositories/coupon_repository.dart';

final adminCouponsProvider = FutureProvider<List<Coupon>>((ref) {
  return ref.watch(couponRepositoryProvider).fetchAll();
});

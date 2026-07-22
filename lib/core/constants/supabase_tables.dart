/// Table and bucket names, kept in one place to avoid typo-driven bugs
/// when writing Supabase queries across features.
class SupabaseTables {
  SupabaseTables._();

  static const profiles = 'profiles';
  static const roles = 'roles';
  static const categories = 'categories';
  static const brands = 'brands';
  static const products = 'products';
  static const productImages = 'product_images';
  static const inventory = 'inventory';
  static const addresses = 'addresses';
  static const cart = 'cart';
  static const wishlist = 'wishlist';
  static const orders = 'orders';
  static const orderItems = 'order_items';
  static const payments = 'payments';
  static const coupons = 'coupons';
  static const shippingMethods = 'shipping_methods';
  static const reviews = 'reviews';
  static const notifications = 'notifications';
  static const settings = 'settings';
}

class SupabaseBuckets {
  SupabaseBuckets._();

  static const productImages = 'product-images';
  static const categoryImages = 'category-images';
  static const brandLogos = 'brand-logos';
  static const banners = 'banners';
  static const avatars = 'avatars';
  static const reviewImages = 'review-images';
  static const invoices = 'invoices';
}

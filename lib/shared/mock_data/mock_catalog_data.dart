import '../models/brand.dart';
import '../models/category.dart';
import '../models/product.dart';
import '../models/product_image.dart';

/// Static in-memory catalog used by [MockCatalogRepository] — see that
/// file's doc comment, and `core/config/data_mode.dart`, for how this gets
/// swapped out for live Supabase data later.
///
/// Image URLs are real (Unsplash-hosted) photos picked per category so the
/// UI looks like a real catalog rather than grey placeholder boxes; each
/// entry was checked to actually resolve before being used here.

const _beautyImages = [
  'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?w=800&q=80&auto=format&fit=crop',
  'https://images.unsplash.com/photo-1596462502278-27bfdc403348?w=800&q=80&auto=format&fit=crop',
  'https://images.unsplash.com/photo-1571781926291-c477ebfd024b?w=800&q=80&auto=format&fit=crop',
  'https://images.unsplash.com/photo-1512496015851-a90fb38ba796?w=800&q=80&auto=format&fit=crop',
  'https://images.unsplash.com/photo-1585386959984-a4155224a1ad?w=800&q=80&auto=format&fit=crop',
  'https://images.unsplash.com/photo-1560750588-73207b1ef5b8?w=800&q=80&auto=format&fit=crop',
];

const _fashionImages = [
  'https://images.unsplash.com/photo-1445205170230-053b83016050?w=800&q=80&auto=format&fit=crop',
  'https://images.unsplash.com/photo-1483985988355-763728e1935b?w=800&q=80&auto=format&fit=crop',
  'https://images.unsplash.com/photo-1490114538077-0a7f8cb49891?w=800&q=80&auto=format&fit=crop',
  'https://images.unsplash.com/photo-1479064555552-3ef4979f8908?w=800&q=80&auto=format&fit=crop',
];

const _kidsImages = [
  'https://images.unsplash.com/photo-1503919545889-aef636e10ad4?w=800&q=80&auto=format&fit=crop',
  'https://images.unsplash.com/photo-1519238263530-99bdd11df2ea?w=800&q=80&auto=format&fit=crop',
  'https://images.unsplash.com/photo-1522771930-78848d9293e8?w=800&q=80&auto=format&fit=crop',
  'https://images.unsplash.com/photo-1471286174890-9c112ffca5b4?w=800&q=80&auto=format&fit=crop',
  'https://images.unsplash.com/photo-1622290291468-a28f7a7dc6a8?w=800&q=80&auto=format&fit=crop',
];

const _menImages = [
  'https://images.unsplash.com/photo-1516257984-b1b4d707412e?w=800&q=80&auto=format&fit=crop',
  'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=800&q=80&auto=format&fit=crop',
  'https://images.unsplash.com/photo-1602810318383-e386cc2a3ccf?w=800&q=80&auto=format&fit=crop',
  'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=800&q=80&auto=format&fit=crop',
  'https://images.unsplash.com/photo-1594633312681-425c7b97ccd1?w=800&q=80&auto=format&fit=crop',
];

const _womenImages = [
  'https://images.unsplash.com/photo-1490481651871-ab68de25d43d?w=800&q=80&auto=format&fit=crop',
  'https://images.unsplash.com/photo-1529139574466-a303027c1d8b?w=800&q=80&auto=format&fit=crop',
  'https://images.unsplash.com/photo-1515372039744-b8f02a3ae446?w=800&q=80&auto=format&fit=crop',
  'https://images.unsplash.com/photo-1496747611176-843222e1e57c?w=800&q=80&auto=format&fit=crop',
  'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=800&q=80&auto=format&fit=crop',
];

/// Builds a product's image list from a pool, cycling with [offset] so
/// different products in the same category get a different primary photo
/// while still sharing the pool (this is dummy data — some reuse is fine).
List<ProductImage> _images(String productId, List<String> pool, int offset, int count) {
  return [
    for (var i = 0; i < count; i++)
      ProductImage(
        id: '$productId-img-$i',
        productId: productId,
        imageUrl: pool[(offset + i) % pool.length],
        sortOrder: i,
        isPrimary: i == 0,
      ),
  ];
}

final mockCategories = <Category>[
  Category(id: 'cat-beauty', name: 'Beauty', slug: 'beauty', imageUrl: _beautyImages[0], sortOrder: 0),
  Category(id: 'cat-fashion', name: 'Fashion', slug: 'fashion', imageUrl: _fashionImages[0], sortOrder: 1),
  Category(id: 'cat-kids', name: 'Kids', slug: 'kids', imageUrl: _kidsImages[0], sortOrder: 2),
  Category(id: 'cat-men', name: "Men's", slug: 'mens', imageUrl: _menImages[0], sortOrder: 3),
  Category(id: 'cat-women', name: "Women's", slug: 'womens', imageUrl: _womenImages[0], sortOrder: 4),
];

final mockBrands = <Brand>[
  const Brand(id: 'brand-chanel', name: 'Chanel', slug: 'chanel'),
  const Brand(id: 'brand-loreal', name: "L'Oréal Paris", slug: 'loreal-paris'),
  const Brand(id: 'brand-zara', name: 'Zara', slug: 'zara'),
  const Brand(id: 'brand-hm', name: 'H&M', slug: 'hm'),
  const Brand(id: 'brand-oshkosh', name: "OshKosh B'gosh", slug: 'oshkosh-bgosh'),
  const Brand(id: 'brand-carters', name: "Carter's", slug: 'carters'),
  const Brand(id: 'brand-nike', name: 'Nike', slug: 'nike'),
  const Brand(id: 'brand-hrx', name: 'HRX', slug: 'hrx'),
  const Brand(id: 'brand-veromoda', name: 'Vero Moda', slug: 'vero-moda'),
  const Brand(id: 'brand-forever21', name: 'Forever 21', slug: 'forever-21'),
];

final mockProducts = <Product>[
  // ---- Beauty ----
  Product(
    id: 'prod-beauty-1',
    name: 'Coco Noir Eau de Parfum',
    slug: 'coco-noir-eau-de-parfum',
    description:
        'A warm, sensual fragrance built around Grasse jasmine and Bulgarian rose, finished with a smoky vetiver base. '
        'The elegant black glass bottle refills, so you can keep the same bottle for years. 100ml spray.',
    brandId: 'brand-chanel',
    categoryId: 'cat-beauty',
    sku: 'BEA-CHN-001',
    price: 128.00,
    compareAtPrice: 160.00,
    ratingAvg: 4.7,
    ratingCount: 5689,
    isFeatured: true,
    images: _images('prod-beauty-1', _beautyImages, 4, 3),
  ),
  Product(
    id: 'prod-beauty-2',
    name: 'Revitalift Anti-Aging Serum',
    slug: 'revitalift-anti-aging-serum',
    description:
        'A lightweight daily serum with 1.5% pure hyaluronic acid that plumps fine lines within one week of use. '
        'Fragrance-free, dermatologist-tested, and suitable for all skin types. 30ml pump bottle.',
    brandId: 'brand-loreal',
    categoryId: 'cat-beauty',
    sku: 'BEA-LOR-002',
    price: 24.99,
    compareAtPrice: 32.99,
    ratingAvg: 4.4,
    ratingCount: 12890,
    images: _images('prod-beauty-2', _beautyImages, 1, 3),
  ),
  Product(
    id: 'prod-beauty-3',
    name: 'Matte Velvet Lipstick Set',
    slug: 'matte-velvet-lipstick-set',
    description:
        'A set of 3 full-size matte lipsticks in universally flattering shades — nude, rose, and classic red. '
        'Long-wearing, transfer-resistant formula that stays comfortable for up to 8 hours.',
    brandId: 'brand-loreal',
    categoryId: 'cat-beauty',
    sku: 'BEA-LOR-003',
    price: 18.50,
    ratingAvg: 4.2,
    ratingCount: 3021,
    images: _images('prod-beauty-3', _beautyImages, 5, 2),
  ),
  Product(
    id: 'prod-beauty-4',
    name: 'Hydrating Facial Moisturizer',
    slug: 'hydrating-facial-moisturizer',
    description:
        'A rich 24-hour moisturizer with ceramides and glycerin that restores the skin barrier without feeling greasy. '
        'Non-comedogenic and safe for sensitive skin. 50ml jar.',
    brandId: 'brand-loreal',
    categoryId: 'cat-beauty',
    sku: 'BEA-LOR-004',
    price: 21.00,
    compareAtPrice: 26.00,
    ratingAvg: 4.5,
    ratingCount: 8760,
    images: _images('prod-beauty-4', _beautyImages, 2, 3),
  ),
  Product(
    id: 'prod-beauty-5',
    name: 'Luxury Rose Perfume Gift Set',
    slug: 'luxury-rose-perfume-gift-set',
    description:
        'A gift-ready set pairing a 50ml rose eau de parfum with a matching travel-size rollerball, presented in a '
        'satin-lined box. A best-seller during the holiday season.',
    brandId: 'brand-chanel',
    categoryId: 'cat-beauty',
    sku: 'BEA-CHN-005',
    price: 89.99,
    ratingAvg: 4.6,
    ratingCount: 2140,
    isFeatured: true,
    images: _images('prod-beauty-5', _beautyImages, 3, 3),
  ),

  // ---- Fashion ----
  Product(
    id: 'prod-fashion-1',
    name: 'Classic Denim Jacket',
    slug: 'classic-denim-jacket',
    description:
        'A mid-wash denim jacket cut for a relaxed fit, with button cuffs and chest flap pockets. A wardrobe staple '
        'that layers over almost anything, from a t-shirt to a dress.',
    brandId: 'brand-zara',
    categoryId: 'cat-fashion',
    sku: 'FSH-ZAR-001',
    price: 64.99,
    compareAtPrice: 89.99,
    ratingAvg: 4.3,
    ratingCount: 4410,
    isFeatured: true,
    attributes: {
      'sizes': ['XS', 'S', 'M', 'L', 'XL'],
      'colors': ['Blue', 'Black'],
    },
    images: _images('prod-fashion-1', _fashionImages, 0, 3),
  ),
  Product(
    id: 'prod-fashion-2',
    name: 'Oversized Knit Sweater',
    slug: 'oversized-knit-sweater',
    description:
        'A soft, chunky-knit sweater with dropped shoulders and ribbed cuffs. Breathable cotton-wool blend, machine '
        'washable, and roomy enough to layer over a shirt.',
    brandId: 'brand-hm',
    categoryId: 'cat-fashion',
    sku: 'FSH-HM-002',
    price: 39.99,
    ratingAvg: 4.1,
    ratingCount: 1875,
    attributes: {
      'sizes': ['S', 'M', 'L'],
      'colors': ['Cream', 'Grey', 'Green'],
    },
    images: _images('prod-fashion-2', _fashionImages, 1, 2),
  ),
  Product(
    id: 'prod-fashion-3',
    name: 'Leather Crossbody Bag',
    slug: 'leather-crossbody-bag',
    description:
        'A compact crossbody in genuine leather with an adjustable strap and three interior compartments. Roomy '
        'enough for a phone, cards, and keys without the bulk.',
    brandId: 'brand-zara',
    categoryId: 'cat-fashion',
    sku: 'FSH-ZAR-003',
    price: 74.50,
    compareAtPrice: 99.00,
    ratingAvg: 4.6,
    ratingCount: 3302,
    attributes: {
      'colors': ['Tan', 'Black'],
    },
    images: _images('prod-fashion-3', _fashionImages, 2, 3),
  ),
  Product(
    id: 'prod-fashion-4',
    name: 'Classic Aviator Sunglasses',
    slug: 'classic-aviator-sunglasses',
    description:
        'Timeless aviator-shaped sunglasses with UV400-rated polarized lenses and a lightweight metal frame. '
        'Comes with a hard case and microfiber cleaning cloth.',
    brandId: 'brand-hm',
    categoryId: 'cat-fashion',
    sku: 'FSH-HM-004',
    price: 22.00,
    ratingAvg: 4.0,
    ratingCount: 986,
    images: _images('prod-fashion-4', _fashionImages, 3, 2),
  ),
  Product(
    id: 'prod-fashion-5',
    name: 'Canvas Tote Bag',
    slug: 'canvas-tote-bag',
    description:
        'A heavy-duty canvas tote with reinforced stitching and a flat base that stands on its own. Big enough for '
        'a laptop, a change of clothes, or a grocery run.',
    brandId: 'brand-zara',
    categoryId: 'cat-fashion',
    sku: 'FSH-ZAR-005',
    price: 29.99,
    ratingAvg: 4.4,
    ratingCount: 2205,
    isFeatured: true,
    images: _images('prod-fashion-5', _fashionImages, 0, 3),
  ),

  // ---- Kids ----
  Product(
    id: 'prod-kids-1',
    name: 'Teddy Bear Fleece Romper',
    slug: 'teddy-bear-fleece-romper',
    description:
        'An ultra-soft fleece romper with bear ears on the hood and a full-length zip for quick changes. Machine '
        'washable and safe for sensitive baby skin.',
    brandId: 'brand-carters',
    categoryId: 'cat-kids',
    sku: 'KID-CAR-001',
    price: 27.99,
    compareAtPrice: 34.99,
    ratingAvg: 4.8,
    ratingCount: 6890,
    isFeatured: true,
    attributes: {
      'sizes': ['0-3M', '3-6M', '6-12M'],
    },
    images: _images('prod-kids-1', _kidsImages, 0, 3),
  ),
  Product(
    id: 'prod-kids-2',
    name: "Boys' Cardigan & Shorts Set",
    slug: 'boys-cardigan-and-shorts-set',
    description:
        'A smart two-piece set — a button-front cardigan over a collared shirt, paired with matching shorts. '
        'Perfect for parties, photos, or any occasion that calls for a little extra polish.',
    brandId: 'brand-oshkosh',
    categoryId: 'cat-kids',
    sku: 'KID-OSH-002',
    price: 32.50,
    ratingAvg: 4.5,
    ratingCount: 1523,
    attributes: {
      'sizes': ['2T', '3T', '4T', '5T'],
    },
    images: _images('prod-kids-2', _kidsImages, 1, 2),
  ),
  Product(
    id: 'prod-kids-3',
    name: "Girls' Floral Summer Dress",
    slug: 'girls-floral-summer-dress',
    description:
        'A breathable cotton dress with an all-over floral print and a twirl-friendly skirt. Machine washable and '
        'colorfast after repeated washes.',
    brandId: 'brand-oshkosh',
    categoryId: 'cat-kids',
    sku: 'KID-OSH-003',
    price: 26.00,
    compareAtPrice: 32.00,
    ratingAvg: 4.6,
    ratingCount: 2870,
    attributes: {
      'sizes': ['2T', '3T', '4T', '5T', '6T'],
    },
    images: _images('prod-kids-3', _kidsImages, 2, 3),
  ),
  Product(
    id: 'prod-kids-4',
    name: 'Kids Denim Overalls',
    slug: 'kids-denim-overalls',
    description:
        'Durable stonewash denim overalls with adjustable straps and roomy front pockets — built for a full day of '
        'play and easy to layer over any shirt.',
    brandId: 'brand-carters',
    categoryId: 'cat-kids',
    sku: 'KID-CAR-004',
    price: 29.99,
    ratingAvg: 4.3,
    ratingCount: 990,
    attributes: {
      'sizes': ['2T', '3T', '4T', '5T'],
    },
    images: _images('prod-kids-4', _kidsImages, 3, 2),
  ),
  Product(
    id: 'prod-kids-5',
    name: 'Toddler Graphic T-Shirt Pack',
    slug: 'toddler-graphic-tshirt-pack',
    description:
        'A pack of 3 soft cotton tees in playful graphic prints. Reinforced neckline seams hold up to daily '
        'wear and machine washing.',
    brandId: 'brand-carters',
    categoryId: 'cat-kids',
    sku: 'KID-CAR-005',
    price: 18.99,
    ratingAvg: 4.4,
    ratingCount: 1345,
    isFeatured: true,
    attributes: {
      'sizes': ['2T', '3T', '4T', '5T', '6T'],
    },
    images: _images('prod-kids-5', _kidsImages, 4, 2),
  ),

  // ---- Men's ----
  Product(
    id: 'prod-men-1',
    name: 'HRX Chicago Colorway Sneakers',
    slug: 'hrx-chicago-colorway-sneakers',
    description:
        'Perhaps the most iconic sneaker silhouette of all time, reissued in the legendary "Chicago" colorway. '
        'Full-grain leather upper, cushioned midsole, and a rubber outsole built to last.',
    brandId: 'brand-hrx',
    categoryId: 'cat-men',
    sku: 'MEN-HRX-001',
    price: 74.99,
    compareAtPrice: 149.99,
    ratingAvg: 4.1,
    ratingCount: 56890,
    isFeatured: true,
    attributes: {
      'sizes': ['6UK', '7UK', '8UK', '9UK', '10UK'],
    },
    images: _images('prod-men-1', _menImages, 2, 3),
  ),
  Product(
    id: 'prod-men-2',
    name: 'Air Zoom Running Shoes',
    slug: 'air-zoom-running-shoes',
    description:
        'Engineered mesh upper for breathability, with a responsive foam midsole tuned for daily training miles. '
        'Reflective details for low-light visibility.',
    brandId: 'brand-nike',
    categoryId: 'cat-men',
    sku: 'MEN-NKE-002',
    price: 89.99,
    compareAtPrice: 119.99,
    ratingAvg: 4.5,
    ratingCount: 24678,
    isFeatured: true,
    attributes: {
      'sizes': ['7UK', '8UK', '9UK', '10UK', '11UK'],
    },
    images: _images('prod-men-2', _menImages, 0, 3),
  ),
  Product(
    id: 'prod-men-3',
    name: "Men's Slim Fit Chino Pants",
    slug: 'mens-slim-fit-chino-pants',
    description:
        'A tailored slim fit in stretch cotton twill that moves with you. Sits at the natural waist with a clean, '
        'no-fade finish wash after wash.',
    brandId: 'brand-hrx',
    categoryId: 'cat-men',
    sku: 'MEN-HRX-003',
    price: 34.99,
    ratingAvg: 4.2,
    ratingCount: 3140,
    attributes: {
      'sizes': ['30', '32', '34', '36', '38'],
      'colors': ['Khaki', 'Navy', 'Black'],
    },
    images: _images('prod-men-3', _menImages, 3, 2),
  ),
  Product(
    id: 'prod-men-4',
    name: "Men's Bomber Jacket",
    slug: 'mens-bomber-jacket',
    description:
        'A classic bomber silhouette in a water-resistant shell with a soft quilted lining. Ribbed collar, cuffs, '
        'and hem for a snug, insulated fit.',
    brandId: 'brand-nike',
    categoryId: 'cat-men',
    sku: 'MEN-NKE-004',
    price: 79.99,
    ratingAvg: 4.3,
    ratingCount: 1890,
    attributes: {
      'sizes': ['S', 'M', 'L', 'XL'],
    },
    images: _images('prod-men-4', _menImages, 1, 3),
  ),
  Product(
    id: 'prod-men-5',
    name: 'Starry Sky Printed Shirt',
    slug: 'starry-sky-printed-shirt',
    description:
        '100% cotton fabric with an all-over star print, cut for a relaxed, breathable fit. Button-down front and '
        'a single chest pocket.',
    brandId: 'brand-hrx',
    categoryId: 'cat-men',
    sku: 'MEN-HRX-005',
    price: 24.99,
    compareAtPrice: 31.99,
    ratingAvg: 4.4,
    ratingCount: 152344,
    attributes: {
      'sizes': ['S', 'M', 'L', 'XL'],
    },
    images: _images('prod-men-5', _menImages, 4, 2),
  ),

  // ---- Women's ----
  Product(
    id: 'prod-women-1',
    name: 'Printed Wrap Kurta',
    slug: 'printed-wrap-kurta',
    description:
        'A relaxed-fit kurta in a soft printed viscose blend, with a wrap-style neckline and three-quarter sleeves. '
        'Pairs equally well with leggings or straight-leg pants.',
    brandId: 'brand-veromoda',
    categoryId: 'cat-women',
    sku: 'WMN-VRM-001',
    price: 45.00,
    compareAtPrice: 75.00,
    ratingAvg: 4.2,
    ratingCount: 56890,
    isFeatured: true,
    attributes: {
      'sizes': ['XS', 'S', 'M', 'L', 'XL'],
    },
    images: _images('prod-women-1', _womenImages, 0, 3),
  ),
  Product(
    id: 'prod-women-2',
    name: 'Floral Tiered Maxi Dress',
    slug: 'floral-tiered-maxi-dress',
    description:
        'A flowing tiered maxi in a rust-and-black floral print, with a flattering elastic waist and adjustable '
        'straps. Fully lined for opacity.',
    brandId: 'brand-forever21',
    categoryId: 'cat-women',
    sku: 'WMN-F21-002',
    price: 59.90,
    ratingAvg: 4.1,
    ratingCount: 335566,
    attributes: {
      'sizes': ['XS', 'S', 'M', 'L'],
    },
    images: _images('prod-women-2', _womenImages, 1, 3),
  ),
  Product(
    id: 'prod-women-3',
    name: 'Black Bodycon Mini Dress',
    slug: 'black-bodycon-mini-dress',
    description:
        'A figure-hugging bodycon in a smooth stretch knit, with a chain-detail shoulder strap and a versatile '
        'silhouette that works for both day and night.',
    brandId: 'brand-forever21',
    categoryId: 'cat-women',
    sku: 'WMN-F21-003',
    price: 39.99,
    compareAtPrice: 59.99,
    ratingAvg: 4.3,
    ratingCount: 523456,
    isFeatured: true,
    attributes: {
      'sizes': ['XS', 'S', 'M', 'L'],
      'colors': ['Black'],
    },
    images: _images('prod-women-3', _womenImages, 2, 3),
  ),
  Product(
    id: 'prod-women-4',
    name: 'Denim Shirt Dress',
    slug: 'denim-shirt-dress',
    description:
        'A button-through shirt dress in soft-washed denim, cinched with a tie belt at the waist. Roomy chest '
        'pockets and a relaxed, all-day silhouette.',
    brandId: 'brand-veromoda',
    categoryId: 'cat-women',
    sku: 'WMN-VRM-004',
    price: 44.99,
    ratingAvg: 4.4,
    ratingCount: 27344,
    attributes: {
      'sizes': ['XS', 'S', 'M', 'L', 'XL'],
    },
    images: _images('prod-women-4', _womenImages, 3, 2),
  ),
  Product(
    id: 'prod-women-5',
    name: 'Pink Embroidered Tiered Maxi',
    slug: 'pink-embroidered-tiered-maxi',
    description:
        'A rose-pink maxi with delicate embroidered detailing along a tiered skirt. Lightweight and breathable, '
        'with a relaxed fit that flatters every body type.',
    brandId: 'brand-veromoda',
    categoryId: 'cat-women',
    sku: 'WMN-VRM-005',
    price: 52.00,
    compareAtPrice: 68.00,
    ratingAvg: 4.5,
    ratingCount: 45678,
    attributes: {
      'sizes': ['XS', 'S', 'M', 'L'],
    },
    images: _images('prod-women-5', _womenImages, 4, 2),
  ),
];

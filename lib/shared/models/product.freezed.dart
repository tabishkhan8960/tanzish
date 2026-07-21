// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Product {

 String get id; String get name; String get slug; String? get description; String? get brandId; String? get categoryId; String? get sku; num get price; num? get compareAtPrice; num? get costPrice; String? get barcode; num? get weightGrams; Map<String, dynamic> get attributes; num get ratingAvg; int get ratingCount; bool get isActive; bool get isFeatured; Brand? get brand; Category? get category;@JsonKey(name: 'product_images') List<ProductImage> get images;
/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductCopyWith<Product> get copyWith => _$ProductCopyWithImpl<Product>(this as Product, _$identity);

  /// Serializes this Product to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Product&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.description, description) || other.description == description)&&(identical(other.brandId, brandId) || other.brandId == brandId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.sku, sku) || other.sku == sku)&&(identical(other.price, price) || other.price == price)&&(identical(other.compareAtPrice, compareAtPrice) || other.compareAtPrice == compareAtPrice)&&(identical(other.costPrice, costPrice) || other.costPrice == costPrice)&&(identical(other.barcode, barcode) || other.barcode == barcode)&&(identical(other.weightGrams, weightGrams) || other.weightGrams == weightGrams)&&const DeepCollectionEquality().equals(other.attributes, attributes)&&(identical(other.ratingAvg, ratingAvg) || other.ratingAvg == ratingAvg)&&(identical(other.ratingCount, ratingCount) || other.ratingCount == ratingCount)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.isFeatured, isFeatured) || other.isFeatured == isFeatured)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.category, category) || other.category == category)&&const DeepCollectionEquality().equals(other.images, images));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,name,slug,description,brandId,categoryId,sku,price,compareAtPrice,costPrice,barcode,weightGrams,const DeepCollectionEquality().hash(attributes),ratingAvg,ratingCount,isActive,isFeatured,brand,category,const DeepCollectionEquality().hash(images)]);

@override
String toString() {
  return 'Product(id: $id, name: $name, slug: $slug, description: $description, brandId: $brandId, categoryId: $categoryId, sku: $sku, price: $price, compareAtPrice: $compareAtPrice, costPrice: $costPrice, barcode: $barcode, weightGrams: $weightGrams, attributes: $attributes, ratingAvg: $ratingAvg, ratingCount: $ratingCount, isActive: $isActive, isFeatured: $isFeatured, brand: $brand, category: $category, images: $images)';
}


}

/// @nodoc
abstract mixin class $ProductCopyWith<$Res>  {
  factory $ProductCopyWith(Product value, $Res Function(Product) _then) = _$ProductCopyWithImpl;
@useResult
$Res call({
 String id, String name, String slug, String? description, String? brandId, String? categoryId, String? sku, num price, num? compareAtPrice, num? costPrice, String? barcode, num? weightGrams, Map<String, dynamic> attributes, num ratingAvg, int ratingCount, bool isActive, bool isFeatured, Brand? brand, Category? category,@JsonKey(name: 'product_images') List<ProductImage> images
});


$BrandCopyWith<$Res>? get brand;$CategoryCopyWith<$Res>? get category;

}
/// @nodoc
class _$ProductCopyWithImpl<$Res>
    implements $ProductCopyWith<$Res> {
  _$ProductCopyWithImpl(this._self, this._then);

  final Product _self;
  final $Res Function(Product) _then;

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? slug = null,Object? description = freezed,Object? brandId = freezed,Object? categoryId = freezed,Object? sku = freezed,Object? price = null,Object? compareAtPrice = freezed,Object? costPrice = freezed,Object? barcode = freezed,Object? weightGrams = freezed,Object? attributes = null,Object? ratingAvg = null,Object? ratingCount = null,Object? isActive = null,Object? isFeatured = null,Object? brand = freezed,Object? category = freezed,Object? images = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,brandId: freezed == brandId ? _self.brandId : brandId // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,sku: freezed == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String?,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as num,compareAtPrice: freezed == compareAtPrice ? _self.compareAtPrice : compareAtPrice // ignore: cast_nullable_to_non_nullable
as num?,costPrice: freezed == costPrice ? _self.costPrice : costPrice // ignore: cast_nullable_to_non_nullable
as num?,barcode: freezed == barcode ? _self.barcode : barcode // ignore: cast_nullable_to_non_nullable
as String?,weightGrams: freezed == weightGrams ? _self.weightGrams : weightGrams // ignore: cast_nullable_to_non_nullable
as num?,attributes: null == attributes ? _self.attributes : attributes // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,ratingAvg: null == ratingAvg ? _self.ratingAvg : ratingAvg // ignore: cast_nullable_to_non_nullable
as num,ratingCount: null == ratingCount ? _self.ratingCount : ratingCount // ignore: cast_nullable_to_non_nullable
as int,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,isFeatured: null == isFeatured ? _self.isFeatured : isFeatured // ignore: cast_nullable_to_non_nullable
as bool,brand: freezed == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as Brand?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as Category?,images: null == images ? _self.images : images // ignore: cast_nullable_to_non_nullable
as List<ProductImage>,
  ));
}
/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BrandCopyWith<$Res>? get brand {
    if (_self.brand == null) {
    return null;
  }

  return $BrandCopyWith<$Res>(_self.brand!, (value) {
    return _then(_self.copyWith(brand: value));
  });
}/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CategoryCopyWith<$Res>? get category {
    if (_self.category == null) {
    return null;
  }

  return $CategoryCopyWith<$Res>(_self.category!, (value) {
    return _then(_self.copyWith(category: value));
  });
}
}


/// Adds pattern-matching-related methods to [Product].
extension ProductPatterns on Product {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Product value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Product() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Product value)  $default,){
final _that = this;
switch (_that) {
case _Product():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Product value)?  $default,){
final _that = this;
switch (_that) {
case _Product() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String slug,  String? description,  String? brandId,  String? categoryId,  String? sku,  num price,  num? compareAtPrice,  num? costPrice,  String? barcode,  num? weightGrams,  Map<String, dynamic> attributes,  num ratingAvg,  int ratingCount,  bool isActive,  bool isFeatured,  Brand? brand,  Category? category, @JsonKey(name: 'product_images')  List<ProductImage> images)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Product() when $default != null:
return $default(_that.id,_that.name,_that.slug,_that.description,_that.brandId,_that.categoryId,_that.sku,_that.price,_that.compareAtPrice,_that.costPrice,_that.barcode,_that.weightGrams,_that.attributes,_that.ratingAvg,_that.ratingCount,_that.isActive,_that.isFeatured,_that.brand,_that.category,_that.images);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String slug,  String? description,  String? brandId,  String? categoryId,  String? sku,  num price,  num? compareAtPrice,  num? costPrice,  String? barcode,  num? weightGrams,  Map<String, dynamic> attributes,  num ratingAvg,  int ratingCount,  bool isActive,  bool isFeatured,  Brand? brand,  Category? category, @JsonKey(name: 'product_images')  List<ProductImage> images)  $default,) {final _that = this;
switch (_that) {
case _Product():
return $default(_that.id,_that.name,_that.slug,_that.description,_that.brandId,_that.categoryId,_that.sku,_that.price,_that.compareAtPrice,_that.costPrice,_that.barcode,_that.weightGrams,_that.attributes,_that.ratingAvg,_that.ratingCount,_that.isActive,_that.isFeatured,_that.brand,_that.category,_that.images);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String slug,  String? description,  String? brandId,  String? categoryId,  String? sku,  num price,  num? compareAtPrice,  num? costPrice,  String? barcode,  num? weightGrams,  Map<String, dynamic> attributes,  num ratingAvg,  int ratingCount,  bool isActive,  bool isFeatured,  Brand? brand,  Category? category, @JsonKey(name: 'product_images')  List<ProductImage> images)?  $default,) {final _that = this;
switch (_that) {
case _Product() when $default != null:
return $default(_that.id,_that.name,_that.slug,_that.description,_that.brandId,_that.categoryId,_that.sku,_that.price,_that.compareAtPrice,_that.costPrice,_that.barcode,_that.weightGrams,_that.attributes,_that.ratingAvg,_that.ratingCount,_that.isActive,_that.isFeatured,_that.brand,_that.category,_that.images);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Product extends Product {
  const _Product({required this.id, required this.name, required this.slug, this.description, this.brandId, this.categoryId, this.sku, required this.price, this.compareAtPrice, this.costPrice, this.barcode, this.weightGrams, final  Map<String, dynamic> attributes = const {}, this.ratingAvg = 0, this.ratingCount = 0, this.isActive = true, this.isFeatured = false, this.brand, this.category, @JsonKey(name: 'product_images') final  List<ProductImage> images = const []}): _attributes = attributes,_images = images,super._();
  factory _Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);

@override final  String id;
@override final  String name;
@override final  String slug;
@override final  String? description;
@override final  String? brandId;
@override final  String? categoryId;
@override final  String? sku;
@override final  num price;
@override final  num? compareAtPrice;
@override final  num? costPrice;
@override final  String? barcode;
@override final  num? weightGrams;
 final  Map<String, dynamic> _attributes;
@override@JsonKey() Map<String, dynamic> get attributes {
  if (_attributes is EqualUnmodifiableMapView) return _attributes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_attributes);
}

@override@JsonKey() final  num ratingAvg;
@override@JsonKey() final  int ratingCount;
@override@JsonKey() final  bool isActive;
@override@JsonKey() final  bool isFeatured;
@override final  Brand? brand;
@override final  Category? category;
 final  List<ProductImage> _images;
@override@JsonKey(name: 'product_images') List<ProductImage> get images {
  if (_images is EqualUnmodifiableListView) return _images;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_images);
}


/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductCopyWith<_Product> get copyWith => __$ProductCopyWithImpl<_Product>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Product&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.description, description) || other.description == description)&&(identical(other.brandId, brandId) || other.brandId == brandId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.sku, sku) || other.sku == sku)&&(identical(other.price, price) || other.price == price)&&(identical(other.compareAtPrice, compareAtPrice) || other.compareAtPrice == compareAtPrice)&&(identical(other.costPrice, costPrice) || other.costPrice == costPrice)&&(identical(other.barcode, barcode) || other.barcode == barcode)&&(identical(other.weightGrams, weightGrams) || other.weightGrams == weightGrams)&&const DeepCollectionEquality().equals(other._attributes, _attributes)&&(identical(other.ratingAvg, ratingAvg) || other.ratingAvg == ratingAvg)&&(identical(other.ratingCount, ratingCount) || other.ratingCount == ratingCount)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.isFeatured, isFeatured) || other.isFeatured == isFeatured)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.category, category) || other.category == category)&&const DeepCollectionEquality().equals(other._images, _images));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,name,slug,description,brandId,categoryId,sku,price,compareAtPrice,costPrice,barcode,weightGrams,const DeepCollectionEquality().hash(_attributes),ratingAvg,ratingCount,isActive,isFeatured,brand,category,const DeepCollectionEquality().hash(_images)]);

@override
String toString() {
  return 'Product(id: $id, name: $name, slug: $slug, description: $description, brandId: $brandId, categoryId: $categoryId, sku: $sku, price: $price, compareAtPrice: $compareAtPrice, costPrice: $costPrice, barcode: $barcode, weightGrams: $weightGrams, attributes: $attributes, ratingAvg: $ratingAvg, ratingCount: $ratingCount, isActive: $isActive, isFeatured: $isFeatured, brand: $brand, category: $category, images: $images)';
}


}

/// @nodoc
abstract mixin class _$ProductCopyWith<$Res> implements $ProductCopyWith<$Res> {
  factory _$ProductCopyWith(_Product value, $Res Function(_Product) _then) = __$ProductCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String slug, String? description, String? brandId, String? categoryId, String? sku, num price, num? compareAtPrice, num? costPrice, String? barcode, num? weightGrams, Map<String, dynamic> attributes, num ratingAvg, int ratingCount, bool isActive, bool isFeatured, Brand? brand, Category? category,@JsonKey(name: 'product_images') List<ProductImage> images
});


@override $BrandCopyWith<$Res>? get brand;@override $CategoryCopyWith<$Res>? get category;

}
/// @nodoc
class __$ProductCopyWithImpl<$Res>
    implements _$ProductCopyWith<$Res> {
  __$ProductCopyWithImpl(this._self, this._then);

  final _Product _self;
  final $Res Function(_Product) _then;

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? slug = null,Object? description = freezed,Object? brandId = freezed,Object? categoryId = freezed,Object? sku = freezed,Object? price = null,Object? compareAtPrice = freezed,Object? costPrice = freezed,Object? barcode = freezed,Object? weightGrams = freezed,Object? attributes = null,Object? ratingAvg = null,Object? ratingCount = null,Object? isActive = null,Object? isFeatured = null,Object? brand = freezed,Object? category = freezed,Object? images = null,}) {
  return _then(_Product(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,brandId: freezed == brandId ? _self.brandId : brandId // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,sku: freezed == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String?,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as num,compareAtPrice: freezed == compareAtPrice ? _self.compareAtPrice : compareAtPrice // ignore: cast_nullable_to_non_nullable
as num?,costPrice: freezed == costPrice ? _self.costPrice : costPrice // ignore: cast_nullable_to_non_nullable
as num?,barcode: freezed == barcode ? _self.barcode : barcode // ignore: cast_nullable_to_non_nullable
as String?,weightGrams: freezed == weightGrams ? _self.weightGrams : weightGrams // ignore: cast_nullable_to_non_nullable
as num?,attributes: null == attributes ? _self._attributes : attributes // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,ratingAvg: null == ratingAvg ? _self.ratingAvg : ratingAvg // ignore: cast_nullable_to_non_nullable
as num,ratingCount: null == ratingCount ? _self.ratingCount : ratingCount // ignore: cast_nullable_to_non_nullable
as int,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,isFeatured: null == isFeatured ? _self.isFeatured : isFeatured // ignore: cast_nullable_to_non_nullable
as bool,brand: freezed == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as Brand?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as Category?,images: null == images ? _self._images : images // ignore: cast_nullable_to_non_nullable
as List<ProductImage>,
  ));
}

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BrandCopyWith<$Res>? get brand {
    if (_self.brand == null) {
    return null;
  }

  return $BrandCopyWith<$Res>(_self.brand!, (value) {
    return _then(_self.copyWith(brand: value));
  });
}/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CategoryCopyWith<$Res>? get category {
    if (_self.category == null) {
    return null;
  }

  return $CategoryCopyWith<$Res>(_self.category!, (value) {
    return _then(_self.copyWith(category: value));
  });
}
}

// dart format on

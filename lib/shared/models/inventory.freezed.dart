// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inventory.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Inventory {

 String get id; String get productId; Map<String, dynamic> get variantAttributes; int get quantity; int get lowStockThreshold; num? get price; num? get compareAtPrice; String? get sku; String? get barcode; num? get weightGrams; List<String> get imageUrls; DateTime get updatedAt; Product? get product;
/// Create a copy of Inventory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InventoryCopyWith<Inventory> get copyWith => _$InventoryCopyWithImpl<Inventory>(this as Inventory, _$identity);

  /// Serializes this Inventory to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Inventory&&(identical(other.id, id) || other.id == id)&&(identical(other.productId, productId) || other.productId == productId)&&const DeepCollectionEquality().equals(other.variantAttributes, variantAttributes)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.lowStockThreshold, lowStockThreshold) || other.lowStockThreshold == lowStockThreshold)&&(identical(other.price, price) || other.price == price)&&(identical(other.compareAtPrice, compareAtPrice) || other.compareAtPrice == compareAtPrice)&&(identical(other.sku, sku) || other.sku == sku)&&(identical(other.barcode, barcode) || other.barcode == barcode)&&(identical(other.weightGrams, weightGrams) || other.weightGrams == weightGrams)&&const DeepCollectionEquality().equals(other.imageUrls, imageUrls)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.product, product) || other.product == product));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,productId,const DeepCollectionEquality().hash(variantAttributes),quantity,lowStockThreshold,price,compareAtPrice,sku,barcode,weightGrams,const DeepCollectionEquality().hash(imageUrls),updatedAt,product);

@override
String toString() {
  return 'Inventory(id: $id, productId: $productId, variantAttributes: $variantAttributes, quantity: $quantity, lowStockThreshold: $lowStockThreshold, price: $price, compareAtPrice: $compareAtPrice, sku: $sku, barcode: $barcode, weightGrams: $weightGrams, imageUrls: $imageUrls, updatedAt: $updatedAt, product: $product)';
}


}

/// @nodoc
abstract mixin class $InventoryCopyWith<$Res>  {
  factory $InventoryCopyWith(Inventory value, $Res Function(Inventory) _then) = _$InventoryCopyWithImpl;
@useResult
$Res call({
 String id, String productId, Map<String, dynamic> variantAttributes, int quantity, int lowStockThreshold, num? price, num? compareAtPrice, String? sku, String? barcode, num? weightGrams, List<String> imageUrls, DateTime updatedAt, Product? product
});


$ProductCopyWith<$Res>? get product;

}
/// @nodoc
class _$InventoryCopyWithImpl<$Res>
    implements $InventoryCopyWith<$Res> {
  _$InventoryCopyWithImpl(this._self, this._then);

  final Inventory _self;
  final $Res Function(Inventory) _then;

/// Create a copy of Inventory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? productId = null,Object? variantAttributes = null,Object? quantity = null,Object? lowStockThreshold = null,Object? price = freezed,Object? compareAtPrice = freezed,Object? sku = freezed,Object? barcode = freezed,Object? weightGrams = freezed,Object? imageUrls = null,Object? updatedAt = null,Object? product = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,variantAttributes: null == variantAttributes ? _self.variantAttributes : variantAttributes // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,lowStockThreshold: null == lowStockThreshold ? _self.lowStockThreshold : lowStockThreshold // ignore: cast_nullable_to_non_nullable
as int,price: freezed == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as num?,compareAtPrice: freezed == compareAtPrice ? _self.compareAtPrice : compareAtPrice // ignore: cast_nullable_to_non_nullable
as num?,sku: freezed == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String?,barcode: freezed == barcode ? _self.barcode : barcode // ignore: cast_nullable_to_non_nullable
as String?,weightGrams: freezed == weightGrams ? _self.weightGrams : weightGrams // ignore: cast_nullable_to_non_nullable
as num?,imageUrls: null == imageUrls ? _self.imageUrls : imageUrls // ignore: cast_nullable_to_non_nullable
as List<String>,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,product: freezed == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as Product?,
  ));
}
/// Create a copy of Inventory
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductCopyWith<$Res>? get product {
    if (_self.product == null) {
    return null;
  }

  return $ProductCopyWith<$Res>(_self.product!, (value) {
    return _then(_self.copyWith(product: value));
  });
}
}


/// Adds pattern-matching-related methods to [Inventory].
extension InventoryPatterns on Inventory {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Inventory value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Inventory() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Inventory value)  $default,){
final _that = this;
switch (_that) {
case _Inventory():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Inventory value)?  $default,){
final _that = this;
switch (_that) {
case _Inventory() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String productId,  Map<String, dynamic> variantAttributes,  int quantity,  int lowStockThreshold,  num? price,  num? compareAtPrice,  String? sku,  String? barcode,  num? weightGrams,  List<String> imageUrls,  DateTime updatedAt,  Product? product)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Inventory() when $default != null:
return $default(_that.id,_that.productId,_that.variantAttributes,_that.quantity,_that.lowStockThreshold,_that.price,_that.compareAtPrice,_that.sku,_that.barcode,_that.weightGrams,_that.imageUrls,_that.updatedAt,_that.product);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String productId,  Map<String, dynamic> variantAttributes,  int quantity,  int lowStockThreshold,  num? price,  num? compareAtPrice,  String? sku,  String? barcode,  num? weightGrams,  List<String> imageUrls,  DateTime updatedAt,  Product? product)  $default,) {final _that = this;
switch (_that) {
case _Inventory():
return $default(_that.id,_that.productId,_that.variantAttributes,_that.quantity,_that.lowStockThreshold,_that.price,_that.compareAtPrice,_that.sku,_that.barcode,_that.weightGrams,_that.imageUrls,_that.updatedAt,_that.product);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String productId,  Map<String, dynamic> variantAttributes,  int quantity,  int lowStockThreshold,  num? price,  num? compareAtPrice,  String? sku,  String? barcode,  num? weightGrams,  List<String> imageUrls,  DateTime updatedAt,  Product? product)?  $default,) {final _that = this;
switch (_that) {
case _Inventory() when $default != null:
return $default(_that.id,_that.productId,_that.variantAttributes,_that.quantity,_that.lowStockThreshold,_that.price,_that.compareAtPrice,_that.sku,_that.barcode,_that.weightGrams,_that.imageUrls,_that.updatedAt,_that.product);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Inventory implements Inventory {
  const _Inventory({required this.id, required this.productId, final  Map<String, dynamic> variantAttributes = const {}, this.quantity = 0, this.lowStockThreshold = 5, this.price, this.compareAtPrice, this.sku, this.barcode, this.weightGrams, final  List<String> imageUrls = const [], required this.updatedAt, this.product}): _variantAttributes = variantAttributes,_imageUrls = imageUrls;
  factory _Inventory.fromJson(Map<String, dynamic> json) => _$InventoryFromJson(json);

@override final  String id;
@override final  String productId;
 final  Map<String, dynamic> _variantAttributes;
@override@JsonKey() Map<String, dynamic> get variantAttributes {
  if (_variantAttributes is EqualUnmodifiableMapView) return _variantAttributes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_variantAttributes);
}

@override@JsonKey() final  int quantity;
@override@JsonKey() final  int lowStockThreshold;
@override final  num? price;
@override final  num? compareAtPrice;
@override final  String? sku;
@override final  String? barcode;
@override final  num? weightGrams;
 final  List<String> _imageUrls;
@override@JsonKey() List<String> get imageUrls {
  if (_imageUrls is EqualUnmodifiableListView) return _imageUrls;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_imageUrls);
}

@override final  DateTime updatedAt;
@override final  Product? product;

/// Create a copy of Inventory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InventoryCopyWith<_Inventory> get copyWith => __$InventoryCopyWithImpl<_Inventory>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InventoryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Inventory&&(identical(other.id, id) || other.id == id)&&(identical(other.productId, productId) || other.productId == productId)&&const DeepCollectionEquality().equals(other._variantAttributes, _variantAttributes)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.lowStockThreshold, lowStockThreshold) || other.lowStockThreshold == lowStockThreshold)&&(identical(other.price, price) || other.price == price)&&(identical(other.compareAtPrice, compareAtPrice) || other.compareAtPrice == compareAtPrice)&&(identical(other.sku, sku) || other.sku == sku)&&(identical(other.barcode, barcode) || other.barcode == barcode)&&(identical(other.weightGrams, weightGrams) || other.weightGrams == weightGrams)&&const DeepCollectionEquality().equals(other._imageUrls, _imageUrls)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.product, product) || other.product == product));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,productId,const DeepCollectionEquality().hash(_variantAttributes),quantity,lowStockThreshold,price,compareAtPrice,sku,barcode,weightGrams,const DeepCollectionEquality().hash(_imageUrls),updatedAt,product);

@override
String toString() {
  return 'Inventory(id: $id, productId: $productId, variantAttributes: $variantAttributes, quantity: $quantity, lowStockThreshold: $lowStockThreshold, price: $price, compareAtPrice: $compareAtPrice, sku: $sku, barcode: $barcode, weightGrams: $weightGrams, imageUrls: $imageUrls, updatedAt: $updatedAt, product: $product)';
}


}

/// @nodoc
abstract mixin class _$InventoryCopyWith<$Res> implements $InventoryCopyWith<$Res> {
  factory _$InventoryCopyWith(_Inventory value, $Res Function(_Inventory) _then) = __$InventoryCopyWithImpl;
@override @useResult
$Res call({
 String id, String productId, Map<String, dynamic> variantAttributes, int quantity, int lowStockThreshold, num? price, num? compareAtPrice, String? sku, String? barcode, num? weightGrams, List<String> imageUrls, DateTime updatedAt, Product? product
});


@override $ProductCopyWith<$Res>? get product;

}
/// @nodoc
class __$InventoryCopyWithImpl<$Res>
    implements _$InventoryCopyWith<$Res> {
  __$InventoryCopyWithImpl(this._self, this._then);

  final _Inventory _self;
  final $Res Function(_Inventory) _then;

/// Create a copy of Inventory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? productId = null,Object? variantAttributes = null,Object? quantity = null,Object? lowStockThreshold = null,Object? price = freezed,Object? compareAtPrice = freezed,Object? sku = freezed,Object? barcode = freezed,Object? weightGrams = freezed,Object? imageUrls = null,Object? updatedAt = null,Object? product = freezed,}) {
  return _then(_Inventory(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,variantAttributes: null == variantAttributes ? _self._variantAttributes : variantAttributes // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,lowStockThreshold: null == lowStockThreshold ? _self.lowStockThreshold : lowStockThreshold // ignore: cast_nullable_to_non_nullable
as int,price: freezed == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as num?,compareAtPrice: freezed == compareAtPrice ? _self.compareAtPrice : compareAtPrice // ignore: cast_nullable_to_non_nullable
as num?,sku: freezed == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String?,barcode: freezed == barcode ? _self.barcode : barcode // ignore: cast_nullable_to_non_nullable
as String?,weightGrams: freezed == weightGrams ? _self.weightGrams : weightGrams // ignore: cast_nullable_to_non_nullable
as num?,imageUrls: null == imageUrls ? _self._imageUrls : imageUrls // ignore: cast_nullable_to_non_nullable
as List<String>,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,product: freezed == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as Product?,
  ));
}

/// Create a copy of Inventory
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductCopyWith<$Res>? get product {
    if (_self.product == null) {
    return null;
  }

  return $ProductCopyWith<$Res>(_self.product!, (value) {
    return _then(_self.copyWith(product: value));
  });
}
}

// dart format on

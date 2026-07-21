// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'review.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Review {

 String get id;@JsonKey(name: 'product_id') String get productId;@JsonKey(name: 'customer_name') String get customerName; int get rating;@JsonKey(name: 'review_title') String? get reviewTitle;@JsonKey(name: 'review_description') String? get reviewDescription;@JsonKey(name: 'customer_avatar') String? get customerAvatar;@JsonKey(name: 'verified_purchase') bool get verifiedPurchase; String get status;@JsonKey(name: 'created_at') DateTime get createdAt;@JsonKey(name: 'updated_at') DateTime get updatedAt;
/// Create a copy of Review
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReviewCopyWith<Review> get copyWith => _$ReviewCopyWithImpl<Review>(this as Review, _$identity);

  /// Serializes this Review to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Review&&(identical(other.id, id) || other.id == id)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.reviewTitle, reviewTitle) || other.reviewTitle == reviewTitle)&&(identical(other.reviewDescription, reviewDescription) || other.reviewDescription == reviewDescription)&&(identical(other.customerAvatar, customerAvatar) || other.customerAvatar == customerAvatar)&&(identical(other.verifiedPurchase, verifiedPurchase) || other.verifiedPurchase == verifiedPurchase)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,productId,customerName,rating,reviewTitle,reviewDescription,customerAvatar,verifiedPurchase,status,createdAt,updatedAt);

@override
String toString() {
  return 'Review(id: $id, productId: $productId, customerName: $customerName, rating: $rating, reviewTitle: $reviewTitle, reviewDescription: $reviewDescription, customerAvatar: $customerAvatar, verifiedPurchase: $verifiedPurchase, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ReviewCopyWith<$Res>  {
  factory $ReviewCopyWith(Review value, $Res Function(Review) _then) = _$ReviewCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'product_id') String productId,@JsonKey(name: 'customer_name') String customerName, int rating,@JsonKey(name: 'review_title') String? reviewTitle,@JsonKey(name: 'review_description') String? reviewDescription,@JsonKey(name: 'customer_avatar') String? customerAvatar,@JsonKey(name: 'verified_purchase') bool verifiedPurchase, String status,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'updated_at') DateTime updatedAt
});




}
/// @nodoc
class _$ReviewCopyWithImpl<$Res>
    implements $ReviewCopyWith<$Res> {
  _$ReviewCopyWithImpl(this._self, this._then);

  final Review _self;
  final $Res Function(Review) _then;

/// Create a copy of Review
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? productId = null,Object? customerName = null,Object? rating = null,Object? reviewTitle = freezed,Object? reviewDescription = freezed,Object? customerAvatar = freezed,Object? verifiedPurchase = null,Object? status = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,customerName: null == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as int,reviewTitle: freezed == reviewTitle ? _self.reviewTitle : reviewTitle // ignore: cast_nullable_to_non_nullable
as String?,reviewDescription: freezed == reviewDescription ? _self.reviewDescription : reviewDescription // ignore: cast_nullable_to_non_nullable
as String?,customerAvatar: freezed == customerAvatar ? _self.customerAvatar : customerAvatar // ignore: cast_nullable_to_non_nullable
as String?,verifiedPurchase: null == verifiedPurchase ? _self.verifiedPurchase : verifiedPurchase // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Review].
extension ReviewPatterns on Review {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Review value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Review() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Review value)  $default,){
final _that = this;
switch (_that) {
case _Review():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Review value)?  $default,){
final _that = this;
switch (_that) {
case _Review() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'product_id')  String productId, @JsonKey(name: 'customer_name')  String customerName,  int rating, @JsonKey(name: 'review_title')  String? reviewTitle, @JsonKey(name: 'review_description')  String? reviewDescription, @JsonKey(name: 'customer_avatar')  String? customerAvatar, @JsonKey(name: 'verified_purchase')  bool verifiedPurchase,  String status, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Review() when $default != null:
return $default(_that.id,_that.productId,_that.customerName,_that.rating,_that.reviewTitle,_that.reviewDescription,_that.customerAvatar,_that.verifiedPurchase,_that.status,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'product_id')  String productId, @JsonKey(name: 'customer_name')  String customerName,  int rating, @JsonKey(name: 'review_title')  String? reviewTitle, @JsonKey(name: 'review_description')  String? reviewDescription, @JsonKey(name: 'customer_avatar')  String? customerAvatar, @JsonKey(name: 'verified_purchase')  bool verifiedPurchase,  String status, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Review():
return $default(_that.id,_that.productId,_that.customerName,_that.rating,_that.reviewTitle,_that.reviewDescription,_that.customerAvatar,_that.verifiedPurchase,_that.status,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'product_id')  String productId, @JsonKey(name: 'customer_name')  String customerName,  int rating, @JsonKey(name: 'review_title')  String? reviewTitle, @JsonKey(name: 'review_description')  String? reviewDescription, @JsonKey(name: 'customer_avatar')  String? customerAvatar, @JsonKey(name: 'verified_purchase')  bool verifiedPurchase,  String status, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Review() when $default != null:
return $default(_that.id,_that.productId,_that.customerName,_that.rating,_that.reviewTitle,_that.reviewDescription,_that.customerAvatar,_that.verifiedPurchase,_that.status,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Review implements Review {
  const _Review({required this.id, @JsonKey(name: 'product_id') required this.productId, @JsonKey(name: 'customer_name') required this.customerName, required this.rating, @JsonKey(name: 'review_title') this.reviewTitle, @JsonKey(name: 'review_description') this.reviewDescription, @JsonKey(name: 'customer_avatar') this.customerAvatar, @JsonKey(name: 'verified_purchase') this.verifiedPurchase = false, this.status = 'Published', @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'updated_at') required this.updatedAt});
  factory _Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);

@override final  String id;
@override@JsonKey(name: 'product_id') final  String productId;
@override@JsonKey(name: 'customer_name') final  String customerName;
@override final  int rating;
@override@JsonKey(name: 'review_title') final  String? reviewTitle;
@override@JsonKey(name: 'review_description') final  String? reviewDescription;
@override@JsonKey(name: 'customer_avatar') final  String? customerAvatar;
@override@JsonKey(name: 'verified_purchase') final  bool verifiedPurchase;
@override@JsonKey() final  String status;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime updatedAt;

/// Create a copy of Review
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReviewCopyWith<_Review> get copyWith => __$ReviewCopyWithImpl<_Review>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReviewToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Review&&(identical(other.id, id) || other.id == id)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.reviewTitle, reviewTitle) || other.reviewTitle == reviewTitle)&&(identical(other.reviewDescription, reviewDescription) || other.reviewDescription == reviewDescription)&&(identical(other.customerAvatar, customerAvatar) || other.customerAvatar == customerAvatar)&&(identical(other.verifiedPurchase, verifiedPurchase) || other.verifiedPurchase == verifiedPurchase)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,productId,customerName,rating,reviewTitle,reviewDescription,customerAvatar,verifiedPurchase,status,createdAt,updatedAt);

@override
String toString() {
  return 'Review(id: $id, productId: $productId, customerName: $customerName, rating: $rating, reviewTitle: $reviewTitle, reviewDescription: $reviewDescription, customerAvatar: $customerAvatar, verifiedPurchase: $verifiedPurchase, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ReviewCopyWith<$Res> implements $ReviewCopyWith<$Res> {
  factory _$ReviewCopyWith(_Review value, $Res Function(_Review) _then) = __$ReviewCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'product_id') String productId,@JsonKey(name: 'customer_name') String customerName, int rating,@JsonKey(name: 'review_title') String? reviewTitle,@JsonKey(name: 'review_description') String? reviewDescription,@JsonKey(name: 'customer_avatar') String? customerAvatar,@JsonKey(name: 'verified_purchase') bool verifiedPurchase, String status,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'updated_at') DateTime updatedAt
});




}
/// @nodoc
class __$ReviewCopyWithImpl<$Res>
    implements _$ReviewCopyWith<$Res> {
  __$ReviewCopyWithImpl(this._self, this._then);

  final _Review _self;
  final $Res Function(_Review) _then;

/// Create a copy of Review
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? productId = null,Object? customerName = null,Object? rating = null,Object? reviewTitle = freezed,Object? reviewDescription = freezed,Object? customerAvatar = freezed,Object? verifiedPurchase = null,Object? status = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_Review(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,customerName: null == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as int,reviewTitle: freezed == reviewTitle ? _self.reviewTitle : reviewTitle // ignore: cast_nullable_to_non_nullable
as String?,reviewDescription: freezed == reviewDescription ? _self.reviewDescription : reviewDescription // ignore: cast_nullable_to_non_nullable
as String?,customerAvatar: freezed == customerAvatar ? _self.customerAvatar : customerAvatar // ignore: cast_nullable_to_non_nullable
as String?,verifiedPurchase: null == verifiedPurchase ? _self.verifiedPurchase : verifiedPurchase // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on

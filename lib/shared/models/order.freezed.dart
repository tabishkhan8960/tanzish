// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Order {

 String get id; String get orderNumber; String get userId; OrderStatus get status; String? get shippingAddressId; String? get billingAddressId; String? get couponId; num get subtotal; num get shippingFee; num get discount; num get total; String get currency; DateTime get placedAt;@JsonKey(name: 'order_items') List<OrderItem> get items; Address? get shippingAddress; List<Payment> get payments;
/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderCopyWith<Order> get copyWith => _$OrderCopyWithImpl<Order>(this as Order, _$identity);

  /// Serializes this Order to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Order&&(identical(other.id, id) || other.id == id)&&(identical(other.orderNumber, orderNumber) || other.orderNumber == orderNumber)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.status, status) || other.status == status)&&(identical(other.shippingAddressId, shippingAddressId) || other.shippingAddressId == shippingAddressId)&&(identical(other.billingAddressId, billingAddressId) || other.billingAddressId == billingAddressId)&&(identical(other.couponId, couponId) || other.couponId == couponId)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal)&&(identical(other.shippingFee, shippingFee) || other.shippingFee == shippingFee)&&(identical(other.discount, discount) || other.discount == discount)&&(identical(other.total, total) || other.total == total)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.placedAt, placedAt) || other.placedAt == placedAt)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.shippingAddress, shippingAddress) || other.shippingAddress == shippingAddress)&&const DeepCollectionEquality().equals(other.payments, payments));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,orderNumber,userId,status,shippingAddressId,billingAddressId,couponId,subtotal,shippingFee,discount,total,currency,placedAt,const DeepCollectionEquality().hash(items),shippingAddress,const DeepCollectionEquality().hash(payments));

@override
String toString() {
  return 'Order(id: $id, orderNumber: $orderNumber, userId: $userId, status: $status, shippingAddressId: $shippingAddressId, billingAddressId: $billingAddressId, couponId: $couponId, subtotal: $subtotal, shippingFee: $shippingFee, discount: $discount, total: $total, currency: $currency, placedAt: $placedAt, items: $items, shippingAddress: $shippingAddress, payments: $payments)';
}


}

/// @nodoc
abstract mixin class $OrderCopyWith<$Res>  {
  factory $OrderCopyWith(Order value, $Res Function(Order) _then) = _$OrderCopyWithImpl;
@useResult
$Res call({
 String id, String orderNumber, String userId, OrderStatus status, String? shippingAddressId, String? billingAddressId, String? couponId, num subtotal, num shippingFee, num discount, num total, String currency, DateTime placedAt,@JsonKey(name: 'order_items') List<OrderItem> items, Address? shippingAddress, List<Payment> payments
});


$AddressCopyWith<$Res>? get shippingAddress;

}
/// @nodoc
class _$OrderCopyWithImpl<$Res>
    implements $OrderCopyWith<$Res> {
  _$OrderCopyWithImpl(this._self, this._then);

  final Order _self;
  final $Res Function(Order) _then;

/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? orderNumber = null,Object? userId = null,Object? status = null,Object? shippingAddressId = freezed,Object? billingAddressId = freezed,Object? couponId = freezed,Object? subtotal = null,Object? shippingFee = null,Object? discount = null,Object? total = null,Object? currency = null,Object? placedAt = null,Object? items = null,Object? shippingAddress = freezed,Object? payments = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orderNumber: null == orderNumber ? _self.orderNumber : orderNumber // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OrderStatus,shippingAddressId: freezed == shippingAddressId ? _self.shippingAddressId : shippingAddressId // ignore: cast_nullable_to_non_nullable
as String?,billingAddressId: freezed == billingAddressId ? _self.billingAddressId : billingAddressId // ignore: cast_nullable_to_non_nullable
as String?,couponId: freezed == couponId ? _self.couponId : couponId // ignore: cast_nullable_to_non_nullable
as String?,subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as num,shippingFee: null == shippingFee ? _self.shippingFee : shippingFee // ignore: cast_nullable_to_non_nullable
as num,discount: null == discount ? _self.discount : discount // ignore: cast_nullable_to_non_nullable
as num,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as num,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,placedAt: null == placedAt ? _self.placedAt : placedAt // ignore: cast_nullable_to_non_nullable
as DateTime,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<OrderItem>,shippingAddress: freezed == shippingAddress ? _self.shippingAddress : shippingAddress // ignore: cast_nullable_to_non_nullable
as Address?,payments: null == payments ? _self.payments : payments // ignore: cast_nullable_to_non_nullable
as List<Payment>,
  ));
}
/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AddressCopyWith<$Res>? get shippingAddress {
    if (_self.shippingAddress == null) {
    return null;
  }

  return $AddressCopyWith<$Res>(_self.shippingAddress!, (value) {
    return _then(_self.copyWith(shippingAddress: value));
  });
}
}


/// Adds pattern-matching-related methods to [Order].
extension OrderPatterns on Order {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Order value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Order() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Order value)  $default,){
final _that = this;
switch (_that) {
case _Order():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Order value)?  $default,){
final _that = this;
switch (_that) {
case _Order() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String orderNumber,  String userId,  OrderStatus status,  String? shippingAddressId,  String? billingAddressId,  String? couponId,  num subtotal,  num shippingFee,  num discount,  num total,  String currency,  DateTime placedAt, @JsonKey(name: 'order_items')  List<OrderItem> items,  Address? shippingAddress,  List<Payment> payments)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Order() when $default != null:
return $default(_that.id,_that.orderNumber,_that.userId,_that.status,_that.shippingAddressId,_that.billingAddressId,_that.couponId,_that.subtotal,_that.shippingFee,_that.discount,_that.total,_that.currency,_that.placedAt,_that.items,_that.shippingAddress,_that.payments);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String orderNumber,  String userId,  OrderStatus status,  String? shippingAddressId,  String? billingAddressId,  String? couponId,  num subtotal,  num shippingFee,  num discount,  num total,  String currency,  DateTime placedAt, @JsonKey(name: 'order_items')  List<OrderItem> items,  Address? shippingAddress,  List<Payment> payments)  $default,) {final _that = this;
switch (_that) {
case _Order():
return $default(_that.id,_that.orderNumber,_that.userId,_that.status,_that.shippingAddressId,_that.billingAddressId,_that.couponId,_that.subtotal,_that.shippingFee,_that.discount,_that.total,_that.currency,_that.placedAt,_that.items,_that.shippingAddress,_that.payments);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String orderNumber,  String userId,  OrderStatus status,  String? shippingAddressId,  String? billingAddressId,  String? couponId,  num subtotal,  num shippingFee,  num discount,  num total,  String currency,  DateTime placedAt, @JsonKey(name: 'order_items')  List<OrderItem> items,  Address? shippingAddress,  List<Payment> payments)?  $default,) {final _that = this;
switch (_that) {
case _Order() when $default != null:
return $default(_that.id,_that.orderNumber,_that.userId,_that.status,_that.shippingAddressId,_that.billingAddressId,_that.couponId,_that.subtotal,_that.shippingFee,_that.discount,_that.total,_that.currency,_that.placedAt,_that.items,_that.shippingAddress,_that.payments);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Order implements Order {
  const _Order({required this.id, required this.orderNumber, required this.userId, this.status = OrderStatus.pending, this.shippingAddressId, this.billingAddressId, this.couponId, this.subtotal = 0, this.shippingFee = 0, this.discount = 0, this.total = 0, this.currency = 'USD', required this.placedAt, @JsonKey(name: 'order_items') final  List<OrderItem> items = const [], this.shippingAddress, final  List<Payment> payments = const []}): _items = items,_payments = payments;
  factory _Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

@override final  String id;
@override final  String orderNumber;
@override final  String userId;
@override@JsonKey() final  OrderStatus status;
@override final  String? shippingAddressId;
@override final  String? billingAddressId;
@override final  String? couponId;
@override@JsonKey() final  num subtotal;
@override@JsonKey() final  num shippingFee;
@override@JsonKey() final  num discount;
@override@JsonKey() final  num total;
@override@JsonKey() final  String currency;
@override final  DateTime placedAt;
 final  List<OrderItem> _items;
@override@JsonKey(name: 'order_items') List<OrderItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  Address? shippingAddress;
 final  List<Payment> _payments;
@override@JsonKey() List<Payment> get payments {
  if (_payments is EqualUnmodifiableListView) return _payments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_payments);
}


/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderCopyWith<_Order> get copyWith => __$OrderCopyWithImpl<_Order>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrderToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Order&&(identical(other.id, id) || other.id == id)&&(identical(other.orderNumber, orderNumber) || other.orderNumber == orderNumber)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.status, status) || other.status == status)&&(identical(other.shippingAddressId, shippingAddressId) || other.shippingAddressId == shippingAddressId)&&(identical(other.billingAddressId, billingAddressId) || other.billingAddressId == billingAddressId)&&(identical(other.couponId, couponId) || other.couponId == couponId)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal)&&(identical(other.shippingFee, shippingFee) || other.shippingFee == shippingFee)&&(identical(other.discount, discount) || other.discount == discount)&&(identical(other.total, total) || other.total == total)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.placedAt, placedAt) || other.placedAt == placedAt)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.shippingAddress, shippingAddress) || other.shippingAddress == shippingAddress)&&const DeepCollectionEquality().equals(other._payments, _payments));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,orderNumber,userId,status,shippingAddressId,billingAddressId,couponId,subtotal,shippingFee,discount,total,currency,placedAt,const DeepCollectionEquality().hash(_items),shippingAddress,const DeepCollectionEquality().hash(_payments));

@override
String toString() {
  return 'Order(id: $id, orderNumber: $orderNumber, userId: $userId, status: $status, shippingAddressId: $shippingAddressId, billingAddressId: $billingAddressId, couponId: $couponId, subtotal: $subtotal, shippingFee: $shippingFee, discount: $discount, total: $total, currency: $currency, placedAt: $placedAt, items: $items, shippingAddress: $shippingAddress, payments: $payments)';
}


}

/// @nodoc
abstract mixin class _$OrderCopyWith<$Res> implements $OrderCopyWith<$Res> {
  factory _$OrderCopyWith(_Order value, $Res Function(_Order) _then) = __$OrderCopyWithImpl;
@override @useResult
$Res call({
 String id, String orderNumber, String userId, OrderStatus status, String? shippingAddressId, String? billingAddressId, String? couponId, num subtotal, num shippingFee, num discount, num total, String currency, DateTime placedAt,@JsonKey(name: 'order_items') List<OrderItem> items, Address? shippingAddress, List<Payment> payments
});


@override $AddressCopyWith<$Res>? get shippingAddress;

}
/// @nodoc
class __$OrderCopyWithImpl<$Res>
    implements _$OrderCopyWith<$Res> {
  __$OrderCopyWithImpl(this._self, this._then);

  final _Order _self;
  final $Res Function(_Order) _then;

/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? orderNumber = null,Object? userId = null,Object? status = null,Object? shippingAddressId = freezed,Object? billingAddressId = freezed,Object? couponId = freezed,Object? subtotal = null,Object? shippingFee = null,Object? discount = null,Object? total = null,Object? currency = null,Object? placedAt = null,Object? items = null,Object? shippingAddress = freezed,Object? payments = null,}) {
  return _then(_Order(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orderNumber: null == orderNumber ? _self.orderNumber : orderNumber // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OrderStatus,shippingAddressId: freezed == shippingAddressId ? _self.shippingAddressId : shippingAddressId // ignore: cast_nullable_to_non_nullable
as String?,billingAddressId: freezed == billingAddressId ? _self.billingAddressId : billingAddressId // ignore: cast_nullable_to_non_nullable
as String?,couponId: freezed == couponId ? _self.couponId : couponId // ignore: cast_nullable_to_non_nullable
as String?,subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as num,shippingFee: null == shippingFee ? _self.shippingFee : shippingFee // ignore: cast_nullable_to_non_nullable
as num,discount: null == discount ? _self.discount : discount // ignore: cast_nullable_to_non_nullable
as num,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as num,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,placedAt: null == placedAt ? _self.placedAt : placedAt // ignore: cast_nullable_to_non_nullable
as DateTime,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<OrderItem>,shippingAddress: freezed == shippingAddress ? _self.shippingAddress : shippingAddress // ignore: cast_nullable_to_non_nullable
as Address?,payments: null == payments ? _self._payments : payments // ignore: cast_nullable_to_non_nullable
as List<Payment>,
  ));
}

/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AddressCopyWith<$Res>? get shippingAddress {
    if (_self.shippingAddress == null) {
    return null;
  }

  return $AddressCopyWith<$Res>(_self.shippingAddress!, (value) {
    return _then(_self.copyWith(shippingAddress: value));
  });
}
}

// dart format on

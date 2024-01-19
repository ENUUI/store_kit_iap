// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

TransactionsResult _$TransactionsResultFromJson(Map<String, dynamic> json) {
  return _TransactionsResult.fromJson(json);
}

/// @nodoc
mixin _$TransactionsResult {
  String get requestId => throw _privateConstructorUsedError; // 是否有资格
  String get productId => throw _privateConstructorUsedError; // 是否有资格
  SkiError? get error => throw _privateConstructorUsedError; // 错误信息
  List<Transaction>? get transactions => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
}

/// @nodoc
@JsonSerializable()
class _$TransactionsResultImpl implements _TransactionsResult {
  const _$TransactionsResultImpl(
      {this.requestId = '',
      this.productId = '',
      this.error,
      final List<Transaction>? transactions})
      : _transactions = transactions;

  factory _$TransactionsResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransactionsResultImplFromJson(json);

  @override
  @JsonKey()
  final String requestId;
// 是否有资格
  @override
  @JsonKey()
  final String productId;
// 是否有资格
  @override
  final SkiError? error;
// 错误信息
  final List<Transaction>? _transactions;
// 错误信息
  @override
  List<Transaction>? get transactions {
    final value = _transactions;
    if (value == null) return null;
    if (_transactions is EqualUnmodifiableListView) return _transactions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'TransactionsResult(requestId: $requestId, productId: $productId, error: $error, transactions: $transactions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionsResultImpl &&
            (identical(other.requestId, requestId) ||
                other.requestId == requestId) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.error, error) || other.error == error) &&
            const DeepCollectionEquality()
                .equals(other._transactions, _transactions));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, requestId, productId, error,
      const DeepCollectionEquality().hash(_transactions));

  @override
  Map<String, dynamic> toJson() {
    return _$$TransactionsResultImplToJson(
      this,
    );
  }
}

abstract class _TransactionsResult implements TransactionsResult {
  const factory _TransactionsResult(
      {final String requestId,
      final String productId,
      final SkiError? error,
      final List<Transaction>? transactions}) = _$TransactionsResultImpl;

  factory _TransactionsResult.fromJson(Map<String, dynamic> json) =
      _$TransactionsResultImpl.fromJson;

  @override
  String get requestId;
  @override // 是否有资格
  String get productId;
  @override // 是否有资格
  SkiError? get error;
  @override // 错误信息
  List<Transaction>? get transactions;
}

PurchaseResult _$PurchaseResultFromJson(Map<String, dynamic> json) {
  return _PurchaseResult.fromJson(json);
}

/// @nodoc
mixin _$PurchaseResult {
  String get requestId => throw _privateConstructorUsedError; // 是否有资格
  String get productId => throw _privateConstructorUsedError; // 是否有资格
  SkiError? get error => throw _privateConstructorUsedError; // 错误信息
  Transaction? get transaction => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
}

/// @nodoc
@JsonSerializable()
class _$PurchaseResultImpl implements _PurchaseResult {
  const _$PurchaseResultImpl(
      {this.requestId = '', this.productId = '', this.error, this.transaction});

  factory _$PurchaseResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$PurchaseResultImplFromJson(json);

  @override
  @JsonKey()
  final String requestId;
// 是否有资格
  @override
  @JsonKey()
  final String productId;
// 是否有资格
  @override
  final SkiError? error;
// 错误信息
  @override
  final Transaction? transaction;

  @override
  String toString() {
    return 'PurchaseResult(requestId: $requestId, productId: $productId, error: $error, transaction: $transaction)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PurchaseResultImpl &&
            (identical(other.requestId, requestId) ||
                other.requestId == requestId) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.transaction, transaction) ||
                other.transaction == transaction));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, requestId, productId, error, transaction);

  @override
  Map<String, dynamic> toJson() {
    return _$$PurchaseResultImplToJson(
      this,
    );
  }
}

abstract class _PurchaseResult implements PurchaseResult {
  const factory _PurchaseResult(
      {final String requestId,
      final String productId,
      final SkiError? error,
      final Transaction? transaction}) = _$PurchaseResultImpl;

  factory _PurchaseResult.fromJson(Map<String, dynamic> json) =
      _$PurchaseResultImpl.fromJson;

  @override
  String get requestId;
  @override // 是否有资格
  String get productId;
  @override // 是否有资格
  SkiError? get error;
  @override // 错误信息
  Transaction? get transaction;
}

EligibleResult _$EligibleResultFromJson(Map<String, dynamic> json) {
  return _EligibleResult.fromJson(json);
}

/// @nodoc
mixin _$EligibleResult {
  String get requestId => throw _privateConstructorUsedError; // 是否有资格
  String get productId => throw _privateConstructorUsedError; // 是否有资格
  bool get offer => throw _privateConstructorUsedError; // 是否享受优惠
  SkiError? get error => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
}

/// @nodoc
@JsonSerializable()
class _$EligibleResultImpl implements _EligibleResult {
  const _$EligibleResultImpl(
      {this.requestId = '',
      this.productId = '',
      this.offer = false,
      this.error});

  factory _$EligibleResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$EligibleResultImplFromJson(json);

  @override
  @JsonKey()
  final String requestId;
// 是否有资格
  @override
  @JsonKey()
  final String productId;
// 是否有资格
  @override
  @JsonKey()
  final bool offer;
// 是否享受优惠
  @override
  final SkiError? error;

  @override
  String toString() {
    return 'EligibleResult(requestId: $requestId, productId: $productId, offer: $offer, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EligibleResultImpl &&
            (identical(other.requestId, requestId) ||
                other.requestId == requestId) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.offer, offer) || other.offer == offer) &&
            (identical(other.error, error) || other.error == error));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, requestId, productId, offer, error);

  @override
  Map<String, dynamic> toJson() {
    return _$$EligibleResultImplToJson(
      this,
    );
  }
}

abstract class _EligibleResult implements EligibleResult {
  const factory _EligibleResult(
      {final String requestId,
      final String productId,
      final bool offer,
      final SkiError? error}) = _$EligibleResultImpl;

  factory _EligibleResult.fromJson(Map<String, dynamic> json) =
      _$EligibleResultImpl.fromJson;

  @override
  String get requestId;
  @override // 是否有资格
  String get productId;
  @override // 是否有资格
  bool get offer;
  @override // 是否享受优惠
  SkiError? get error;
}

ProductResult _$ProductResultFromJson(Map<String, dynamic> json) {
  return _ProductResult.fromJson(json);
}

/// @nodoc
mixin _$ProductResult {
  String get requestId => throw _privateConstructorUsedError; // 是否有资格
  String get productId => throw _privateConstructorUsedError; // 是否有资格
  Map<String, dynamic> get product =>
      throw _privateConstructorUsedError; // 是否享受优惠
  SkiError? get error => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
}

/// @nodoc
@JsonSerializable()
class _$ProductResultImpl implements _ProductResult {
  _$ProductResultImpl(
      {this.requestId = '',
      this.productId = '',
      final Map<String, dynamic> product = const <String, dynamic>{},
      this.error})
      : _product = product;

  factory _$ProductResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductResultImplFromJson(json);

  @override
  @JsonKey()
  final String requestId;
// 是否有资格
  @override
  @JsonKey()
  final String productId;
// 是否有资格
  final Map<String, dynamic> _product;
// 是否有资格
  @override
  @JsonKey()
  Map<String, dynamic> get product {
    if (_product is EqualUnmodifiableMapView) return _product;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_product);
  }

// 是否享受优惠
  @override
  final SkiError? error;

  @override
  String toString() {
    return 'ProductResult(requestId: $requestId, productId: $productId, product: $product, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductResultImpl &&
            (identical(other.requestId, requestId) ||
                other.requestId == requestId) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            const DeepCollectionEquality().equals(other._product, _product) &&
            (identical(other.error, error) || other.error == error));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, requestId, productId,
      const DeepCollectionEquality().hash(_product), error);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductResultImplToJson(
      this,
    );
  }
}

abstract class _ProductResult implements ProductResult {
  factory _ProductResult(
      {final String requestId,
      final String productId,
      final Map<String, dynamic> product,
      final SkiError? error}) = _$ProductResultImpl;

  factory _ProductResult.fromJson(Map<String, dynamic> json) =
      _$ProductResultImpl.fromJson;

  @override
  String get requestId;
  @override // 是否有资格
  String get productId;
  @override // 是否有资格
  Map<String, dynamic> get product;
  @override // 是否享受优惠
  SkiError? get error;
}

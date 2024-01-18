// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Transaction _$TransactionFromJson(Map<String, dynamic> json) {
  return _Transaction.fromJson(json);
}

/// @nodoc
mixin _$Transaction {
  TransactionState get state => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError; // 信息
  String get description => throw _privateConstructorUsedError; // 失败时的错误信息
  Trade? get trade => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
}

/// @nodoc
@JsonSerializable()
class _$TransactionImpl implements _Transaction {
  const _$TransactionImpl(
      {this.state = TransactionState.unknown,
      this.message = '',
      this.description = '',
      this.trade});

  factory _$TransactionImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransactionImplFromJson(json);

  @override
  @JsonKey()
  final TransactionState state;
  @override
  @JsonKey()
  final String message;
// 信息
  @override
  @JsonKey()
  final String description;
// 失败时的错误信息
  @override
  final Trade? trade;

  @override
  String toString() {
    return 'Transaction(state: $state, message: $message, description: $description, trade: $trade)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionImpl &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.trade, trade) || other.trade == trade));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, state, message, description, trade);

  @override
  Map<String, dynamic> toJson() {
    return _$$TransactionImplToJson(
      this,
    );
  }
}

abstract class _Transaction implements Transaction {
  const factory _Transaction(
      {final TransactionState state,
      final String message,
      final String description,
      final Trade? trade}) = _$TransactionImpl;

  factory _Transaction.fromJson(Map<String, dynamic> json) =
      _$TransactionImpl.fromJson;

  @override
  TransactionState get state;
  @override
  String get message;
  @override // 信息
  String get description;
  @override // 失败时的错误信息
  Trade? get trade;
}

Trade _$TradeFromJson(Map<String, dynamic> json) {
  return _Trade.fromJson(json);
}

/// @nodoc
mixin _$Trade {
  int get id => throw _privateConstructorUsedError;
  int get originalId => throw _privateConstructorUsedError;
  TradeEnv get env => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
}

/// @nodoc
@JsonSerializable()
class _$TradeImpl implements _Trade {
  const _$TradeImpl(
      {this.id = 0, this.originalId = 0, this.env = TradeEnv.unknown});

  factory _$TradeImpl.fromJson(Map<String, dynamic> json) =>
      _$$TradeImplFromJson(json);

  @override
  @JsonKey()
  final int id;
  @override
  @JsonKey()
  final int originalId;
  @override
  @JsonKey()
  final TradeEnv env;

  @override
  String toString() {
    return 'Trade(id: $id, originalId: $originalId, env: $env)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TradeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.originalId, originalId) ||
                other.originalId == originalId) &&
            (identical(other.env, env) || other.env == env));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, originalId, env);

  @override
  Map<String, dynamic> toJson() {
    return _$$TradeImplToJson(
      this,
    );
  }
}

abstract class _Trade implements Trade {
  const factory _Trade(
      {final int id, final int originalId, final TradeEnv env}) = _$TradeImpl;

  factory _Trade.fromJson(Map<String, dynamic> json) = _$TradeImpl.fromJson;

  @override
  int get id;
  @override
  int get originalId;
  @override
  TradeEnv get env;
}

EligibleResult _$EligibleResultFromJson(Map<String, dynamic> json) {
  return _EligibleOffer.fromJson(json);
}

/// @nodoc
mixin _$EligibleResult {
  bool get state => throw _privateConstructorUsedError;
  bool get offer => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  String get details => throw _privateConstructorUsedError;
  String get productId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
}

/// @nodoc
@JsonSerializable()
class _$EligibleOfferImpl implements _EligibleOffer {
  const _$EligibleOfferImpl(
      {this.state = false,
      this.offer = false,
      this.message = '',
      this.details = '',
      this.productId = ''});

  factory _$EligibleOfferImpl.fromJson(Map<String, dynamic> json) =>
      _$$EligibleOfferImplFromJson(json);

  @override
  @JsonKey()
  final bool state;
  @override
  @JsonKey()
  final bool offer;
  @override
  @JsonKey()
  final String message;
  @override
  @JsonKey()
  final String details;
  @override
  @JsonKey()
  final String productId;

  @override
  String toString() {
    return 'EligibleResult(state: $state, offer: $offer, message: $message, details: $details, productId: $productId)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EligibleOfferImpl &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.offer, offer) || other.offer == offer) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.details, details) || other.details == details) &&
            (identical(other.productId, productId) ||
                other.productId == productId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, state, offer, message, details, productId);

  @override
  Map<String, dynamic> toJson() {
    return _$$EligibleOfferImplToJson(
      this,
    );
  }
}

abstract class _EligibleOffer implements EligibleResult {
  const factory _EligibleOffer(
      {final bool state,
      final bool offer,
      final String message,
      final String details,
      final String productId}) = _$EligibleOfferImpl;

  factory _EligibleOffer.fromJson(Map<String, dynamic> json) =
      _$EligibleOfferImpl.fromJson;

  @override
  bool get state;
  @override
  bool get offer;
  @override
  String get message;
  @override
  String get details;
  @override
  String get productId;
}

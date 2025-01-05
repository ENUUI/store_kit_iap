// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TransactionList _$TransactionListFromJson(Map<String, dynamic> json) {
  return _TransactionList.fromJson(json);
}

/// @nodoc
mixin _$TransactionList {
  List<Transaction>? get data => throw _privateConstructorUsedError;

  /// Serializes this TransactionList to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
}

/// @nodoc
@JsonSerializable()
class _$TransactionListImpl implements _TransactionList {
  const _$TransactionListImpl(
      {final List<Transaction>? data = const <Transaction>[]})
      : _data = data;

  factory _$TransactionListImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransactionListImplFromJson(json);

  final List<Transaction>? _data;
  @override
  @JsonKey()
  List<Transaction>? get data {
    final value = _data;
    if (value == null) return null;
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'TransactionList(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionListImpl &&
            const DeepCollectionEquality().equals(other._data, _data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_data));

  @override
  Map<String, dynamic> toJson() {
    return _$$TransactionListImplToJson(
      this,
    );
  }
}

abstract class _TransactionList implements TransactionList {
  const factory _TransactionList({final List<Transaction>? data}) =
      _$TransactionListImpl;

  factory _TransactionList.fromJson(Map<String, dynamic> json) =
      _$TransactionListImpl.fromJson;

  @override
  List<Transaction>? get data;
}

Transaction _$TransactionFromJson(Map<String, dynamic> json) {
  return _Transaction.fromJson(json);
}

/// @nodoc
mixin _$Transaction {
  int get id => throw _privateConstructorUsedError;
  int get originalId => throw _privateConstructorUsedError;
  String get productId => throw _privateConstructorUsedError; // 信息
  TransactionState get state => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError; // 信息
  String get description => throw _privateConstructorUsedError; // 失败时的错误信息
  TransactionEnv get env => throw _privateConstructorUsedError;

  /// Serializes this Transaction to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
}

/// @nodoc
@JsonSerializable()
class _$TransactionImpl implements _Transaction {
  const _$TransactionImpl(
      {this.id = 0,
      this.originalId = 0,
      this.productId = '',
      this.state = TransactionState.unknown,
      this.message = '',
      this.description = '',
      this.env = TransactionEnv.unknown});

  factory _$TransactionImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransactionImplFromJson(json);

  @override
  @JsonKey()
  final int id;
  @override
  @JsonKey()
  final int originalId;
  @override
  @JsonKey()
  final String productId;
// 信息
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
  @JsonKey()
  final TransactionEnv env;

  @override
  String toString() {
    return 'Transaction(id: $id, originalId: $originalId, productId: $productId, state: $state, message: $message, description: $description, env: $env)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.originalId, originalId) ||
                other.originalId == originalId) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.env, env) || other.env == env));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, originalId, productId, state, message, description, env);

  @override
  Map<String, dynamic> toJson() {
    return _$$TransactionImplToJson(
      this,
    );
  }
}

abstract class _Transaction implements Transaction {
  const factory _Transaction(
      {final int id,
      final int originalId,
      final String productId,
      final TransactionState state,
      final String message,
      final String description,
      final TransactionEnv env}) = _$TransactionImpl;

  factory _Transaction.fromJson(Map<String, dynamic> json) =
      _$TransactionImpl.fromJson;

  @override
  int get id;
  @override
  int get originalId;
  @override
  String get productId; // 信息
  @override
  TransactionState get state;
  @override
  String get message; // 信息
  @override
  String get description; // 失败时的错误信息
  @override
  TransactionEnv get env;
}

Result<T> _$ResultFromJson<T>(
    Map<String, dynamic> json, T Function(Object?) fromJsonT) {
  return _Result<T>.fromJson(json, fromJsonT);
}

/// @nodoc
mixin _$Result<T> {
  String get requestId => throw _privateConstructorUsedError; // 是否有资格
  SkiError? get error =>
      throw _privateConstructorUsedError; // 错误信息, 如果错误信息不为空，则代表请求失败
  T? get data => throw _privateConstructorUsedError;

  /// Serializes this Result to a JSON map.
  Map<String, dynamic> toJson(Object? Function(T) toJsonT) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
@JsonSerializable(genericArgumentFactories: true)
class _$ResultImpl<T> implements _Result<T> {
  const _$ResultImpl({this.requestId = '', this.error, this.data});

  factory _$ResultImpl.fromJson(
          Map<String, dynamic> json, T Function(Object?) fromJsonT) =>
      _$$ResultImplFromJson(json, fromJsonT);

  @override
  @JsonKey()
  final String requestId;
// 是否有资格
  @override
  final SkiError? error;
// 错误信息, 如果错误信息不为空，则代表请求失败
  @override
  final T? data;

  @override
  String toString() {
    return 'Result<$T>(requestId: $requestId, error: $error, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ResultImpl<T> &&
            (identical(other.requestId, requestId) ||
                other.requestId == requestId) &&
            (identical(other.error, error) || other.error == error) &&
            const DeepCollectionEquality().equals(other.data, data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, requestId, error, const DeepCollectionEquality().hash(data));

  @override
  Map<String, dynamic> toJson(Object? Function(T) toJsonT) {
    return _$$ResultImplToJson<T>(this, toJsonT);
  }
}

abstract class _Result<T> implements Result<T> {
  const factory _Result(
      {final String requestId,
      final SkiError? error,
      final T? data}) = _$ResultImpl<T>;

  factory _Result.fromJson(
          Map<String, dynamic> json, T Function(Object?) fromJsonT) =
      _$ResultImpl<T>.fromJson;

  @override
  String get requestId; // 是否有资格
  @override
  SkiError? get error; // 错误信息, 如果错误信息不为空，则代表请求失败
  @override
  T? get data;
}

SkiError _$SkiErrorFromJson(Map<String, dynamic> json) {
  return _SkiError.fromJson(json);
}

/// @nodoc
mixin _$SkiError {
  int get code => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  String get details => throw _privateConstructorUsedError;

  /// Serializes this SkiError to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
}

/// @nodoc
@JsonSerializable()
class _$SkiErrorImpl implements _SkiError {
  const _$SkiErrorImpl(
      {this.code = 0, this.message = '未知错误', this.details = ''});

  factory _$SkiErrorImpl.fromJson(Map<String, dynamic> json) =>
      _$$SkiErrorImplFromJson(json);

  @override
  @JsonKey()
  final int code;
  @override
  @JsonKey()
  final String message;
  @override
  @JsonKey()
  final String details;

  @override
  String toString() {
    return 'SkiError(code: $code, message: $message, details: $details)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SkiErrorImpl &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.details, details) || other.details == details));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, code, message, details);

  @override
  Map<String, dynamic> toJson() {
    return _$$SkiErrorImplToJson(
      this,
    );
  }
}

abstract class _SkiError implements SkiError {
  const factory _SkiError(
      {final int code,
      final String message,
      final String details}) = _$SkiErrorImpl;

  factory _SkiError.fromJson(Map<String, dynamic> json) =
      _$SkiErrorImpl.fromJson;

  @override
  int get code;
  @override
  String get message;
  @override
  String get details;
}

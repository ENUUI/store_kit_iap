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

TransactionList _$TransactionListFromJson(Map<String, dynamic> json) {
  return _TransactionList.fromJson(json);
}

/// @nodoc
mixin _$TransactionList {
  List<Transaction>? get data => throw _privateConstructorUsedError;

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

  @JsonKey(ignore: true)
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

  @JsonKey(ignore: true)
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
  String get productId;
  @override // 信息
  TransactionState get state;
  @override
  String get message;
  @override // 信息
  String get description;
  @override // 失败时的错误信息
  TransactionEnv get env;
}

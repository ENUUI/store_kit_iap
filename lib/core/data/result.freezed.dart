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

  @JsonKey(ignore: true)
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
  String get requestId;
  @override // 是否有资格
  SkiError? get error;
  @override // 错误信息, 如果错误信息不为空，则代表请求失败
  T? get data;
}

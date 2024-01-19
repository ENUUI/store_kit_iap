// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'error.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

SkiError _$SkiErrorFromJson(Map<String, dynamic> json) {
  return _SkiError.fromJson(json);
}

/// @nodoc
mixin _$SkiError {
  String get message => throw _privateConstructorUsedError;
  String get details => throw _privateConstructorUsedError;
  String get requestId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
}

/// @nodoc
@JsonSerializable()
class _$SkiErrorImpl implements _SkiError {
  const _$SkiErrorImpl(
      {this.message = '未知错误', this.details = '', this.requestId = ''});

  factory _$SkiErrorImpl.fromJson(Map<String, dynamic> json) =>
      _$$SkiErrorImplFromJson(json);

  @override
  @JsonKey()
  final String message;
  @override
  @JsonKey()
  final String details;
  @override
  @JsonKey()
  final String requestId;

  @override
  String toString() {
    return 'SkiError(message: $message, details: $details, requestId: $requestId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SkiErrorImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.details, details) || other.details == details) &&
            (identical(other.requestId, requestId) ||
                other.requestId == requestId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, message, details, requestId);

  @override
  Map<String, dynamic> toJson() {
    return _$$SkiErrorImplToJson(
      this,
    );
  }
}

abstract class _SkiError implements SkiError {
  const factory _SkiError(
      {final String message,
      final String details,
      final String requestId}) = _$SkiErrorImpl;

  factory _SkiError.fromJson(Map<String, dynamic> json) =
      _$SkiErrorImpl.fromJson;

  @override
  String get message;
  @override
  String get details;
  @override
  String get requestId;
}

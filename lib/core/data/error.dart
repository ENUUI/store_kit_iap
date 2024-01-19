import 'package:freezed_annotation/freezed_annotation.dart';

part 'error.g.dart';

part 'error.freezed.dart';

@freezed
class SkiError with _$SkiError implements Exception {
  const factory SkiError({
    @Default('未知错误') final String message,
    @Default('') final String details,
    @Default('') final String requestId,
  }) = _SkiError;

  factory SkiError.fromJson(Map<String, dynamic> json) => _$SkiErrorFromJson(json);
}

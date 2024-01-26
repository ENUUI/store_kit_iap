import 'package:freezed_annotation/freezed_annotation.dart';

part 'error.g.dart';

part 'error.freezed.dart';

@freezed
class SkiError with _$SkiError implements Exception {
  const factory SkiError({
    @Default(0) final int code,
    @Default('未知错误') final String message,
    @Default('') final String details,
  }) = _SkiError;

  factory SkiError.fromJson(Map<String, dynamic> json) => _$SkiErrorFromJson(json);
}

extension SkiErrorExtra on SkiError {
  /// 是否是用户取消
  bool get isCancel => code == 499;
}

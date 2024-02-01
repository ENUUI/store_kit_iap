import 'package:flutter/services.dart';
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

  static SkiError fromError(Object error) {
    if (error is SkiError) {
      return error;
    } else if (error is PlatformException) {
      return SkiError(code: int.tryParse(error.code) ?? 400, message: error.message ?? '', details: error.details);
    } else if (error is MissingPluginException) {
      return const SkiError(code: 500, message: '未找到插件');
    } else {
      return SkiError(code: 500, message: '未知错误', details: error.toString());
    }
  }
}

extension SkiErrorExtra on SkiError {
  /// 是否是用户取消
  bool get isCancel => code == 499;

  /// 用户不适用优惠
  bool get isNotEligible => code == 4104;
}

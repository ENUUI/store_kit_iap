import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_kit_iap/core/data/error.dart';

part 'result.freezed.dart';

part 'result.g.dart';

typedef FromJson<T> = T Function(Object? json);

@Freezed(genericArgumentFactories: true)
class Result<T> with _$Result<T> {
  const factory Result({
    @Default('') final String requestId, // 是否有资格
    final SkiError? error, // 错误信息, 如果错误信息不为空，则代表请求失败
    final T? data,
  }) = _Result;

  factory Result.fromJson(Map<String, dynamic> json, FromJson<T> fromJsonT) => _$ResultFromJson(json, fromJsonT);
}

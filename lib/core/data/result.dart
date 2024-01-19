import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_kit_iap/core/data/error.dart';

import 'model.dart';

part 'result.freezed.dart';

part 'result.g.dart';

@freezed
class TransactionsResult with _$TransactionsResult {
  const factory TransactionsResult({
    @Default('') final String requestId, // 是否有资格
    @Default('') final String productId, // 是否有资格
    final SkiError? error, // 错误信息
    final List<Transaction>? transactions,
  }) = _TransactionsResult;

  factory TransactionsResult.fromJson(Map<String, dynamic> json) => _$TransactionsResultFromJson(json);
}

@freezed
class PurchaseResult with _$PurchaseResult {
  const factory PurchaseResult({
    @Default('') final String requestId, // 是否有资格
    @Default('') final String productId, // 是否有资格
    final SkiError? error, // 错误信息
    final Transaction? transaction,
  }) = _PurchaseResult;

  factory PurchaseResult.fromJson(Map<String, dynamic> json) => _$PurchaseResultFromJson(json);
}

@freezed
class EligibleResult with _$EligibleResult {
  const factory EligibleResult({
    @Default('') final String requestId, // 是否有资格
    @Default('') final String productId, // 是否有资格
    @Default(false) final bool offer, // 是否享受优惠
    final SkiError? error, // 错误信息
  }) = _EligibleResult;

  factory EligibleResult.fromJson(Map<String, dynamic> json) => _$EligibleResultFromJson(json);
}

@freezed
class ProductResult {
  factory ProductResult({
    @Default('') final String requestId, // 是否有资格
    @Default('') final String productId, // 是否有资格
    @Default(<String, dynamic>{}) final Map<String, dynamic> product, // 是否享受优惠
    final SkiError? error, // 错误信息
  }) = _ProductResult;

  factory ProductResult.fromJson(Map<String, dynamic> json) => _$ProductResultFromJson(json);
}

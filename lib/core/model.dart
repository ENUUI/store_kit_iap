import 'package:freezed_annotation/freezed_annotation.dart';

part 'model.freezed.dart';

part 'model.g.dart';

enum TransactionState {
  /// 支付成功
  @JsonValue('verified')
  verified,

  /// 失败
  ///  - 获取商品失败
  ///  - 拉起支付失败
  ///  - 支付失败
  @JsonValue('unverified')
  unverified,

  /// 用户取消了
  @JsonValue('cancelled')
  cancelled,

  /// 待处理
  @JsonValue('pending')
  pending,
  @JsonValue('unknown')
  unknown,
}

extension TransactionStateExt on TransactionState {
  bool get isVerified => this == TransactionState.verified;

  bool get isUnverified => this == TransactionState.unverified;

  bool get isCancelled => this == TransactionState.cancelled;

  bool get isPending => this == TransactionState.pending;

  bool get isUnknown => this == TransactionState.unknown;
}

@freezed
class Transaction with _$Transaction {
  const factory Transaction({
    @Default(TransactionState.unknown) final TransactionState state,
    @Default('') final String message, // 信息
    @Default('') final String description, // 失败时的错误信息
    final Trade? trade,
  }) = _Transaction;

  factory Transaction.fromJson(Map<String, dynamic> json) => _$TransactionFromJson(json);
}

enum TradeEnv {
  @JsonValue('sandbox')
  sandbox,
  @JsonValue('production')
  production,
  @JsonValue('xcode')
  xcode,
  @JsonValue('unknown')
  unknown,
}

@freezed
class Trade with _$Trade {
  const factory Trade({
    @Default(0) final int id,
    @Default(0) final int originalId,
    @Default(TradeEnv.unknown) final TradeEnv env,
  }) = _Trade;

  factory Trade.fromJson(Map<String, dynamic> json) => _$TradeFromJson(json);
}

@JsonSerializable(createFactory: false, createToJson: true)
class PurchaseOpt {
  /// Product id from app store connect
  final String productId;

  /// Quantity of the product
  final int? quantity;

  /// UUID of the transaction
  final String? uuid;

  /// Extra data
  final Map<String, String>? extra;

  PurchaseOpt({
    required this.productId,
    this.quantity,
    this.uuid,
    this.extra,
  });

  Map<String, dynamic> toJson() => _$PurchaseOptToJson(this);
}

@freezed
class EligibleResult with _$EligibleResult {
  const factory EligibleResult({
    @Default('') final String requestId, // 是否有资格
    @Default('') final String productId, // 是否有资格
    @Default(false) final bool offer, // 是否享受优惠
    @Default(false) final bool state, // 请求是否成功
    @Default('') final String message, // 错误信息
    @Default('') final String details, // 错误详情
  }) = _EligibleResult;

  factory EligibleResult.fromJson(Map<String, dynamic> json) => _$EligibleResultFromJson(json);
}

@freezed
class ProductResult {
  factory ProductResult({
    @Default('') final String requestId, // 是否有资格
    @Default('') final String productId, // 是否有资格
    @Default(<String, dynamic>{}) final Map<String,dynamic> product, // 是否享受优惠
    @Default(false) final bool state, // 请求是否成功
    @Default('') final String message, // 错误信息
    @Default('') final String details, // 错误详情
  }) = _ProductResult;

  factory ProductResult.fromJson(Map<String, dynamic> json) => _$ProductResultFromJson(json);
}

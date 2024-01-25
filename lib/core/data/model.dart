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

enum TransactionEnv {
  @JsonValue('sandbox')
  sandbox,
  @JsonValue('production')
  production,
  @JsonValue('xcode')
  xcode,
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
class TransactionList with _$TransactionList {
  const factory TransactionList({
    @Default(<Transaction>[]) final List<Transaction>? data,
  }) = _TransactionList;

  factory TransactionList.fromJson(Map<String, dynamic> json) => _$TransactionListFromJson(json);
}

@freezed
class Transaction with _$Transaction {
  const factory Transaction({
    @Default(0) final int id,
    @Default(0) final int originalId,
    @Default(TransactionState.unknown) final TransactionState state,
    @Default('') final String message, // 信息
    @Default('') final String description, // 失败时的错误信息
    @Default(TransactionEnv.unknown) final TransactionEnv env, // 生成订单的环境
  }) = _Transaction;

  factory Transaction.fromJson(Map<String, dynamic> json) => _$TransactionFromJson(json);
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

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
  factory Transaction({
    @Default(TransactionState.unknown) final TransactionState state,
    @Default('') final String message, // 信息
    @Default('') final String description, // 失败时的错误信息
    @Default(0) final int transactionId, // 交易 id，当 state 为 verified 时有效
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

  final Promotion? promotion;

  /// Extra data
  final Map<String, String>? extra;

  PurchaseOpt({
    required this.productId,
    this.quantity,
    this.promotion,
    this.uuid,
    this.extra,
  });

  Map<String, dynamic> toJson() => _$PurchaseOptToJson(this);
}

@JsonSerializable(createFactory: false, createToJson: true)
class Promotion {
  Promotion({
    required this.offerId,
    required this.keyID,
    required this.nonce,
    required this.signature,
    required this.timestamp,
  });

  final String offerId;
  final String keyID;
  final String nonce;
  final String signature;
  final int timestamp;

  Map<String, dynamic> toJson() => _$PromotionToJson(this);
}

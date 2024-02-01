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
    @Default('') final String productId, // 信息
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

  ArgumentError? validate() {
    if (productId.isEmpty) {
      return ArgumentError('productId is empty');
    }
    if (quantity != null && quantity! <= 0) {
      return ArgumentError('quantity must be greater than 0');
    }
    if (promotion != null) {
      final error = promotion!.validate();
      if (error != null) {
        return error;
      }
    }
    return null;
  }

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

  ArgumentError? validate() {
    if (offerId.isEmpty) {
      return ArgumentError('offerId is empty');
    }
    if (keyID.isEmpty) {
      return ArgumentError('keyID is empty');
    }
    if (nonce.isEmpty) {
      return ArgumentError('nonce is empty');
    }
    if (signature.isEmpty) {
      return ArgumentError('signature is empty');
    }
    if (timestamp <= 0) {
      return ArgumentError('timestamp must be greater than 0');
    }
    return null;
  }

  Map<String, dynamic> toJson() => _$PromotionToJson(this);
}

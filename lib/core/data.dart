import 'package:flutter/services.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'gen/data.freezed.dart';

part 'gen/data.g.dart';

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

  factory TransactionList.fromJson(Map<String, dynamic> json) =>
      _$TransactionListFromJson(json);
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

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);
}

@JsonSerializable(createFactory: false, createToJson: true)
class PurchaseOpt {
  /// Product id from app store connect
  final String productId;

  /// Quantity of the product
  final int? quantity;

  /// UUID of the transaction
  final String? uuid;

  /// 参加促销优惠（非推介促销优惠）时必填
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

/// https://developer.apple.com/documentation/storekit/implementing-promotional-offers-in-your-app
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

typedef FromJson<T> = T Function(Object? json);

@Freezed(genericArgumentFactories: true)
class Result<T> with _$Result<T> {
  const factory Result({
    @Default('') final String requestId, // 是否有资格
    final SkiError? error, // 错误信息, 如果错误信息不为空，则代表请求失败
    final T? data,
  }) = _Result;

  factory Result.fromJson(Map<String, dynamic> json, FromJson<T> fromJsonT) =>
      _$ResultFromJson(json, fromJsonT);
}

@freezed
class SkiError with _$SkiError implements Exception {
  const factory SkiError({
    @Default(0) final int code,
    @Default('未知错误') final String message,
    @Default('') final String details,
  }) = _SkiError;

  factory SkiError.fromJson(Map<String, dynamic> json) =>
      _$SkiErrorFromJson(json);

  static SkiError fromError(Object error) {
    if (error is SkiError) {
      return error;
    } else if (error is PlatformException) {
      return SkiError(
          code: int.tryParse(error.code) ?? 400,
          message: error.message ?? '',
          details: error.details);
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

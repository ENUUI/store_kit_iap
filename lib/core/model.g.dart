// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$PurchaseOptToJson(PurchaseOpt instance) =>
    <String, dynamic>{
      'product_id': instance.productId,
      'quantity': instance.quantity,
      'uuid': instance.uuid,
      'extra': instance.extra,
    };

_$TransactionImpl _$$TransactionImplFromJson(Map<String, dynamic> json) =>
    _$TransactionImpl(
      state: $enumDecodeNullable(_$TransactionStateEnumMap, json['state']) ??
          TransactionState.unknown,
      message: json['message'] as String? ?? '',
      description: json['description'] as String? ?? '',
      trade: json['trade'] == null
          ? null
          : Trade.fromJson(json['trade'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$TransactionImplToJson(_$TransactionImpl instance) =>
    <String, dynamic>{
      'state': _$TransactionStateEnumMap[instance.state]!,
      'message': instance.message,
      'description': instance.description,
      'trade': instance.trade?.toJson(),
    };

const _$TransactionStateEnumMap = {
  TransactionState.verified: 'verified',
  TransactionState.unverified: 'unverified',
  TransactionState.cancelled: 'cancelled',
  TransactionState.pending: 'pending',
  TransactionState.unknown: 'unknown',
};

_$TradeImpl _$$TradeImplFromJson(Map<String, dynamic> json) => _$TradeImpl(
      id: json['id'] as int? ?? 0,
      originalId: json['original_id'] as int? ?? 0,
      env: $enumDecodeNullable(_$TradeEnvEnumMap, json['env']) ??
          TradeEnv.unknown,
    );

Map<String, dynamic> _$$TradeImplToJson(_$TradeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'original_id': instance.originalId,
      'env': _$TradeEnvEnumMap[instance.env]!,
    };

const _$TradeEnvEnumMap = {
  TradeEnv.sandbox: 'sandbox',
  TradeEnv.production: 'production',
  TradeEnv.xcode: 'xcode',
  TradeEnv.unknown: 'unknown',
};

_$EligibleResultImpl _$$EligibleResultImplFromJson(Map<String, dynamic> json) =>
    _$EligibleResultImpl(
      requestId: json['request_id'] as String? ?? '',
      productId: json['product_id'] as String? ?? '',
      offer: json['offer'] as bool? ?? false,
      state: json['state'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      details: json['details'] as String? ?? '',
    );

Map<String, dynamic> _$$EligibleResultImplToJson(
        _$EligibleResultImpl instance) =>
    <String, dynamic>{
      'request_id': instance.requestId,
      'product_id': instance.productId,
      'offer': instance.offer,
      'state': instance.state,
      'message': instance.message,
      'details': instance.details,
    };

_$ProductResultImpl _$$ProductResultImplFromJson(Map<String, dynamic> json) =>
    _$ProductResultImpl(
      requestId: json['request_id'] as String? ?? '',
      productId: json['product_id'] as String? ?? '',
      product:
          json['product'] as Map<String, dynamic>? ?? const <String, dynamic>{},
      state: json['state'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      details: json['details'] as String? ?? '',
    );

Map<String, dynamic> _$$ProductResultImplToJson(_$ProductResultImpl instance) =>
    <String, dynamic>{
      'request_id': instance.requestId,
      'product_id': instance.productId,
      'product': instance.product,
      'state': instance.state,
      'message': instance.message,
      'details': instance.details,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$PurchaseOptToJson(PurchaseOpt instance) =>
    <String, dynamic>{
      'product_id': instance.productId,
      'quantity': instance.quantity,
      'uuid': instance.uuid,
      'promotion': instance.promotion?.toJson(),
      'extra': instance.extra,
    };

Map<String, dynamic> _$PromotionToJson(Promotion instance) => <String, dynamic>{
      'offer_id': instance.offerId,
      'key_i_d': instance.keyID,
      'nonce': instance.nonce,
      'signature': instance.signature,
      'timestamp': instance.timestamp,
    };

_$TransactionListImpl _$$TransactionListImplFromJson(
        Map<String, dynamic> json) =>
    _$TransactionListImpl(
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => Transaction.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <Transaction>[],
    );

Map<String, dynamic> _$$TransactionListImplToJson(
        _$TransactionListImpl instance) =>
    <String, dynamic>{
      'data': instance.data?.map((e) => e.toJson()).toList(),
    };

_$TransactionImpl _$$TransactionImplFromJson(Map<String, dynamic> json) =>
    _$TransactionImpl(
      id: (json['id'] as num?)?.toInt() ?? 0,
      originalId: (json['original_id'] as num?)?.toInt() ?? 0,
      productId: json['product_id'] as String? ?? '',
      state: $enumDecodeNullable(_$TransactionStateEnumMap, json['state']) ??
          TransactionState.unknown,
      message: json['message'] as String? ?? '',
      description: json['description'] as String? ?? '',
      env: $enumDecodeNullable(_$TransactionEnvEnumMap, json['env']) ??
          TransactionEnv.unknown,
    );

Map<String, dynamic> _$$TransactionImplToJson(_$TransactionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'original_id': instance.originalId,
      'product_id': instance.productId,
      'state': _$TransactionStateEnumMap[instance.state]!,
      'message': instance.message,
      'description': instance.description,
      'env': _$TransactionEnvEnumMap[instance.env]!,
    };

const _$TransactionStateEnumMap = {
  TransactionState.verified: 'verified',
  TransactionState.unverified: 'unverified',
  TransactionState.unknown: 'unknown',
};

const _$TransactionEnvEnumMap = {
  TransactionEnv.sandbox: 'sandbox',
  TransactionEnv.production: 'production',
  TransactionEnv.xcode: 'xcode',
  TransactionEnv.unknown: 'unknown',
};

_$ResultImpl<T> _$$ResultImplFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    _$ResultImpl<T>(
      requestId: json['request_id'] as String? ?? '',
      error: json['error'] == null
          ? null
          : SkiError.fromJson(json['error'] as Map<String, dynamic>),
      data: _$nullableGenericFromJson(json['data'], fromJsonT),
    );

Map<String, dynamic> _$$ResultImplToJson<T>(
  _$ResultImpl<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'request_id': instance.requestId,
      'error': instance.error?.toJson(),
      'data': _$nullableGenericToJson(instance.data, toJsonT),
    };

T? _$nullableGenericFromJson<T>(
  Object? input,
  T Function(Object? json) fromJson,
) =>
    input == null ? null : fromJson(input);

Object? _$nullableGenericToJson<T>(
  T? input,
  Object? Function(T value) toJson,
) =>
    input == null ? null : toJson(input);

_$SkiErrorImpl _$$SkiErrorImplFromJson(Map<String, dynamic> json) =>
    _$SkiErrorImpl(
      code: (json['code'] as num?)?.toInt() ?? 0,
      message: json['message'] as String? ?? '未知错误',
      details: json['details'] as String? ?? '',
    );

Map<String, dynamic> _$$SkiErrorImplToJson(_$SkiErrorImpl instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'details': instance.details,
    };

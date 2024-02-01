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
      id: json['id'] as int? ?? 0,
      originalId: json['original_id'] as int? ?? 0,
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

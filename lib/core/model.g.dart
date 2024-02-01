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

_$TransactionImpl _$$TransactionImplFromJson(Map<String, dynamic> json) =>
    _$TransactionImpl(
      state: $enumDecodeNullable(_$TransactionStateEnumMap, json['state']) ??
          TransactionState.unknown,
      message: json['message'] as String? ?? '',
      description: json['description'] as String? ?? '',
      transactionId: json['transaction_id'] as int? ?? 0,
    );

Map<String, dynamic> _$$TransactionImplToJson(_$TransactionImpl instance) =>
    <String, dynamic>{
      'state': _$TransactionStateEnumMap[instance.state]!,
      'message': instance.message,
      'description': instance.description,
      'transaction_id': instance.transactionId,
    };

const _$TransactionStateEnumMap = {
  TransactionState.verified: 'verified',
  TransactionState.unverified: 'unverified',
  TransactionState.cancelled: 'cancelled',
  TransactionState.pending: 'pending',
  TransactionState.unknown: 'unknown',
};

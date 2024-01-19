// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TransactionsResultImpl _$$TransactionsResultImplFromJson(
        Map<String, dynamic> json) =>
    _$TransactionsResultImpl(
      requestId: json['request_id'] as String? ?? '',
      productId: json['product_id'] as String? ?? '',
      error: json['error'] == null
          ? null
          : SkiError.fromJson(json['error'] as Map<String, dynamic>),
      transactions: (json['transactions'] as List<dynamic>?)
          ?.map((e) => Transaction.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$TransactionsResultImplToJson(
        _$TransactionsResultImpl instance) =>
    <String, dynamic>{
      'request_id': instance.requestId,
      'product_id': instance.productId,
      'error': instance.error?.toJson(),
      'transactions': instance.transactions?.map((e) => e.toJson()).toList(),
    };

_$PurchaseResultImpl _$$PurchaseResultImplFromJson(Map<String, dynamic> json) =>
    _$PurchaseResultImpl(
      requestId: json['request_id'] as String? ?? '',
      productId: json['product_id'] as String? ?? '',
      error: json['error'] == null
          ? null
          : SkiError.fromJson(json['error'] as Map<String, dynamic>),
      transaction: json['transaction'] == null
          ? null
          : Transaction.fromJson(json['transaction'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$PurchaseResultImplToJson(
        _$PurchaseResultImpl instance) =>
    <String, dynamic>{
      'request_id': instance.requestId,
      'product_id': instance.productId,
      'error': instance.error?.toJson(),
      'transaction': instance.transaction?.toJson(),
    };

_$EligibleResultImpl _$$EligibleResultImplFromJson(Map<String, dynamic> json) =>
    _$EligibleResultImpl(
      requestId: json['request_id'] as String? ?? '',
      productId: json['product_id'] as String? ?? '',
      offer: json['offer'] as bool? ?? false,
      error: json['error'] == null
          ? null
          : SkiError.fromJson(json['error'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$EligibleResultImplToJson(
        _$EligibleResultImpl instance) =>
    <String, dynamic>{
      'request_id': instance.requestId,
      'product_id': instance.productId,
      'offer': instance.offer,
      'error': instance.error?.toJson(),
    };

_$ProductResultImpl _$$ProductResultImplFromJson(Map<String, dynamic> json) =>
    _$ProductResultImpl(
      requestId: json['request_id'] as String? ?? '',
      productId: json['product_id'] as String? ?? '',
      product:
          json['product'] as Map<String, dynamic>? ?? const <String, dynamic>{},
      error: json['error'] == null
          ? null
          : SkiError.fromJson(json['error'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$ProductResultImplToJson(_$ProductResultImpl instance) =>
    <String, dynamic>{
      'request_id': instance.requestId,
      'product_id': instance.productId,
      'product': instance.product,
      'error': instance.error?.toJson(),
    };

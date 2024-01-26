// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SkiErrorImpl _$$SkiErrorImplFromJson(Map<String, dynamic> json) =>
    _$SkiErrorImpl(
      code: json['code'] as int? ?? 0,
      message: json['message'] as String? ?? '未知错误',
      details: json['details'] as String? ?? '',
    );

Map<String, dynamic> _$$SkiErrorImplToJson(_$SkiErrorImpl instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'details': instance.details,
    };

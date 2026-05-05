// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'duplicate_match_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DuplicateMatchDto _$DuplicateMatchDtoFromJson(Map<String, dynamic> json) =>
    DuplicateMatchDto(
      matchType: json['match_type'] as String?,
      confidence: (json['confidence'] as num?)?.toDouble(),
      transactionId: (json['transaction_id'] as num?)?.toInt(),
      transactionDate: json['transaction_date'] as String?,
      transactionType: json['transaction_type'] as String?,
      transactionAmount: (json['transaction_amount'] as num?)?.toDouble(),
      transactionDescription: json['transaction_description'] as String?,
    );

Map<String, dynamic> _$DuplicateMatchDtoToJson(DuplicateMatchDto instance) =>
    <String, dynamic>{
      'match_type': instance.matchType,
      'confidence': instance.confidence,
      'transaction_id': instance.transactionId,
      'transaction_date': instance.transactionDate,
      'transaction_type': instance.transactionType,
      'transaction_amount': instance.transactionAmount,
      'transaction_description': instance.transactionDescription,
    };

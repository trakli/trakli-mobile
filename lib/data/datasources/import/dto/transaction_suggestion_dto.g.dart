// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_suggestion_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionSuggestionDto _$TransactionSuggestionDtoFromJson(
        Map<String, dynamic> json) =>
    TransactionSuggestionDto(
      documentType: json['document_type'] as String,
      amount: _parseAmountNullable(json['amount']),
      currency: json['currency'] as String?,
      type: json['type'] as String?,
      party: json['party'] as String?,
      wallet: json['wallet'] as String?,
      category: json['category'] as String?,
      description: json['description'] as String?,
      date: json['date'] as String?,
      confidence: (json['confidence'] as num?)?.toDouble(),
      duplicate: json['duplicate'] == null
          ? null
          : DuplicateMatchDto.fromJson(
              json['duplicate'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TransactionSuggestionDtoToJson(
        TransactionSuggestionDto instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'currency': instance.currency,
      'type': instance.type,
      'party': instance.party,
      'wallet': instance.wallet,
      'category': instance.category,
      'description': instance.description,
      'date': instance.date,
      'confidence': instance.confidence,
      'document_type': instance.documentType,
      'duplicate': instance.duplicate?.toJson(),
    };

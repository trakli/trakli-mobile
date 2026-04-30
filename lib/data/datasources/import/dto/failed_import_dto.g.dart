// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'failed_import_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FailedImportDto _$FailedImportDtoFromJson(Map<String, dynamic> json) =>
    FailedImportDto(
      id: (json['id'] as num).toInt(),
      fileImportId: (json['file_import_id'] as num).toInt(),
      amount: json['amount'] as String?,
      currency: json['currency'] as String?,
      type: json['type'] as String?,
      party: json['party'] as String?,
      wallet: json['wallet'] as String?,
      category: json['category'] as String?,
      description: json['description'] as String?,
      date: json['date'] as String?,
      reason: json['reason'] as String?,
    );

Map<String, dynamic> _$FailedImportDtoToJson(FailedImportDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'file_import_id': instance.fileImportId,
      'amount': instance.amount,
      'currency': instance.currency,
      'type': instance.type,
      'party': instance.party,
      'wallet': instance.wallet,
      'category': instance.category,
      'description': instance.description,
      'date': instance.date,
      'reason': instance.reason,
    };

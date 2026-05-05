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
      walletId: (json['wallet_id'] as num?)?.toInt(),
      partyId: (json['party_id'] as num?)?.toInt(),
      categoryId: (json['category_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$FailedImportDtoToJson(FailedImportDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'file_import_id': instance.fileImportId,
      if (instance.amount case final value?) 'amount': value,
      if (instance.currency case final value?) 'currency': value,
      if (instance.type case final value?) 'type': value,
      if (instance.party case final value?) 'party': value,
      if (instance.wallet case final value?) 'wallet': value,
      if (instance.category case final value?) 'category': value,
      if (instance.description case final value?) 'description': value,
      if (instance.date case final value?) 'date': value,
      if (instance.reason case final value?) 'reason': value,
      if (instance.walletId case final value?) 'wallet_id': value,
      if (instance.partyId case final value?) 'party_id': value,
      if (instance.categoryId case final value?) 'category_id': value,
    };

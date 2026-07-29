// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_complete_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionCompleteDto _$TransactionCompleteDtoFromJson(
        Map<String, dynamic> json) =>
    TransactionCompleteDto(
      transaction: const TransactionConverter()
          .fromJson(json['transaction'] as Map<String, dynamic>),
      categories: (json['categories'] as List<dynamic>?)
              ?.map((e) =>
                  const CategoryConverter().fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      wallet: const WalletConverter()
          .fromJson(json['wallet'] as Map<String, dynamic>),
      party: const PartyConverter()
          .fromJson(json['party'] as Map<String, dynamic>?),
      group: const GroupConverter()
          .fromJson(json['group'] as Map<String, dynamic>?),
      files: json['files'] == null
          ? []
          : const MediaFileListConverter().fromJson(json['files'] as List),
    );

Map<String, dynamic> _$TransactionCompleteDtoToJson(
        TransactionCompleteDto instance) =>
    <String, dynamic>{
      'transaction': const TransactionConverter().toJson(instance.transaction),
      'categories':
          instance.categories.map(const CategoryConverter().toJson).toList(),
      'wallet': const WalletConverter().toJson(instance.wallet),
      'party': const PartyConverter().toJson(instance.party),
      'group': const GroupConverter().toJson(instance.group),
      'files': const MediaFileListConverter().toJson(instance.files),
    };

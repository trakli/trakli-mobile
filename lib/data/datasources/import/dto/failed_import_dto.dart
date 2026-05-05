import 'package:json_annotation/json_annotation.dart';
import 'package:trakli/domain/entities/import/failed_import_entity.dart';

part 'failed_import_dto.g.dart';

@JsonSerializable(includeIfNull: false)
class FailedImportDto {
  final int id;
  @JsonKey(name: 'file_import_id')
  final int fileImportId;
  final String? amount;
  final String? currency;
  final String? type;
  final String? party;
  final String? wallet;
  final String? category;
  final String? description;
  final String? date;
  final String? reason;

  /// Optional existing-record IDs. The fix endpoint prefers these over the
  /// name strings when present; auto-create flags only kick in when the ID
  /// for the corresponding resource is omitted.
  @JsonKey(name: 'wallet_id')
  final int? walletId;
  @JsonKey(name: 'party_id')
  final int? partyId;
  @JsonKey(name: 'category_id')
  final int? categoryId;

  const FailedImportDto({
    required this.id,
    required this.fileImportId,
    this.amount,
    this.currency,
    this.type,
    this.party,
    this.wallet,
    this.category,
    this.description,
    this.date,
    this.reason,
    this.walletId,
    this.partyId,
    this.categoryId,
  });

  factory FailedImportDto.fromJson(Map<String, dynamic> json) =>
      _$FailedImportDtoFromJson(json);

  Map<String, dynamic> toJson() => _$FailedImportDtoToJson(this);

  factory FailedImportDto.fromEntity(FailedImportEntity entity) =>
      FailedImportDto(
        id: entity.id,
        fileImportId: entity.fileImportId,
        amount: entity.amount,
        currency: entity.currency,
        type: entity.type,
        party: entity.party,
        wallet: entity.wallet,
        category: entity.category,
        description: entity.description,
        date: entity.date,
        reason: entity.reason,
        walletId: entity.walletId,
        partyId: entity.partyId,
        categoryId: entity.categoryId,
      );

  FailedImportEntity toEntity() => FailedImportEntity(
        id: id,
        fileImportId: fileImportId,
        amount: amount,
        currency: currency,
        type: type,
        party: party,
        wallet: wallet,
        category: category,
        description: description,
        date: date,
        reason: reason,
        walletId: walletId,
        partyId: partyId,
        categoryId: categoryId,
      );
}

import 'package:json_annotation/json_annotation.dart';
import 'package:trakli/domain/entities/import/transaction_suggestion_entity.dart';
import 'package:trakli/presentation/utils/enums.dart';

part 'confirm_accepted_item_dto.g.dart';

/// Outgoing shape for an item in `POST /import/confirm`'s `accepted` array.
@JsonSerializable(includeIfNull: false, createFactory: false)
class ConfirmAcceptedItemDto {
  final int index;
  @JsonKey(name: 'wallet_id')
  final int? walletId;
  @JsonKey(name: 'party_id')
  final int? partyId;
  @JsonKey(name: 'category_id')
  final int? categoryId;
  final double? amount;
  final TransactionType? type;
  final String? description;
  final String? date;

  const ConfirmAcceptedItemDto({
    required this.index,
    this.walletId,
    this.partyId,
    this.categoryId,
    this.amount,
    this.type,
    this.description,
    this.date,
  });

  Map<String, dynamic> toJson() => _$ConfirmAcceptedItemDtoToJson(this);

  factory ConfirmAcceptedItemDto.fromAccepted(
    int index,
    TransactionSuggestionEntity entity,
  ) =>
      ConfirmAcceptedItemDto(
        index: index,
        walletId: entity.walletId,
        partyId: entity.partyId,
        categoryId: entity.categoryId,
        amount: entity.amount,
        type: entity.type,
        description: entity.description,
        date: entity.date,
      );
}

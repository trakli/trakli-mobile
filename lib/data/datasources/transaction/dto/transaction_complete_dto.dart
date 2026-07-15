import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trakli/core/utils/date_util.dart';
import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/data/datasources/media_file/dto/media_file_dto.dart';
import 'package:trakli/data/datasources/transaction/dto/transaction_dto.dart';
import 'package:trakli/data/datasources/wallet/dtos/wallet_dto.dart';

part 'transaction_complete_dto.freezed.dart';
part 'transaction_complete_dto.g.dart';

class MediaFileListConverter
    implements JsonConverter<List<MediaFile>, List<dynamic>> {
  const MediaFileListConverter();

  @override
  List<MediaFile> fromJson(List<dynamic> list) {
    return list
        .map((e) => MediaFile.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  List<dynamic> toJson(List<MediaFile> list) {
    return list.map((e) => e.toJson()).toList();
  }
}

class TransactionConverter
    implements JsonConverter<Transaction, Map<String, dynamic>> {
  const TransactionConverter();

  @override
  Transaction fromJson(Map<String, dynamic> json) {
    return Transaction.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(Transaction transaction) {
    return transaction.toJson();
  }
}

class CategoryConverter
    implements JsonConverter<Category, Map<String, dynamic>> {
  const CategoryConverter();

  @override
  Category fromJson(Map<String, dynamic> json) {
    return Category.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(Category category) {
    return category.toJson();
  }
}

class WalletConverter implements JsonConverter<Wallet, Map<String, dynamic>> {
  const WalletConverter();

  @override
  Wallet fromJson(Map<String, dynamic> json) {
    return Wallet.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(Wallet wallet) {
    return wallet.toJson();
  }
}

class PartyConverter implements JsonConverter<Party?, Map<String, dynamic>?> {
  const PartyConverter();

  @override
  Party? fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return null;
    }
    return Party.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(Party? party) {
    if (party == null) {
      return null;
    }
    return party.toJson();
  }
}

class GroupConverter implements JsonConverter<Group?, Map<String, dynamic>?> {
  const GroupConverter();

  @override
  Group? fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return null;
    }
    return Group.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(Group? group) {
    if (group == null) {
      return null;
    }
    return group.toJson();
  }
}

@freezed
@JsonSerializable(explicitToJson: true)
class TransactionCompleteDto with _$TransactionCompleteDto {
  const TransactionCompleteDto._();

  const factory TransactionCompleteDto({
    @TransactionConverter() required Transaction transaction,
    @CategoryConverter() @Default([]) List<Category> categories,
    @WalletConverter() required Wallet wallet,
    @PartyConverter() Party? party,
    @GroupConverter() Group? group,
    @MediaFileListConverter() @Default([]) List<MediaFile> files,
  }) = _TransactionCompleteDto;

  factory TransactionCompleteDto.fromTransaction({
    @TransactionConverter() required Transaction transaction,
    @CategoryConverter() @Default([]) List<Category>? categories,
    @WalletConverter() required Wallet wallet,
    @PartyConverter() Party? party,
    @GroupConverter() Group? group,
    List<MediaFile>? files,
  }) {
    return TransactionCompleteDto(
      transaction: transaction,
      categories: categories ?? [],
      wallet: wallet,
      party: party,
      group: group,
      files: files ?? [],
    );
  }

  factory TransactionCompleteDto.fromJson(Map<String, dynamic> json) {
    return _$TransactionCompleteDtoFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$TransactionCompleteDtoToJson(this);
  }

  Map<String, dynamic> toServerJson() {
    final data = <String, dynamic>{
      ...transaction.toJson(),
      'client_id': transaction.clientId,
      'type': transaction.type.serverKey,
      'datetime': transaction.datetime != null
          ? formatServerIsoDateTimeString(transaction.datetime!)
          : null,
      'created_at': formatServerIsoDateTimeString(transaction.createdAt),
      'updated_at': formatServerIsoDateTimeString(transaction.updatedAt),
      'deleted_at': transaction.deletedAt != null
          ? formatServerIsoDateTimeString(transaction.deletedAt!)
          : null,
      'categories': categories.map((c) => c.id).toList(),
      'wallet_id': wallet.id,
      'party_id': party?.id,
      'group_id': group?.id,
    };

    // Refund state is set via the dedicated endpoint, not a normal write request.
    data.remove('is_refund');
    data.remove('refund_of_transaction_id');

    data.remove('next_scheduled_at');
    data.remove('recurrence_period');
    data.remove('recurrence_interval');
    data.remove('recurrence_ends_at');
    if (transaction.recurrencePeriod != null) {
      data['is_recurring'] = true;
      data['recurrence_period'] = transaction.recurrencePeriod;
      if (transaction.recurrenceInterval != null) {
        data['recurrence_interval'] = transaction.recurrenceInterval;
      }
      if (transaction.recurrenceEndsAt != null) {
        data['recurrence_ends_at'] =
            formatServerIsoDateTimeString(transaction.recurrenceEndsAt!);
      }
    }

    return data;
  }

  factory TransactionCompleteDto.fromServerJson(Map<String, dynamic> json) {
    final transactionDto = TransactionDTO.fromJson(json);

    final categories = (json['categories'] as List<dynamic>)
        .map((c) => Category.fromJson(c as Map<String, dynamic>))
        .toList();

    final wallet =
        WalletDto.fromJson(json['wallet'] as Map<String, dynamic>).toModel();

    final party = json['party'] != null
        ? Party.fromJson(json['party'] as Map<String, dynamic>)
        : null;

    final group = json['group'] != null
        ? Group.fromJson(json['group'] as Map<String, dynamic>)
        : null;

    final recurringRule = json['recurring_rules'] as Map<String, dynamic>?;

    final transaction = Transaction(
      amount: transactionDto.amount,
      clientId: transactionDto.clientGeneratedId,
      createdAt: DateTime.parse(transactionDto.createdAt),
      updatedAt: DateTime.parse(transactionDto.updatedAt),
      type: transactionDto.type,
      intent: transactionDto.intent ?? 'regular',
      datetime: transactionDto.datetime != null
          ? DateTime.parse(transactionDto.datetime!)
          : null,
      walletClientId: wallet.clientId,
      description: transactionDto.description,
      id: transactionDto.id,
      userId: transactionDto.userId,
      walletId: wallet.id,
      partyClientId: party?.clientId,
      groupClientId: group?.clientId,
      lastSyncedAt: transactionDto.lastSyncedAt,
      deletedAt: transactionDto.deletedAt,
      partyId: party?.id,
      groupId: group?.id,
      transferId: transactionDto.transferId,
      transferClientId: transactionDto.transferClientId,
      isRefund: transactionDto.isRefund ?? false,
      refundOfTransactionId: transactionDto.refundOfTransactionId,
      recurrencePeriod: recurringRule?['recurrence_period'] as String?,
      recurrenceInterval:
          (recurringRule?['recurrence_interval'] as num?)?.toInt(),
      recurrenceEndsAt: recurringRule?['recurrence_ends_at'] != null
          ? DateTime.parse(recurringRule!['recurrence_ends_at'] as String)
          : null,
      recurrenceNextScheduledAt: recurringRule?['next_scheduled_at'] != null
          ? DateTime.parse(recurringRule!['next_scheduled_at'] as String)
          : null,
    );

    final filesRaw = json['files'] is List<dynamic>
        ? (json['files'] as List<dynamic>)
            .map((e) => MediaFileDto.fromJson(e as Map<String, dynamic>))
            .toList()
        : <MediaFileDto>[];
    final files = filesRaw
        .map((dto) => MediaFile(
              path: dto.path,
              id: dto.id,
              type: dto.type,
              fileableType: dto.fileableType,
              fileableId: dto.fileableId,
              localFileableType: null,
              localFileableId: null,
              createdAt: dto.createdAt,
              updatedAt: dto.updatedAt,
            ))
        .toList();

    return TransactionCompleteDto(
      transaction: transaction,
      categories: categories,
      wallet: wallet,
      party: party,
      group: group,
      files: files,
    );
  }
}

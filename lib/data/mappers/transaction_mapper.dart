import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/data/datasources/transaction/dto/transaction_complete_dto.dart';
import 'package:trakli/data/mappers/category_mapper.dart';
import 'package:trakli/data/mappers/group_mapper.dart';
import 'package:trakli/data/mappers/party_mapper.dart';
import 'package:trakli/data/mappers/wallet_mapper.dart';
import 'package:trakli/domain/entities/transaction_complete_entity.dart';
import 'package:trakli/domain/entities/transaction_entity.dart';
import 'package:trakli/data/mappers/media_file_mapper.dart';
import 'package:trakli/presentation/utils/enums.dart';

class _TransactionMapper {
  static TransactionEntity toDomain(Transaction row) {
    return TransactionEntity(
      clientId: row.clientId,
      id: row.id,
      amount: row.amount,
      description: row.description ?? '',
      lastSyncedAt: row.lastSyncedAt,
      createdAt: row.createdAt,
      datetime: row.datetime ?? row.createdAt,
      type: row.type,
      intent:
          TransactionIntent.tryParse(row.intent) ?? TransactionIntent.regular,
      isRefund: row.isRefund,
      refundOfTransactionId: row.refundOfTransactionId,
      recurrencePeriod: row.recurrencePeriod,
      recurrenceInterval: row.recurrenceInterval,
      recurrenceEndsAt: row.recurrenceEndsAt,
      recurrenceNextScheduledAt: row.recurrenceNextScheduledAt,
      updatedAt: row.updatedAt,
      walletClientId: row.walletClientId,
      partyClientId: row.partyClientId,
      groupClientId: row.groupClientId,
      transferId: row.transferId,
      transferClientId: row.transferClientId,
    );
  }
}

class TransactionCompleteModelMapper {
  static TransactionCompleteEntity toDomain(TransactionCompleteDto data) {
    return TransactionCompleteEntity(
      transaction: _TransactionMapper.toDomain(data.transaction),
      categories:
          data.categories.map((c) => CategoryMapper.toDomain(c)).toList(),
      wallet: WalletMapper.toDomain(data.wallet),
      party: data.party != null ? PartyMapper.toDomain(data.party!) : null,
      group: data.group != null ? GroupMapper.toDomain(data.group!) : null,
      files: MediaFileMapper.toDomainListFromRows(data.files),
    );
  }

  static List<TransactionCompleteEntity> toDomainList(
      List<TransactionCompleteDto> dataList) {
    return dataList.map((data) => toDomain(data)).toList();
  }
}

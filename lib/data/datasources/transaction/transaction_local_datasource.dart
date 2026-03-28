import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/constants/fileable_type_constants.dart';
import 'package:trakli/core/utils/date_util.dart';
import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/data/datasources/media_file/media_file_local_datasource.dart';
import 'package:trakli/data/datasources/transaction/dto/transaction_complete_dto.dart';
import 'package:trakli/data/models/wallet_stats.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/core/utils/id_helper.dart';

abstract class TransactionLocalDataSource {
  Future<List<TransactionCompleteDto>> getAllTransactions();
  Future<Transaction?> getTransactionByClientId(String clientId);
  Future<TransactionCompleteDto> insertTransaction(
    double amount,
    String description,
    List<String> categoryIds,
    TransactionType type,
    DateTime datetime,
    String walletClientId, {
    String? partyClientId,
    String? groupClientId,
    List<String> attachedFilePaths = const [],
  });
  Future<TransactionCompleteDto> updateTransaction(
    String id,
    {
    double? amount,
    String? description,
    List<String>? categoryIds,
    DateTime? datetime,
    String? walletClientId,
    String? partyClientId,
    String? groupClientId,
    String? transferClientId,
  });

  Future<TransactionCompleteDto> deleteTransaction(String id);

  Stream<List<TransactionCompleteDto>> listenToTransaction();
}

@Injectable(as: TransactionLocalDataSource)
class TransactionLocalDataSourceImpl implements TransactionLocalDataSource {
  TransactionLocalDataSourceImpl(this.database, this._mediaFileLocalDataSource);

  final AppDatabase database;
  final MediaFileLocalDataSource _mediaFileLocalDataSource;

  List<TransactionCompleteDto> mapTransactionAndComplete(
    List<TypedResult> rows,
  ) {
    final transactionMap = <String, TransactionCompleteDto>{};

    for (final row in rows) {
      final transaction = row.readTable(database.transactions);
      final category = row.readTableOrNull(database.categories);
      final wallet = row.readTableOrNull(database.wallets);
      final party = row.readTableOrNull(database.parties);
      final group = row.readTableOrNull(database.groups);
      final mediaFile = row.readTableOrNull(database.mediaFiles);

      if (wallet == null) {
        throw Exception('Transaction wallet not found');
      }

      final transactionClientId = transaction.clientId;

      // Initialize the transaction entry if not exists
      transactionMap.putIfAbsent(
          transactionClientId,
          () => TransactionCompleteDto.fromTransaction(
                transaction: transaction,
                categories: [],
                wallet: wallet,
                party: party,
                group: group,
                files: [],
              ));

      var dto = transactionMap[transactionClientId]!;

      // Add the category if it exists (leftOuterJoin may return null)
      if (category != null) {
        final currentCategories = List<Category>.from(
            transactionMap[transaction.clientId]?.categories ?? []);
        if (!currentCategories.any((c) => c.clientId == category.clientId)) {
          currentCategories.add(category);
          // Create a new TransactionCompleteModel with the updated categories
          transactionMap[transaction.clientId] =
              TransactionCompleteDto.fromTransaction(
            transaction: transaction,
            categories: currentCategories,
            wallet: wallet,
            party: party,
            group: group,
            files: dto.files,
          );
          dto = transactionMap[transactionClientId]!;
        }
      }

      // Add the media file if it exists (leftOuterJoin may return null)
      if (mediaFile != null) {
        final currentFiles = List<MediaFile>.from(dto.files);
        if (!currentFiles.any((f) => f.path == mediaFile.path)) {
          currentFiles.add(mediaFile);
          transactionMap[transactionClientId] =
              TransactionCompleteDto.fromTransaction(
            transaction: transaction,
            categories: dto.categories,
            wallet: wallet,
            party: party,
            group: group,
            files: currentFiles,
          );
        }
      }
    }

    return transactionMap.values.toList();
  }

  /// Updates wallet balance and stats based on transaction changes
  /// If [isDelete] is true, it will revert the transaction's effect
  /// If [isUpdate] is true, it will first revert the old transaction and then apply the new one
  Future<void> _updateWalletBalanceAndStats({
    required Wallet wallet,
    required Transaction transaction,
    double? newAmount,
    bool isDelete = false,
    bool isUpdate = false,
  }) async {
    final currentStats =
        wallet.stats ?? WalletStats(totalIncome: 0, totalExpense: 0);
    double balanceChange = 0;
    WalletStats newStats;

    if (isDelete) {
      // For deletion, reverse the transaction's effect
      balanceChange = transaction.type == TransactionType.income
          ? -transaction.amount // Remove income
          : transaction.amount; // Add back expense
      newStats = WalletStats(
        totalIncome: transaction.type == TransactionType.income
            ? currentStats.totalIncome - transaction.amount
            : currentStats.totalIncome,
        totalExpense: transaction.type == TransactionType.expense
            ? currentStats.totalExpense - transaction.amount
            : currentStats.totalExpense,
      );
    } else if (isUpdate && newAmount != null) {
      // For updates, first revert old amount then apply new amount
      final revertAmount = transaction.type == TransactionType.income
          ? -transaction.amount
          : transaction.amount;
      final applyAmount =
          transaction.type == TransactionType.income ? newAmount : -newAmount;
      balanceChange = revertAmount + applyAmount;

      newStats = WalletStats(
        totalIncome: transaction.type == TransactionType.income
            ? currentStats.totalIncome - transaction.amount + newAmount
            : currentStats.totalIncome,
        totalExpense: transaction.type == TransactionType.expense
            ? currentStats.totalExpense - transaction.amount + newAmount
            : currentStats.totalExpense,
      );
    } else {
      // For new transactions
      balanceChange = transaction.type == TransactionType.income
          ? transaction.amount
          : -transaction.amount;
      newStats = WalletStats(
        totalIncome: transaction.type == TransactionType.income
            ? currentStats.totalIncome + transaction.amount
            : currentStats.totalIncome,
        totalExpense: transaction.type == TransactionType.expense
            ? currentStats.totalExpense + transaction.amount
            : currentStats.totalExpense,
      );
    }

    await (database.update(database.wallets)
          ..where((w) => w.clientId.equals(wallet.clientId)))
        .write(
      WalletsCompanion(
        balance: Value(wallet.balance + balanceChange),
        stats: Value(newStats),
      ),
    );
  }

  @override
  Future<List<TransactionCompleteDto>> getAllTransactions() async {
    final query = database.select(database.transactions).join([
      leftOuterJoin(
        database.categorizables,
        database.categorizables.categorizableId
                .equalsExp(database.transactions.clientId) &
            database.categorizables.categorizableType
                .equals(CategorizableType.transaction.name),
      ),
      leftOuterJoin(
        database.categories,
        database.categories.clientId
            .equalsExp(database.categorizables.categoryClientId),
      ),
      leftOuterJoin(
        database.wallets,
        database.wallets.clientId
            .equalsExp(database.transactions.walletClientId),
      ),
      leftOuterJoin(
        database.parties,
        database.parties.clientId
            .equalsExp(database.transactions.partyClientId),
      ),
      leftOuterJoin(
        database.groups,
        database.groups.clientId.equalsExp(database.transactions.groupClientId),
      ),
      leftOuterJoin(
        database.mediaFiles,
        database.mediaFiles.localFileableType
                .equals(FileableTypeConstants.transactions) &
            database.mediaFiles.localFileableId
                .equalsExp(database.transactions.clientId),
      ),
    ])
      ..orderBy([OrderingTerm.desc(database.transactions.createdAt)]);

    final rows = await query.get();
    return mapTransactionAndComplete(rows);
  }

  @override
  Future<Transaction?> getTransactionByClientId(String clientId) async {
    return (database.select(database.transactions)
          ..where((t) => t.clientId.equals(clientId)))
        .getSingleOrNull();
  }

  @override
  Future<TransactionCompleteDto> insertTransaction(
    double amount,
    String description,
    List<String> categoryIds,
    TransactionType type,
    DateTime datetime,
    String walletClientId, {
    String? partyClientId,
    String? groupClientId,
    List<String> attachedFilePaths = const [],
  }) async {
    // Reads outside transaction to avoid long blocking.
    for (var categoryId in categoryIds) {
      final categoryModel = await (database.select(database.categories)
            ..where((c) => c.clientId.equals(categoryId)))
          .getSingleOrNull();

      if (categoryModel == null) {
        throw Exception('Category $categoryId not found');
      }
    }

    final wallet = await (database.select(database.wallets)
          ..where((w) => w.clientId.equals(walletClientId)))
        .getSingleOrNull();

    if (wallet == null) {
      throw Exception('Wallet $walletClientId not found');
    }

    Party? party;
    if (partyClientId != null) {
      party = await (database.select(database.parties)
            ..where((p) => p.clientId.equals(partyClientId)))
          .getSingleOrNull();

      if (party == null) {
        throw Exception('Party $partyClientId not found');
      }
    }

    Group? group;
    if (groupClientId != null) {
      group = await (database.select(database.groups)
            ..where((g) => g.clientId.equals(groupClientId)))
          .getSingleOrNull();

      if (group == null) {
        throw Exception('Group $groupClientId not found');
      }
    }

    final clientId = await generateDeviceScopedId();
    final now = getNewFormattedUtcDateTime();
    final utcDatetime = getFormattedUtcDateTimeFromUtc(datetime);

    // Copy attached files into app media directory only when saving.
    final resolvedPaths = <String>[];
    for (final path in attachedFilePaths) {
      resolvedPaths
          .add(await _mediaFileLocalDataSource.copyToStoredLocation(path));
    }

    // Transaction: writes only + reads that depend on those writes.
    return database.transaction(() async {
      final model = await database.into(database.transactions).insertReturning(
            TransactionsCompanion.insert(
              clientId: Value(clientId),
              amount: amount,
              description: Value(description),
              type: type,
              datetime: Value(utcDatetime),
              updatedAt: Value(now),
              createdAt: Value(now),
              walletClientId: walletClientId,
              partyClientId: Value(partyClientId),
              groupClientId: Value(groupClientId),
            ),
          );

      await _updateWalletBalanceAndStats(
        wallet: wallet,
        transaction: model,
      );

      for (var categoryId in categoryIds) {
        await database.into(database.categorizables).insert(
              CategorizablesCompanion.insert(
                categorizableId: model.clientId,
                categorizableType: CategorizableType.transaction,
                categoryClientId: categoryId,
              ),
            );
      }

      for (final path in resolvedPaths) {
        final media = MediaFile(
          path: path,
          id: null,
          type: null,
          fileableType: null,
          fileableId: null,
          localFileableType: FileableTypeConstants.transactions,
          localFileableId: model.clientId,
          createdAt: null,
          updatedAt: null,
        );
        await database.mediaFiles.insertOne(
          media,
          mode: InsertMode.insertOrReplace,
        );
      }

      final categories = await database.getCategoriesForTransaction(
        model.clientId,
        CategorizableType.transaction,
      );

      final updatedWallet = await (database.select(database.wallets)
            ..where((w) => w.clientId.equals(walletClientId)))
          .getSingleOrNull();

      if (updatedWallet == null) {
        throw Exception('Wallet $walletClientId not found');
      }

      return TransactionCompleteDto.fromTransaction(
        transaction: model,
        categories: categories,
        wallet: updatedWallet,
        party: party,
        group: group,
        files: resolvedPaths
            .map((path) => MediaFile(
                  path: path,
                  id: null,
                  localFileableType: FileableTypeConstants.transactions,
                  localFileableId: model.clientId,
                ))
            .toList(),
      );
    });
  }

  @override
  Future<TransactionCompleteDto> updateTransaction(
    String id,
    {
    double? amount,
    String? description,
    List<String>? categoryIds,
    DateTime? datetime,
    String? walletClientId,
    String? partyClientId,
    String? groupClientId,
    String? transferClientId,
  }) async {
    return database.transaction(() async {
      final originalTransaction = await (database.select(database.transactions)
            ..where((t) => t.clientId.equals(id)))
          .getSingle();

      if (walletClientId != null || amount != null) {
        final originalWallet = await (database.select(database.wallets)
              ..where(
                  (w) => w.clientId.equals(originalTransaction.walletClientId)))
            .getSingleOrNull();

        if (originalWallet != null) {
          await _updateWalletBalanceAndStats(
            wallet: originalWallet,
            transaction: originalTransaction,
            newAmount: amount,
            isUpdate: true,
          );
        }

        if (walletClientId != null &&
            walletClientId != originalTransaction.walletClientId) {
          final newWallet = await (database.select(database.wallets)
                ..where((w) => w.clientId.equals(walletClientId)))
              .getSingleOrNull();

          if (newWallet == null) {
            throw Exception('New wallet $walletClientId not found');
          }

          await _updateWalletBalanceAndStats(
            wallet: newWallet,
            transaction: originalTransaction.copyWith(
              amount: amount ?? originalTransaction.amount,
            ),
          );
        }
      }

      Party? party;
      if (partyClientId != null) {
        party = await (database.select(database.parties)
              ..where((p) => p.clientId.equals(partyClientId)))
            .getSingleOrNull();

        if (party == null) {
          throw Exception('Party $partyClientId not found');
        }
      }

      Group? group;
      if (groupClientId != null) {
        group = await (database.select(database.groups)
              ..where((g) => g.clientId.equals(groupClientId)))
            .getSingleOrNull();

        if (group == null) {
          throw Exception('Group $groupClientId not found');
        }
      }

      final model = await (database.update(database.transactions)
            ..where((t) => t.clientId.equals(id)))
          .writeReturning(
        TransactionsCompanion(
          amount: amount != null ? Value(amount) : const Value.absent(),
          description:
              description != null ? Value(description) : const Value.absent(),
          datetime: datetime != null
              ? Value(getFormattedUtcDateTimeFromUtc(datetime))
              : const Value.absent(),
          walletClientId: walletClientId != null
              ? Value(walletClientId)
              : const Value.absent(),
          partyClientId: partyClientId != null
              ? Value(partyClientId)
              : const Value.absent(),
          groupClientId: groupClientId != null
              ? Value(groupClientId)
              : const Value.absent(),
          transferClientId: transferClientId != null
              ? Value(transferClientId)
              : const Value.absent(),
        ),
      );

      final categories = await database.getCategoriesForTransaction(
        model.first.clientId,
        CategorizableType.transaction,
      );

      final wallet = await (database.select(database.wallets)
            ..where((w) => w.clientId.equals(model.first.walletClientId)))
          .getSingleOrNull();

      if (wallet == null) {
        throw Exception('Wallet ${model.first.walletClientId} not found');
      }

      if (categoryIds == null) {
        final files = await _mediaFileLocalDataSource.getForTransaction(
          model.first.clientId,
        );
        return TransactionCompleteDto.fromTransaction(
          transaction: model.first,
          categories: categories,
          wallet: wallet,
          party: party,
          group: group,
          files: files,
        );
      }

      final categoriesToRemove =
          categories.where((c) => !categoryIds.contains(c.clientId)).toList();

      for (var category in categoriesToRemove) {
        await database.categorizables.deleteWhere(
          (row) =>
              row.categorizableId.equals(model.first.clientId) &
              row.categorizableType.equals(CategorizableType.transaction.name) &
              row.categoryClientId.equals(category.clientId),
        );
      }

      final categoriesToAdd = categoryIds
          .where((c) => !categories.any((cc) => cc.clientId == c))
          .toList();

      for (var categoryId in categoriesToAdd) {
        await database.into(database.categorizables).insert(
              CategorizablesCompanion.insert(
                categorizableId: model.first.clientId,
                categorizableType: CategorizableType.transaction,
                categoryClientId: categoryId,
              ),
            );
      }

      final finalCategories = await database.getCategoriesForTransaction(
        model.first.clientId,
        CategorizableType.transaction,
      );

      final files = await _mediaFileLocalDataSource.getForTransaction(
        model.first.clientId,
      );
      return TransactionCompleteDto.fromTransaction(
        transaction: model.first,
        categories: finalCategories,
        wallet: wallet,
        party: party,
        group: group,
        files: files,
      );
    });
  }

  @override
  Future<TransactionCompleteDto> deleteTransaction(String id) async {
    return database.transaction(() async {
      final transaction = await (database.select(database.transactions)
            ..where((t) => t.clientId.equals(id)))
          .getSingle();

      final wallet = await (database.select(database.wallets)
            ..where((w) => w.clientId.equals(transaction.walletClientId)))
          .getSingleOrNull();

      if (wallet == null) {
        throw Exception('Transaction wallet not found');
      }

      Party? party;
      final partyClientId = transaction.partyClientId;
      if (partyClientId != null) {
        party = await (database.select(database.parties)
              ..where((p) => p.clientId.equals(partyClientId)))
            .getSingleOrNull();
      }

      Group? group;
      final groupClientId = transaction.groupClientId;
      if (groupClientId != null) {
        group = await (database.select(database.groups)
              ..where((g) => g.clientId.equals(groupClientId)))
            .getSingleOrNull();
      }

      await _updateWalletBalanceAndStats(
        wallet: wallet,
        transaction: transaction,
        isDelete: true,
      );

      final files = await _mediaFileLocalDataSource.getForTransaction(
        transaction.clientId,
      );
      final categories = await database.getCategoriesForTransaction(
        transaction.clientId,
        CategorizableType.transaction,
      );

      // Delete all categorizables for this transaction
      await database.categorizables.deleteWhere((row) =>
          row.categorizableId.equals(transaction.clientId) &
          row.categorizableType.equals(CategorizableType.transaction.name));

      await database.delete(database.transactions).delete(transaction);

      return TransactionCompleteDto.fromTransaction(
        transaction: transaction,
        categories: categories,
        wallet: wallet,
        party: party,
        group: group,
        files: files,
      );
    });
  }

  @override
  Stream<List<TransactionCompleteDto>> listenToTransaction() {
    final query = database.select(database.transactions).join([
      leftOuterJoin(
        database.categorizables,
        database.categorizables.categorizableId
                .equalsExp(database.transactions.clientId) &
            database.categorizables.categorizableType
                .equals(CategorizableType.transaction.name),
      ),
      leftOuterJoin(
        database.categories,
        database.categories.clientId
            .equalsExp(database.categorizables.categoryClientId),
      ),
      leftOuterJoin(
        database.wallets,
        database.wallets.clientId
            .equalsExp(database.transactions.walletClientId),
      ),
      leftOuterJoin(
        database.parties,
        database.parties.clientId
            .equalsExp(database.transactions.partyClientId),
      ),
      leftOuterJoin(
        database.groups,
        database.groups.clientId.equalsExp(database.transactions.groupClientId),
      ),
      leftOuterJoin(
        database.mediaFiles,
        database.mediaFiles.localFileableType
                .equals(FileableTypeConstants.transactions) &
            database.mediaFiles.localFileableId
                .equalsExp(database.transactions.clientId),
      ),
    ])
      ..orderBy([OrderingTerm.desc(database.transactions.createdAt)]);

    return query.watch().map(mapTransactionAndComplete);
  }
}

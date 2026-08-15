import 'package:drift_sync_core/drift_sync_core.dart' as sync;
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/exceptions.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/error/repository_error_handler.dart';
import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/data/datasources/wallet/wallet_local_datasource.dart';
import 'package:trakli/data/mappers/wallet_mapper.dart';
import 'package:trakli/data/models/media.dart';
import 'package:trakli/data/sync/wallet_sync_handler.dart';
import 'package:trakli/domain/entities/media_entity.dart';
import 'package:trakli/domain/entities/wallet_entity.dart';
import 'package:trakli/domain/repositories/wallet_repository.dart';
import 'package:trakli/presentation/utils/enums.dart';

@LazySingleton(as: WalletRepository)
class WalletRepositoryImpl
    extends sync.SyncEntityRepository<AppDatabase, Wallet, String, int>
    implements WalletRepository {
  final WalletLocalDataSource localDataSource;

  WalletRepositoryImpl({
    required WalletSyncHandler syncHandler,
    required this.localDataSource,
    required super.db,
    required super.requestAuthorizationService,
  }) : super(syncHandler: syncHandler);

  @override
  Future<Either<Failure, List<WalletEntity>>> getAllWallets() {
    return RepositoryErrorHandler.handleApiCall(() async {
      final wallets = await localDataSource.getAllWallets();
      return WalletMapper.toDomainList(wallets);
    });
  }

  @override
  Future<Either<Failure, WalletEntity>> insertWallet(
    String name,
    WalletType type,
    double balance,
    String currency, {
    String? description,
    MediaEntity? icon,
  }) {
    return RepositoryErrorHandler.handleApiCall(() async {
      final media = icon != null
          ? Media(
              content: icon.content,
              type: icon.mediaType,
            )
          : null;
      final wallet = await persistAndPost(() => localDataSource.insertWallet(
            name,
            type,
            balance,
            currency,
            description: description,
            icon: media,
          ));
      return WalletMapper.toDomain(wallet);
    });
  }

  @override
  Future<Either<Failure, WalletEntity>> updateWallet(
    String clientId, {
    String? name,
    WalletType? type,
    double? balance,
    String? currency,
    String? description,
    MediaEntity? icon,
  }) {
    return RepositoryErrorHandler.handleApiCall(() async {
      final existingWallet = await localDataSource.getWallet(clientId);
      if (existingWallet == null) {
        throw NotFoundException('Wallet not found');
      }

      final media = icon != null
          ? Media(
              content: icon.content,
              type: icon.mediaType,
            )
          : null;

      final wallet = await persistAndPut(() => localDataSource.updateWallet(
            clientId,
            name: name,
            type: type,
            balance: balance,
            currency: currency,
            description: description,
            icon: media,
          ));
      return WalletMapper.toDomain(wallet);
    });
  }

  @override
  Future<Either<Failure, Unit>> deleteWallet(String clientId) {
    return RepositoryErrorHandler.handleApiCall(() async {
      final wallet = await localDataSource.getWallet(clientId);
      if (wallet == null) {
        throw NotFoundException('Wallet not found');
      }

      await delete(wallet);
      return unit;
    });
  }

  @override
  Stream<Either<Failure, List<WalletEntity>>> listenToWallets() {
    return localDataSource.listenToWallets().map((wallets) {
      return Right(WalletMapper.toDomainList(wallets));
    });
  }

  @override
  Future<Either<Failure, bool>> hasAnyWallet() async {
    return RepositoryErrorHandler.handleApiCall(() async {
      final wallets = await localDataSource.getAllWallets();
      return wallets.isNotEmpty;
    });
  }
}

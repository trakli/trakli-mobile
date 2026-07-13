import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/data/datasources/holding/dto/holding_dto.dart';
import 'package:trakli/data/mappers/holding_mapper.dart';

abstract class HoldingLocalDataSource {
  Future<List<HoldingRow>> getHoldings();
  Stream<List<HoldingRow>> watchHoldings();

  /// Replace the entire cache with the given holdings (keeps cache in sync with
  /// the server list — drops holdings deleted on other devices).
  Future<void> replaceAll(List<HoldingDto> holdings);

  /// Upsert a single holding (after a create/update).
  Future<void> upsert(HoldingDto holding);

  Future<void> deleteById(int id);
}

@Injectable(as: HoldingLocalDataSource)
class HoldingLocalDataSourceImpl implements HoldingLocalDataSource {
  final AppDatabase database;

  HoldingLocalDataSourceImpl(this.database);

  @override
  Future<List<HoldingRow>> getHoldings() {
    return (database.select(database.holdings)
          ..orderBy([(h) => OrderingTerm.desc(h.value)]))
        .get();
  }

  @override
  Stream<List<HoldingRow>> watchHoldings() {
    return (database.select(database.holdings)
          ..orderBy([(h) => OrderingTerm.desc(h.value)]))
        .watch();
  }

  @override
  Future<void> replaceAll(List<HoldingDto> holdings) async {
    await database.transaction(() async {
      await database.delete(database.holdings).go();
      for (final dto in holdings) {
        await database.into(database.holdings).insert(
              HoldingMapper.dtoToCompanion(dto),
              mode: InsertMode.insertOrReplace,
            );
      }
    });
  }

  @override
  Future<void> upsert(HoldingDto holding) async {
    await database.into(database.holdings).insert(
          HoldingMapper.dtoToCompanion(holding),
          mode: InsertMode.insertOrReplace,
        );
  }

  @override
  Future<void> deleteById(int id) async {
    await (database.delete(database.holdings)..where((h) => h.id.equals(id)))
        .go();
  }
}

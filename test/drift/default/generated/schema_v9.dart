// dart format width=80
// GENERATED CODE, DO NOT EDIT BY HAND.
// ignore_for_file: type=lint
import 'package:drift/drift.dart';

class Wallets extends Table with TableInfo<Wallets, WalletsData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Wallets(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  late final GeneratedColumn<String> clientId = GeneratedColumn<String>(
      'client_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const CustomExpression('\'\''));
  late final GeneratedColumn<String> rev = GeneratedColumn<String>(
      'rev', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const CustomExpression('\'1\''));
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: const CustomExpression('CURRENT_TIMESTAMP'));
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: const CustomExpression('CURRENT_TIMESTAMP'));
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  late final GeneratedColumn<DateTime> lastSyncedAt = GeneratedColumn<DateTime>(
      'last_synced_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<double> balance = GeneratedColumn<double>(
      'balance', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const CustomExpression('0.0'));
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
      'currency', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  late final GeneratedColumn<String> stats = GeneratedColumn<String>(
      'stats', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
      'icon', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userId,
        clientId,
        rev,
        createdAt,
        updatedAt,
        deletedAt,
        lastSyncedAt,
        name,
        type,
        balance,
        currency,
        description,
        stats,
        icon
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'wallets';
  @override
  Set<GeneratedColumn> get $primaryKey => {clientId};
  @override
  WalletsData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WalletsData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id']),
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id']),
      clientId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}client_id'])!,
      rev: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}rev']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
      lastSyncedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_synced_at']),
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      balance: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}balance'])!,
      currency: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}currency'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      stats: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}stats']),
      icon: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}icon']),
    );
  }

  @override
  Wallets createAlias(String alias) {
    return Wallets(attachedDatabase, alias);
  }
}

class WalletsData extends DataClass implements Insertable<WalletsData> {
  final int? id;
  final int? userId;
  final String clientId;
  final String? rev;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final DateTime? lastSyncedAt;
  final String name;
  final String type;
  final double balance;
  final String currency;
  final String? description;
  final String? stats;
  final String? icon;
  const WalletsData(
      {this.id,
      this.userId,
      required this.clientId,
      this.rev,
      required this.createdAt,
      required this.updatedAt,
      this.deletedAt,
      this.lastSyncedAt,
      required this.name,
      required this.type,
      required this.balance,
      required this.currency,
      this.description,
      this.stats,
      this.icon});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<int>(userId);
    }
    map['client_id'] = Variable<String>(clientId);
    if (!nullToAbsent || rev != null) {
      map['rev'] = Variable<String>(rev);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    if (!nullToAbsent || lastSyncedAt != null) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt);
    }
    map['name'] = Variable<String>(name);
    map['type'] = Variable<String>(type);
    map['balance'] = Variable<double>(balance);
    map['currency'] = Variable<String>(currency);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || stats != null) {
      map['stats'] = Variable<String>(stats);
    }
    if (!nullToAbsent || icon != null) {
      map['icon'] = Variable<String>(icon);
    }
    return map;
  }

  WalletsCompanion toCompanion(bool nullToAbsent) {
    return WalletsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      userId:
          userId == null && nullToAbsent ? const Value.absent() : Value(userId),
      clientId: Value(clientId),
      rev: rev == null && nullToAbsent ? const Value.absent() : Value(rev),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      lastSyncedAt: lastSyncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncedAt),
      name: Value(name),
      type: Value(type),
      balance: Value(balance),
      currency: Value(currency),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      stats:
          stats == null && nullToAbsent ? const Value.absent() : Value(stats),
      icon: icon == null && nullToAbsent ? const Value.absent() : Value(icon),
    );
  }

  factory WalletsData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WalletsData(
      id: serializer.fromJson<int?>(json['id']),
      userId: serializer.fromJson<int?>(json['userId']),
      clientId: serializer.fromJson<String>(json['clientId']),
      rev: serializer.fromJson<String?>(json['rev']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      lastSyncedAt: serializer.fromJson<DateTime?>(json['lastSyncedAt']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<String>(json['type']),
      balance: serializer.fromJson<double>(json['balance']),
      currency: serializer.fromJson<String>(json['currency']),
      description: serializer.fromJson<String?>(json['description']),
      stats: serializer.fromJson<String?>(json['stats']),
      icon: serializer.fromJson<String?>(json['icon']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int?>(id),
      'userId': serializer.toJson<int?>(userId),
      'clientId': serializer.toJson<String>(clientId),
      'rev': serializer.toJson<String?>(rev),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'lastSyncedAt': serializer.toJson<DateTime?>(lastSyncedAt),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(type),
      'balance': serializer.toJson<double>(balance),
      'currency': serializer.toJson<String>(currency),
      'description': serializer.toJson<String?>(description),
      'stats': serializer.toJson<String?>(stats),
      'icon': serializer.toJson<String?>(icon),
    };
  }

  WalletsData copyWith(
          {Value<int?> id = const Value.absent(),
          Value<int?> userId = const Value.absent(),
          String? clientId,
          Value<String?> rev = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<DateTime?> deletedAt = const Value.absent(),
          Value<DateTime?> lastSyncedAt = const Value.absent(),
          String? name,
          String? type,
          double? balance,
          String? currency,
          Value<String?> description = const Value.absent(),
          Value<String?> stats = const Value.absent(),
          Value<String?> icon = const Value.absent()}) =>
      WalletsData(
        id: id.present ? id.value : this.id,
        userId: userId.present ? userId.value : this.userId,
        clientId: clientId ?? this.clientId,
        rev: rev.present ? rev.value : this.rev,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
        lastSyncedAt:
            lastSyncedAt.present ? lastSyncedAt.value : this.lastSyncedAt,
        name: name ?? this.name,
        type: type ?? this.type,
        balance: balance ?? this.balance,
        currency: currency ?? this.currency,
        description: description.present ? description.value : this.description,
        stats: stats.present ? stats.value : this.stats,
        icon: icon.present ? icon.value : this.icon,
      );
  WalletsData copyWithCompanion(WalletsCompanion data) {
    return WalletsData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      clientId: data.clientId.present ? data.clientId.value : this.clientId,
      rev: data.rev.present ? data.rev.value : this.rev,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      lastSyncedAt: data.lastSyncedAt.present
          ? data.lastSyncedAt.value
          : this.lastSyncedAt,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      balance: data.balance.present ? data.balance.value : this.balance,
      currency: data.currency.present ? data.currency.value : this.currency,
      description:
          data.description.present ? data.description.value : this.description,
      stats: data.stats.present ? data.stats.value : this.stats,
      icon: data.icon.present ? data.icon.value : this.icon,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WalletsData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('clientId: $clientId, ')
          ..write('rev: $rev, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('balance: $balance, ')
          ..write('currency: $currency, ')
          ..write('description: $description, ')
          ..write('stats: $stats, ')
          ..write('icon: $icon')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      userId,
      clientId,
      rev,
      createdAt,
      updatedAt,
      deletedAt,
      lastSyncedAt,
      name,
      type,
      balance,
      currency,
      description,
      stats,
      icon);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WalletsData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.clientId == this.clientId &&
          other.rev == this.rev &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.lastSyncedAt == this.lastSyncedAt &&
          other.name == this.name &&
          other.type == this.type &&
          other.balance == this.balance &&
          other.currency == this.currency &&
          other.description == this.description &&
          other.stats == this.stats &&
          other.icon == this.icon);
}

class WalletsCompanion extends UpdateCompanion<WalletsData> {
  final Value<int?> id;
  final Value<int?> userId;
  final Value<String> clientId;
  final Value<String?> rev;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<DateTime?> lastSyncedAt;
  final Value<String> name;
  final Value<String> type;
  final Value<double> balance;
  final Value<String> currency;
  final Value<String?> description;
  final Value<String?> stats;
  final Value<String?> icon;
  final Value<int> rowid;
  const WalletsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.clientId = const Value.absent(),
    this.rev = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.balance = const Value.absent(),
    this.currency = const Value.absent(),
    this.description = const Value.absent(),
    this.stats = const Value.absent(),
    this.icon = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WalletsCompanion.insert({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.clientId = const Value.absent(),
    this.rev = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    required String name,
    required String type,
    this.balance = const Value.absent(),
    required String currency,
    this.description = const Value.absent(),
    this.stats = const Value.absent(),
    this.icon = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : name = Value(name),
        type = Value(type),
        currency = Value(currency);
  static Insertable<WalletsData> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<String>? clientId,
    Expression<String>? rev,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<DateTime>? lastSyncedAt,
    Expression<String>? name,
    Expression<String>? type,
    Expression<double>? balance,
    Expression<String>? currency,
    Expression<String>? description,
    Expression<String>? stats,
    Expression<String>? icon,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (clientId != null) 'client_id': clientId,
      if (rev != null) 'rev': rev,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (balance != null) 'balance': balance,
      if (currency != null) 'currency': currency,
      if (description != null) 'description': description,
      if (stats != null) 'stats': stats,
      if (icon != null) 'icon': icon,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WalletsCompanion copyWith(
      {Value<int?>? id,
      Value<int?>? userId,
      Value<String>? clientId,
      Value<String?>? rev,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<DateTime?>? deletedAt,
      Value<DateTime?>? lastSyncedAt,
      Value<String>? name,
      Value<String>? type,
      Value<double>? balance,
      Value<String>? currency,
      Value<String?>? description,
      Value<String?>? stats,
      Value<String?>? icon,
      Value<int>? rowid}) {
    return WalletsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      clientId: clientId ?? this.clientId,
      rev: rev ?? this.rev,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      name: name ?? this.name,
      type: type ?? this.type,
      balance: balance ?? this.balance,
      currency: currency ?? this.currency,
      description: description ?? this.description,
      stats: stats ?? this.stats,
      icon: icon ?? this.icon,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (clientId.present) {
      map['client_id'] = Variable<String>(clientId.value);
    }
    if (rev.present) {
      map['rev'] = Variable<String>(rev.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (lastSyncedAt.present) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (balance.present) {
      map['balance'] = Variable<double>(balance.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (stats.present) {
      map['stats'] = Variable<String>(stats.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WalletsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('clientId: $clientId, ')
          ..write('rev: $rev, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('balance: $balance, ')
          ..write('currency: $currency, ')
          ..write('description: $description, ')
          ..write('stats: $stats, ')
          ..write('icon: $icon, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class Parties extends Table with TableInfo<Parties, PartiesData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Parties(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  late final GeneratedColumn<String> clientId = GeneratedColumn<String>(
      'client_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const CustomExpression('\'\''));
  late final GeneratedColumn<String> rev = GeneratedColumn<String>(
      'rev', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const CustomExpression('\'1\''));
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: const CustomExpression('CURRENT_TIMESTAMP'));
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: const CustomExpression('CURRENT_TIMESTAMP'));
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  late final GeneratedColumn<DateTime> lastSyncedAt = GeneratedColumn<DateTime>(
      'last_synced_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
      'icon', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userId,
        clientId,
        rev,
        createdAt,
        updatedAt,
        deletedAt,
        lastSyncedAt,
        name,
        description,
        icon,
        type
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'parties';
  @override
  Set<GeneratedColumn> get $primaryKey => {clientId};
  @override
  PartiesData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PartiesData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id']),
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id']),
      clientId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}client_id'])!,
      rev: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}rev']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
      lastSyncedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_synced_at']),
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      icon: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}icon']),
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type']),
    );
  }

  @override
  Parties createAlias(String alias) {
    return Parties(attachedDatabase, alias);
  }
}

class PartiesData extends DataClass implements Insertable<PartiesData> {
  final int? id;
  final int? userId;
  final String clientId;
  final String? rev;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final DateTime? lastSyncedAt;
  final String name;
  final String? description;
  final String? icon;
  final String? type;
  const PartiesData(
      {this.id,
      this.userId,
      required this.clientId,
      this.rev,
      required this.createdAt,
      required this.updatedAt,
      this.deletedAt,
      this.lastSyncedAt,
      required this.name,
      this.description,
      this.icon,
      this.type});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<int>(userId);
    }
    map['client_id'] = Variable<String>(clientId);
    if (!nullToAbsent || rev != null) {
      map['rev'] = Variable<String>(rev);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    if (!nullToAbsent || lastSyncedAt != null) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt);
    }
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || icon != null) {
      map['icon'] = Variable<String>(icon);
    }
    if (!nullToAbsent || type != null) {
      map['type'] = Variable<String>(type);
    }
    return map;
  }

  PartiesCompanion toCompanion(bool nullToAbsent) {
    return PartiesCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      userId:
          userId == null && nullToAbsent ? const Value.absent() : Value(userId),
      clientId: Value(clientId),
      rev: rev == null && nullToAbsent ? const Value.absent() : Value(rev),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      lastSyncedAt: lastSyncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncedAt),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      icon: icon == null && nullToAbsent ? const Value.absent() : Value(icon),
      type: type == null && nullToAbsent ? const Value.absent() : Value(type),
    );
  }

  factory PartiesData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PartiesData(
      id: serializer.fromJson<int?>(json['id']),
      userId: serializer.fromJson<int?>(json['userId']),
      clientId: serializer.fromJson<String>(json['clientId']),
      rev: serializer.fromJson<String?>(json['rev']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      lastSyncedAt: serializer.fromJson<DateTime?>(json['lastSyncedAt']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      icon: serializer.fromJson<String?>(json['icon']),
      type: serializer.fromJson<String?>(json['type']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int?>(id),
      'userId': serializer.toJson<int?>(userId),
      'clientId': serializer.toJson<String>(clientId),
      'rev': serializer.toJson<String?>(rev),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'lastSyncedAt': serializer.toJson<DateTime?>(lastSyncedAt),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'icon': serializer.toJson<String?>(icon),
      'type': serializer.toJson<String?>(type),
    };
  }

  PartiesData copyWith(
          {Value<int?> id = const Value.absent(),
          Value<int?> userId = const Value.absent(),
          String? clientId,
          Value<String?> rev = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<DateTime?> deletedAt = const Value.absent(),
          Value<DateTime?> lastSyncedAt = const Value.absent(),
          String? name,
          Value<String?> description = const Value.absent(),
          Value<String?> icon = const Value.absent(),
          Value<String?> type = const Value.absent()}) =>
      PartiesData(
        id: id.present ? id.value : this.id,
        userId: userId.present ? userId.value : this.userId,
        clientId: clientId ?? this.clientId,
        rev: rev.present ? rev.value : this.rev,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
        lastSyncedAt:
            lastSyncedAt.present ? lastSyncedAt.value : this.lastSyncedAt,
        name: name ?? this.name,
        description: description.present ? description.value : this.description,
        icon: icon.present ? icon.value : this.icon,
        type: type.present ? type.value : this.type,
      );
  PartiesData copyWithCompanion(PartiesCompanion data) {
    return PartiesData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      clientId: data.clientId.present ? data.clientId.value : this.clientId,
      rev: data.rev.present ? data.rev.value : this.rev,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      lastSyncedAt: data.lastSyncedAt.present
          ? data.lastSyncedAt.value
          : this.lastSyncedAt,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
      icon: data.icon.present ? data.icon.value : this.icon,
      type: data.type.present ? data.type.value : this.type,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PartiesData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('clientId: $clientId, ')
          ..write('rev: $rev, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('icon: $icon, ')
          ..write('type: $type')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userId, clientId, rev, createdAt,
      updatedAt, deletedAt, lastSyncedAt, name, description, icon, type);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PartiesData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.clientId == this.clientId &&
          other.rev == this.rev &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.lastSyncedAt == this.lastSyncedAt &&
          other.name == this.name &&
          other.description == this.description &&
          other.icon == this.icon &&
          other.type == this.type);
}

class PartiesCompanion extends UpdateCompanion<PartiesData> {
  final Value<int?> id;
  final Value<int?> userId;
  final Value<String> clientId;
  final Value<String?> rev;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<DateTime?> lastSyncedAt;
  final Value<String> name;
  final Value<String?> description;
  final Value<String?> icon;
  final Value<String?> type;
  final Value<int> rowid;
  const PartiesCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.clientId = const Value.absent(),
    this.rev = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.icon = const Value.absent(),
    this.type = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PartiesCompanion.insert({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.clientId = const Value.absent(),
    this.rev = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    required String name,
    this.description = const Value.absent(),
    this.icon = const Value.absent(),
    this.type = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : name = Value(name);
  static Insertable<PartiesData> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<String>? clientId,
    Expression<String>? rev,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<DateTime>? lastSyncedAt,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? icon,
    Expression<String>? type,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (clientId != null) 'client_id': clientId,
      if (rev != null) 'rev': rev,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (icon != null) 'icon': icon,
      if (type != null) 'type': type,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PartiesCompanion copyWith(
      {Value<int?>? id,
      Value<int?>? userId,
      Value<String>? clientId,
      Value<String?>? rev,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<DateTime?>? deletedAt,
      Value<DateTime?>? lastSyncedAt,
      Value<String>? name,
      Value<String?>? description,
      Value<String?>? icon,
      Value<String?>? type,
      Value<int>? rowid}) {
    return PartiesCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      clientId: clientId ?? this.clientId,
      rev: rev ?? this.rev,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      type: type ?? this.type,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (clientId.present) {
      map['client_id'] = Variable<String>(clientId.value);
    }
    if (rev.present) {
      map['rev'] = Variable<String>(rev.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (lastSyncedAt.present) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PartiesCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('clientId: $clientId, ')
          ..write('rev: $rev, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('icon: $icon, ')
          ..write('type: $type, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class Groups extends Table with TableInfo<Groups, GroupsData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Groups(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  late final GeneratedColumn<String> clientId = GeneratedColumn<String>(
      'client_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const CustomExpression('\'\''));
  late final GeneratedColumn<String> rev = GeneratedColumn<String>(
      'rev', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const CustomExpression('\'1\''));
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: const CustomExpression('CURRENT_TIMESTAMP'));
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: const CustomExpression('CURRENT_TIMESTAMP'));
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  late final GeneratedColumn<DateTime> lastSyncedAt = GeneratedColumn<DateTime>(
      'last_synced_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
      'icon', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userId,
        clientId,
        rev,
        createdAt,
        updatedAt,
        deletedAt,
        lastSyncedAt,
        name,
        description,
        icon
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'groups';
  @override
  Set<GeneratedColumn> get $primaryKey => {clientId};
  @override
  GroupsData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GroupsData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id']),
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id']),
      clientId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}client_id'])!,
      rev: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}rev']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
      lastSyncedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_synced_at']),
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      icon: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}icon']),
    );
  }

  @override
  Groups createAlias(String alias) {
    return Groups(attachedDatabase, alias);
  }
}

class GroupsData extends DataClass implements Insertable<GroupsData> {
  final int? id;
  final int? userId;
  final String clientId;
  final String? rev;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final DateTime? lastSyncedAt;
  final String name;
  final String? description;
  final String? icon;
  const GroupsData(
      {this.id,
      this.userId,
      required this.clientId,
      this.rev,
      required this.createdAt,
      required this.updatedAt,
      this.deletedAt,
      this.lastSyncedAt,
      required this.name,
      this.description,
      this.icon});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<int>(userId);
    }
    map['client_id'] = Variable<String>(clientId);
    if (!nullToAbsent || rev != null) {
      map['rev'] = Variable<String>(rev);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    if (!nullToAbsent || lastSyncedAt != null) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt);
    }
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || icon != null) {
      map['icon'] = Variable<String>(icon);
    }
    return map;
  }

  GroupsCompanion toCompanion(bool nullToAbsent) {
    return GroupsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      userId:
          userId == null && nullToAbsent ? const Value.absent() : Value(userId),
      clientId: Value(clientId),
      rev: rev == null && nullToAbsent ? const Value.absent() : Value(rev),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      lastSyncedAt: lastSyncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncedAt),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      icon: icon == null && nullToAbsent ? const Value.absent() : Value(icon),
    );
  }

  factory GroupsData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GroupsData(
      id: serializer.fromJson<int?>(json['id']),
      userId: serializer.fromJson<int?>(json['userId']),
      clientId: serializer.fromJson<String>(json['clientId']),
      rev: serializer.fromJson<String?>(json['rev']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      lastSyncedAt: serializer.fromJson<DateTime?>(json['lastSyncedAt']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      icon: serializer.fromJson<String?>(json['icon']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int?>(id),
      'userId': serializer.toJson<int?>(userId),
      'clientId': serializer.toJson<String>(clientId),
      'rev': serializer.toJson<String?>(rev),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'lastSyncedAt': serializer.toJson<DateTime?>(lastSyncedAt),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'icon': serializer.toJson<String?>(icon),
    };
  }

  GroupsData copyWith(
          {Value<int?> id = const Value.absent(),
          Value<int?> userId = const Value.absent(),
          String? clientId,
          Value<String?> rev = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<DateTime?> deletedAt = const Value.absent(),
          Value<DateTime?> lastSyncedAt = const Value.absent(),
          String? name,
          Value<String?> description = const Value.absent(),
          Value<String?> icon = const Value.absent()}) =>
      GroupsData(
        id: id.present ? id.value : this.id,
        userId: userId.present ? userId.value : this.userId,
        clientId: clientId ?? this.clientId,
        rev: rev.present ? rev.value : this.rev,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
        lastSyncedAt:
            lastSyncedAt.present ? lastSyncedAt.value : this.lastSyncedAt,
        name: name ?? this.name,
        description: description.present ? description.value : this.description,
        icon: icon.present ? icon.value : this.icon,
      );
  GroupsData copyWithCompanion(GroupsCompanion data) {
    return GroupsData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      clientId: data.clientId.present ? data.clientId.value : this.clientId,
      rev: data.rev.present ? data.rev.value : this.rev,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      lastSyncedAt: data.lastSyncedAt.present
          ? data.lastSyncedAt.value
          : this.lastSyncedAt,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
      icon: data.icon.present ? data.icon.value : this.icon,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GroupsData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('clientId: $clientId, ')
          ..write('rev: $rev, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('icon: $icon')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userId, clientId, rev, createdAt,
      updatedAt, deletedAt, lastSyncedAt, name, description, icon);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GroupsData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.clientId == this.clientId &&
          other.rev == this.rev &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.lastSyncedAt == this.lastSyncedAt &&
          other.name == this.name &&
          other.description == this.description &&
          other.icon == this.icon);
}

class GroupsCompanion extends UpdateCompanion<GroupsData> {
  final Value<int?> id;
  final Value<int?> userId;
  final Value<String> clientId;
  final Value<String?> rev;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<DateTime?> lastSyncedAt;
  final Value<String> name;
  final Value<String?> description;
  final Value<String?> icon;
  final Value<int> rowid;
  const GroupsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.clientId = const Value.absent(),
    this.rev = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.icon = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GroupsCompanion.insert({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.clientId = const Value.absent(),
    this.rev = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    required String name,
    this.description = const Value.absent(),
    this.icon = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : name = Value(name);
  static Insertable<GroupsData> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<String>? clientId,
    Expression<String>? rev,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<DateTime>? lastSyncedAt,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? icon,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (clientId != null) 'client_id': clientId,
      if (rev != null) 'rev': rev,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (icon != null) 'icon': icon,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GroupsCompanion copyWith(
      {Value<int?>? id,
      Value<int?>? userId,
      Value<String>? clientId,
      Value<String?>? rev,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<DateTime?>? deletedAt,
      Value<DateTime?>? lastSyncedAt,
      Value<String>? name,
      Value<String?>? description,
      Value<String?>? icon,
      Value<int>? rowid}) {
    return GroupsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      clientId: clientId ?? this.clientId,
      rev: rev ?? this.rev,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (clientId.present) {
      map['client_id'] = Variable<String>(clientId.value);
    }
    if (rev.present) {
      map['rev'] = Variable<String>(rev.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (lastSyncedAt.present) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GroupsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('clientId: $clientId, ')
          ..write('rev: $rev, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('icon: $icon, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class Transactions extends Table
    with TableInfo<Transactions, TransactionsData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Transactions(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  late final GeneratedColumn<String> clientId = GeneratedColumn<String>(
      'client_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const CustomExpression('\'\''));
  late final GeneratedColumn<String> rev = GeneratedColumn<String>(
      'rev', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const CustomExpression('\'1\''));
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: const CustomExpression('CURRENT_TIMESTAMP'));
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: const CustomExpression('CURRENT_TIMESTAMP'));
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  late final GeneratedColumn<DateTime> lastSyncedAt = GeneratedColumn<DateTime>(
      'last_synced_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> intent = GeneratedColumn<String>(
      'intent', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const CustomExpression('\'regular\''));
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  late final GeneratedColumn<DateTime> datetime = GeneratedColumn<DateTime>(
      'datetime', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  late final GeneratedColumn<int> partyId = GeneratedColumn<int>(
      'party_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  late final GeneratedColumn<int> walletId = GeneratedColumn<int>(
      'wallet_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  late final GeneratedColumn<int> groupId = GeneratedColumn<int>(
      'group_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  late final GeneratedColumn<String> walletClientId = GeneratedColumn<String>(
      'wallet_client_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES wallets (client_id)'));
  late final GeneratedColumn<String> partyClientId = GeneratedColumn<String>(
      'party_client_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES parties (client_id)'));
  late final GeneratedColumn<String> groupClientId = GeneratedColumn<String>(
      'group_client_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES "groups" (client_id)'));
  late final GeneratedColumn<int> transferId = GeneratedColumn<int>(
      'transfer_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  late final GeneratedColumn<String> transferClientId = GeneratedColumn<String>(
      'transfer_client_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  late final GeneratedColumn<bool> isRefund = GeneratedColumn<bool>(
      'is_refund', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_refund" IN (0, 1))'),
      defaultValue: const CustomExpression('0'));
  late final GeneratedColumn<int> refundOfTransactionId = GeneratedColumn<int>(
      'refund_of_transaction_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  late final GeneratedColumn<String> recurrencePeriod = GeneratedColumn<String>(
      'recurrence_period', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  late final GeneratedColumn<int> recurrenceInterval = GeneratedColumn<int>(
      'recurrence_interval', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  late final GeneratedColumn<DateTime> recurrenceEndsAt =
      GeneratedColumn<DateTime>('recurrence_ends_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  late final GeneratedColumn<DateTime> recurrenceNextScheduledAt =
      GeneratedColumn<DateTime>(
          'recurrence_next_scheduled_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userId,
        clientId,
        rev,
        createdAt,
        updatedAt,
        deletedAt,
        lastSyncedAt,
        amount,
        type,
        intent,
        description,
        datetime,
        partyId,
        walletId,
        groupId,
        walletClientId,
        partyClientId,
        groupClientId,
        transferId,
        transferClientId,
        isRefund,
        refundOfTransactionId,
        recurrencePeriod,
        recurrenceInterval,
        recurrenceEndsAt,
        recurrenceNextScheduledAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transactions';
  @override
  Set<GeneratedColumn> get $primaryKey => {clientId};
  @override
  TransactionsData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TransactionsData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id']),
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id']),
      clientId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}client_id'])!,
      rev: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}rev']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
      lastSyncedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_synced_at']),
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      intent: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}intent'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      datetime: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}datetime']),
      partyId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}party_id']),
      walletId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}wallet_id']),
      groupId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}group_id']),
      walletClientId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}wallet_client_id'])!,
      partyClientId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}party_client_id']),
      groupClientId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}group_client_id']),
      transferId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}transfer_id']),
      transferClientId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}transfer_client_id']),
      isRefund: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_refund'])!,
      refundOfTransactionId: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}refund_of_transaction_id']),
      recurrencePeriod: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}recurrence_period']),
      recurrenceInterval: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}recurrence_interval']),
      recurrenceEndsAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}recurrence_ends_at']),
      recurrenceNextScheduledAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime,
          data['${effectivePrefix}recurrence_next_scheduled_at']),
    );
  }

  @override
  Transactions createAlias(String alias) {
    return Transactions(attachedDatabase, alias);
  }
}

class TransactionsData extends DataClass
    implements Insertable<TransactionsData> {
  final int? id;
  final int? userId;
  final String clientId;
  final String? rev;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final DateTime? lastSyncedAt;
  final double amount;
  final String type;
  final String intent;
  final String? description;
  final DateTime? datetime;
  final int? partyId;
  final int? walletId;
  final int? groupId;
  final String walletClientId;
  final String? partyClientId;
  final String? groupClientId;
  final int? transferId;
  final String? transferClientId;
  final bool isRefund;
  final int? refundOfTransactionId;
  final String? recurrencePeriod;
  final int? recurrenceInterval;
  final DateTime? recurrenceEndsAt;
  final DateTime? recurrenceNextScheduledAt;
  const TransactionsData(
      {this.id,
      this.userId,
      required this.clientId,
      this.rev,
      required this.createdAt,
      required this.updatedAt,
      this.deletedAt,
      this.lastSyncedAt,
      required this.amount,
      required this.type,
      required this.intent,
      this.description,
      this.datetime,
      this.partyId,
      this.walletId,
      this.groupId,
      required this.walletClientId,
      this.partyClientId,
      this.groupClientId,
      this.transferId,
      this.transferClientId,
      required this.isRefund,
      this.refundOfTransactionId,
      this.recurrencePeriod,
      this.recurrenceInterval,
      this.recurrenceEndsAt,
      this.recurrenceNextScheduledAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<int>(userId);
    }
    map['client_id'] = Variable<String>(clientId);
    if (!nullToAbsent || rev != null) {
      map['rev'] = Variable<String>(rev);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    if (!nullToAbsent || lastSyncedAt != null) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt);
    }
    map['amount'] = Variable<double>(amount);
    map['type'] = Variable<String>(type);
    map['intent'] = Variable<String>(intent);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || datetime != null) {
      map['datetime'] = Variable<DateTime>(datetime);
    }
    if (!nullToAbsent || partyId != null) {
      map['party_id'] = Variable<int>(partyId);
    }
    if (!nullToAbsent || walletId != null) {
      map['wallet_id'] = Variable<int>(walletId);
    }
    if (!nullToAbsent || groupId != null) {
      map['group_id'] = Variable<int>(groupId);
    }
    map['wallet_client_id'] = Variable<String>(walletClientId);
    if (!nullToAbsent || partyClientId != null) {
      map['party_client_id'] = Variable<String>(partyClientId);
    }
    if (!nullToAbsent || groupClientId != null) {
      map['group_client_id'] = Variable<String>(groupClientId);
    }
    if (!nullToAbsent || transferId != null) {
      map['transfer_id'] = Variable<int>(transferId);
    }
    if (!nullToAbsent || transferClientId != null) {
      map['transfer_client_id'] = Variable<String>(transferClientId);
    }
    map['is_refund'] = Variable<bool>(isRefund);
    if (!nullToAbsent || refundOfTransactionId != null) {
      map['refund_of_transaction_id'] = Variable<int>(refundOfTransactionId);
    }
    if (!nullToAbsent || recurrencePeriod != null) {
      map['recurrence_period'] = Variable<String>(recurrencePeriod);
    }
    if (!nullToAbsent || recurrenceInterval != null) {
      map['recurrence_interval'] = Variable<int>(recurrenceInterval);
    }
    if (!nullToAbsent || recurrenceEndsAt != null) {
      map['recurrence_ends_at'] = Variable<DateTime>(recurrenceEndsAt);
    }
    if (!nullToAbsent || recurrenceNextScheduledAt != null) {
      map['recurrence_next_scheduled_at'] =
          Variable<DateTime>(recurrenceNextScheduledAt);
    }
    return map;
  }

  TransactionsCompanion toCompanion(bool nullToAbsent) {
    return TransactionsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      userId:
          userId == null && nullToAbsent ? const Value.absent() : Value(userId),
      clientId: Value(clientId),
      rev: rev == null && nullToAbsent ? const Value.absent() : Value(rev),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      lastSyncedAt: lastSyncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncedAt),
      amount: Value(amount),
      type: Value(type),
      intent: Value(intent),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      datetime: datetime == null && nullToAbsent
          ? const Value.absent()
          : Value(datetime),
      partyId: partyId == null && nullToAbsent
          ? const Value.absent()
          : Value(partyId),
      walletId: walletId == null && nullToAbsent
          ? const Value.absent()
          : Value(walletId),
      groupId: groupId == null && nullToAbsent
          ? const Value.absent()
          : Value(groupId),
      walletClientId: Value(walletClientId),
      partyClientId: partyClientId == null && nullToAbsent
          ? const Value.absent()
          : Value(partyClientId),
      groupClientId: groupClientId == null && nullToAbsent
          ? const Value.absent()
          : Value(groupClientId),
      transferId: transferId == null && nullToAbsent
          ? const Value.absent()
          : Value(transferId),
      transferClientId: transferClientId == null && nullToAbsent
          ? const Value.absent()
          : Value(transferClientId),
      isRefund: Value(isRefund),
      refundOfTransactionId: refundOfTransactionId == null && nullToAbsent
          ? const Value.absent()
          : Value(refundOfTransactionId),
      recurrencePeriod: recurrencePeriod == null && nullToAbsent
          ? const Value.absent()
          : Value(recurrencePeriod),
      recurrenceInterval: recurrenceInterval == null && nullToAbsent
          ? const Value.absent()
          : Value(recurrenceInterval),
      recurrenceEndsAt: recurrenceEndsAt == null && nullToAbsent
          ? const Value.absent()
          : Value(recurrenceEndsAt),
      recurrenceNextScheduledAt:
          recurrenceNextScheduledAt == null && nullToAbsent
              ? const Value.absent()
              : Value(recurrenceNextScheduledAt),
    );
  }

  factory TransactionsData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransactionsData(
      id: serializer.fromJson<int?>(json['id']),
      userId: serializer.fromJson<int?>(json['userId']),
      clientId: serializer.fromJson<String>(json['clientId']),
      rev: serializer.fromJson<String?>(json['rev']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      lastSyncedAt: serializer.fromJson<DateTime?>(json['lastSyncedAt']),
      amount: serializer.fromJson<double>(json['amount']),
      type: serializer.fromJson<String>(json['type']),
      intent: serializer.fromJson<String>(json['intent']),
      description: serializer.fromJson<String?>(json['description']),
      datetime: serializer.fromJson<DateTime?>(json['datetime']),
      partyId: serializer.fromJson<int?>(json['partyId']),
      walletId: serializer.fromJson<int?>(json['walletId']),
      groupId: serializer.fromJson<int?>(json['groupId']),
      walletClientId: serializer.fromJson<String>(json['walletClientId']),
      partyClientId: serializer.fromJson<String?>(json['partyClientId']),
      groupClientId: serializer.fromJson<String?>(json['groupClientId']),
      transferId: serializer.fromJson<int?>(json['transferId']),
      transferClientId: serializer.fromJson<String?>(json['transferClientId']),
      isRefund: serializer.fromJson<bool>(json['isRefund']),
      refundOfTransactionId:
          serializer.fromJson<int?>(json['refundOfTransactionId']),
      recurrencePeriod: serializer.fromJson<String?>(json['recurrencePeriod']),
      recurrenceInterval: serializer.fromJson<int?>(json['recurrenceInterval']),
      recurrenceEndsAt:
          serializer.fromJson<DateTime?>(json['recurrenceEndsAt']),
      recurrenceNextScheduledAt:
          serializer.fromJson<DateTime?>(json['recurrenceNextScheduledAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int?>(id),
      'userId': serializer.toJson<int?>(userId),
      'clientId': serializer.toJson<String>(clientId),
      'rev': serializer.toJson<String?>(rev),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'lastSyncedAt': serializer.toJson<DateTime?>(lastSyncedAt),
      'amount': serializer.toJson<double>(amount),
      'type': serializer.toJson<String>(type),
      'intent': serializer.toJson<String>(intent),
      'description': serializer.toJson<String?>(description),
      'datetime': serializer.toJson<DateTime?>(datetime),
      'partyId': serializer.toJson<int?>(partyId),
      'walletId': serializer.toJson<int?>(walletId),
      'groupId': serializer.toJson<int?>(groupId),
      'walletClientId': serializer.toJson<String>(walletClientId),
      'partyClientId': serializer.toJson<String?>(partyClientId),
      'groupClientId': serializer.toJson<String?>(groupClientId),
      'transferId': serializer.toJson<int?>(transferId),
      'transferClientId': serializer.toJson<String?>(transferClientId),
      'isRefund': serializer.toJson<bool>(isRefund),
      'refundOfTransactionId': serializer.toJson<int?>(refundOfTransactionId),
      'recurrencePeriod': serializer.toJson<String?>(recurrencePeriod),
      'recurrenceInterval': serializer.toJson<int?>(recurrenceInterval),
      'recurrenceEndsAt': serializer.toJson<DateTime?>(recurrenceEndsAt),
      'recurrenceNextScheduledAt':
          serializer.toJson<DateTime?>(recurrenceNextScheduledAt),
    };
  }

  TransactionsData copyWith(
          {Value<int?> id = const Value.absent(),
          Value<int?> userId = const Value.absent(),
          String? clientId,
          Value<String?> rev = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<DateTime?> deletedAt = const Value.absent(),
          Value<DateTime?> lastSyncedAt = const Value.absent(),
          double? amount,
          String? type,
          String? intent,
          Value<String?> description = const Value.absent(),
          Value<DateTime?> datetime = const Value.absent(),
          Value<int?> partyId = const Value.absent(),
          Value<int?> walletId = const Value.absent(),
          Value<int?> groupId = const Value.absent(),
          String? walletClientId,
          Value<String?> partyClientId = const Value.absent(),
          Value<String?> groupClientId = const Value.absent(),
          Value<int?> transferId = const Value.absent(),
          Value<String?> transferClientId = const Value.absent(),
          bool? isRefund,
          Value<int?> refundOfTransactionId = const Value.absent(),
          Value<String?> recurrencePeriod = const Value.absent(),
          Value<int?> recurrenceInterval = const Value.absent(),
          Value<DateTime?> recurrenceEndsAt = const Value.absent(),
          Value<DateTime?> recurrenceNextScheduledAt = const Value.absent()}) =>
      TransactionsData(
        id: id.present ? id.value : this.id,
        userId: userId.present ? userId.value : this.userId,
        clientId: clientId ?? this.clientId,
        rev: rev.present ? rev.value : this.rev,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
        lastSyncedAt:
            lastSyncedAt.present ? lastSyncedAt.value : this.lastSyncedAt,
        amount: amount ?? this.amount,
        type: type ?? this.type,
        intent: intent ?? this.intent,
        description: description.present ? description.value : this.description,
        datetime: datetime.present ? datetime.value : this.datetime,
        partyId: partyId.present ? partyId.value : this.partyId,
        walletId: walletId.present ? walletId.value : this.walletId,
        groupId: groupId.present ? groupId.value : this.groupId,
        walletClientId: walletClientId ?? this.walletClientId,
        partyClientId:
            partyClientId.present ? partyClientId.value : this.partyClientId,
        groupClientId:
            groupClientId.present ? groupClientId.value : this.groupClientId,
        transferId: transferId.present ? transferId.value : this.transferId,
        transferClientId: transferClientId.present
            ? transferClientId.value
            : this.transferClientId,
        isRefund: isRefund ?? this.isRefund,
        refundOfTransactionId: refundOfTransactionId.present
            ? refundOfTransactionId.value
            : this.refundOfTransactionId,
        recurrencePeriod: recurrencePeriod.present
            ? recurrencePeriod.value
            : this.recurrencePeriod,
        recurrenceInterval: recurrenceInterval.present
            ? recurrenceInterval.value
            : this.recurrenceInterval,
        recurrenceEndsAt: recurrenceEndsAt.present
            ? recurrenceEndsAt.value
            : this.recurrenceEndsAt,
        recurrenceNextScheduledAt: recurrenceNextScheduledAt.present
            ? recurrenceNextScheduledAt.value
            : this.recurrenceNextScheduledAt,
      );
  TransactionsData copyWithCompanion(TransactionsCompanion data) {
    return TransactionsData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      clientId: data.clientId.present ? data.clientId.value : this.clientId,
      rev: data.rev.present ? data.rev.value : this.rev,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      lastSyncedAt: data.lastSyncedAt.present
          ? data.lastSyncedAt.value
          : this.lastSyncedAt,
      amount: data.amount.present ? data.amount.value : this.amount,
      type: data.type.present ? data.type.value : this.type,
      intent: data.intent.present ? data.intent.value : this.intent,
      description:
          data.description.present ? data.description.value : this.description,
      datetime: data.datetime.present ? data.datetime.value : this.datetime,
      partyId: data.partyId.present ? data.partyId.value : this.partyId,
      walletId: data.walletId.present ? data.walletId.value : this.walletId,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      walletClientId: data.walletClientId.present
          ? data.walletClientId.value
          : this.walletClientId,
      partyClientId: data.partyClientId.present
          ? data.partyClientId.value
          : this.partyClientId,
      groupClientId: data.groupClientId.present
          ? data.groupClientId.value
          : this.groupClientId,
      transferId:
          data.transferId.present ? data.transferId.value : this.transferId,
      transferClientId: data.transferClientId.present
          ? data.transferClientId.value
          : this.transferClientId,
      isRefund: data.isRefund.present ? data.isRefund.value : this.isRefund,
      refundOfTransactionId: data.refundOfTransactionId.present
          ? data.refundOfTransactionId.value
          : this.refundOfTransactionId,
      recurrencePeriod: data.recurrencePeriod.present
          ? data.recurrencePeriod.value
          : this.recurrencePeriod,
      recurrenceInterval: data.recurrenceInterval.present
          ? data.recurrenceInterval.value
          : this.recurrenceInterval,
      recurrenceEndsAt: data.recurrenceEndsAt.present
          ? data.recurrenceEndsAt.value
          : this.recurrenceEndsAt,
      recurrenceNextScheduledAt: data.recurrenceNextScheduledAt.present
          ? data.recurrenceNextScheduledAt.value
          : this.recurrenceNextScheduledAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('clientId: $clientId, ')
          ..write('rev: $rev, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('amount: $amount, ')
          ..write('type: $type, ')
          ..write('intent: $intent, ')
          ..write('description: $description, ')
          ..write('datetime: $datetime, ')
          ..write('partyId: $partyId, ')
          ..write('walletId: $walletId, ')
          ..write('groupId: $groupId, ')
          ..write('walletClientId: $walletClientId, ')
          ..write('partyClientId: $partyClientId, ')
          ..write('groupClientId: $groupClientId, ')
          ..write('transferId: $transferId, ')
          ..write('transferClientId: $transferClientId, ')
          ..write('isRefund: $isRefund, ')
          ..write('refundOfTransactionId: $refundOfTransactionId, ')
          ..write('recurrencePeriod: $recurrencePeriod, ')
          ..write('recurrenceInterval: $recurrenceInterval, ')
          ..write('recurrenceEndsAt: $recurrenceEndsAt, ')
          ..write('recurrenceNextScheduledAt: $recurrenceNextScheduledAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        userId,
        clientId,
        rev,
        createdAt,
        updatedAt,
        deletedAt,
        lastSyncedAt,
        amount,
        type,
        intent,
        description,
        datetime,
        partyId,
        walletId,
        groupId,
        walletClientId,
        partyClientId,
        groupClientId,
        transferId,
        transferClientId,
        isRefund,
        refundOfTransactionId,
        recurrencePeriod,
        recurrenceInterval,
        recurrenceEndsAt,
        recurrenceNextScheduledAt
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransactionsData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.clientId == this.clientId &&
          other.rev == this.rev &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.lastSyncedAt == this.lastSyncedAt &&
          other.amount == this.amount &&
          other.type == this.type &&
          other.intent == this.intent &&
          other.description == this.description &&
          other.datetime == this.datetime &&
          other.partyId == this.partyId &&
          other.walletId == this.walletId &&
          other.groupId == this.groupId &&
          other.walletClientId == this.walletClientId &&
          other.partyClientId == this.partyClientId &&
          other.groupClientId == this.groupClientId &&
          other.transferId == this.transferId &&
          other.transferClientId == this.transferClientId &&
          other.isRefund == this.isRefund &&
          other.refundOfTransactionId == this.refundOfTransactionId &&
          other.recurrencePeriod == this.recurrencePeriod &&
          other.recurrenceInterval == this.recurrenceInterval &&
          other.recurrenceEndsAt == this.recurrenceEndsAt &&
          other.recurrenceNextScheduledAt == this.recurrenceNextScheduledAt);
}

class TransactionsCompanion extends UpdateCompanion<TransactionsData> {
  final Value<int?> id;
  final Value<int?> userId;
  final Value<String> clientId;
  final Value<String?> rev;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<DateTime?> lastSyncedAt;
  final Value<double> amount;
  final Value<String> type;
  final Value<String> intent;
  final Value<String?> description;
  final Value<DateTime?> datetime;
  final Value<int?> partyId;
  final Value<int?> walletId;
  final Value<int?> groupId;
  final Value<String> walletClientId;
  final Value<String?> partyClientId;
  final Value<String?> groupClientId;
  final Value<int?> transferId;
  final Value<String?> transferClientId;
  final Value<bool> isRefund;
  final Value<int?> refundOfTransactionId;
  final Value<String?> recurrencePeriod;
  final Value<int?> recurrenceInterval;
  final Value<DateTime?> recurrenceEndsAt;
  final Value<DateTime?> recurrenceNextScheduledAt;
  final Value<int> rowid;
  const TransactionsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.clientId = const Value.absent(),
    this.rev = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.amount = const Value.absent(),
    this.type = const Value.absent(),
    this.intent = const Value.absent(),
    this.description = const Value.absent(),
    this.datetime = const Value.absent(),
    this.partyId = const Value.absent(),
    this.walletId = const Value.absent(),
    this.groupId = const Value.absent(),
    this.walletClientId = const Value.absent(),
    this.partyClientId = const Value.absent(),
    this.groupClientId = const Value.absent(),
    this.transferId = const Value.absent(),
    this.transferClientId = const Value.absent(),
    this.isRefund = const Value.absent(),
    this.refundOfTransactionId = const Value.absent(),
    this.recurrencePeriod = const Value.absent(),
    this.recurrenceInterval = const Value.absent(),
    this.recurrenceEndsAt = const Value.absent(),
    this.recurrenceNextScheduledAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TransactionsCompanion.insert({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.clientId = const Value.absent(),
    this.rev = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    required double amount,
    required String type,
    this.intent = const Value.absent(),
    this.description = const Value.absent(),
    this.datetime = const Value.absent(),
    this.partyId = const Value.absent(),
    this.walletId = const Value.absent(),
    this.groupId = const Value.absent(),
    required String walletClientId,
    this.partyClientId = const Value.absent(),
    this.groupClientId = const Value.absent(),
    this.transferId = const Value.absent(),
    this.transferClientId = const Value.absent(),
    this.isRefund = const Value.absent(),
    this.refundOfTransactionId = const Value.absent(),
    this.recurrencePeriod = const Value.absent(),
    this.recurrenceInterval = const Value.absent(),
    this.recurrenceEndsAt = const Value.absent(),
    this.recurrenceNextScheduledAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : amount = Value(amount),
        type = Value(type),
        walletClientId = Value(walletClientId);
  static Insertable<TransactionsData> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<String>? clientId,
    Expression<String>? rev,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<DateTime>? lastSyncedAt,
    Expression<double>? amount,
    Expression<String>? type,
    Expression<String>? intent,
    Expression<String>? description,
    Expression<DateTime>? datetime,
    Expression<int>? partyId,
    Expression<int>? walletId,
    Expression<int>? groupId,
    Expression<String>? walletClientId,
    Expression<String>? partyClientId,
    Expression<String>? groupClientId,
    Expression<int>? transferId,
    Expression<String>? transferClientId,
    Expression<bool>? isRefund,
    Expression<int>? refundOfTransactionId,
    Expression<String>? recurrencePeriod,
    Expression<int>? recurrenceInterval,
    Expression<DateTime>? recurrenceEndsAt,
    Expression<DateTime>? recurrenceNextScheduledAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (clientId != null) 'client_id': clientId,
      if (rev != null) 'rev': rev,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
      if (amount != null) 'amount': amount,
      if (type != null) 'type': type,
      if (intent != null) 'intent': intent,
      if (description != null) 'description': description,
      if (datetime != null) 'datetime': datetime,
      if (partyId != null) 'party_id': partyId,
      if (walletId != null) 'wallet_id': walletId,
      if (groupId != null) 'group_id': groupId,
      if (walletClientId != null) 'wallet_client_id': walletClientId,
      if (partyClientId != null) 'party_client_id': partyClientId,
      if (groupClientId != null) 'group_client_id': groupClientId,
      if (transferId != null) 'transfer_id': transferId,
      if (transferClientId != null) 'transfer_client_id': transferClientId,
      if (isRefund != null) 'is_refund': isRefund,
      if (refundOfTransactionId != null)
        'refund_of_transaction_id': refundOfTransactionId,
      if (recurrencePeriod != null) 'recurrence_period': recurrencePeriod,
      if (recurrenceInterval != null) 'recurrence_interval': recurrenceInterval,
      if (recurrenceEndsAt != null) 'recurrence_ends_at': recurrenceEndsAt,
      if (recurrenceNextScheduledAt != null)
        'recurrence_next_scheduled_at': recurrenceNextScheduledAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TransactionsCompanion copyWith(
      {Value<int?>? id,
      Value<int?>? userId,
      Value<String>? clientId,
      Value<String?>? rev,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<DateTime?>? deletedAt,
      Value<DateTime?>? lastSyncedAt,
      Value<double>? amount,
      Value<String>? type,
      Value<String>? intent,
      Value<String?>? description,
      Value<DateTime?>? datetime,
      Value<int?>? partyId,
      Value<int?>? walletId,
      Value<int?>? groupId,
      Value<String>? walletClientId,
      Value<String?>? partyClientId,
      Value<String?>? groupClientId,
      Value<int?>? transferId,
      Value<String?>? transferClientId,
      Value<bool>? isRefund,
      Value<int?>? refundOfTransactionId,
      Value<String?>? recurrencePeriod,
      Value<int?>? recurrenceInterval,
      Value<DateTime?>? recurrenceEndsAt,
      Value<DateTime?>? recurrenceNextScheduledAt,
      Value<int>? rowid}) {
    return TransactionsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      clientId: clientId ?? this.clientId,
      rev: rev ?? this.rev,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      intent: intent ?? this.intent,
      description: description ?? this.description,
      datetime: datetime ?? this.datetime,
      partyId: partyId ?? this.partyId,
      walletId: walletId ?? this.walletId,
      groupId: groupId ?? this.groupId,
      walletClientId: walletClientId ?? this.walletClientId,
      partyClientId: partyClientId ?? this.partyClientId,
      groupClientId: groupClientId ?? this.groupClientId,
      transferId: transferId ?? this.transferId,
      transferClientId: transferClientId ?? this.transferClientId,
      isRefund: isRefund ?? this.isRefund,
      refundOfTransactionId:
          refundOfTransactionId ?? this.refundOfTransactionId,
      recurrencePeriod: recurrencePeriod ?? this.recurrencePeriod,
      recurrenceInterval: recurrenceInterval ?? this.recurrenceInterval,
      recurrenceEndsAt: recurrenceEndsAt ?? this.recurrenceEndsAt,
      recurrenceNextScheduledAt:
          recurrenceNextScheduledAt ?? this.recurrenceNextScheduledAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (clientId.present) {
      map['client_id'] = Variable<String>(clientId.value);
    }
    if (rev.present) {
      map['rev'] = Variable<String>(rev.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (lastSyncedAt.present) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (intent.present) {
      map['intent'] = Variable<String>(intent.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (datetime.present) {
      map['datetime'] = Variable<DateTime>(datetime.value);
    }
    if (partyId.present) {
      map['party_id'] = Variable<int>(partyId.value);
    }
    if (walletId.present) {
      map['wallet_id'] = Variable<int>(walletId.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<int>(groupId.value);
    }
    if (walletClientId.present) {
      map['wallet_client_id'] = Variable<String>(walletClientId.value);
    }
    if (partyClientId.present) {
      map['party_client_id'] = Variable<String>(partyClientId.value);
    }
    if (groupClientId.present) {
      map['group_client_id'] = Variable<String>(groupClientId.value);
    }
    if (transferId.present) {
      map['transfer_id'] = Variable<int>(transferId.value);
    }
    if (transferClientId.present) {
      map['transfer_client_id'] = Variable<String>(transferClientId.value);
    }
    if (isRefund.present) {
      map['is_refund'] = Variable<bool>(isRefund.value);
    }
    if (refundOfTransactionId.present) {
      map['refund_of_transaction_id'] =
          Variable<int>(refundOfTransactionId.value);
    }
    if (recurrencePeriod.present) {
      map['recurrence_period'] = Variable<String>(recurrencePeriod.value);
    }
    if (recurrenceInterval.present) {
      map['recurrence_interval'] = Variable<int>(recurrenceInterval.value);
    }
    if (recurrenceEndsAt.present) {
      map['recurrence_ends_at'] = Variable<DateTime>(recurrenceEndsAt.value);
    }
    if (recurrenceNextScheduledAt.present) {
      map['recurrence_next_scheduled_at'] =
          Variable<DateTime>(recurrenceNextScheduledAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('clientId: $clientId, ')
          ..write('rev: $rev, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('amount: $amount, ')
          ..write('type: $type, ')
          ..write('intent: $intent, ')
          ..write('description: $description, ')
          ..write('datetime: $datetime, ')
          ..write('partyId: $partyId, ')
          ..write('walletId: $walletId, ')
          ..write('groupId: $groupId, ')
          ..write('walletClientId: $walletClientId, ')
          ..write('partyClientId: $partyClientId, ')
          ..write('groupClientId: $groupClientId, ')
          ..write('transferId: $transferId, ')
          ..write('transferClientId: $transferClientId, ')
          ..write('isRefund: $isRefund, ')
          ..write('refundOfTransactionId: $refundOfTransactionId, ')
          ..write('recurrencePeriod: $recurrencePeriod, ')
          ..write('recurrenceInterval: $recurrenceInterval, ')
          ..write('recurrenceEndsAt: $recurrenceEndsAt, ')
          ..write('recurrenceNextScheduledAt: $recurrenceNextScheduledAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class Categories extends Table with TableInfo<Categories, CategoriesData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Categories(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  late final GeneratedColumn<String> clientId = GeneratedColumn<String>(
      'client_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const CustomExpression('\'\''));
  late final GeneratedColumn<String> rev = GeneratedColumn<String>(
      'rev', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const CustomExpression('\'1\''));
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: const CustomExpression('CURRENT_TIMESTAMP'));
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: const CustomExpression('CURRENT_TIMESTAMP'));
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  late final GeneratedColumn<DateTime> lastSyncedAt = GeneratedColumn<DateTime>(
      'last_synced_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  late final GeneratedColumn<String> slug = GeneratedColumn<String>(
      'slug', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
      'icon', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userId,
        clientId,
        rev,
        createdAt,
        updatedAt,
        deletedAt,
        lastSyncedAt,
        name,
        slug,
        description,
        type,
        icon
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  Set<GeneratedColumn> get $primaryKey => {clientId};
  @override
  CategoriesData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoriesData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id']),
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id']),
      clientId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}client_id'])!,
      rev: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}rev']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
      lastSyncedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_synced_at']),
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      slug: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}slug'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      icon: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}icon']),
    );
  }

  @override
  Categories createAlias(String alias) {
    return Categories(attachedDatabase, alias);
  }
}

class CategoriesData extends DataClass implements Insertable<CategoriesData> {
  final int? id;
  final int? userId;
  final String clientId;
  final String? rev;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final DateTime? lastSyncedAt;
  final String name;
  final String slug;
  final String? description;
  final String type;
  final String? icon;
  const CategoriesData(
      {this.id,
      this.userId,
      required this.clientId,
      this.rev,
      required this.createdAt,
      required this.updatedAt,
      this.deletedAt,
      this.lastSyncedAt,
      required this.name,
      required this.slug,
      this.description,
      required this.type,
      this.icon});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<int>(userId);
    }
    map['client_id'] = Variable<String>(clientId);
    if (!nullToAbsent || rev != null) {
      map['rev'] = Variable<String>(rev);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    if (!nullToAbsent || lastSyncedAt != null) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt);
    }
    map['name'] = Variable<String>(name);
    map['slug'] = Variable<String>(slug);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || icon != null) {
      map['icon'] = Variable<String>(icon);
    }
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      userId:
          userId == null && nullToAbsent ? const Value.absent() : Value(userId),
      clientId: Value(clientId),
      rev: rev == null && nullToAbsent ? const Value.absent() : Value(rev),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      lastSyncedAt: lastSyncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncedAt),
      name: Value(name),
      slug: Value(slug),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      type: Value(type),
      icon: icon == null && nullToAbsent ? const Value.absent() : Value(icon),
    );
  }

  factory CategoriesData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoriesData(
      id: serializer.fromJson<int?>(json['id']),
      userId: serializer.fromJson<int?>(json['userId']),
      clientId: serializer.fromJson<String>(json['clientId']),
      rev: serializer.fromJson<String?>(json['rev']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      lastSyncedAt: serializer.fromJson<DateTime?>(json['lastSyncedAt']),
      name: serializer.fromJson<String>(json['name']),
      slug: serializer.fromJson<String>(json['slug']),
      description: serializer.fromJson<String?>(json['description']),
      type: serializer.fromJson<String>(json['type']),
      icon: serializer.fromJson<String?>(json['icon']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int?>(id),
      'userId': serializer.toJson<int?>(userId),
      'clientId': serializer.toJson<String>(clientId),
      'rev': serializer.toJson<String?>(rev),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'lastSyncedAt': serializer.toJson<DateTime?>(lastSyncedAt),
      'name': serializer.toJson<String>(name),
      'slug': serializer.toJson<String>(slug),
      'description': serializer.toJson<String?>(description),
      'type': serializer.toJson<String>(type),
      'icon': serializer.toJson<String?>(icon),
    };
  }

  CategoriesData copyWith(
          {Value<int?> id = const Value.absent(),
          Value<int?> userId = const Value.absent(),
          String? clientId,
          Value<String?> rev = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<DateTime?> deletedAt = const Value.absent(),
          Value<DateTime?> lastSyncedAt = const Value.absent(),
          String? name,
          String? slug,
          Value<String?> description = const Value.absent(),
          String? type,
          Value<String?> icon = const Value.absent()}) =>
      CategoriesData(
        id: id.present ? id.value : this.id,
        userId: userId.present ? userId.value : this.userId,
        clientId: clientId ?? this.clientId,
        rev: rev.present ? rev.value : this.rev,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
        lastSyncedAt:
            lastSyncedAt.present ? lastSyncedAt.value : this.lastSyncedAt,
        name: name ?? this.name,
        slug: slug ?? this.slug,
        description: description.present ? description.value : this.description,
        type: type ?? this.type,
        icon: icon.present ? icon.value : this.icon,
      );
  CategoriesData copyWithCompanion(CategoriesCompanion data) {
    return CategoriesData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      clientId: data.clientId.present ? data.clientId.value : this.clientId,
      rev: data.rev.present ? data.rev.value : this.rev,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      lastSyncedAt: data.lastSyncedAt.present
          ? data.lastSyncedAt.value
          : this.lastSyncedAt,
      name: data.name.present ? data.name.value : this.name,
      slug: data.slug.present ? data.slug.value : this.slug,
      description:
          data.description.present ? data.description.value : this.description,
      type: data.type.present ? data.type.value : this.type,
      icon: data.icon.present ? data.icon.value : this.icon,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('clientId: $clientId, ')
          ..write('rev: $rev, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('name: $name, ')
          ..write('slug: $slug, ')
          ..write('description: $description, ')
          ..write('type: $type, ')
          ..write('icon: $icon')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userId, clientId, rev, createdAt,
      updatedAt, deletedAt, lastSyncedAt, name, slug, description, type, icon);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoriesData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.clientId == this.clientId &&
          other.rev == this.rev &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.lastSyncedAt == this.lastSyncedAt &&
          other.name == this.name &&
          other.slug == this.slug &&
          other.description == this.description &&
          other.type == this.type &&
          other.icon == this.icon);
}

class CategoriesCompanion extends UpdateCompanion<CategoriesData> {
  final Value<int?> id;
  final Value<int?> userId;
  final Value<String> clientId;
  final Value<String?> rev;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<DateTime?> lastSyncedAt;
  final Value<String> name;
  final Value<String> slug;
  final Value<String?> description;
  final Value<String> type;
  final Value<String?> icon;
  final Value<int> rowid;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.clientId = const Value.absent(),
    this.rev = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.name = const Value.absent(),
    this.slug = const Value.absent(),
    this.description = const Value.absent(),
    this.type = const Value.absent(),
    this.icon = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CategoriesCompanion.insert({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.clientId = const Value.absent(),
    this.rev = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    required String name,
    required String slug,
    this.description = const Value.absent(),
    required String type,
    this.icon = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : name = Value(name),
        slug = Value(slug),
        type = Value(type);
  static Insertable<CategoriesData> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<String>? clientId,
    Expression<String>? rev,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<DateTime>? lastSyncedAt,
    Expression<String>? name,
    Expression<String>? slug,
    Expression<String>? description,
    Expression<String>? type,
    Expression<String>? icon,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (clientId != null) 'client_id': clientId,
      if (rev != null) 'rev': rev,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
      if (name != null) 'name': name,
      if (slug != null) 'slug': slug,
      if (description != null) 'description': description,
      if (type != null) 'type': type,
      if (icon != null) 'icon': icon,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CategoriesCompanion copyWith(
      {Value<int?>? id,
      Value<int?>? userId,
      Value<String>? clientId,
      Value<String?>? rev,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<DateTime?>? deletedAt,
      Value<DateTime?>? lastSyncedAt,
      Value<String>? name,
      Value<String>? slug,
      Value<String?>? description,
      Value<String>? type,
      Value<String?>? icon,
      Value<int>? rowid}) {
    return CategoriesCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      clientId: clientId ?? this.clientId,
      rev: rev ?? this.rev,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      description: description ?? this.description,
      type: type ?? this.type,
      icon: icon ?? this.icon,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (clientId.present) {
      map['client_id'] = Variable<String>(clientId.value);
    }
    if (rev.present) {
      map['rev'] = Variable<String>(rev.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (lastSyncedAt.present) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (slug.present) {
      map['slug'] = Variable<String>(slug.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('clientId: $clientId, ')
          ..write('rev: $rev, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('name: $name, ')
          ..write('slug: $slug, ')
          ..write('description: $description, ')
          ..write('type: $type, ')
          ..write('icon: $icon, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class Configs extends Table with TableInfo<Configs, ConfigsData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Configs(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  late final GeneratedColumn<String> clientId = GeneratedColumn<String>(
      'client_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const CustomExpression('\'\''));
  late final GeneratedColumn<String> rev = GeneratedColumn<String>(
      'rev', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const CustomExpression('\'1\''));
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: const CustomExpression('CURRENT_TIMESTAMP'));
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: const CustomExpression('CURRENT_TIMESTAMP'));
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  late final GeneratedColumn<DateTime> lastSyncedAt = GeneratedColumn<DateTime>(
      'last_synced_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
      'key', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
      'value', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userId,
        clientId,
        rev,
        createdAt,
        updatedAt,
        deletedAt,
        lastSyncedAt,
        key,
        type,
        value
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'configs';
  @override
  Set<GeneratedColumn> get $primaryKey => {clientId};
  @override
  ConfigsData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ConfigsData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id']),
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id']),
      clientId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}client_id'])!,
      rev: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}rev']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
      lastSyncedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_synced_at']),
      key: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}key'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}value'])!,
    );
  }

  @override
  Configs createAlias(String alias) {
    return Configs(attachedDatabase, alias);
  }
}

class ConfigsData extends DataClass implements Insertable<ConfigsData> {
  final int? id;
  final int? userId;
  final String clientId;
  final String? rev;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final DateTime? lastSyncedAt;
  final String key;
  final String type;
  final String value;
  const ConfigsData(
      {this.id,
      this.userId,
      required this.clientId,
      this.rev,
      required this.createdAt,
      required this.updatedAt,
      this.deletedAt,
      this.lastSyncedAt,
      required this.key,
      required this.type,
      required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<int>(userId);
    }
    map['client_id'] = Variable<String>(clientId);
    if (!nullToAbsent || rev != null) {
      map['rev'] = Variable<String>(rev);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    if (!nullToAbsent || lastSyncedAt != null) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt);
    }
    map['key'] = Variable<String>(key);
    map['type'] = Variable<String>(type);
    map['value'] = Variable<String>(value);
    return map;
  }

  ConfigsCompanion toCompanion(bool nullToAbsent) {
    return ConfigsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      userId:
          userId == null && nullToAbsent ? const Value.absent() : Value(userId),
      clientId: Value(clientId),
      rev: rev == null && nullToAbsent ? const Value.absent() : Value(rev),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      lastSyncedAt: lastSyncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncedAt),
      key: Value(key),
      type: Value(type),
      value: Value(value),
    );
  }

  factory ConfigsData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ConfigsData(
      id: serializer.fromJson<int?>(json['id']),
      userId: serializer.fromJson<int?>(json['userId']),
      clientId: serializer.fromJson<String>(json['clientId']),
      rev: serializer.fromJson<String?>(json['rev']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      lastSyncedAt: serializer.fromJson<DateTime?>(json['lastSyncedAt']),
      key: serializer.fromJson<String>(json['key']),
      type: serializer.fromJson<String>(json['type']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int?>(id),
      'userId': serializer.toJson<int?>(userId),
      'clientId': serializer.toJson<String>(clientId),
      'rev': serializer.toJson<String?>(rev),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'lastSyncedAt': serializer.toJson<DateTime?>(lastSyncedAt),
      'key': serializer.toJson<String>(key),
      'type': serializer.toJson<String>(type),
      'value': serializer.toJson<String>(value),
    };
  }

  ConfigsData copyWith(
          {Value<int?> id = const Value.absent(),
          Value<int?> userId = const Value.absent(),
          String? clientId,
          Value<String?> rev = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<DateTime?> deletedAt = const Value.absent(),
          Value<DateTime?> lastSyncedAt = const Value.absent(),
          String? key,
          String? type,
          String? value}) =>
      ConfigsData(
        id: id.present ? id.value : this.id,
        userId: userId.present ? userId.value : this.userId,
        clientId: clientId ?? this.clientId,
        rev: rev.present ? rev.value : this.rev,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
        lastSyncedAt:
            lastSyncedAt.present ? lastSyncedAt.value : this.lastSyncedAt,
        key: key ?? this.key,
        type: type ?? this.type,
        value: value ?? this.value,
      );
  ConfigsData copyWithCompanion(ConfigsCompanion data) {
    return ConfigsData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      clientId: data.clientId.present ? data.clientId.value : this.clientId,
      rev: data.rev.present ? data.rev.value : this.rev,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      lastSyncedAt: data.lastSyncedAt.present
          ? data.lastSyncedAt.value
          : this.lastSyncedAt,
      key: data.key.present ? data.key.value : this.key,
      type: data.type.present ? data.type.value : this.type,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ConfigsData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('clientId: $clientId, ')
          ..write('rev: $rev, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('key: $key, ')
          ..write('type: $type, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userId, clientId, rev, createdAt,
      updatedAt, deletedAt, lastSyncedAt, key, type, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ConfigsData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.clientId == this.clientId &&
          other.rev == this.rev &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.lastSyncedAt == this.lastSyncedAt &&
          other.key == this.key &&
          other.type == this.type &&
          other.value == this.value);
}

class ConfigsCompanion extends UpdateCompanion<ConfigsData> {
  final Value<int?> id;
  final Value<int?> userId;
  final Value<String> clientId;
  final Value<String?> rev;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<DateTime?> lastSyncedAt;
  final Value<String> key;
  final Value<String> type;
  final Value<String> value;
  final Value<int> rowid;
  const ConfigsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.clientId = const Value.absent(),
    this.rev = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.key = const Value.absent(),
    this.type = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ConfigsCompanion.insert({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.clientId = const Value.absent(),
    this.rev = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    required String key,
    required String type,
    required String value,
    this.rowid = const Value.absent(),
  })  : key = Value(key),
        type = Value(type),
        value = Value(value);
  static Insertable<ConfigsData> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<String>? clientId,
    Expression<String>? rev,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<DateTime>? lastSyncedAt,
    Expression<String>? key,
    Expression<String>? type,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (clientId != null) 'client_id': clientId,
      if (rev != null) 'rev': rev,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
      if (key != null) 'key': key,
      if (type != null) 'type': type,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ConfigsCompanion copyWith(
      {Value<int?>? id,
      Value<int?>? userId,
      Value<String>? clientId,
      Value<String?>? rev,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<DateTime?>? deletedAt,
      Value<DateTime?>? lastSyncedAt,
      Value<String>? key,
      Value<String>? type,
      Value<String>? value,
      Value<int>? rowid}) {
    return ConfigsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      clientId: clientId ?? this.clientId,
      rev: rev ?? this.rev,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      key: key ?? this.key,
      type: type ?? this.type,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (clientId.present) {
      map['client_id'] = Variable<String>(clientId.value);
    }
    if (rev.present) {
      map['rev'] = Variable<String>(rev.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (lastSyncedAt.present) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt.value);
    }
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ConfigsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('clientId: $clientId, ')
          ..write('rev: $rev, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('key: $key, ')
          ..write('type: $type, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class Users extends Table with TableInfo<Users, UsersData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Users(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  late final GeneratedColumn<String> firstName = GeneratedColumn<String>(
      'first_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> lastName = GeneratedColumn<String>(
      'last_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
      'username', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
      'phone', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  late final GeneratedColumn<String> avatar = GeneratedColumn<String>(
      'avatar', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        email,
        firstName,
        lastName,
        username,
        phone,
        avatar,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UsersData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UsersData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email'])!,
      firstName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}first_name'])!,
      lastName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}last_name']),
      username: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}username']),
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone']),
      avatar: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}avatar']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
    );
  }

  @override
  Users createAlias(String alias) {
    return Users(attachedDatabase, alias);
  }
}

class UsersData extends DataClass implements Insertable<UsersData> {
  final int id;
  final String email;
  final String firstName;
  final String? lastName;
  final String? username;
  final String? phone;
  final String? avatar;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  const UsersData(
      {required this.id,
      required this.email,
      required this.firstName,
      this.lastName,
      this.username,
      this.phone,
      this.avatar,
      this.createdAt,
      this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['email'] = Variable<String>(email);
    map['first_name'] = Variable<String>(firstName);
    if (!nullToAbsent || lastName != null) {
      map['last_name'] = Variable<String>(lastName);
    }
    if (!nullToAbsent || username != null) {
      map['username'] = Variable<String>(username);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || avatar != null) {
      map['avatar'] = Variable<String>(avatar);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      email: Value(email),
      firstName: Value(firstName),
      lastName: lastName == null && nullToAbsent
          ? const Value.absent()
          : Value(lastName),
      username: username == null && nullToAbsent
          ? const Value.absent()
          : Value(username),
      phone:
          phone == null && nullToAbsent ? const Value.absent() : Value(phone),
      avatar:
          avatar == null && nullToAbsent ? const Value.absent() : Value(avatar),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory UsersData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UsersData(
      id: serializer.fromJson<int>(json['id']),
      email: serializer.fromJson<String>(json['email']),
      firstName: serializer.fromJson<String>(json['firstName']),
      lastName: serializer.fromJson<String?>(json['lastName']),
      username: serializer.fromJson<String?>(json['username']),
      phone: serializer.fromJson<String?>(json['phone']),
      avatar: serializer.fromJson<String?>(json['avatar']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'email': serializer.toJson<String>(email),
      'firstName': serializer.toJson<String>(firstName),
      'lastName': serializer.toJson<String?>(lastName),
      'username': serializer.toJson<String?>(username),
      'phone': serializer.toJson<String?>(phone),
      'avatar': serializer.toJson<String?>(avatar),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  UsersData copyWith(
          {int? id,
          String? email,
          String? firstName,
          Value<String?> lastName = const Value.absent(),
          Value<String?> username = const Value.absent(),
          Value<String?> phone = const Value.absent(),
          Value<String?> avatar = const Value.absent(),
          Value<DateTime?> createdAt = const Value.absent(),
          Value<DateTime?> updatedAt = const Value.absent()}) =>
      UsersData(
        id: id ?? this.id,
        email: email ?? this.email,
        firstName: firstName ?? this.firstName,
        lastName: lastName.present ? lastName.value : this.lastName,
        username: username.present ? username.value : this.username,
        phone: phone.present ? phone.value : this.phone,
        avatar: avatar.present ? avatar.value : this.avatar,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
      );
  UsersData copyWithCompanion(UsersCompanion data) {
    return UsersData(
      id: data.id.present ? data.id.value : this.id,
      email: data.email.present ? data.email.value : this.email,
      firstName: data.firstName.present ? data.firstName.value : this.firstName,
      lastName: data.lastName.present ? data.lastName.value : this.lastName,
      username: data.username.present ? data.username.value : this.username,
      phone: data.phone.present ? data.phone.value : this.phone,
      avatar: data.avatar.present ? data.avatar.value : this.avatar,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UsersData(')
          ..write('id: $id, ')
          ..write('email: $email, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('username: $username, ')
          ..write('phone: $phone, ')
          ..write('avatar: $avatar, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, email, firstName, lastName, username,
      phone, avatar, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UsersData &&
          other.id == this.id &&
          other.email == this.email &&
          other.firstName == this.firstName &&
          other.lastName == this.lastName &&
          other.username == this.username &&
          other.phone == this.phone &&
          other.avatar == this.avatar &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class UsersCompanion extends UpdateCompanion<UsersData> {
  final Value<int> id;
  final Value<String> email;
  final Value<String> firstName;
  final Value<String?> lastName;
  final Value<String?> username;
  final Value<String?> phone;
  final Value<String?> avatar;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.email = const Value.absent(),
    this.firstName = const Value.absent(),
    this.lastName = const Value.absent(),
    this.username = const Value.absent(),
    this.phone = const Value.absent(),
    this.avatar = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  UsersCompanion.insert({
    this.id = const Value.absent(),
    required String email,
    required String firstName,
    this.lastName = const Value.absent(),
    this.username = const Value.absent(),
    this.phone = const Value.absent(),
    this.avatar = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : email = Value(email),
        firstName = Value(firstName);
  static Insertable<UsersData> custom({
    Expression<int>? id,
    Expression<String>? email,
    Expression<String>? firstName,
    Expression<String>? lastName,
    Expression<String>? username,
    Expression<String>? phone,
    Expression<String>? avatar,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (email != null) 'email': email,
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (username != null) 'username': username,
      if (phone != null) 'phone': phone,
      if (avatar != null) 'avatar': avatar,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  UsersCompanion copyWith(
      {Value<int>? id,
      Value<String>? email,
      Value<String>? firstName,
      Value<String?>? lastName,
      Value<String?>? username,
      Value<String?>? phone,
      Value<String?>? avatar,
      Value<DateTime?>? createdAt,
      Value<DateTime?>? updatedAt}) {
    return UsersCompanion(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      username: username ?? this.username,
      phone: phone ?? this.phone,
      avatar: avatar ?? this.avatar,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (firstName.present) {
      map['first_name'] = Variable<String>(firstName.value);
    }
    if (lastName.present) {
      map['last_name'] = Variable<String>(lastName.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (avatar.present) {
      map['avatar'] = Variable<String>(avatar.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('email: $email, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('username: $username, ')
          ..write('phone: $phone, ')
          ..write('avatar: $avatar, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class LocalChanges extends Table
    with TableInfo<LocalChanges, LocalChangesData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  LocalChanges(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
      'entity_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
      'entity_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> entityRev = GeneratedColumn<String>(
      'entity_rev', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
      'deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("deleted" IN (0, 1))'));
  late final GeneratedColumn<String> data = GeneratedColumn<String>(
      'data', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<DateTime> createAt = GeneratedColumn<DateTime>(
      'create_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  late final GeneratedColumn<bool> concluded = GeneratedColumn<bool>(
      'concluded', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("concluded" IN (0, 1))'));
  late final GeneratedColumn<DateTime> concludedMoment =
      GeneratedColumn<DateTime>('concluded_moment', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  late final GeneratedColumn<String> error = GeneratedColumn<String>(
      'error', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  late final GeneratedColumn<bool> dismissed = GeneratedColumn<bool>(
      'dismissed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("dismissed" IN (0, 1))'));
  late final GeneratedColumn<int> attemptCount = GeneratedColumn<int>(
      'attempt_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const CustomExpression('0'));
  late final GeneratedColumn<DateTime> quarantinedAt =
      GeneratedColumn<DateTime>('quarantined_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        entityType,
        entityId,
        entityRev,
        deleted,
        data,
        createAt,
        concluded,
        concludedMoment,
        error,
        dismissed,
        attemptCount,
        quarantinedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_changes';
  @override
  Set<GeneratedColumn> get $primaryKey => {entityId, entityType};
  @override
  LocalChangesData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalChangesData(
      entityType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_type'])!,
      entityId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_id'])!,
      entityRev: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_rev'])!,
      deleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}deleted'])!,
      data: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}data'])!,
      createAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}create_at'])!,
      concluded: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}concluded'])!,
      concludedMoment: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}concluded_moment']),
      error: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}error']),
      dismissed: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}dismissed'])!,
      attemptCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}attempt_count'])!,
      quarantinedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}quarantined_at']),
    );
  }

  @override
  LocalChanges createAlias(String alias) {
    return LocalChanges(attachedDatabase, alias);
  }
}

class LocalChangesData extends DataClass
    implements Insertable<LocalChangesData> {
  final String entityType;
  final String entityId;
  final String entityRev;
  final bool deleted;
  final String data;
  final DateTime createAt;
  final bool concluded;
  final DateTime? concludedMoment;
  final String? error;
  final bool dismissed;
  final int attemptCount;
  final DateTime? quarantinedAt;
  const LocalChangesData(
      {required this.entityType,
      required this.entityId,
      required this.entityRev,
      required this.deleted,
      required this.data,
      required this.createAt,
      required this.concluded,
      this.concludedMoment,
      this.error,
      required this.dismissed,
      required this.attemptCount,
      this.quarantinedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['entity_type'] = Variable<String>(entityType);
    map['entity_id'] = Variable<String>(entityId);
    map['entity_rev'] = Variable<String>(entityRev);
    map['deleted'] = Variable<bool>(deleted);
    map['data'] = Variable<String>(data);
    map['create_at'] = Variable<DateTime>(createAt);
    map['concluded'] = Variable<bool>(concluded);
    if (!nullToAbsent || concludedMoment != null) {
      map['concluded_moment'] = Variable<DateTime>(concludedMoment);
    }
    if (!nullToAbsent || error != null) {
      map['error'] = Variable<String>(error);
    }
    map['dismissed'] = Variable<bool>(dismissed);
    map['attempt_count'] = Variable<int>(attemptCount);
    if (!nullToAbsent || quarantinedAt != null) {
      map['quarantined_at'] = Variable<DateTime>(quarantinedAt);
    }
    return map;
  }

  LocalChangesCompanion toCompanion(bool nullToAbsent) {
    return LocalChangesCompanion(
      entityType: Value(entityType),
      entityId: Value(entityId),
      entityRev: Value(entityRev),
      deleted: Value(deleted),
      data: Value(data),
      createAt: Value(createAt),
      concluded: Value(concluded),
      concludedMoment: concludedMoment == null && nullToAbsent
          ? const Value.absent()
          : Value(concludedMoment),
      error:
          error == null && nullToAbsent ? const Value.absent() : Value(error),
      dismissed: Value(dismissed),
      attemptCount: Value(attemptCount),
      quarantinedAt: quarantinedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(quarantinedAt),
    );
  }

  factory LocalChangesData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalChangesData(
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<String>(json['entityId']),
      entityRev: serializer.fromJson<String>(json['entityRev']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      data: serializer.fromJson<String>(json['data']),
      createAt: serializer.fromJson<DateTime>(json['createAt']),
      concluded: serializer.fromJson<bool>(json['concluded']),
      concludedMoment: serializer.fromJson<DateTime?>(json['concludedMoment']),
      error: serializer.fromJson<String?>(json['error']),
      dismissed: serializer.fromJson<bool>(json['dismissed']),
      attemptCount: serializer.fromJson<int>(json['attemptCount']),
      quarantinedAt: serializer.fromJson<DateTime?>(json['quarantinedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<String>(entityId),
      'entityRev': serializer.toJson<String>(entityRev),
      'deleted': serializer.toJson<bool>(deleted),
      'data': serializer.toJson<String>(data),
      'createAt': serializer.toJson<DateTime>(createAt),
      'concluded': serializer.toJson<bool>(concluded),
      'concludedMoment': serializer.toJson<DateTime?>(concludedMoment),
      'error': serializer.toJson<String?>(error),
      'dismissed': serializer.toJson<bool>(dismissed),
      'attemptCount': serializer.toJson<int>(attemptCount),
      'quarantinedAt': serializer.toJson<DateTime?>(quarantinedAt),
    };
  }

  LocalChangesData copyWith(
          {String? entityType,
          String? entityId,
          String? entityRev,
          bool? deleted,
          String? data,
          DateTime? createAt,
          bool? concluded,
          Value<DateTime?> concludedMoment = const Value.absent(),
          Value<String?> error = const Value.absent(),
          bool? dismissed,
          int? attemptCount,
          Value<DateTime?> quarantinedAt = const Value.absent()}) =>
      LocalChangesData(
        entityType: entityType ?? this.entityType,
        entityId: entityId ?? this.entityId,
        entityRev: entityRev ?? this.entityRev,
        deleted: deleted ?? this.deleted,
        data: data ?? this.data,
        createAt: createAt ?? this.createAt,
        concluded: concluded ?? this.concluded,
        concludedMoment: concludedMoment.present
            ? concludedMoment.value
            : this.concludedMoment,
        error: error.present ? error.value : this.error,
        dismissed: dismissed ?? this.dismissed,
        attemptCount: attemptCount ?? this.attemptCount,
        quarantinedAt:
            quarantinedAt.present ? quarantinedAt.value : this.quarantinedAt,
      );
  LocalChangesData copyWithCompanion(LocalChangesCompanion data) {
    return LocalChangesData(
      entityType:
          data.entityType.present ? data.entityType.value : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      entityRev: data.entityRev.present ? data.entityRev.value : this.entityRev,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      data: data.data.present ? data.data.value : this.data,
      createAt: data.createAt.present ? data.createAt.value : this.createAt,
      concluded: data.concluded.present ? data.concluded.value : this.concluded,
      concludedMoment: data.concludedMoment.present
          ? data.concludedMoment.value
          : this.concludedMoment,
      error: data.error.present ? data.error.value : this.error,
      dismissed: data.dismissed.present ? data.dismissed.value : this.dismissed,
      attemptCount: data.attemptCount.present
          ? data.attemptCount.value
          : this.attemptCount,
      quarantinedAt: data.quarantinedAt.present
          ? data.quarantinedAt.value
          : this.quarantinedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalChangesData(')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('entityRev: $entityRev, ')
          ..write('deleted: $deleted, ')
          ..write('data: $data, ')
          ..write('createAt: $createAt, ')
          ..write('concluded: $concluded, ')
          ..write('concludedMoment: $concludedMoment, ')
          ..write('error: $error, ')
          ..write('dismissed: $dismissed, ')
          ..write('attemptCount: $attemptCount, ')
          ..write('quarantinedAt: $quarantinedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      entityType,
      entityId,
      entityRev,
      deleted,
      data,
      createAt,
      concluded,
      concludedMoment,
      error,
      dismissed,
      attemptCount,
      quarantinedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalChangesData &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.entityRev == this.entityRev &&
          other.deleted == this.deleted &&
          other.data == this.data &&
          other.createAt == this.createAt &&
          other.concluded == this.concluded &&
          other.concludedMoment == this.concludedMoment &&
          other.error == this.error &&
          other.dismissed == this.dismissed &&
          other.attemptCount == this.attemptCount &&
          other.quarantinedAt == this.quarantinedAt);
}

class LocalChangesCompanion extends UpdateCompanion<LocalChangesData> {
  final Value<String> entityType;
  final Value<String> entityId;
  final Value<String> entityRev;
  final Value<bool> deleted;
  final Value<String> data;
  final Value<DateTime> createAt;
  final Value<bool> concluded;
  final Value<DateTime?> concludedMoment;
  final Value<String?> error;
  final Value<bool> dismissed;
  final Value<int> attemptCount;
  final Value<DateTime?> quarantinedAt;
  final Value<int> rowid;
  const LocalChangesCompanion({
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.entityRev = const Value.absent(),
    this.deleted = const Value.absent(),
    this.data = const Value.absent(),
    this.createAt = const Value.absent(),
    this.concluded = const Value.absent(),
    this.concludedMoment = const Value.absent(),
    this.error = const Value.absent(),
    this.dismissed = const Value.absent(),
    this.attemptCount = const Value.absent(),
    this.quarantinedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalChangesCompanion.insert({
    required String entityType,
    required String entityId,
    required String entityRev,
    required bool deleted,
    required String data,
    required DateTime createAt,
    required bool concluded,
    this.concludedMoment = const Value.absent(),
    this.error = const Value.absent(),
    required bool dismissed,
    this.attemptCount = const Value.absent(),
    this.quarantinedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : entityType = Value(entityType),
        entityId = Value(entityId),
        entityRev = Value(entityRev),
        deleted = Value(deleted),
        data = Value(data),
        createAt = Value(createAt),
        concluded = Value(concluded),
        dismissed = Value(dismissed);
  static Insertable<LocalChangesData> custom({
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<String>? entityRev,
    Expression<bool>? deleted,
    Expression<String>? data,
    Expression<DateTime>? createAt,
    Expression<bool>? concluded,
    Expression<DateTime>? concludedMoment,
    Expression<String>? error,
    Expression<bool>? dismissed,
    Expression<int>? attemptCount,
    Expression<DateTime>? quarantinedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (entityRev != null) 'entity_rev': entityRev,
      if (deleted != null) 'deleted': deleted,
      if (data != null) 'data': data,
      if (createAt != null) 'create_at': createAt,
      if (concluded != null) 'concluded': concluded,
      if (concludedMoment != null) 'concluded_moment': concludedMoment,
      if (error != null) 'error': error,
      if (dismissed != null) 'dismissed': dismissed,
      if (attemptCount != null) 'attempt_count': attemptCount,
      if (quarantinedAt != null) 'quarantined_at': quarantinedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalChangesCompanion copyWith(
      {Value<String>? entityType,
      Value<String>? entityId,
      Value<String>? entityRev,
      Value<bool>? deleted,
      Value<String>? data,
      Value<DateTime>? createAt,
      Value<bool>? concluded,
      Value<DateTime?>? concludedMoment,
      Value<String?>? error,
      Value<bool>? dismissed,
      Value<int>? attemptCount,
      Value<DateTime?>? quarantinedAt,
      Value<int>? rowid}) {
    return LocalChangesCompanion(
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      entityRev: entityRev ?? this.entityRev,
      deleted: deleted ?? this.deleted,
      data: data ?? this.data,
      createAt: createAt ?? this.createAt,
      concluded: concluded ?? this.concluded,
      concludedMoment: concludedMoment ?? this.concludedMoment,
      error: error ?? this.error,
      dismissed: dismissed ?? this.dismissed,
      attemptCount: attemptCount ?? this.attemptCount,
      quarantinedAt: quarantinedAt ?? this.quarantinedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (entityRev.present) {
      map['entity_rev'] = Variable<String>(entityRev.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (data.present) {
      map['data'] = Variable<String>(data.value);
    }
    if (createAt.present) {
      map['create_at'] = Variable<DateTime>(createAt.value);
    }
    if (concluded.present) {
      map['concluded'] = Variable<bool>(concluded.value);
    }
    if (concludedMoment.present) {
      map['concluded_moment'] = Variable<DateTime>(concludedMoment.value);
    }
    if (error.present) {
      map['error'] = Variable<String>(error.value);
    }
    if (dismissed.present) {
      map['dismissed'] = Variable<bool>(dismissed.value);
    }
    if (attemptCount.present) {
      map['attempt_count'] = Variable<int>(attemptCount.value);
    }
    if (quarantinedAt.present) {
      map['quarantined_at'] = Variable<DateTime>(quarantinedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalChangesCompanion(')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('entityRev: $entityRev, ')
          ..write('deleted: $deleted, ')
          ..write('data: $data, ')
          ..write('createAt: $createAt, ')
          ..write('concluded: $concluded, ')
          ..write('concludedMoment: $concludedMoment, ')
          ..write('error: $error, ')
          ..write('dismissed: $dismissed, ')
          ..write('attemptCount: $attemptCount, ')
          ..write('quarantinedAt: $quarantinedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class SyncMetadata extends Table
    with TableInfo<SyncMetadata, SyncMetadataData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  SyncMetadata(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
      'entity_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<DateTime> lastSyncedAt = GeneratedColumn<DateTime>(
      'last_synced_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  late final GeneratedColumn<DateTime> lastAttemptedAt =
      GeneratedColumn<DateTime>('last_attempted_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
      'last_error', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [entityType, lastSyncedAt, lastAttemptedAt, lastError];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_metadata';
  @override
  Set<GeneratedColumn> get $primaryKey => {entityType};
  @override
  SyncMetadataData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncMetadataData(
      entityType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_type'])!,
      lastSyncedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_synced_at']),
      lastAttemptedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_attempted_at']),
      lastError: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}last_error']),
    );
  }

  @override
  SyncMetadata createAlias(String alias) {
    return SyncMetadata(attachedDatabase, alias);
  }
}

class SyncMetadataData extends DataClass
    implements Insertable<SyncMetadataData> {
  final String entityType;
  final DateTime? lastSyncedAt;
  final DateTime? lastAttemptedAt;
  final String? lastError;
  const SyncMetadataData(
      {required this.entityType,
      this.lastSyncedAt,
      this.lastAttemptedAt,
      this.lastError});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['entity_type'] = Variable<String>(entityType);
    if (!nullToAbsent || lastSyncedAt != null) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt);
    }
    if (!nullToAbsent || lastAttemptedAt != null) {
      map['last_attempted_at'] = Variable<DateTime>(lastAttemptedAt);
    }
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    return map;
  }

  SyncMetadataCompanion toCompanion(bool nullToAbsent) {
    return SyncMetadataCompanion(
      entityType: Value(entityType),
      lastSyncedAt: lastSyncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncedAt),
      lastAttemptedAt: lastAttemptedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastAttemptedAt),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
    );
  }

  factory SyncMetadataData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncMetadataData(
      entityType: serializer.fromJson<String>(json['entityType']),
      lastSyncedAt: serializer.fromJson<DateTime?>(json['lastSyncedAt']),
      lastAttemptedAt: serializer.fromJson<DateTime?>(json['lastAttemptedAt']),
      lastError: serializer.fromJson<String?>(json['lastError']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'entityType': serializer.toJson<String>(entityType),
      'lastSyncedAt': serializer.toJson<DateTime?>(lastSyncedAt),
      'lastAttemptedAt': serializer.toJson<DateTime?>(lastAttemptedAt),
      'lastError': serializer.toJson<String?>(lastError),
    };
  }

  SyncMetadataData copyWith(
          {String? entityType,
          Value<DateTime?> lastSyncedAt = const Value.absent(),
          Value<DateTime?> lastAttemptedAt = const Value.absent(),
          Value<String?> lastError = const Value.absent()}) =>
      SyncMetadataData(
        entityType: entityType ?? this.entityType,
        lastSyncedAt:
            lastSyncedAt.present ? lastSyncedAt.value : this.lastSyncedAt,
        lastAttemptedAt: lastAttemptedAt.present
            ? lastAttemptedAt.value
            : this.lastAttemptedAt,
        lastError: lastError.present ? lastError.value : this.lastError,
      );
  SyncMetadataData copyWithCompanion(SyncMetadataCompanion data) {
    return SyncMetadataData(
      entityType:
          data.entityType.present ? data.entityType.value : this.entityType,
      lastSyncedAt: data.lastSyncedAt.present
          ? data.lastSyncedAt.value
          : this.lastSyncedAt,
      lastAttemptedAt: data.lastAttemptedAt.present
          ? data.lastAttemptedAt.value
          : this.lastAttemptedAt,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncMetadataData(')
          ..write('entityType: $entityType, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('lastAttemptedAt: $lastAttemptedAt, ')
          ..write('lastError: $lastError')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(entityType, lastSyncedAt, lastAttemptedAt, lastError);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncMetadataData &&
          other.entityType == this.entityType &&
          other.lastSyncedAt == this.lastSyncedAt &&
          other.lastAttemptedAt == this.lastAttemptedAt &&
          other.lastError == this.lastError);
}

class SyncMetadataCompanion extends UpdateCompanion<SyncMetadataData> {
  final Value<String> entityType;
  final Value<DateTime?> lastSyncedAt;
  final Value<DateTime?> lastAttemptedAt;
  final Value<String?> lastError;
  final Value<int> rowid;
  const SyncMetadataCompanion({
    this.entityType = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.lastAttemptedAt = const Value.absent(),
    this.lastError = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncMetadataCompanion.insert({
    required String entityType,
    this.lastSyncedAt = const Value.absent(),
    this.lastAttemptedAt = const Value.absent(),
    this.lastError = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : entityType = Value(entityType);
  static Insertable<SyncMetadataData> custom({
    Expression<String>? entityType,
    Expression<DateTime>? lastSyncedAt,
    Expression<DateTime>? lastAttemptedAt,
    Expression<String>? lastError,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (entityType != null) 'entity_type': entityType,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
      if (lastAttemptedAt != null) 'last_attempted_at': lastAttemptedAt,
      if (lastError != null) 'last_error': lastError,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncMetadataCompanion copyWith(
      {Value<String>? entityType,
      Value<DateTime?>? lastSyncedAt,
      Value<DateTime?>? lastAttemptedAt,
      Value<String?>? lastError,
      Value<int>? rowid}) {
    return SyncMetadataCompanion(
      entityType: entityType ?? this.entityType,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      lastAttemptedAt: lastAttemptedAt ?? this.lastAttemptedAt,
      lastError: lastError ?? this.lastError,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (lastSyncedAt.present) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt.value);
    }
    if (lastAttemptedAt.present) {
      map['last_attempted_at'] = Variable<DateTime>(lastAttemptedAt.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncMetadataCompanion(')
          ..write('entityType: $entityType, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('lastAttemptedAt: $lastAttemptedAt, ')
          ..write('lastError: $lastError, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class Categorizables extends Table
    with TableInfo<Categorizables, CategorizablesData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Categorizables(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<String> categorizableId = GeneratedColumn<String>(
      'categorizable_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> categorizableType =
      GeneratedColumn<String>('categorizable_type', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> categoryClientId = GeneratedColumn<String>(
      'category_client_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES categories (client_id)'));
  @override
  List<GeneratedColumn> get $columns =>
      [categorizableId, categorizableType, categoryClientId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categorizables';
  @override
  Set<GeneratedColumn> get $primaryKey =>
      {categorizableId, categorizableType, categoryClientId};
  @override
  CategorizablesData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategorizablesData(
      categorizableId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}categorizable_id'])!,
      categorizableType: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}categorizable_type'])!,
      categoryClientId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}category_client_id'])!,
    );
  }

  @override
  Categorizables createAlias(String alias) {
    return Categorizables(attachedDatabase, alias);
  }
}

class CategorizablesData extends DataClass
    implements Insertable<CategorizablesData> {
  final String categorizableId;
  final String categorizableType;
  final String categoryClientId;
  const CategorizablesData(
      {required this.categorizableId,
      required this.categorizableType,
      required this.categoryClientId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['categorizable_id'] = Variable<String>(categorizableId);
    map['categorizable_type'] = Variable<String>(categorizableType);
    map['category_client_id'] = Variable<String>(categoryClientId);
    return map;
  }

  CategorizablesCompanion toCompanion(bool nullToAbsent) {
    return CategorizablesCompanion(
      categorizableId: Value(categorizableId),
      categorizableType: Value(categorizableType),
      categoryClientId: Value(categoryClientId),
    );
  }

  factory CategorizablesData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategorizablesData(
      categorizableId: serializer.fromJson<String>(json['categorizableId']),
      categorizableType: serializer.fromJson<String>(json['categorizableType']),
      categoryClientId: serializer.fromJson<String>(json['categoryClientId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'categorizableId': serializer.toJson<String>(categorizableId),
      'categorizableType': serializer.toJson<String>(categorizableType),
      'categoryClientId': serializer.toJson<String>(categoryClientId),
    };
  }

  CategorizablesData copyWith(
          {String? categorizableId,
          String? categorizableType,
          String? categoryClientId}) =>
      CategorizablesData(
        categorizableId: categorizableId ?? this.categorizableId,
        categorizableType: categorizableType ?? this.categorizableType,
        categoryClientId: categoryClientId ?? this.categoryClientId,
      );
  CategorizablesData copyWithCompanion(CategorizablesCompanion data) {
    return CategorizablesData(
      categorizableId: data.categorizableId.present
          ? data.categorizableId.value
          : this.categorizableId,
      categorizableType: data.categorizableType.present
          ? data.categorizableType.value
          : this.categorizableType,
      categoryClientId: data.categoryClientId.present
          ? data.categoryClientId.value
          : this.categoryClientId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategorizablesData(')
          ..write('categorizableId: $categorizableId, ')
          ..write('categorizableType: $categorizableType, ')
          ..write('categoryClientId: $categoryClientId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(categorizableId, categorizableType, categoryClientId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategorizablesData &&
          other.categorizableId == this.categorizableId &&
          other.categorizableType == this.categorizableType &&
          other.categoryClientId == this.categoryClientId);
}

class CategorizablesCompanion extends UpdateCompanion<CategorizablesData> {
  final Value<String> categorizableId;
  final Value<String> categorizableType;
  final Value<String> categoryClientId;
  final Value<int> rowid;
  const CategorizablesCompanion({
    this.categorizableId = const Value.absent(),
    this.categorizableType = const Value.absent(),
    this.categoryClientId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CategorizablesCompanion.insert({
    required String categorizableId,
    required String categorizableType,
    required String categoryClientId,
    this.rowid = const Value.absent(),
  })  : categorizableId = Value(categorizableId),
        categorizableType = Value(categorizableType),
        categoryClientId = Value(categoryClientId);
  static Insertable<CategorizablesData> custom({
    Expression<String>? categorizableId,
    Expression<String>? categorizableType,
    Expression<String>? categoryClientId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (categorizableId != null) 'categorizable_id': categorizableId,
      if (categorizableType != null) 'categorizable_type': categorizableType,
      if (categoryClientId != null) 'category_client_id': categoryClientId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CategorizablesCompanion copyWith(
      {Value<String>? categorizableId,
      Value<String>? categorizableType,
      Value<String>? categoryClientId,
      Value<int>? rowid}) {
    return CategorizablesCompanion(
      categorizableId: categorizableId ?? this.categorizableId,
      categorizableType: categorizableType ?? this.categorizableType,
      categoryClientId: categoryClientId ?? this.categoryClientId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (categorizableId.present) {
      map['categorizable_id'] = Variable<String>(categorizableId.value);
    }
    if (categorizableType.present) {
      map['categorizable_type'] = Variable<String>(categorizableType.value);
    }
    if (categoryClientId.present) {
      map['category_client_id'] = Variable<String>(categoryClientId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategorizablesCompanion(')
          ..write('categorizableId: $categorizableId, ')
          ..write('categorizableType: $categorizableType, ')
          ..write('categoryClientId: $categoryClientId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class Notifications extends Table
    with TableInfo<Notifications, NotificationsData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Notifications(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  late final GeneratedColumn<String> clientId = GeneratedColumn<String>(
      'client_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const CustomExpression('\'\''));
  late final GeneratedColumn<String> rev = GeneratedColumn<String>(
      'rev', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const CustomExpression('\'1\''));
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: const CustomExpression('CURRENT_TIMESTAMP'));
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: const CustomExpression('CURRENT_TIMESTAMP'));
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  late final GeneratedColumn<DateTime> lastSyncedAt = GeneratedColumn<DateTime>(
      'last_synced_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
      'body', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> data = GeneratedColumn<String>(
      'data', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<DateTime> readAt = GeneratedColumn<DateTime>(
      'read_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userId,
        clientId,
        rev,
        createdAt,
        updatedAt,
        deletedAt,
        lastSyncedAt,
        type,
        title,
        body,
        data,
        readAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notifications';
  @override
  Set<GeneratedColumn> get $primaryKey => {clientId};
  @override
  NotificationsData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NotificationsData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id']),
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id']),
      clientId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}client_id'])!,
      rev: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}rev']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
      lastSyncedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_synced_at']),
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      body: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}body'])!,
      data: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}data'])!,
      readAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}read_at']),
    );
  }

  @override
  Notifications createAlias(String alias) {
    return Notifications(attachedDatabase, alias);
  }
}

class NotificationsData extends DataClass
    implements Insertable<NotificationsData> {
  final int? id;
  final int? userId;
  final String clientId;
  final String? rev;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final DateTime? lastSyncedAt;
  final String type;
  final String title;
  final String body;
  final String data;
  final DateTime? readAt;
  const NotificationsData(
      {this.id,
      this.userId,
      required this.clientId,
      this.rev,
      required this.createdAt,
      required this.updatedAt,
      this.deletedAt,
      this.lastSyncedAt,
      required this.type,
      required this.title,
      required this.body,
      required this.data,
      this.readAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<int>(userId);
    }
    map['client_id'] = Variable<String>(clientId);
    if (!nullToAbsent || rev != null) {
      map['rev'] = Variable<String>(rev);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    if (!nullToAbsent || lastSyncedAt != null) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt);
    }
    map['type'] = Variable<String>(type);
    map['title'] = Variable<String>(title);
    map['body'] = Variable<String>(body);
    map['data'] = Variable<String>(data);
    if (!nullToAbsent || readAt != null) {
      map['read_at'] = Variable<DateTime>(readAt);
    }
    return map;
  }

  NotificationsCompanion toCompanion(bool nullToAbsent) {
    return NotificationsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      userId:
          userId == null && nullToAbsent ? const Value.absent() : Value(userId),
      clientId: Value(clientId),
      rev: rev == null && nullToAbsent ? const Value.absent() : Value(rev),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      lastSyncedAt: lastSyncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncedAt),
      type: Value(type),
      title: Value(title),
      body: Value(body),
      data: Value(data),
      readAt:
          readAt == null && nullToAbsent ? const Value.absent() : Value(readAt),
    );
  }

  factory NotificationsData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NotificationsData(
      id: serializer.fromJson<int?>(json['id']),
      userId: serializer.fromJson<int?>(json['userId']),
      clientId: serializer.fromJson<String>(json['clientId']),
      rev: serializer.fromJson<String?>(json['rev']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      lastSyncedAt: serializer.fromJson<DateTime?>(json['lastSyncedAt']),
      type: serializer.fromJson<String>(json['type']),
      title: serializer.fromJson<String>(json['title']),
      body: serializer.fromJson<String>(json['body']),
      data: serializer.fromJson<String>(json['data']),
      readAt: serializer.fromJson<DateTime?>(json['readAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int?>(id),
      'userId': serializer.toJson<int?>(userId),
      'clientId': serializer.toJson<String>(clientId),
      'rev': serializer.toJson<String?>(rev),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'lastSyncedAt': serializer.toJson<DateTime?>(lastSyncedAt),
      'type': serializer.toJson<String>(type),
      'title': serializer.toJson<String>(title),
      'body': serializer.toJson<String>(body),
      'data': serializer.toJson<String>(data),
      'readAt': serializer.toJson<DateTime?>(readAt),
    };
  }

  NotificationsData copyWith(
          {Value<int?> id = const Value.absent(),
          Value<int?> userId = const Value.absent(),
          String? clientId,
          Value<String?> rev = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<DateTime?> deletedAt = const Value.absent(),
          Value<DateTime?> lastSyncedAt = const Value.absent(),
          String? type,
          String? title,
          String? body,
          String? data,
          Value<DateTime?> readAt = const Value.absent()}) =>
      NotificationsData(
        id: id.present ? id.value : this.id,
        userId: userId.present ? userId.value : this.userId,
        clientId: clientId ?? this.clientId,
        rev: rev.present ? rev.value : this.rev,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
        lastSyncedAt:
            lastSyncedAt.present ? lastSyncedAt.value : this.lastSyncedAt,
        type: type ?? this.type,
        title: title ?? this.title,
        body: body ?? this.body,
        data: data ?? this.data,
        readAt: readAt.present ? readAt.value : this.readAt,
      );
  NotificationsData copyWithCompanion(NotificationsCompanion data) {
    return NotificationsData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      clientId: data.clientId.present ? data.clientId.value : this.clientId,
      rev: data.rev.present ? data.rev.value : this.rev,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      lastSyncedAt: data.lastSyncedAt.present
          ? data.lastSyncedAt.value
          : this.lastSyncedAt,
      type: data.type.present ? data.type.value : this.type,
      title: data.title.present ? data.title.value : this.title,
      body: data.body.present ? data.body.value : this.body,
      data: data.data.present ? data.data.value : this.data,
      readAt: data.readAt.present ? data.readAt.value : this.readAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NotificationsData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('clientId: $clientId, ')
          ..write('rev: $rev, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('type: $type, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('data: $data, ')
          ..write('readAt: $readAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userId, clientId, rev, createdAt,
      updatedAt, deletedAt, lastSyncedAt, type, title, body, data, readAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NotificationsData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.clientId == this.clientId &&
          other.rev == this.rev &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.lastSyncedAt == this.lastSyncedAt &&
          other.type == this.type &&
          other.title == this.title &&
          other.body == this.body &&
          other.data == this.data &&
          other.readAt == this.readAt);
}

class NotificationsCompanion extends UpdateCompanion<NotificationsData> {
  final Value<int?> id;
  final Value<int?> userId;
  final Value<String> clientId;
  final Value<String?> rev;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<DateTime?> lastSyncedAt;
  final Value<String> type;
  final Value<String> title;
  final Value<String> body;
  final Value<String> data;
  final Value<DateTime?> readAt;
  final Value<int> rowid;
  const NotificationsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.clientId = const Value.absent(),
    this.rev = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.type = const Value.absent(),
    this.title = const Value.absent(),
    this.body = const Value.absent(),
    this.data = const Value.absent(),
    this.readAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NotificationsCompanion.insert({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.clientId = const Value.absent(),
    this.rev = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    required String type,
    required String title,
    required String body,
    required String data,
    this.readAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : type = Value(type),
        title = Value(title),
        body = Value(body),
        data = Value(data);
  static Insertable<NotificationsData> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<String>? clientId,
    Expression<String>? rev,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<DateTime>? lastSyncedAt,
    Expression<String>? type,
    Expression<String>? title,
    Expression<String>? body,
    Expression<String>? data,
    Expression<DateTime>? readAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (clientId != null) 'client_id': clientId,
      if (rev != null) 'rev': rev,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
      if (type != null) 'type': type,
      if (title != null) 'title': title,
      if (body != null) 'body': body,
      if (data != null) 'data': data,
      if (readAt != null) 'read_at': readAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NotificationsCompanion copyWith(
      {Value<int?>? id,
      Value<int?>? userId,
      Value<String>? clientId,
      Value<String?>? rev,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<DateTime?>? deletedAt,
      Value<DateTime?>? lastSyncedAt,
      Value<String>? type,
      Value<String>? title,
      Value<String>? body,
      Value<String>? data,
      Value<DateTime?>? readAt,
      Value<int>? rowid}) {
    return NotificationsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      clientId: clientId ?? this.clientId,
      rev: rev ?? this.rev,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      type: type ?? this.type,
      title: title ?? this.title,
      body: body ?? this.body,
      data: data ?? this.data,
      readAt: readAt ?? this.readAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (clientId.present) {
      map['client_id'] = Variable<String>(clientId.value);
    }
    if (rev.present) {
      map['rev'] = Variable<String>(rev.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (lastSyncedAt.present) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (data.present) {
      map['data'] = Variable<String>(data.value);
    }
    if (readAt.present) {
      map['read_at'] = Variable<DateTime>(readAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotificationsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('clientId: $clientId, ')
          ..write('rev: $rev, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('type: $type, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('data: $data, ')
          ..write('readAt: $readAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class MediaFiles extends Table with TableInfo<MediaFiles, MediaFilesData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  MediaFiles(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<String> path = GeneratedColumn<String>(
      'path', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  late final GeneratedColumn<String> fileableType = GeneratedColumn<String>(
      'fileable_type', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  late final GeneratedColumn<int> fileableId = GeneratedColumn<int>(
      'fileable_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  late final GeneratedColumn<String> localFileableType =
      GeneratedColumn<String>('local_fileable_type', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  late final GeneratedColumn<String> localFileableId = GeneratedColumn<String>(
      'local_fileable_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        path,
        id,
        type,
        fileableType,
        fileableId,
        localFileableType,
        localFileableId,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'media_files';
  @override
  Set<GeneratedColumn> get $primaryKey => {path};
  @override
  MediaFilesData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MediaFilesData(
      path: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}path'])!,
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id']),
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type']),
      fileableType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}fileable_type']),
      fileableId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}fileable_id']),
      localFileableType: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}local_fileable_type']),
      localFileableId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}local_fileable_id']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
    );
  }

  @override
  MediaFiles createAlias(String alias) {
    return MediaFiles(attachedDatabase, alias);
  }
}

class MediaFilesData extends DataClass implements Insertable<MediaFilesData> {
  final String path;
  final int? id;
  final String? type;
  final String? fileableType;
  final int? fileableId;
  final String? localFileableType;
  final String? localFileableId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  const MediaFilesData(
      {required this.path,
      this.id,
      this.type,
      this.fileableType,
      this.fileableId,
      this.localFileableType,
      this.localFileableId,
      this.createdAt,
      this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['path'] = Variable<String>(path);
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || type != null) {
      map['type'] = Variable<String>(type);
    }
    if (!nullToAbsent || fileableType != null) {
      map['fileable_type'] = Variable<String>(fileableType);
    }
    if (!nullToAbsent || fileableId != null) {
      map['fileable_id'] = Variable<int>(fileableId);
    }
    if (!nullToAbsent || localFileableType != null) {
      map['local_fileable_type'] = Variable<String>(localFileableType);
    }
    if (!nullToAbsent || localFileableId != null) {
      map['local_fileable_id'] = Variable<String>(localFileableId);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  MediaFilesCompanion toCompanion(bool nullToAbsent) {
    return MediaFilesCompanion(
      path: Value(path),
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      type: type == null && nullToAbsent ? const Value.absent() : Value(type),
      fileableType: fileableType == null && nullToAbsent
          ? const Value.absent()
          : Value(fileableType),
      fileableId: fileableId == null && nullToAbsent
          ? const Value.absent()
          : Value(fileableId),
      localFileableType: localFileableType == null && nullToAbsent
          ? const Value.absent()
          : Value(localFileableType),
      localFileableId: localFileableId == null && nullToAbsent
          ? const Value.absent()
          : Value(localFileableId),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory MediaFilesData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MediaFilesData(
      path: serializer.fromJson<String>(json['path']),
      id: serializer.fromJson<int?>(json['id']),
      type: serializer.fromJson<String?>(json['type']),
      fileableType: serializer.fromJson<String?>(json['fileableType']),
      fileableId: serializer.fromJson<int?>(json['fileableId']),
      localFileableType:
          serializer.fromJson<String?>(json['localFileableType']),
      localFileableId: serializer.fromJson<String?>(json['localFileableId']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'path': serializer.toJson<String>(path),
      'id': serializer.toJson<int?>(id),
      'type': serializer.toJson<String?>(type),
      'fileableType': serializer.toJson<String?>(fileableType),
      'fileableId': serializer.toJson<int?>(fileableId),
      'localFileableType': serializer.toJson<String?>(localFileableType),
      'localFileableId': serializer.toJson<String?>(localFileableId),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  MediaFilesData copyWith(
          {String? path,
          Value<int?> id = const Value.absent(),
          Value<String?> type = const Value.absent(),
          Value<String?> fileableType = const Value.absent(),
          Value<int?> fileableId = const Value.absent(),
          Value<String?> localFileableType = const Value.absent(),
          Value<String?> localFileableId = const Value.absent(),
          Value<DateTime?> createdAt = const Value.absent(),
          Value<DateTime?> updatedAt = const Value.absent()}) =>
      MediaFilesData(
        path: path ?? this.path,
        id: id.present ? id.value : this.id,
        type: type.present ? type.value : this.type,
        fileableType:
            fileableType.present ? fileableType.value : this.fileableType,
        fileableId: fileableId.present ? fileableId.value : this.fileableId,
        localFileableType: localFileableType.present
            ? localFileableType.value
            : this.localFileableType,
        localFileableId: localFileableId.present
            ? localFileableId.value
            : this.localFileableId,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
      );
  MediaFilesData copyWithCompanion(MediaFilesCompanion data) {
    return MediaFilesData(
      path: data.path.present ? data.path.value : this.path,
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      fileableType: data.fileableType.present
          ? data.fileableType.value
          : this.fileableType,
      fileableId:
          data.fileableId.present ? data.fileableId.value : this.fileableId,
      localFileableType: data.localFileableType.present
          ? data.localFileableType.value
          : this.localFileableType,
      localFileableId: data.localFileableId.present
          ? data.localFileableId.value
          : this.localFileableId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MediaFilesData(')
          ..write('path: $path, ')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('fileableType: $fileableType, ')
          ..write('fileableId: $fileableId, ')
          ..write('localFileableType: $localFileableType, ')
          ..write('localFileableId: $localFileableId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(path, id, type, fileableType, fileableId,
      localFileableType, localFileableId, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MediaFilesData &&
          other.path == this.path &&
          other.id == this.id &&
          other.type == this.type &&
          other.fileableType == this.fileableType &&
          other.fileableId == this.fileableId &&
          other.localFileableType == this.localFileableType &&
          other.localFileableId == this.localFileableId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class MediaFilesCompanion extends UpdateCompanion<MediaFilesData> {
  final Value<String> path;
  final Value<int?> id;
  final Value<String?> type;
  final Value<String?> fileableType;
  final Value<int?> fileableId;
  final Value<String?> localFileableType;
  final Value<String?> localFileableId;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<int> rowid;
  const MediaFilesCompanion({
    this.path = const Value.absent(),
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.fileableType = const Value.absent(),
    this.fileableId = const Value.absent(),
    this.localFileableType = const Value.absent(),
    this.localFileableId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MediaFilesCompanion.insert({
    required String path,
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.fileableType = const Value.absent(),
    this.fileableId = const Value.absent(),
    this.localFileableType = const Value.absent(),
    this.localFileableId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : path = Value(path);
  static Insertable<MediaFilesData> custom({
    Expression<String>? path,
    Expression<int>? id,
    Expression<String>? type,
    Expression<String>? fileableType,
    Expression<int>? fileableId,
    Expression<String>? localFileableType,
    Expression<String>? localFileableId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (path != null) 'path': path,
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (fileableType != null) 'fileable_type': fileableType,
      if (fileableId != null) 'fileable_id': fileableId,
      if (localFileableType != null) 'local_fileable_type': localFileableType,
      if (localFileableId != null) 'local_fileable_id': localFileableId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MediaFilesCompanion copyWith(
      {Value<String>? path,
      Value<int?>? id,
      Value<String?>? type,
      Value<String?>? fileableType,
      Value<int?>? fileableId,
      Value<String?>? localFileableType,
      Value<String?>? localFileableId,
      Value<DateTime?>? createdAt,
      Value<DateTime?>? updatedAt,
      Value<int>? rowid}) {
    return MediaFilesCompanion(
      path: path ?? this.path,
      id: id ?? this.id,
      type: type ?? this.type,
      fileableType: fileableType ?? this.fileableType,
      fileableId: fileableId ?? this.fileableId,
      localFileableType: localFileableType ?? this.localFileableType,
      localFileableId: localFileableId ?? this.localFileableId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (path.present) {
      map['path'] = Variable<String>(path.value);
    }
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (fileableType.present) {
      map['fileable_type'] = Variable<String>(fileableType.value);
    }
    if (fileableId.present) {
      map['fileable_id'] = Variable<int>(fileableId.value);
    }
    if (localFileableType.present) {
      map['local_fileable_type'] = Variable<String>(localFileableType.value);
    }
    if (localFileableId.present) {
      map['local_fileable_id'] = Variable<String>(localFileableId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MediaFilesCompanion(')
          ..write('path: $path, ')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('fileableType: $fileableType, ')
          ..write('fileableId: $fileableId, ')
          ..write('localFileableType: $localFileableType, ')
          ..write('localFileableId: $localFileableId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class Transfers extends Table with TableInfo<Transfers, TransfersData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Transfers(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  late final GeneratedColumn<String> clientId = GeneratedColumn<String>(
      'client_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const CustomExpression('\'\''));
  late final GeneratedColumn<String> rev = GeneratedColumn<String>(
      'rev', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const CustomExpression('\'1\''));
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: const CustomExpression('CURRENT_TIMESTAMP'));
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: const CustomExpression('CURRENT_TIMESTAMP'));
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  late final GeneratedColumn<DateTime> lastSyncedAt = GeneratedColumn<DateTime>(
      'last_synced_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  late final GeneratedColumn<int> fromWalletId = GeneratedColumn<int>(
      'from_wallet_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  late final GeneratedColumn<int> toWalletId = GeneratedColumn<int>(
      'to_wallet_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  late final GeneratedColumn<String> fromWalletClientId =
      GeneratedColumn<String>('from_wallet_client_id', aliasedName, true,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintIsAlways(
              'REFERENCES wallets (client_id)'));
  late final GeneratedColumn<String> toWalletClientId = GeneratedColumn<String>(
      'to_wallet_client_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES wallets (client_id)'));
  late final GeneratedColumn<double> exchangeRate = GeneratedColumn<double>(
      'exchange_rate', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  late final GeneratedColumn<DateTime> datetime = GeneratedColumn<DateTime>(
      'datetime', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  late final GeneratedColumn<String> expenseTransactionClientId =
      GeneratedColumn<String>(
          'expense_transaction_client_id', aliasedName, true,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintIsAlways(
              'REFERENCES transactions (client_id)'));
  late final GeneratedColumn<String> incomeTransactionClientId =
      GeneratedColumn<String>('income_transaction_client_id', aliasedName, true,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintIsAlways(
              'REFERENCES transactions (client_id)'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userId,
        clientId,
        rev,
        createdAt,
        updatedAt,
        deletedAt,
        lastSyncedAt,
        amount,
        fromWalletId,
        toWalletId,
        fromWalletClientId,
        toWalletClientId,
        exchangeRate,
        datetime,
        expenseTransactionClientId,
        incomeTransactionClientId
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transfers';
  @override
  Set<GeneratedColumn> get $primaryKey => {clientId};
  @override
  TransfersData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TransfersData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id']),
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id']),
      clientId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}client_id'])!,
      rev: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}rev']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
      lastSyncedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_synced_at']),
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      fromWalletId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}from_wallet_id']),
      toWalletId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}to_wallet_id']),
      fromWalletClientId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}from_wallet_client_id']),
      toWalletClientId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}to_wallet_client_id']),
      exchangeRate: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}exchange_rate']),
      datetime: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}datetime'])!,
      expenseTransactionClientId: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}expense_transaction_client_id']),
      incomeTransactionClientId: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}income_transaction_client_id']),
    );
  }

  @override
  Transfers createAlias(String alias) {
    return Transfers(attachedDatabase, alias);
  }
}

class TransfersData extends DataClass implements Insertable<TransfersData> {
  final int? id;
  final int? userId;
  final String clientId;
  final String? rev;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final DateTime? lastSyncedAt;
  final double amount;
  final int? fromWalletId;
  final int? toWalletId;
  final String? fromWalletClientId;
  final String? toWalletClientId;
  final double? exchangeRate;
  final DateTime datetime;
  final String? expenseTransactionClientId;
  final String? incomeTransactionClientId;
  const TransfersData(
      {this.id,
      this.userId,
      required this.clientId,
      this.rev,
      required this.createdAt,
      required this.updatedAt,
      this.deletedAt,
      this.lastSyncedAt,
      required this.amount,
      this.fromWalletId,
      this.toWalletId,
      this.fromWalletClientId,
      this.toWalletClientId,
      this.exchangeRate,
      required this.datetime,
      this.expenseTransactionClientId,
      this.incomeTransactionClientId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<int>(userId);
    }
    map['client_id'] = Variable<String>(clientId);
    if (!nullToAbsent || rev != null) {
      map['rev'] = Variable<String>(rev);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    if (!nullToAbsent || lastSyncedAt != null) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt);
    }
    map['amount'] = Variable<double>(amount);
    if (!nullToAbsent || fromWalletId != null) {
      map['from_wallet_id'] = Variable<int>(fromWalletId);
    }
    if (!nullToAbsent || toWalletId != null) {
      map['to_wallet_id'] = Variable<int>(toWalletId);
    }
    if (!nullToAbsent || fromWalletClientId != null) {
      map['from_wallet_client_id'] = Variable<String>(fromWalletClientId);
    }
    if (!nullToAbsent || toWalletClientId != null) {
      map['to_wallet_client_id'] = Variable<String>(toWalletClientId);
    }
    if (!nullToAbsent || exchangeRate != null) {
      map['exchange_rate'] = Variable<double>(exchangeRate);
    }
    map['datetime'] = Variable<DateTime>(datetime);
    if (!nullToAbsent || expenseTransactionClientId != null) {
      map['expense_transaction_client_id'] =
          Variable<String>(expenseTransactionClientId);
    }
    if (!nullToAbsent || incomeTransactionClientId != null) {
      map['income_transaction_client_id'] =
          Variable<String>(incomeTransactionClientId);
    }
    return map;
  }

  TransfersCompanion toCompanion(bool nullToAbsent) {
    return TransfersCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      userId:
          userId == null && nullToAbsent ? const Value.absent() : Value(userId),
      clientId: Value(clientId),
      rev: rev == null && nullToAbsent ? const Value.absent() : Value(rev),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      lastSyncedAt: lastSyncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncedAt),
      amount: Value(amount),
      fromWalletId: fromWalletId == null && nullToAbsent
          ? const Value.absent()
          : Value(fromWalletId),
      toWalletId: toWalletId == null && nullToAbsent
          ? const Value.absent()
          : Value(toWalletId),
      fromWalletClientId: fromWalletClientId == null && nullToAbsent
          ? const Value.absent()
          : Value(fromWalletClientId),
      toWalletClientId: toWalletClientId == null && nullToAbsent
          ? const Value.absent()
          : Value(toWalletClientId),
      exchangeRate: exchangeRate == null && nullToAbsent
          ? const Value.absent()
          : Value(exchangeRate),
      datetime: Value(datetime),
      expenseTransactionClientId:
          expenseTransactionClientId == null && nullToAbsent
              ? const Value.absent()
              : Value(expenseTransactionClientId),
      incomeTransactionClientId:
          incomeTransactionClientId == null && nullToAbsent
              ? const Value.absent()
              : Value(incomeTransactionClientId),
    );
  }

  factory TransfersData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransfersData(
      id: serializer.fromJson<int?>(json['id']),
      userId: serializer.fromJson<int?>(json['userId']),
      clientId: serializer.fromJson<String>(json['clientId']),
      rev: serializer.fromJson<String?>(json['rev']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      lastSyncedAt: serializer.fromJson<DateTime?>(json['lastSyncedAt']),
      amount: serializer.fromJson<double>(json['amount']),
      fromWalletId: serializer.fromJson<int?>(json['fromWalletId']),
      toWalletId: serializer.fromJson<int?>(json['toWalletId']),
      fromWalletClientId:
          serializer.fromJson<String?>(json['fromWalletClientId']),
      toWalletClientId: serializer.fromJson<String?>(json['toWalletClientId']),
      exchangeRate: serializer.fromJson<double?>(json['exchangeRate']),
      datetime: serializer.fromJson<DateTime>(json['datetime']),
      expenseTransactionClientId:
          serializer.fromJson<String?>(json['expenseTransactionClientId']),
      incomeTransactionClientId:
          serializer.fromJson<String?>(json['incomeTransactionClientId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int?>(id),
      'userId': serializer.toJson<int?>(userId),
      'clientId': serializer.toJson<String>(clientId),
      'rev': serializer.toJson<String?>(rev),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'lastSyncedAt': serializer.toJson<DateTime?>(lastSyncedAt),
      'amount': serializer.toJson<double>(amount),
      'fromWalletId': serializer.toJson<int?>(fromWalletId),
      'toWalletId': serializer.toJson<int?>(toWalletId),
      'fromWalletClientId': serializer.toJson<String?>(fromWalletClientId),
      'toWalletClientId': serializer.toJson<String?>(toWalletClientId),
      'exchangeRate': serializer.toJson<double?>(exchangeRate),
      'datetime': serializer.toJson<DateTime>(datetime),
      'expenseTransactionClientId':
          serializer.toJson<String?>(expenseTransactionClientId),
      'incomeTransactionClientId':
          serializer.toJson<String?>(incomeTransactionClientId),
    };
  }

  TransfersData copyWith(
          {Value<int?> id = const Value.absent(),
          Value<int?> userId = const Value.absent(),
          String? clientId,
          Value<String?> rev = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<DateTime?> deletedAt = const Value.absent(),
          Value<DateTime?> lastSyncedAt = const Value.absent(),
          double? amount,
          Value<int?> fromWalletId = const Value.absent(),
          Value<int?> toWalletId = const Value.absent(),
          Value<String?> fromWalletClientId = const Value.absent(),
          Value<String?> toWalletClientId = const Value.absent(),
          Value<double?> exchangeRate = const Value.absent(),
          DateTime? datetime,
          Value<String?> expenseTransactionClientId = const Value.absent(),
          Value<String?> incomeTransactionClientId = const Value.absent()}) =>
      TransfersData(
        id: id.present ? id.value : this.id,
        userId: userId.present ? userId.value : this.userId,
        clientId: clientId ?? this.clientId,
        rev: rev.present ? rev.value : this.rev,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
        lastSyncedAt:
            lastSyncedAt.present ? lastSyncedAt.value : this.lastSyncedAt,
        amount: amount ?? this.amount,
        fromWalletId:
            fromWalletId.present ? fromWalletId.value : this.fromWalletId,
        toWalletId: toWalletId.present ? toWalletId.value : this.toWalletId,
        fromWalletClientId: fromWalletClientId.present
            ? fromWalletClientId.value
            : this.fromWalletClientId,
        toWalletClientId: toWalletClientId.present
            ? toWalletClientId.value
            : this.toWalletClientId,
        exchangeRate:
            exchangeRate.present ? exchangeRate.value : this.exchangeRate,
        datetime: datetime ?? this.datetime,
        expenseTransactionClientId: expenseTransactionClientId.present
            ? expenseTransactionClientId.value
            : this.expenseTransactionClientId,
        incomeTransactionClientId: incomeTransactionClientId.present
            ? incomeTransactionClientId.value
            : this.incomeTransactionClientId,
      );
  TransfersData copyWithCompanion(TransfersCompanion data) {
    return TransfersData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      clientId: data.clientId.present ? data.clientId.value : this.clientId,
      rev: data.rev.present ? data.rev.value : this.rev,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      lastSyncedAt: data.lastSyncedAt.present
          ? data.lastSyncedAt.value
          : this.lastSyncedAt,
      amount: data.amount.present ? data.amount.value : this.amount,
      fromWalletId: data.fromWalletId.present
          ? data.fromWalletId.value
          : this.fromWalletId,
      toWalletId:
          data.toWalletId.present ? data.toWalletId.value : this.toWalletId,
      fromWalletClientId: data.fromWalletClientId.present
          ? data.fromWalletClientId.value
          : this.fromWalletClientId,
      toWalletClientId: data.toWalletClientId.present
          ? data.toWalletClientId.value
          : this.toWalletClientId,
      exchangeRate: data.exchangeRate.present
          ? data.exchangeRate.value
          : this.exchangeRate,
      datetime: data.datetime.present ? data.datetime.value : this.datetime,
      expenseTransactionClientId: data.expenseTransactionClientId.present
          ? data.expenseTransactionClientId.value
          : this.expenseTransactionClientId,
      incomeTransactionClientId: data.incomeTransactionClientId.present
          ? data.incomeTransactionClientId.value
          : this.incomeTransactionClientId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TransfersData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('clientId: $clientId, ')
          ..write('rev: $rev, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('amount: $amount, ')
          ..write('fromWalletId: $fromWalletId, ')
          ..write('toWalletId: $toWalletId, ')
          ..write('fromWalletClientId: $fromWalletClientId, ')
          ..write('toWalletClientId: $toWalletClientId, ')
          ..write('exchangeRate: $exchangeRate, ')
          ..write('datetime: $datetime, ')
          ..write('expenseTransactionClientId: $expenseTransactionClientId, ')
          ..write('incomeTransactionClientId: $incomeTransactionClientId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      userId,
      clientId,
      rev,
      createdAt,
      updatedAt,
      deletedAt,
      lastSyncedAt,
      amount,
      fromWalletId,
      toWalletId,
      fromWalletClientId,
      toWalletClientId,
      exchangeRate,
      datetime,
      expenseTransactionClientId,
      incomeTransactionClientId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransfersData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.clientId == this.clientId &&
          other.rev == this.rev &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.lastSyncedAt == this.lastSyncedAt &&
          other.amount == this.amount &&
          other.fromWalletId == this.fromWalletId &&
          other.toWalletId == this.toWalletId &&
          other.fromWalletClientId == this.fromWalletClientId &&
          other.toWalletClientId == this.toWalletClientId &&
          other.exchangeRate == this.exchangeRate &&
          other.datetime == this.datetime &&
          other.expenseTransactionClientId == this.expenseTransactionClientId &&
          other.incomeTransactionClientId == this.incomeTransactionClientId);
}

class TransfersCompanion extends UpdateCompanion<TransfersData> {
  final Value<int?> id;
  final Value<int?> userId;
  final Value<String> clientId;
  final Value<String?> rev;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<DateTime?> lastSyncedAt;
  final Value<double> amount;
  final Value<int?> fromWalletId;
  final Value<int?> toWalletId;
  final Value<String?> fromWalletClientId;
  final Value<String?> toWalletClientId;
  final Value<double?> exchangeRate;
  final Value<DateTime> datetime;
  final Value<String?> expenseTransactionClientId;
  final Value<String?> incomeTransactionClientId;
  final Value<int> rowid;
  const TransfersCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.clientId = const Value.absent(),
    this.rev = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.amount = const Value.absent(),
    this.fromWalletId = const Value.absent(),
    this.toWalletId = const Value.absent(),
    this.fromWalletClientId = const Value.absent(),
    this.toWalletClientId = const Value.absent(),
    this.exchangeRate = const Value.absent(),
    this.datetime = const Value.absent(),
    this.expenseTransactionClientId = const Value.absent(),
    this.incomeTransactionClientId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TransfersCompanion.insert({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.clientId = const Value.absent(),
    this.rev = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    required double amount,
    this.fromWalletId = const Value.absent(),
    this.toWalletId = const Value.absent(),
    this.fromWalletClientId = const Value.absent(),
    this.toWalletClientId = const Value.absent(),
    this.exchangeRate = const Value.absent(),
    required DateTime datetime,
    this.expenseTransactionClientId = const Value.absent(),
    this.incomeTransactionClientId = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : amount = Value(amount),
        datetime = Value(datetime);
  static Insertable<TransfersData> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<String>? clientId,
    Expression<String>? rev,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<DateTime>? lastSyncedAt,
    Expression<double>? amount,
    Expression<int>? fromWalletId,
    Expression<int>? toWalletId,
    Expression<String>? fromWalletClientId,
    Expression<String>? toWalletClientId,
    Expression<double>? exchangeRate,
    Expression<DateTime>? datetime,
    Expression<String>? expenseTransactionClientId,
    Expression<String>? incomeTransactionClientId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (clientId != null) 'client_id': clientId,
      if (rev != null) 'rev': rev,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
      if (amount != null) 'amount': amount,
      if (fromWalletId != null) 'from_wallet_id': fromWalletId,
      if (toWalletId != null) 'to_wallet_id': toWalletId,
      if (fromWalletClientId != null)
        'from_wallet_client_id': fromWalletClientId,
      if (toWalletClientId != null) 'to_wallet_client_id': toWalletClientId,
      if (exchangeRate != null) 'exchange_rate': exchangeRate,
      if (datetime != null) 'datetime': datetime,
      if (expenseTransactionClientId != null)
        'expense_transaction_client_id': expenseTransactionClientId,
      if (incomeTransactionClientId != null)
        'income_transaction_client_id': incomeTransactionClientId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TransfersCompanion copyWith(
      {Value<int?>? id,
      Value<int?>? userId,
      Value<String>? clientId,
      Value<String?>? rev,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<DateTime?>? deletedAt,
      Value<DateTime?>? lastSyncedAt,
      Value<double>? amount,
      Value<int?>? fromWalletId,
      Value<int?>? toWalletId,
      Value<String?>? fromWalletClientId,
      Value<String?>? toWalletClientId,
      Value<double?>? exchangeRate,
      Value<DateTime>? datetime,
      Value<String?>? expenseTransactionClientId,
      Value<String?>? incomeTransactionClientId,
      Value<int>? rowid}) {
    return TransfersCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      clientId: clientId ?? this.clientId,
      rev: rev ?? this.rev,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      amount: amount ?? this.amount,
      fromWalletId: fromWalletId ?? this.fromWalletId,
      toWalletId: toWalletId ?? this.toWalletId,
      fromWalletClientId: fromWalletClientId ?? this.fromWalletClientId,
      toWalletClientId: toWalletClientId ?? this.toWalletClientId,
      exchangeRate: exchangeRate ?? this.exchangeRate,
      datetime: datetime ?? this.datetime,
      expenseTransactionClientId:
          expenseTransactionClientId ?? this.expenseTransactionClientId,
      incomeTransactionClientId:
          incomeTransactionClientId ?? this.incomeTransactionClientId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (clientId.present) {
      map['client_id'] = Variable<String>(clientId.value);
    }
    if (rev.present) {
      map['rev'] = Variable<String>(rev.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (lastSyncedAt.present) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (fromWalletId.present) {
      map['from_wallet_id'] = Variable<int>(fromWalletId.value);
    }
    if (toWalletId.present) {
      map['to_wallet_id'] = Variable<int>(toWalletId.value);
    }
    if (fromWalletClientId.present) {
      map['from_wallet_client_id'] = Variable<String>(fromWalletClientId.value);
    }
    if (toWalletClientId.present) {
      map['to_wallet_client_id'] = Variable<String>(toWalletClientId.value);
    }
    if (exchangeRate.present) {
      map['exchange_rate'] = Variable<double>(exchangeRate.value);
    }
    if (datetime.present) {
      map['datetime'] = Variable<DateTime>(datetime.value);
    }
    if (expenseTransactionClientId.present) {
      map['expense_transaction_client_id'] =
          Variable<String>(expenseTransactionClientId.value);
    }
    if (incomeTransactionClientId.present) {
      map['income_transaction_client_id'] =
          Variable<String>(incomeTransactionClientId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransfersCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('clientId: $clientId, ')
          ..write('rev: $rev, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('amount: $amount, ')
          ..write('fromWalletId: $fromWalletId, ')
          ..write('toWalletId: $toWalletId, ')
          ..write('fromWalletClientId: $fromWalletClientId, ')
          ..write('toWalletClientId: $toWalletClientId, ')
          ..write('exchangeRate: $exchangeRate, ')
          ..write('datetime: $datetime, ')
          ..write('expenseTransactionClientId: $expenseTransactionClientId, ')
          ..write('incomeTransactionClientId: $incomeTransactionClientId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class Budgets extends Table with TableInfo<Budgets, BudgetsData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Budgets(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  late final GeneratedColumn<String> clientId = GeneratedColumn<String>(
      'client_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const CustomExpression('\'\''));
  late final GeneratedColumn<String> rev = GeneratedColumn<String>(
      'rev', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const CustomExpression('\'1\''));
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: const CustomExpression('CURRENT_TIMESTAMP'));
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: const CustomExpression('CURRENT_TIMESTAMP'));
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  late final GeneratedColumn<DateTime> lastSyncedAt = GeneratedColumn<DateTime>(
      'last_synced_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> slug = GeneratedColumn<String>(
      'slug', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  late final GeneratedColumn<String> amount = GeneratedColumn<String>(
      'amount', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
      'currency', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> periodType = GeneratedColumn<String>(
      'period_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
      'start_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
      'end_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  late final GeneratedColumn<bool> rolloverEnabled = GeneratedColumn<bool>(
      'rollover_enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("rollover_enabled" IN (0, 1))'),
      defaultValue: const CustomExpression('0'));
  late final GeneratedColumn<int> thresholdPercent = GeneratedColumn<int>(
      'threshold_percent', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const CustomExpression('80'));
  late final GeneratedColumn<bool> forecastAlertsEnabled =
      GeneratedColumn<bool>('forecast_alerts_enabled', aliasedName, false,
          type: DriftSqlType.bool,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintIsAlways(
              'CHECK ("forecast_alerts_enabled" IN (0, 1))'),
          defaultValue: const CustomExpression('0'));
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const CustomExpression('1'));
  late final GeneratedColumn<String> ownerType = GeneratedColumn<String>(
      'owner_type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const CustomExpression('\'user\''));
  late final GeneratedColumn<int> ownerId = GeneratedColumn<int>(
      'owner_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  late final GeneratedColumn<String> progress = GeneratedColumn<String>(
      'progress', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userId,
        clientId,
        rev,
        createdAt,
        updatedAt,
        deletedAt,
        lastSyncedAt,
        name,
        slug,
        description,
        amount,
        currency,
        periodType,
        startDate,
        endDate,
        rolloverEnabled,
        thresholdPercent,
        forecastAlertsEnabled,
        isActive,
        ownerType,
        ownerId,
        progress
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'budgets';
  @override
  Set<GeneratedColumn> get $primaryKey => {clientId};
  @override
  BudgetsData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BudgetsData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id']),
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id']),
      clientId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}client_id'])!,
      rev: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}rev']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
      lastSyncedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_synced_at']),
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      slug: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}slug'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}amount'])!,
      currency: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}currency'])!,
      periodType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}period_type'])!,
      startDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start_date'])!,
      endDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}end_date']),
      rolloverEnabled: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}rollover_enabled'])!,
      thresholdPercent: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}threshold_percent'])!,
      forecastAlertsEnabled: attachedDatabase.typeMapping.read(
          DriftSqlType.bool,
          data['${effectivePrefix}forecast_alerts_enabled'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      ownerType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}owner_type'])!,
      ownerId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}owner_id']),
      progress: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}progress']),
    );
  }

  @override
  Budgets createAlias(String alias) {
    return Budgets(attachedDatabase, alias);
  }
}

class BudgetsData extends DataClass implements Insertable<BudgetsData> {
  final int? id;
  final int? userId;
  final String clientId;
  final String? rev;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final DateTime? lastSyncedAt;
  final String name;
  final String slug;
  final String? description;
  final String amount;
  final String currency;
  final String periodType;
  final DateTime startDate;
  final DateTime? endDate;
  final bool rolloverEnabled;
  final int thresholdPercent;
  final bool forecastAlertsEnabled;
  final bool isActive;
  final String ownerType;
  final int? ownerId;
  final String? progress;
  const BudgetsData(
      {this.id,
      this.userId,
      required this.clientId,
      this.rev,
      required this.createdAt,
      required this.updatedAt,
      this.deletedAt,
      this.lastSyncedAt,
      required this.name,
      required this.slug,
      this.description,
      required this.amount,
      required this.currency,
      required this.periodType,
      required this.startDate,
      this.endDate,
      required this.rolloverEnabled,
      required this.thresholdPercent,
      required this.forecastAlertsEnabled,
      required this.isActive,
      required this.ownerType,
      this.ownerId,
      this.progress});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<int>(userId);
    }
    map['client_id'] = Variable<String>(clientId);
    if (!nullToAbsent || rev != null) {
      map['rev'] = Variable<String>(rev);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    if (!nullToAbsent || lastSyncedAt != null) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt);
    }
    map['name'] = Variable<String>(name);
    map['slug'] = Variable<String>(slug);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['amount'] = Variable<String>(amount);
    map['currency'] = Variable<String>(currency);
    map['period_type'] = Variable<String>(periodType);
    map['start_date'] = Variable<DateTime>(startDate);
    if (!nullToAbsent || endDate != null) {
      map['end_date'] = Variable<DateTime>(endDate);
    }
    map['rollover_enabled'] = Variable<bool>(rolloverEnabled);
    map['threshold_percent'] = Variable<int>(thresholdPercent);
    map['forecast_alerts_enabled'] = Variable<bool>(forecastAlertsEnabled);
    map['is_active'] = Variable<bool>(isActive);
    map['owner_type'] = Variable<String>(ownerType);
    if (!nullToAbsent || ownerId != null) {
      map['owner_id'] = Variable<int>(ownerId);
    }
    if (!nullToAbsent || progress != null) {
      map['progress'] = Variable<String>(progress);
    }
    return map;
  }

  BudgetsCompanion toCompanion(bool nullToAbsent) {
    return BudgetsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      userId:
          userId == null && nullToAbsent ? const Value.absent() : Value(userId),
      clientId: Value(clientId),
      rev: rev == null && nullToAbsent ? const Value.absent() : Value(rev),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      lastSyncedAt: lastSyncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncedAt),
      name: Value(name),
      slug: Value(slug),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      amount: Value(amount),
      currency: Value(currency),
      periodType: Value(periodType),
      startDate: Value(startDate),
      endDate: endDate == null && nullToAbsent
          ? const Value.absent()
          : Value(endDate),
      rolloverEnabled: Value(rolloverEnabled),
      thresholdPercent: Value(thresholdPercent),
      forecastAlertsEnabled: Value(forecastAlertsEnabled),
      isActive: Value(isActive),
      ownerType: Value(ownerType),
      ownerId: ownerId == null && nullToAbsent
          ? const Value.absent()
          : Value(ownerId),
      progress: progress == null && nullToAbsent
          ? const Value.absent()
          : Value(progress),
    );
  }

  factory BudgetsData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BudgetsData(
      id: serializer.fromJson<int?>(json['id']),
      userId: serializer.fromJson<int?>(json['userId']),
      clientId: serializer.fromJson<String>(json['clientId']),
      rev: serializer.fromJson<String?>(json['rev']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      lastSyncedAt: serializer.fromJson<DateTime?>(json['lastSyncedAt']),
      name: serializer.fromJson<String>(json['name']),
      slug: serializer.fromJson<String>(json['slug']),
      description: serializer.fromJson<String?>(json['description']),
      amount: serializer.fromJson<String>(json['amount']),
      currency: serializer.fromJson<String>(json['currency']),
      periodType: serializer.fromJson<String>(json['periodType']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime?>(json['endDate']),
      rolloverEnabled: serializer.fromJson<bool>(json['rolloverEnabled']),
      thresholdPercent: serializer.fromJson<int>(json['thresholdPercent']),
      forecastAlertsEnabled:
          serializer.fromJson<bool>(json['forecastAlertsEnabled']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      ownerType: serializer.fromJson<String>(json['ownerType']),
      ownerId: serializer.fromJson<int?>(json['ownerId']),
      progress: serializer.fromJson<String?>(json['progress']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int?>(id),
      'userId': serializer.toJson<int?>(userId),
      'clientId': serializer.toJson<String>(clientId),
      'rev': serializer.toJson<String?>(rev),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'lastSyncedAt': serializer.toJson<DateTime?>(lastSyncedAt),
      'name': serializer.toJson<String>(name),
      'slug': serializer.toJson<String>(slug),
      'description': serializer.toJson<String?>(description),
      'amount': serializer.toJson<String>(amount),
      'currency': serializer.toJson<String>(currency),
      'periodType': serializer.toJson<String>(periodType),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime?>(endDate),
      'rolloverEnabled': serializer.toJson<bool>(rolloverEnabled),
      'thresholdPercent': serializer.toJson<int>(thresholdPercent),
      'forecastAlertsEnabled': serializer.toJson<bool>(forecastAlertsEnabled),
      'isActive': serializer.toJson<bool>(isActive),
      'ownerType': serializer.toJson<String>(ownerType),
      'ownerId': serializer.toJson<int?>(ownerId),
      'progress': serializer.toJson<String?>(progress),
    };
  }

  BudgetsData copyWith(
          {Value<int?> id = const Value.absent(),
          Value<int?> userId = const Value.absent(),
          String? clientId,
          Value<String?> rev = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<DateTime?> deletedAt = const Value.absent(),
          Value<DateTime?> lastSyncedAt = const Value.absent(),
          String? name,
          String? slug,
          Value<String?> description = const Value.absent(),
          String? amount,
          String? currency,
          String? periodType,
          DateTime? startDate,
          Value<DateTime?> endDate = const Value.absent(),
          bool? rolloverEnabled,
          int? thresholdPercent,
          bool? forecastAlertsEnabled,
          bool? isActive,
          String? ownerType,
          Value<int?> ownerId = const Value.absent(),
          Value<String?> progress = const Value.absent()}) =>
      BudgetsData(
        id: id.present ? id.value : this.id,
        userId: userId.present ? userId.value : this.userId,
        clientId: clientId ?? this.clientId,
        rev: rev.present ? rev.value : this.rev,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
        lastSyncedAt:
            lastSyncedAt.present ? lastSyncedAt.value : this.lastSyncedAt,
        name: name ?? this.name,
        slug: slug ?? this.slug,
        description: description.present ? description.value : this.description,
        amount: amount ?? this.amount,
        currency: currency ?? this.currency,
        periodType: periodType ?? this.periodType,
        startDate: startDate ?? this.startDate,
        endDate: endDate.present ? endDate.value : this.endDate,
        rolloverEnabled: rolloverEnabled ?? this.rolloverEnabled,
        thresholdPercent: thresholdPercent ?? this.thresholdPercent,
        forecastAlertsEnabled:
            forecastAlertsEnabled ?? this.forecastAlertsEnabled,
        isActive: isActive ?? this.isActive,
        ownerType: ownerType ?? this.ownerType,
        ownerId: ownerId.present ? ownerId.value : this.ownerId,
        progress: progress.present ? progress.value : this.progress,
      );
  BudgetsData copyWithCompanion(BudgetsCompanion data) {
    return BudgetsData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      clientId: data.clientId.present ? data.clientId.value : this.clientId,
      rev: data.rev.present ? data.rev.value : this.rev,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      lastSyncedAt: data.lastSyncedAt.present
          ? data.lastSyncedAt.value
          : this.lastSyncedAt,
      name: data.name.present ? data.name.value : this.name,
      slug: data.slug.present ? data.slug.value : this.slug,
      description:
          data.description.present ? data.description.value : this.description,
      amount: data.amount.present ? data.amount.value : this.amount,
      currency: data.currency.present ? data.currency.value : this.currency,
      periodType:
          data.periodType.present ? data.periodType.value : this.periodType,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      rolloverEnabled: data.rolloverEnabled.present
          ? data.rolloverEnabled.value
          : this.rolloverEnabled,
      thresholdPercent: data.thresholdPercent.present
          ? data.thresholdPercent.value
          : this.thresholdPercent,
      forecastAlertsEnabled: data.forecastAlertsEnabled.present
          ? data.forecastAlertsEnabled.value
          : this.forecastAlertsEnabled,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      ownerType: data.ownerType.present ? data.ownerType.value : this.ownerType,
      ownerId: data.ownerId.present ? data.ownerId.value : this.ownerId,
      progress: data.progress.present ? data.progress.value : this.progress,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BudgetsData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('clientId: $clientId, ')
          ..write('rev: $rev, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('name: $name, ')
          ..write('slug: $slug, ')
          ..write('description: $description, ')
          ..write('amount: $amount, ')
          ..write('currency: $currency, ')
          ..write('periodType: $periodType, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('rolloverEnabled: $rolloverEnabled, ')
          ..write('thresholdPercent: $thresholdPercent, ')
          ..write('forecastAlertsEnabled: $forecastAlertsEnabled, ')
          ..write('isActive: $isActive, ')
          ..write('ownerType: $ownerType, ')
          ..write('ownerId: $ownerId, ')
          ..write('progress: $progress')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        userId,
        clientId,
        rev,
        createdAt,
        updatedAt,
        deletedAt,
        lastSyncedAt,
        name,
        slug,
        description,
        amount,
        currency,
        periodType,
        startDate,
        endDate,
        rolloverEnabled,
        thresholdPercent,
        forecastAlertsEnabled,
        isActive,
        ownerType,
        ownerId,
        progress
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BudgetsData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.clientId == this.clientId &&
          other.rev == this.rev &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.lastSyncedAt == this.lastSyncedAt &&
          other.name == this.name &&
          other.slug == this.slug &&
          other.description == this.description &&
          other.amount == this.amount &&
          other.currency == this.currency &&
          other.periodType == this.periodType &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.rolloverEnabled == this.rolloverEnabled &&
          other.thresholdPercent == this.thresholdPercent &&
          other.forecastAlertsEnabled == this.forecastAlertsEnabled &&
          other.isActive == this.isActive &&
          other.ownerType == this.ownerType &&
          other.ownerId == this.ownerId &&
          other.progress == this.progress);
}

class BudgetsCompanion extends UpdateCompanion<BudgetsData> {
  final Value<int?> id;
  final Value<int?> userId;
  final Value<String> clientId;
  final Value<String?> rev;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<DateTime?> lastSyncedAt;
  final Value<String> name;
  final Value<String> slug;
  final Value<String?> description;
  final Value<String> amount;
  final Value<String> currency;
  final Value<String> periodType;
  final Value<DateTime> startDate;
  final Value<DateTime?> endDate;
  final Value<bool> rolloverEnabled;
  final Value<int> thresholdPercent;
  final Value<bool> forecastAlertsEnabled;
  final Value<bool> isActive;
  final Value<String> ownerType;
  final Value<int?> ownerId;
  final Value<String?> progress;
  final Value<int> rowid;
  const BudgetsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.clientId = const Value.absent(),
    this.rev = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.name = const Value.absent(),
    this.slug = const Value.absent(),
    this.description = const Value.absent(),
    this.amount = const Value.absent(),
    this.currency = const Value.absent(),
    this.periodType = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.rolloverEnabled = const Value.absent(),
    this.thresholdPercent = const Value.absent(),
    this.forecastAlertsEnabled = const Value.absent(),
    this.isActive = const Value.absent(),
    this.ownerType = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.progress = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BudgetsCompanion.insert({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.clientId = const Value.absent(),
    this.rev = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    required String name,
    required String slug,
    this.description = const Value.absent(),
    required String amount,
    required String currency,
    required String periodType,
    required DateTime startDate,
    this.endDate = const Value.absent(),
    this.rolloverEnabled = const Value.absent(),
    this.thresholdPercent = const Value.absent(),
    this.forecastAlertsEnabled = const Value.absent(),
    this.isActive = const Value.absent(),
    this.ownerType = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.progress = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : name = Value(name),
        slug = Value(slug),
        amount = Value(amount),
        currency = Value(currency),
        periodType = Value(periodType),
        startDate = Value(startDate);
  static Insertable<BudgetsData> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<String>? clientId,
    Expression<String>? rev,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<DateTime>? lastSyncedAt,
    Expression<String>? name,
    Expression<String>? slug,
    Expression<String>? description,
    Expression<String>? amount,
    Expression<String>? currency,
    Expression<String>? periodType,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<bool>? rolloverEnabled,
    Expression<int>? thresholdPercent,
    Expression<bool>? forecastAlertsEnabled,
    Expression<bool>? isActive,
    Expression<String>? ownerType,
    Expression<int>? ownerId,
    Expression<String>? progress,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (clientId != null) 'client_id': clientId,
      if (rev != null) 'rev': rev,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
      if (name != null) 'name': name,
      if (slug != null) 'slug': slug,
      if (description != null) 'description': description,
      if (amount != null) 'amount': amount,
      if (currency != null) 'currency': currency,
      if (periodType != null) 'period_type': periodType,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (rolloverEnabled != null) 'rollover_enabled': rolloverEnabled,
      if (thresholdPercent != null) 'threshold_percent': thresholdPercent,
      if (forecastAlertsEnabled != null)
        'forecast_alerts_enabled': forecastAlertsEnabled,
      if (isActive != null) 'is_active': isActive,
      if (ownerType != null) 'owner_type': ownerType,
      if (ownerId != null) 'owner_id': ownerId,
      if (progress != null) 'progress': progress,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BudgetsCompanion copyWith(
      {Value<int?>? id,
      Value<int?>? userId,
      Value<String>? clientId,
      Value<String?>? rev,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<DateTime?>? deletedAt,
      Value<DateTime?>? lastSyncedAt,
      Value<String>? name,
      Value<String>? slug,
      Value<String?>? description,
      Value<String>? amount,
      Value<String>? currency,
      Value<String>? periodType,
      Value<DateTime>? startDate,
      Value<DateTime?>? endDate,
      Value<bool>? rolloverEnabled,
      Value<int>? thresholdPercent,
      Value<bool>? forecastAlertsEnabled,
      Value<bool>? isActive,
      Value<String>? ownerType,
      Value<int?>? ownerId,
      Value<String?>? progress,
      Value<int>? rowid}) {
    return BudgetsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      clientId: clientId ?? this.clientId,
      rev: rev ?? this.rev,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      periodType: periodType ?? this.periodType,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      rolloverEnabled: rolloverEnabled ?? this.rolloverEnabled,
      thresholdPercent: thresholdPercent ?? this.thresholdPercent,
      forecastAlertsEnabled:
          forecastAlertsEnabled ?? this.forecastAlertsEnabled,
      isActive: isActive ?? this.isActive,
      ownerType: ownerType ?? this.ownerType,
      ownerId: ownerId ?? this.ownerId,
      progress: progress ?? this.progress,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (clientId.present) {
      map['client_id'] = Variable<String>(clientId.value);
    }
    if (rev.present) {
      map['rev'] = Variable<String>(rev.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (lastSyncedAt.present) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (slug.present) {
      map['slug'] = Variable<String>(slug.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (amount.present) {
      map['amount'] = Variable<String>(amount.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (periodType.present) {
      map['period_type'] = Variable<String>(periodType.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (rolloverEnabled.present) {
      map['rollover_enabled'] = Variable<bool>(rolloverEnabled.value);
    }
    if (thresholdPercent.present) {
      map['threshold_percent'] = Variable<int>(thresholdPercent.value);
    }
    if (forecastAlertsEnabled.present) {
      map['forecast_alerts_enabled'] =
          Variable<bool>(forecastAlertsEnabled.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (ownerType.present) {
      map['owner_type'] = Variable<String>(ownerType.value);
    }
    if (ownerId.present) {
      map['owner_id'] = Variable<int>(ownerId.value);
    }
    if (progress.present) {
      map['progress'] = Variable<String>(progress.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BudgetsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('clientId: $clientId, ')
          ..write('rev: $rev, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('name: $name, ')
          ..write('slug: $slug, ')
          ..write('description: $description, ')
          ..write('amount: $amount, ')
          ..write('currency: $currency, ')
          ..write('periodType: $periodType, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('rolloverEnabled: $rolloverEnabled, ')
          ..write('thresholdPercent: $thresholdPercent, ')
          ..write('forecastAlertsEnabled: $forecastAlertsEnabled, ')
          ..write('isActive: $isActive, ')
          ..write('ownerType: $ownerType, ')
          ..write('ownerId: $ownerId, ')
          ..write('progress: $progress, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class BudgetTargets extends Table
    with TableInfo<BudgetTargets, BudgetTargetsData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  BudgetTargets(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<String> budgetClientId = GeneratedColumn<String>(
      'budget_client_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES budgets (client_id)'));
  late final GeneratedColumn<String> targetType = GeneratedColumn<String>(
      'target_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> targetClientId = GeneratedColumn<String>(
      'target_client_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [budgetClientId, targetType, targetClientId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'budget_targets';
  @override
  Set<GeneratedColumn> get $primaryKey =>
      {budgetClientId, targetType, targetClientId};
  @override
  BudgetTargetsData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BudgetTargetsData(
      budgetClientId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}budget_client_id'])!,
      targetType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}target_type'])!,
      targetClientId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}target_client_id'])!,
    );
  }

  @override
  BudgetTargets createAlias(String alias) {
    return BudgetTargets(attachedDatabase, alias);
  }
}

class BudgetTargetsData extends DataClass
    implements Insertable<BudgetTargetsData> {
  final String budgetClientId;
  final String targetType;
  final String targetClientId;
  const BudgetTargetsData(
      {required this.budgetClientId,
      required this.targetType,
      required this.targetClientId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['budget_client_id'] = Variable<String>(budgetClientId);
    map['target_type'] = Variable<String>(targetType);
    map['target_client_id'] = Variable<String>(targetClientId);
    return map;
  }

  BudgetTargetsCompanion toCompanion(bool nullToAbsent) {
    return BudgetTargetsCompanion(
      budgetClientId: Value(budgetClientId),
      targetType: Value(targetType),
      targetClientId: Value(targetClientId),
    );
  }

  factory BudgetTargetsData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BudgetTargetsData(
      budgetClientId: serializer.fromJson<String>(json['budgetClientId']),
      targetType: serializer.fromJson<String>(json['targetType']),
      targetClientId: serializer.fromJson<String>(json['targetClientId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'budgetClientId': serializer.toJson<String>(budgetClientId),
      'targetType': serializer.toJson<String>(targetType),
      'targetClientId': serializer.toJson<String>(targetClientId),
    };
  }

  BudgetTargetsData copyWith(
          {String? budgetClientId,
          String? targetType,
          String? targetClientId}) =>
      BudgetTargetsData(
        budgetClientId: budgetClientId ?? this.budgetClientId,
        targetType: targetType ?? this.targetType,
        targetClientId: targetClientId ?? this.targetClientId,
      );
  BudgetTargetsData copyWithCompanion(BudgetTargetsCompanion data) {
    return BudgetTargetsData(
      budgetClientId: data.budgetClientId.present
          ? data.budgetClientId.value
          : this.budgetClientId,
      targetType:
          data.targetType.present ? data.targetType.value : this.targetType,
      targetClientId: data.targetClientId.present
          ? data.targetClientId.value
          : this.targetClientId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BudgetTargetsData(')
          ..write('budgetClientId: $budgetClientId, ')
          ..write('targetType: $targetType, ')
          ..write('targetClientId: $targetClientId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(budgetClientId, targetType, targetClientId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BudgetTargetsData &&
          other.budgetClientId == this.budgetClientId &&
          other.targetType == this.targetType &&
          other.targetClientId == this.targetClientId);
}

class BudgetTargetsCompanion extends UpdateCompanion<BudgetTargetsData> {
  final Value<String> budgetClientId;
  final Value<String> targetType;
  final Value<String> targetClientId;
  final Value<int> rowid;
  const BudgetTargetsCompanion({
    this.budgetClientId = const Value.absent(),
    this.targetType = const Value.absent(),
    this.targetClientId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BudgetTargetsCompanion.insert({
    required String budgetClientId,
    required String targetType,
    required String targetClientId,
    this.rowid = const Value.absent(),
  })  : budgetClientId = Value(budgetClientId),
        targetType = Value(targetType),
        targetClientId = Value(targetClientId);
  static Insertable<BudgetTargetsData> custom({
    Expression<String>? budgetClientId,
    Expression<String>? targetType,
    Expression<String>? targetClientId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (budgetClientId != null) 'budget_client_id': budgetClientId,
      if (targetType != null) 'target_type': targetType,
      if (targetClientId != null) 'target_client_id': targetClientId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BudgetTargetsCompanion copyWith(
      {Value<String>? budgetClientId,
      Value<String>? targetType,
      Value<String>? targetClientId,
      Value<int>? rowid}) {
    return BudgetTargetsCompanion(
      budgetClientId: budgetClientId ?? this.budgetClientId,
      targetType: targetType ?? this.targetType,
      targetClientId: targetClientId ?? this.targetClientId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (budgetClientId.present) {
      map['budget_client_id'] = Variable<String>(budgetClientId.value);
    }
    if (targetType.present) {
      map['target_type'] = Variable<String>(targetType.value);
    }
    if (targetClientId.present) {
      map['target_client_id'] = Variable<String>(targetClientId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BudgetTargetsCompanion(')
          ..write('budgetClientId: $budgetClientId, ')
          ..write('targetType: $targetType, ')
          ..write('targetClientId: $targetClientId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class BudgetPeriodStates extends Table
    with TableInfo<BudgetPeriodStates, BudgetPeriodStatesData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  BudgetPeriodStates(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  late final GeneratedColumn<String> clientId = GeneratedColumn<String>(
      'client_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const CustomExpression('\'\''));
  late final GeneratedColumn<String> rev = GeneratedColumn<String>(
      'rev', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const CustomExpression('\'1\''));
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: const CustomExpression('CURRENT_TIMESTAMP'));
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: const CustomExpression('CURRENT_TIMESTAMP'));
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  late final GeneratedColumn<DateTime> lastSyncedAt = GeneratedColumn<DateTime>(
      'last_synced_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  late final GeneratedColumn<String> budgetClientId = GeneratedColumn<String>(
      'budget_client_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES budgets (client_id)'));
  late final GeneratedColumn<DateTime> periodStart = GeneratedColumn<DateTime>(
      'period_start', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  late final GeneratedColumn<DateTime> periodEnd = GeneratedColumn<DateTime>(
      'period_end', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  late final GeneratedColumn<double> netSpent = GeneratedColumn<double>(
      'net_spent', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const CustomExpression('0.0'));
  late final GeneratedColumn<double> rolloverIn = GeneratedColumn<double>(
      'rollover_in', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const CustomExpression('0.0'));
  late final GeneratedColumn<double> rolloverOut = GeneratedColumn<double>(
      'rollover_out', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const CustomExpression('0.0'));
  late final GeneratedColumn<DateTime> closedAt = GeneratedColumn<DateTime>(
      'closed_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userId,
        clientId,
        rev,
        createdAt,
        updatedAt,
        deletedAt,
        lastSyncedAt,
        budgetClientId,
        periodStart,
        periodEnd,
        netSpent,
        rolloverIn,
        rolloverOut,
        closedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'budget_period_states';
  @override
  Set<GeneratedColumn> get $primaryKey => {clientId};
  @override
  BudgetPeriodStatesData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BudgetPeriodStatesData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id']),
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id']),
      clientId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}client_id'])!,
      rev: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}rev']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
      lastSyncedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_synced_at']),
      budgetClientId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}budget_client_id'])!,
      periodStart: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}period_start'])!,
      periodEnd: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}period_end'])!,
      netSpent: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}net_spent'])!,
      rolloverIn: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}rollover_in'])!,
      rolloverOut: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}rollover_out'])!,
      closedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}closed_at']),
    );
  }

  @override
  BudgetPeriodStates createAlias(String alias) {
    return BudgetPeriodStates(attachedDatabase, alias);
  }
}

class BudgetPeriodStatesData extends DataClass
    implements Insertable<BudgetPeriodStatesData> {
  final int? id;
  final int? userId;
  final String clientId;
  final String? rev;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final DateTime? lastSyncedAt;
  final String budgetClientId;
  final DateTime periodStart;
  final DateTime periodEnd;
  final double netSpent;
  final double rolloverIn;
  final double rolloverOut;
  final DateTime? closedAt;
  const BudgetPeriodStatesData(
      {this.id,
      this.userId,
      required this.clientId,
      this.rev,
      required this.createdAt,
      required this.updatedAt,
      this.deletedAt,
      this.lastSyncedAt,
      required this.budgetClientId,
      required this.periodStart,
      required this.periodEnd,
      required this.netSpent,
      required this.rolloverIn,
      required this.rolloverOut,
      this.closedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<int>(userId);
    }
    map['client_id'] = Variable<String>(clientId);
    if (!nullToAbsent || rev != null) {
      map['rev'] = Variable<String>(rev);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    if (!nullToAbsent || lastSyncedAt != null) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt);
    }
    map['budget_client_id'] = Variable<String>(budgetClientId);
    map['period_start'] = Variable<DateTime>(periodStart);
    map['period_end'] = Variable<DateTime>(periodEnd);
    map['net_spent'] = Variable<double>(netSpent);
    map['rollover_in'] = Variable<double>(rolloverIn);
    map['rollover_out'] = Variable<double>(rolloverOut);
    if (!nullToAbsent || closedAt != null) {
      map['closed_at'] = Variable<DateTime>(closedAt);
    }
    return map;
  }

  BudgetPeriodStatesCompanion toCompanion(bool nullToAbsent) {
    return BudgetPeriodStatesCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      userId:
          userId == null && nullToAbsent ? const Value.absent() : Value(userId),
      clientId: Value(clientId),
      rev: rev == null && nullToAbsent ? const Value.absent() : Value(rev),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      lastSyncedAt: lastSyncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncedAt),
      budgetClientId: Value(budgetClientId),
      periodStart: Value(periodStart),
      periodEnd: Value(periodEnd),
      netSpent: Value(netSpent),
      rolloverIn: Value(rolloverIn),
      rolloverOut: Value(rolloverOut),
      closedAt: closedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(closedAt),
    );
  }

  factory BudgetPeriodStatesData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BudgetPeriodStatesData(
      id: serializer.fromJson<int?>(json['id']),
      userId: serializer.fromJson<int?>(json['userId']),
      clientId: serializer.fromJson<String>(json['clientId']),
      rev: serializer.fromJson<String?>(json['rev']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      lastSyncedAt: serializer.fromJson<DateTime?>(json['lastSyncedAt']),
      budgetClientId: serializer.fromJson<String>(json['budgetClientId']),
      periodStart: serializer.fromJson<DateTime>(json['periodStart']),
      periodEnd: serializer.fromJson<DateTime>(json['periodEnd']),
      netSpent: serializer.fromJson<double>(json['netSpent']),
      rolloverIn: serializer.fromJson<double>(json['rolloverIn']),
      rolloverOut: serializer.fromJson<double>(json['rolloverOut']),
      closedAt: serializer.fromJson<DateTime?>(json['closedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int?>(id),
      'userId': serializer.toJson<int?>(userId),
      'clientId': serializer.toJson<String>(clientId),
      'rev': serializer.toJson<String?>(rev),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'lastSyncedAt': serializer.toJson<DateTime?>(lastSyncedAt),
      'budgetClientId': serializer.toJson<String>(budgetClientId),
      'periodStart': serializer.toJson<DateTime>(periodStart),
      'periodEnd': serializer.toJson<DateTime>(periodEnd),
      'netSpent': serializer.toJson<double>(netSpent),
      'rolloverIn': serializer.toJson<double>(rolloverIn),
      'rolloverOut': serializer.toJson<double>(rolloverOut),
      'closedAt': serializer.toJson<DateTime?>(closedAt),
    };
  }

  BudgetPeriodStatesData copyWith(
          {Value<int?> id = const Value.absent(),
          Value<int?> userId = const Value.absent(),
          String? clientId,
          Value<String?> rev = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<DateTime?> deletedAt = const Value.absent(),
          Value<DateTime?> lastSyncedAt = const Value.absent(),
          String? budgetClientId,
          DateTime? periodStart,
          DateTime? periodEnd,
          double? netSpent,
          double? rolloverIn,
          double? rolloverOut,
          Value<DateTime?> closedAt = const Value.absent()}) =>
      BudgetPeriodStatesData(
        id: id.present ? id.value : this.id,
        userId: userId.present ? userId.value : this.userId,
        clientId: clientId ?? this.clientId,
        rev: rev.present ? rev.value : this.rev,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
        lastSyncedAt:
            lastSyncedAt.present ? lastSyncedAt.value : this.lastSyncedAt,
        budgetClientId: budgetClientId ?? this.budgetClientId,
        periodStart: periodStart ?? this.periodStart,
        periodEnd: periodEnd ?? this.periodEnd,
        netSpent: netSpent ?? this.netSpent,
        rolloverIn: rolloverIn ?? this.rolloverIn,
        rolloverOut: rolloverOut ?? this.rolloverOut,
        closedAt: closedAt.present ? closedAt.value : this.closedAt,
      );
  BudgetPeriodStatesData copyWithCompanion(BudgetPeriodStatesCompanion data) {
    return BudgetPeriodStatesData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      clientId: data.clientId.present ? data.clientId.value : this.clientId,
      rev: data.rev.present ? data.rev.value : this.rev,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      lastSyncedAt: data.lastSyncedAt.present
          ? data.lastSyncedAt.value
          : this.lastSyncedAt,
      budgetClientId: data.budgetClientId.present
          ? data.budgetClientId.value
          : this.budgetClientId,
      periodStart:
          data.periodStart.present ? data.periodStart.value : this.periodStart,
      periodEnd: data.periodEnd.present ? data.periodEnd.value : this.periodEnd,
      netSpent: data.netSpent.present ? data.netSpent.value : this.netSpent,
      rolloverIn:
          data.rolloverIn.present ? data.rolloverIn.value : this.rolloverIn,
      rolloverOut:
          data.rolloverOut.present ? data.rolloverOut.value : this.rolloverOut,
      closedAt: data.closedAt.present ? data.closedAt.value : this.closedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BudgetPeriodStatesData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('clientId: $clientId, ')
          ..write('rev: $rev, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('budgetClientId: $budgetClientId, ')
          ..write('periodStart: $periodStart, ')
          ..write('periodEnd: $periodEnd, ')
          ..write('netSpent: $netSpent, ')
          ..write('rolloverIn: $rolloverIn, ')
          ..write('rolloverOut: $rolloverOut, ')
          ..write('closedAt: $closedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      userId,
      clientId,
      rev,
      createdAt,
      updatedAt,
      deletedAt,
      lastSyncedAt,
      budgetClientId,
      periodStart,
      periodEnd,
      netSpent,
      rolloverIn,
      rolloverOut,
      closedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BudgetPeriodStatesData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.clientId == this.clientId &&
          other.rev == this.rev &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.lastSyncedAt == this.lastSyncedAt &&
          other.budgetClientId == this.budgetClientId &&
          other.periodStart == this.periodStart &&
          other.periodEnd == this.periodEnd &&
          other.netSpent == this.netSpent &&
          other.rolloverIn == this.rolloverIn &&
          other.rolloverOut == this.rolloverOut &&
          other.closedAt == this.closedAt);
}

class BudgetPeriodStatesCompanion
    extends UpdateCompanion<BudgetPeriodStatesData> {
  final Value<int?> id;
  final Value<int?> userId;
  final Value<String> clientId;
  final Value<String?> rev;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<DateTime?> lastSyncedAt;
  final Value<String> budgetClientId;
  final Value<DateTime> periodStart;
  final Value<DateTime> periodEnd;
  final Value<double> netSpent;
  final Value<double> rolloverIn;
  final Value<double> rolloverOut;
  final Value<DateTime?> closedAt;
  final Value<int> rowid;
  const BudgetPeriodStatesCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.clientId = const Value.absent(),
    this.rev = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.budgetClientId = const Value.absent(),
    this.periodStart = const Value.absent(),
    this.periodEnd = const Value.absent(),
    this.netSpent = const Value.absent(),
    this.rolloverIn = const Value.absent(),
    this.rolloverOut = const Value.absent(),
    this.closedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BudgetPeriodStatesCompanion.insert({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.clientId = const Value.absent(),
    this.rev = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    required String budgetClientId,
    required DateTime periodStart,
    required DateTime periodEnd,
    this.netSpent = const Value.absent(),
    this.rolloverIn = const Value.absent(),
    this.rolloverOut = const Value.absent(),
    this.closedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : budgetClientId = Value(budgetClientId),
        periodStart = Value(periodStart),
        periodEnd = Value(periodEnd);
  static Insertable<BudgetPeriodStatesData> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<String>? clientId,
    Expression<String>? rev,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<DateTime>? lastSyncedAt,
    Expression<String>? budgetClientId,
    Expression<DateTime>? periodStart,
    Expression<DateTime>? periodEnd,
    Expression<double>? netSpent,
    Expression<double>? rolloverIn,
    Expression<double>? rolloverOut,
    Expression<DateTime>? closedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (clientId != null) 'client_id': clientId,
      if (rev != null) 'rev': rev,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
      if (budgetClientId != null) 'budget_client_id': budgetClientId,
      if (periodStart != null) 'period_start': periodStart,
      if (periodEnd != null) 'period_end': periodEnd,
      if (netSpent != null) 'net_spent': netSpent,
      if (rolloverIn != null) 'rollover_in': rolloverIn,
      if (rolloverOut != null) 'rollover_out': rolloverOut,
      if (closedAt != null) 'closed_at': closedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BudgetPeriodStatesCompanion copyWith(
      {Value<int?>? id,
      Value<int?>? userId,
      Value<String>? clientId,
      Value<String?>? rev,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<DateTime?>? deletedAt,
      Value<DateTime?>? lastSyncedAt,
      Value<String>? budgetClientId,
      Value<DateTime>? periodStart,
      Value<DateTime>? periodEnd,
      Value<double>? netSpent,
      Value<double>? rolloverIn,
      Value<double>? rolloverOut,
      Value<DateTime?>? closedAt,
      Value<int>? rowid}) {
    return BudgetPeriodStatesCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      clientId: clientId ?? this.clientId,
      rev: rev ?? this.rev,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      budgetClientId: budgetClientId ?? this.budgetClientId,
      periodStart: periodStart ?? this.periodStart,
      periodEnd: periodEnd ?? this.periodEnd,
      netSpent: netSpent ?? this.netSpent,
      rolloverIn: rolloverIn ?? this.rolloverIn,
      rolloverOut: rolloverOut ?? this.rolloverOut,
      closedAt: closedAt ?? this.closedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (clientId.present) {
      map['client_id'] = Variable<String>(clientId.value);
    }
    if (rev.present) {
      map['rev'] = Variable<String>(rev.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (lastSyncedAt.present) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt.value);
    }
    if (budgetClientId.present) {
      map['budget_client_id'] = Variable<String>(budgetClientId.value);
    }
    if (periodStart.present) {
      map['period_start'] = Variable<DateTime>(periodStart.value);
    }
    if (periodEnd.present) {
      map['period_end'] = Variable<DateTime>(periodEnd.value);
    }
    if (netSpent.present) {
      map['net_spent'] = Variable<double>(netSpent.value);
    }
    if (rolloverIn.present) {
      map['rollover_in'] = Variable<double>(rolloverIn.value);
    }
    if (rolloverOut.present) {
      map['rollover_out'] = Variable<double>(rolloverOut.value);
    }
    if (closedAt.present) {
      map['closed_at'] = Variable<DateTime>(closedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BudgetPeriodStatesCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('clientId: $clientId, ')
          ..write('rev: $rev, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('budgetClientId: $budgetClientId, ')
          ..write('periodStart: $periodStart, ')
          ..write('periodEnd: $periodEnd, ')
          ..write('netSpent: $netSpent, ')
          ..write('rolloverIn: $rolloverIn, ')
          ..write('rolloverOut: $rolloverOut, ')
          ..write('closedAt: $closedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class Holdings extends Table with TableInfo<Holdings, HoldingsData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Holdings(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> symbol = GeneratedColumn<String>(
      'symbol', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
      'quantity', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const CustomExpression('0.0'));
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
      'currency', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<double> unitPrice = GeneratedColumn<double>(
      'unit_price', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const CustomExpression('0.0'));
  late final GeneratedColumn<double> value = GeneratedColumn<double>(
      'value', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const CustomExpression('0.0'));
  late final GeneratedColumn<String> priceSource = GeneratedColumn<String>(
      'price_source', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const CustomExpression('\'manual\''));
  late final GeneratedColumn<String> provider = GeneratedColumn<String>(
      'provider', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  late final GeneratedColumn<String> externalRef = GeneratedColumn<String>(
      'external_ref', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  late final GeneratedColumn<DateTime> lastPricedAt = GeneratedColumn<DateTime>(
      'last_priced_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        symbol,
        quantity,
        currency,
        unitPrice,
        value,
        priceSource,
        provider,
        externalRef,
        lastPricedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'holdings';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HoldingsData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HoldingsData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      symbol: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}symbol']),
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}quantity'])!,
      currency: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}currency'])!,
      unitPrice: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}unit_price'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}value'])!,
      priceSource: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}price_source'])!,
      provider: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}provider']),
      externalRef: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}external_ref']),
      lastPricedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_priced_at']),
    );
  }

  @override
  Holdings createAlias(String alias) {
    return Holdings(attachedDatabase, alias);
  }
}

class HoldingsData extends DataClass implements Insertable<HoldingsData> {
  final int id;
  final String name;
  final String? symbol;
  final double quantity;
  final String currency;
  final double unitPrice;
  final double value;
  final String priceSource;
  final String? provider;
  final String? externalRef;
  final DateTime? lastPricedAt;
  const HoldingsData(
      {required this.id,
      required this.name,
      this.symbol,
      required this.quantity,
      required this.currency,
      required this.unitPrice,
      required this.value,
      required this.priceSource,
      this.provider,
      this.externalRef,
      this.lastPricedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || symbol != null) {
      map['symbol'] = Variable<String>(symbol);
    }
    map['quantity'] = Variable<double>(quantity);
    map['currency'] = Variable<String>(currency);
    map['unit_price'] = Variable<double>(unitPrice);
    map['value'] = Variable<double>(value);
    map['price_source'] = Variable<String>(priceSource);
    if (!nullToAbsent || provider != null) {
      map['provider'] = Variable<String>(provider);
    }
    if (!nullToAbsent || externalRef != null) {
      map['external_ref'] = Variable<String>(externalRef);
    }
    if (!nullToAbsent || lastPricedAt != null) {
      map['last_priced_at'] = Variable<DateTime>(lastPricedAt);
    }
    return map;
  }

  HoldingsCompanion toCompanion(bool nullToAbsent) {
    return HoldingsCompanion(
      id: Value(id),
      name: Value(name),
      symbol:
          symbol == null && nullToAbsent ? const Value.absent() : Value(symbol),
      quantity: Value(quantity),
      currency: Value(currency),
      unitPrice: Value(unitPrice),
      value: Value(value),
      priceSource: Value(priceSource),
      provider: provider == null && nullToAbsent
          ? const Value.absent()
          : Value(provider),
      externalRef: externalRef == null && nullToAbsent
          ? const Value.absent()
          : Value(externalRef),
      lastPricedAt: lastPricedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastPricedAt),
    );
  }

  factory HoldingsData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HoldingsData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      symbol: serializer.fromJson<String?>(json['symbol']),
      quantity: serializer.fromJson<double>(json['quantity']),
      currency: serializer.fromJson<String>(json['currency']),
      unitPrice: serializer.fromJson<double>(json['unitPrice']),
      value: serializer.fromJson<double>(json['value']),
      priceSource: serializer.fromJson<String>(json['priceSource']),
      provider: serializer.fromJson<String?>(json['provider']),
      externalRef: serializer.fromJson<String?>(json['externalRef']),
      lastPricedAt: serializer.fromJson<DateTime?>(json['lastPricedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'symbol': serializer.toJson<String?>(symbol),
      'quantity': serializer.toJson<double>(quantity),
      'currency': serializer.toJson<String>(currency),
      'unitPrice': serializer.toJson<double>(unitPrice),
      'value': serializer.toJson<double>(value),
      'priceSource': serializer.toJson<String>(priceSource),
      'provider': serializer.toJson<String?>(provider),
      'externalRef': serializer.toJson<String?>(externalRef),
      'lastPricedAt': serializer.toJson<DateTime?>(lastPricedAt),
    };
  }

  HoldingsData copyWith(
          {int? id,
          String? name,
          Value<String?> symbol = const Value.absent(),
          double? quantity,
          String? currency,
          double? unitPrice,
          double? value,
          String? priceSource,
          Value<String?> provider = const Value.absent(),
          Value<String?> externalRef = const Value.absent(),
          Value<DateTime?> lastPricedAt = const Value.absent()}) =>
      HoldingsData(
        id: id ?? this.id,
        name: name ?? this.name,
        symbol: symbol.present ? symbol.value : this.symbol,
        quantity: quantity ?? this.quantity,
        currency: currency ?? this.currency,
        unitPrice: unitPrice ?? this.unitPrice,
        value: value ?? this.value,
        priceSource: priceSource ?? this.priceSource,
        provider: provider.present ? provider.value : this.provider,
        externalRef: externalRef.present ? externalRef.value : this.externalRef,
        lastPricedAt:
            lastPricedAt.present ? lastPricedAt.value : this.lastPricedAt,
      );
  HoldingsData copyWithCompanion(HoldingsCompanion data) {
    return HoldingsData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      symbol: data.symbol.present ? data.symbol.value : this.symbol,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      currency: data.currency.present ? data.currency.value : this.currency,
      unitPrice: data.unitPrice.present ? data.unitPrice.value : this.unitPrice,
      value: data.value.present ? data.value.value : this.value,
      priceSource:
          data.priceSource.present ? data.priceSource.value : this.priceSource,
      provider: data.provider.present ? data.provider.value : this.provider,
      externalRef:
          data.externalRef.present ? data.externalRef.value : this.externalRef,
      lastPricedAt: data.lastPricedAt.present
          ? data.lastPricedAt.value
          : this.lastPricedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HoldingsData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('symbol: $symbol, ')
          ..write('quantity: $quantity, ')
          ..write('currency: $currency, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('value: $value, ')
          ..write('priceSource: $priceSource, ')
          ..write('provider: $provider, ')
          ..write('externalRef: $externalRef, ')
          ..write('lastPricedAt: $lastPricedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, symbol, quantity, currency,
      unitPrice, value, priceSource, provider, externalRef, lastPricedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HoldingsData &&
          other.id == this.id &&
          other.name == this.name &&
          other.symbol == this.symbol &&
          other.quantity == this.quantity &&
          other.currency == this.currency &&
          other.unitPrice == this.unitPrice &&
          other.value == this.value &&
          other.priceSource == this.priceSource &&
          other.provider == this.provider &&
          other.externalRef == this.externalRef &&
          other.lastPricedAt == this.lastPricedAt);
}

class HoldingsCompanion extends UpdateCompanion<HoldingsData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> symbol;
  final Value<double> quantity;
  final Value<String> currency;
  final Value<double> unitPrice;
  final Value<double> value;
  final Value<String> priceSource;
  final Value<String?> provider;
  final Value<String?> externalRef;
  final Value<DateTime?> lastPricedAt;
  const HoldingsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.symbol = const Value.absent(),
    this.quantity = const Value.absent(),
    this.currency = const Value.absent(),
    this.unitPrice = const Value.absent(),
    this.value = const Value.absent(),
    this.priceSource = const Value.absent(),
    this.provider = const Value.absent(),
    this.externalRef = const Value.absent(),
    this.lastPricedAt = const Value.absent(),
  });
  HoldingsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.symbol = const Value.absent(),
    this.quantity = const Value.absent(),
    required String currency,
    this.unitPrice = const Value.absent(),
    this.value = const Value.absent(),
    this.priceSource = const Value.absent(),
    this.provider = const Value.absent(),
    this.externalRef = const Value.absent(),
    this.lastPricedAt = const Value.absent(),
  })  : name = Value(name),
        currency = Value(currency);
  static Insertable<HoldingsData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? symbol,
    Expression<double>? quantity,
    Expression<String>? currency,
    Expression<double>? unitPrice,
    Expression<double>? value,
    Expression<String>? priceSource,
    Expression<String>? provider,
    Expression<String>? externalRef,
    Expression<DateTime>? lastPricedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (symbol != null) 'symbol': symbol,
      if (quantity != null) 'quantity': quantity,
      if (currency != null) 'currency': currency,
      if (unitPrice != null) 'unit_price': unitPrice,
      if (value != null) 'value': value,
      if (priceSource != null) 'price_source': priceSource,
      if (provider != null) 'provider': provider,
      if (externalRef != null) 'external_ref': externalRef,
      if (lastPricedAt != null) 'last_priced_at': lastPricedAt,
    });
  }

  HoldingsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String?>? symbol,
      Value<double>? quantity,
      Value<String>? currency,
      Value<double>? unitPrice,
      Value<double>? value,
      Value<String>? priceSource,
      Value<String?>? provider,
      Value<String?>? externalRef,
      Value<DateTime?>? lastPricedAt}) {
    return HoldingsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      symbol: symbol ?? this.symbol,
      quantity: quantity ?? this.quantity,
      currency: currency ?? this.currency,
      unitPrice: unitPrice ?? this.unitPrice,
      value: value ?? this.value,
      priceSource: priceSource ?? this.priceSource,
      provider: provider ?? this.provider,
      externalRef: externalRef ?? this.externalRef,
      lastPricedAt: lastPricedAt ?? this.lastPricedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (symbol.present) {
      map['symbol'] = Variable<String>(symbol.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (unitPrice.present) {
      map['unit_price'] = Variable<double>(unitPrice.value);
    }
    if (value.present) {
      map['value'] = Variable<double>(value.value);
    }
    if (priceSource.present) {
      map['price_source'] = Variable<String>(priceSource.value);
    }
    if (provider.present) {
      map['provider'] = Variable<String>(provider.value);
    }
    if (externalRef.present) {
      map['external_ref'] = Variable<String>(externalRef.value);
    }
    if (lastPricedAt.present) {
      map['last_priced_at'] = Variable<DateTime>(lastPricedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HoldingsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('symbol: $symbol, ')
          ..write('quantity: $quantity, ')
          ..write('currency: $currency, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('value: $value, ')
          ..write('priceSource: $priceSource, ')
          ..write('provider: $provider, ')
          ..write('externalRef: $externalRef, ')
          ..write('lastPricedAt: $lastPricedAt')
          ..write(')'))
        .toString();
  }
}

class FinancialPositionCache extends Table
    with TableInfo<FinancialPositionCache, FinancialPositionCacheData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  FinancialPositionCache(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<String> cacheKey = GeneratedColumn<String>(
      'cache_key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
      'payload', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
      'currency', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  late final GeneratedColumn<DateTime> fetchedAt = GeneratedColumn<DateTime>(
      'fetched_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [cacheKey, payload, currency, fetchedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'financial_position_cache';
  @override
  Set<GeneratedColumn> get $primaryKey => {cacheKey};
  @override
  FinancialPositionCacheData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FinancialPositionCacheData(
      cacheKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cache_key'])!,
      payload: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payload'])!,
      currency: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}currency']),
      fetchedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}fetched_at'])!,
    );
  }

  @override
  FinancialPositionCache createAlias(String alias) {
    return FinancialPositionCache(attachedDatabase, alias);
  }
}

class FinancialPositionCacheData extends DataClass
    implements Insertable<FinancialPositionCacheData> {
  final String cacheKey;
  final String payload;
  final String? currency;
  final DateTime fetchedAt;
  const FinancialPositionCacheData(
      {required this.cacheKey,
      required this.payload,
      this.currency,
      required this.fetchedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['cache_key'] = Variable<String>(cacheKey);
    map['payload'] = Variable<String>(payload);
    if (!nullToAbsent || currency != null) {
      map['currency'] = Variable<String>(currency);
    }
    map['fetched_at'] = Variable<DateTime>(fetchedAt);
    return map;
  }

  FinancialPositionCacheCompanion toCompanion(bool nullToAbsent) {
    return FinancialPositionCacheCompanion(
      cacheKey: Value(cacheKey),
      payload: Value(payload),
      currency: currency == null && nullToAbsent
          ? const Value.absent()
          : Value(currency),
      fetchedAt: Value(fetchedAt),
    );
  }

  factory FinancialPositionCacheData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FinancialPositionCacheData(
      cacheKey: serializer.fromJson<String>(json['cacheKey']),
      payload: serializer.fromJson<String>(json['payload']),
      currency: serializer.fromJson<String?>(json['currency']),
      fetchedAt: serializer.fromJson<DateTime>(json['fetchedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'cacheKey': serializer.toJson<String>(cacheKey),
      'payload': serializer.toJson<String>(payload),
      'currency': serializer.toJson<String?>(currency),
      'fetchedAt': serializer.toJson<DateTime>(fetchedAt),
    };
  }

  FinancialPositionCacheData copyWith(
          {String? cacheKey,
          String? payload,
          Value<String?> currency = const Value.absent(),
          DateTime? fetchedAt}) =>
      FinancialPositionCacheData(
        cacheKey: cacheKey ?? this.cacheKey,
        payload: payload ?? this.payload,
        currency: currency.present ? currency.value : this.currency,
        fetchedAt: fetchedAt ?? this.fetchedAt,
      );
  FinancialPositionCacheData copyWithCompanion(
      FinancialPositionCacheCompanion data) {
    return FinancialPositionCacheData(
      cacheKey: data.cacheKey.present ? data.cacheKey.value : this.cacheKey,
      payload: data.payload.present ? data.payload.value : this.payload,
      currency: data.currency.present ? data.currency.value : this.currency,
      fetchedAt: data.fetchedAt.present ? data.fetchedAt.value : this.fetchedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FinancialPositionCacheData(')
          ..write('cacheKey: $cacheKey, ')
          ..write('payload: $payload, ')
          ..write('currency: $currency, ')
          ..write('fetchedAt: $fetchedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(cacheKey, payload, currency, fetchedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FinancialPositionCacheData &&
          other.cacheKey == this.cacheKey &&
          other.payload == this.payload &&
          other.currency == this.currency &&
          other.fetchedAt == this.fetchedAt);
}

class FinancialPositionCacheCompanion
    extends UpdateCompanion<FinancialPositionCacheData> {
  final Value<String> cacheKey;
  final Value<String> payload;
  final Value<String?> currency;
  final Value<DateTime> fetchedAt;
  final Value<int> rowid;
  const FinancialPositionCacheCompanion({
    this.cacheKey = const Value.absent(),
    this.payload = const Value.absent(),
    this.currency = const Value.absent(),
    this.fetchedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FinancialPositionCacheCompanion.insert({
    required String cacheKey,
    required String payload,
    this.currency = const Value.absent(),
    required DateTime fetchedAt,
    this.rowid = const Value.absent(),
  })  : cacheKey = Value(cacheKey),
        payload = Value(payload),
        fetchedAt = Value(fetchedAt);
  static Insertable<FinancialPositionCacheData> custom({
    Expression<String>? cacheKey,
    Expression<String>? payload,
    Expression<String>? currency,
    Expression<DateTime>? fetchedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (cacheKey != null) 'cache_key': cacheKey,
      if (payload != null) 'payload': payload,
      if (currency != null) 'currency': currency,
      if (fetchedAt != null) 'fetched_at': fetchedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FinancialPositionCacheCompanion copyWith(
      {Value<String>? cacheKey,
      Value<String>? payload,
      Value<String?>? currency,
      Value<DateTime>? fetchedAt,
      Value<int>? rowid}) {
    return FinancialPositionCacheCompanion(
      cacheKey: cacheKey ?? this.cacheKey,
      payload: payload ?? this.payload,
      currency: currency ?? this.currency,
      fetchedAt: fetchedAt ?? this.fetchedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (cacheKey.present) {
      map['cache_key'] = Variable<String>(cacheKey.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (fetchedAt.present) {
      map['fetched_at'] = Variable<DateTime>(fetchedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FinancialPositionCacheCompanion(')
          ..write('cacheKey: $cacheKey, ')
          ..write('payload: $payload, ')
          ..write('currency: $currency, ')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class Reminders extends Table with TableInfo<Reminders, RemindersData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Reminders(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  late final GeneratedColumn<String> clientId = GeneratedColumn<String>(
      'client_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const CustomExpression('\'\''));
  late final GeneratedColumn<String> rev = GeneratedColumn<String>(
      'rev', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const CustomExpression('\'1\''));
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: const CustomExpression('CURRENT_TIMESTAMP'));
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: const CustomExpression('CURRENT_TIMESTAMP'));
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  late final GeneratedColumn<DateTime> lastSyncedAt = GeneratedColumn<DateTime>(
      'last_synced_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const CustomExpression('\'custom\''));
  late final GeneratedColumn<DateTime> triggerAt = GeneratedColumn<DateTime>(
      'trigger_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  late final GeneratedColumn<DateTime> dueAt = GeneratedColumn<DateTime>(
      'due_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  late final GeneratedColumn<String> repeatRule = GeneratedColumn<String>(
      'repeat_rule', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  late final GeneratedColumn<String> timezone = GeneratedColumn<String>(
      'timezone', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const CustomExpression('\'active\''));
  late final GeneratedColumn<int> priority = GeneratedColumn<int>(
      'priority', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const CustomExpression('0'));
  late final GeneratedColumn<DateTime> snoozedUntil = GeneratedColumn<DateTime>(
      'snoozed_until', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  late final GeneratedColumn<DateTime> lastTriggeredAt =
      GeneratedColumn<DateTime>('last_triggered_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  late final GeneratedColumn<DateTime> nextTriggerAt =
      GeneratedColumn<DateTime>('next_trigger_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userId,
        clientId,
        rev,
        createdAt,
        updatedAt,
        deletedAt,
        lastSyncedAt,
        title,
        description,
        type,
        triggerAt,
        dueAt,
        repeatRule,
        timezone,
        status,
        priority,
        snoozedUntil,
        lastTriggeredAt,
        nextTriggerAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reminders';
  @override
  Set<GeneratedColumn> get $primaryKey => {clientId};
  @override
  RemindersData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RemindersData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id']),
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id']),
      clientId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}client_id'])!,
      rev: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}rev']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
      lastSyncedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_synced_at']),
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      triggerAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}trigger_at']),
      dueAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}due_at']),
      repeatRule: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}repeat_rule']),
      timezone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}timezone']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      priority: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}priority'])!,
      snoozedUntil: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}snoozed_until']),
      lastTriggeredAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_triggered_at']),
      nextTriggerAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}next_trigger_at']),
    );
  }

  @override
  Reminders createAlias(String alias) {
    return Reminders(attachedDatabase, alias);
  }
}

class RemindersData extends DataClass implements Insertable<RemindersData> {
  final int? id;
  final int? userId;
  final String clientId;
  final String? rev;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final DateTime? lastSyncedAt;
  final String title;
  final String? description;
  final String type;
  final DateTime? triggerAt;
  final DateTime? dueAt;
  final String? repeatRule;
  final String? timezone;
  final String status;
  final int priority;
  final DateTime? snoozedUntil;
  final DateTime? lastTriggeredAt;
  final DateTime? nextTriggerAt;
  const RemindersData(
      {this.id,
      this.userId,
      required this.clientId,
      this.rev,
      required this.createdAt,
      required this.updatedAt,
      this.deletedAt,
      this.lastSyncedAt,
      required this.title,
      this.description,
      required this.type,
      this.triggerAt,
      this.dueAt,
      this.repeatRule,
      this.timezone,
      required this.status,
      required this.priority,
      this.snoozedUntil,
      this.lastTriggeredAt,
      this.nextTriggerAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<int>(userId);
    }
    map['client_id'] = Variable<String>(clientId);
    if (!nullToAbsent || rev != null) {
      map['rev'] = Variable<String>(rev);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    if (!nullToAbsent || lastSyncedAt != null) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt);
    }
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || triggerAt != null) {
      map['trigger_at'] = Variable<DateTime>(triggerAt);
    }
    if (!nullToAbsent || dueAt != null) {
      map['due_at'] = Variable<DateTime>(dueAt);
    }
    if (!nullToAbsent || repeatRule != null) {
      map['repeat_rule'] = Variable<String>(repeatRule);
    }
    if (!nullToAbsent || timezone != null) {
      map['timezone'] = Variable<String>(timezone);
    }
    map['status'] = Variable<String>(status);
    map['priority'] = Variable<int>(priority);
    if (!nullToAbsent || snoozedUntil != null) {
      map['snoozed_until'] = Variable<DateTime>(snoozedUntil);
    }
    if (!nullToAbsent || lastTriggeredAt != null) {
      map['last_triggered_at'] = Variable<DateTime>(lastTriggeredAt);
    }
    if (!nullToAbsent || nextTriggerAt != null) {
      map['next_trigger_at'] = Variable<DateTime>(nextTriggerAt);
    }
    return map;
  }

  RemindersCompanion toCompanion(bool nullToAbsent) {
    return RemindersCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      userId:
          userId == null && nullToAbsent ? const Value.absent() : Value(userId),
      clientId: Value(clientId),
      rev: rev == null && nullToAbsent ? const Value.absent() : Value(rev),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      lastSyncedAt: lastSyncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncedAt),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      type: Value(type),
      triggerAt: triggerAt == null && nullToAbsent
          ? const Value.absent()
          : Value(triggerAt),
      dueAt:
          dueAt == null && nullToAbsent ? const Value.absent() : Value(dueAt),
      repeatRule: repeatRule == null && nullToAbsent
          ? const Value.absent()
          : Value(repeatRule),
      timezone: timezone == null && nullToAbsent
          ? const Value.absent()
          : Value(timezone),
      status: Value(status),
      priority: Value(priority),
      snoozedUntil: snoozedUntil == null && nullToAbsent
          ? const Value.absent()
          : Value(snoozedUntil),
      lastTriggeredAt: lastTriggeredAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastTriggeredAt),
      nextTriggerAt: nextTriggerAt == null && nullToAbsent
          ? const Value.absent()
          : Value(nextTriggerAt),
    );
  }

  factory RemindersData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RemindersData(
      id: serializer.fromJson<int?>(json['id']),
      userId: serializer.fromJson<int?>(json['userId']),
      clientId: serializer.fromJson<String>(json['clientId']),
      rev: serializer.fromJson<String?>(json['rev']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      lastSyncedAt: serializer.fromJson<DateTime?>(json['lastSyncedAt']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      type: serializer.fromJson<String>(json['type']),
      triggerAt: serializer.fromJson<DateTime?>(json['triggerAt']),
      dueAt: serializer.fromJson<DateTime?>(json['dueAt']),
      repeatRule: serializer.fromJson<String?>(json['repeatRule']),
      timezone: serializer.fromJson<String?>(json['timezone']),
      status: serializer.fromJson<String>(json['status']),
      priority: serializer.fromJson<int>(json['priority']),
      snoozedUntil: serializer.fromJson<DateTime?>(json['snoozedUntil']),
      lastTriggeredAt: serializer.fromJson<DateTime?>(json['lastTriggeredAt']),
      nextTriggerAt: serializer.fromJson<DateTime?>(json['nextTriggerAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int?>(id),
      'userId': serializer.toJson<int?>(userId),
      'clientId': serializer.toJson<String>(clientId),
      'rev': serializer.toJson<String?>(rev),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'lastSyncedAt': serializer.toJson<DateTime?>(lastSyncedAt),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'type': serializer.toJson<String>(type),
      'triggerAt': serializer.toJson<DateTime?>(triggerAt),
      'dueAt': serializer.toJson<DateTime?>(dueAt),
      'repeatRule': serializer.toJson<String?>(repeatRule),
      'timezone': serializer.toJson<String?>(timezone),
      'status': serializer.toJson<String>(status),
      'priority': serializer.toJson<int>(priority),
      'snoozedUntil': serializer.toJson<DateTime?>(snoozedUntil),
      'lastTriggeredAt': serializer.toJson<DateTime?>(lastTriggeredAt),
      'nextTriggerAt': serializer.toJson<DateTime?>(nextTriggerAt),
    };
  }

  RemindersData copyWith(
          {Value<int?> id = const Value.absent(),
          Value<int?> userId = const Value.absent(),
          String? clientId,
          Value<String?> rev = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<DateTime?> deletedAt = const Value.absent(),
          Value<DateTime?> lastSyncedAt = const Value.absent(),
          String? title,
          Value<String?> description = const Value.absent(),
          String? type,
          Value<DateTime?> triggerAt = const Value.absent(),
          Value<DateTime?> dueAt = const Value.absent(),
          Value<String?> repeatRule = const Value.absent(),
          Value<String?> timezone = const Value.absent(),
          String? status,
          int? priority,
          Value<DateTime?> snoozedUntil = const Value.absent(),
          Value<DateTime?> lastTriggeredAt = const Value.absent(),
          Value<DateTime?> nextTriggerAt = const Value.absent()}) =>
      RemindersData(
        id: id.present ? id.value : this.id,
        userId: userId.present ? userId.value : this.userId,
        clientId: clientId ?? this.clientId,
        rev: rev.present ? rev.value : this.rev,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
        lastSyncedAt:
            lastSyncedAt.present ? lastSyncedAt.value : this.lastSyncedAt,
        title: title ?? this.title,
        description: description.present ? description.value : this.description,
        type: type ?? this.type,
        triggerAt: triggerAt.present ? triggerAt.value : this.triggerAt,
        dueAt: dueAt.present ? dueAt.value : this.dueAt,
        repeatRule: repeatRule.present ? repeatRule.value : this.repeatRule,
        timezone: timezone.present ? timezone.value : this.timezone,
        status: status ?? this.status,
        priority: priority ?? this.priority,
        snoozedUntil:
            snoozedUntil.present ? snoozedUntil.value : this.snoozedUntil,
        lastTriggeredAt: lastTriggeredAt.present
            ? lastTriggeredAt.value
            : this.lastTriggeredAt,
        nextTriggerAt:
            nextTriggerAt.present ? nextTriggerAt.value : this.nextTriggerAt,
      );
  RemindersData copyWithCompanion(RemindersCompanion data) {
    return RemindersData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      clientId: data.clientId.present ? data.clientId.value : this.clientId,
      rev: data.rev.present ? data.rev.value : this.rev,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      lastSyncedAt: data.lastSyncedAt.present
          ? data.lastSyncedAt.value
          : this.lastSyncedAt,
      title: data.title.present ? data.title.value : this.title,
      description:
          data.description.present ? data.description.value : this.description,
      type: data.type.present ? data.type.value : this.type,
      triggerAt: data.triggerAt.present ? data.triggerAt.value : this.triggerAt,
      dueAt: data.dueAt.present ? data.dueAt.value : this.dueAt,
      repeatRule:
          data.repeatRule.present ? data.repeatRule.value : this.repeatRule,
      timezone: data.timezone.present ? data.timezone.value : this.timezone,
      status: data.status.present ? data.status.value : this.status,
      priority: data.priority.present ? data.priority.value : this.priority,
      snoozedUntil: data.snoozedUntil.present
          ? data.snoozedUntil.value
          : this.snoozedUntil,
      lastTriggeredAt: data.lastTriggeredAt.present
          ? data.lastTriggeredAt.value
          : this.lastTriggeredAt,
      nextTriggerAt: data.nextTriggerAt.present
          ? data.nextTriggerAt.value
          : this.nextTriggerAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RemindersData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('clientId: $clientId, ')
          ..write('rev: $rev, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('type: $type, ')
          ..write('triggerAt: $triggerAt, ')
          ..write('dueAt: $dueAt, ')
          ..write('repeatRule: $repeatRule, ')
          ..write('timezone: $timezone, ')
          ..write('status: $status, ')
          ..write('priority: $priority, ')
          ..write('snoozedUntil: $snoozedUntil, ')
          ..write('lastTriggeredAt: $lastTriggeredAt, ')
          ..write('nextTriggerAt: $nextTriggerAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      userId,
      clientId,
      rev,
      createdAt,
      updatedAt,
      deletedAt,
      lastSyncedAt,
      title,
      description,
      type,
      triggerAt,
      dueAt,
      repeatRule,
      timezone,
      status,
      priority,
      snoozedUntil,
      lastTriggeredAt,
      nextTriggerAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RemindersData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.clientId == this.clientId &&
          other.rev == this.rev &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.lastSyncedAt == this.lastSyncedAt &&
          other.title == this.title &&
          other.description == this.description &&
          other.type == this.type &&
          other.triggerAt == this.triggerAt &&
          other.dueAt == this.dueAt &&
          other.repeatRule == this.repeatRule &&
          other.timezone == this.timezone &&
          other.status == this.status &&
          other.priority == this.priority &&
          other.snoozedUntil == this.snoozedUntil &&
          other.lastTriggeredAt == this.lastTriggeredAt &&
          other.nextTriggerAt == this.nextTriggerAt);
}

class RemindersCompanion extends UpdateCompanion<RemindersData> {
  final Value<int?> id;
  final Value<int?> userId;
  final Value<String> clientId;
  final Value<String?> rev;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<DateTime?> lastSyncedAt;
  final Value<String> title;
  final Value<String?> description;
  final Value<String> type;
  final Value<DateTime?> triggerAt;
  final Value<DateTime?> dueAt;
  final Value<String?> repeatRule;
  final Value<String?> timezone;
  final Value<String> status;
  final Value<int> priority;
  final Value<DateTime?> snoozedUntil;
  final Value<DateTime?> lastTriggeredAt;
  final Value<DateTime?> nextTriggerAt;
  final Value<int> rowid;
  const RemindersCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.clientId = const Value.absent(),
    this.rev = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.type = const Value.absent(),
    this.triggerAt = const Value.absent(),
    this.dueAt = const Value.absent(),
    this.repeatRule = const Value.absent(),
    this.timezone = const Value.absent(),
    this.status = const Value.absent(),
    this.priority = const Value.absent(),
    this.snoozedUntil = const Value.absent(),
    this.lastTriggeredAt = const Value.absent(),
    this.nextTriggerAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RemindersCompanion.insert({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.clientId = const Value.absent(),
    this.rev = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    required String title,
    this.description = const Value.absent(),
    this.type = const Value.absent(),
    this.triggerAt = const Value.absent(),
    this.dueAt = const Value.absent(),
    this.repeatRule = const Value.absent(),
    this.timezone = const Value.absent(),
    this.status = const Value.absent(),
    this.priority = const Value.absent(),
    this.snoozedUntil = const Value.absent(),
    this.lastTriggeredAt = const Value.absent(),
    this.nextTriggerAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : title = Value(title);
  static Insertable<RemindersData> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<String>? clientId,
    Expression<String>? rev,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<DateTime>? lastSyncedAt,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? type,
    Expression<DateTime>? triggerAt,
    Expression<DateTime>? dueAt,
    Expression<String>? repeatRule,
    Expression<String>? timezone,
    Expression<String>? status,
    Expression<int>? priority,
    Expression<DateTime>? snoozedUntil,
    Expression<DateTime>? lastTriggeredAt,
    Expression<DateTime>? nextTriggerAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (clientId != null) 'client_id': clientId,
      if (rev != null) 'rev': rev,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (type != null) 'type': type,
      if (triggerAt != null) 'trigger_at': triggerAt,
      if (dueAt != null) 'due_at': dueAt,
      if (repeatRule != null) 'repeat_rule': repeatRule,
      if (timezone != null) 'timezone': timezone,
      if (status != null) 'status': status,
      if (priority != null) 'priority': priority,
      if (snoozedUntil != null) 'snoozed_until': snoozedUntil,
      if (lastTriggeredAt != null) 'last_triggered_at': lastTriggeredAt,
      if (nextTriggerAt != null) 'next_trigger_at': nextTriggerAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RemindersCompanion copyWith(
      {Value<int?>? id,
      Value<int?>? userId,
      Value<String>? clientId,
      Value<String?>? rev,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<DateTime?>? deletedAt,
      Value<DateTime?>? lastSyncedAt,
      Value<String>? title,
      Value<String?>? description,
      Value<String>? type,
      Value<DateTime?>? triggerAt,
      Value<DateTime?>? dueAt,
      Value<String?>? repeatRule,
      Value<String?>? timezone,
      Value<String>? status,
      Value<int>? priority,
      Value<DateTime?>? snoozedUntil,
      Value<DateTime?>? lastTriggeredAt,
      Value<DateTime?>? nextTriggerAt,
      Value<int>? rowid}) {
    return RemindersCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      clientId: clientId ?? this.clientId,
      rev: rev ?? this.rev,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      triggerAt: triggerAt ?? this.triggerAt,
      dueAt: dueAt ?? this.dueAt,
      repeatRule: repeatRule ?? this.repeatRule,
      timezone: timezone ?? this.timezone,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      snoozedUntil: snoozedUntil ?? this.snoozedUntil,
      lastTriggeredAt: lastTriggeredAt ?? this.lastTriggeredAt,
      nextTriggerAt: nextTriggerAt ?? this.nextTriggerAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (clientId.present) {
      map['client_id'] = Variable<String>(clientId.value);
    }
    if (rev.present) {
      map['rev'] = Variable<String>(rev.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (lastSyncedAt.present) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (triggerAt.present) {
      map['trigger_at'] = Variable<DateTime>(triggerAt.value);
    }
    if (dueAt.present) {
      map['due_at'] = Variable<DateTime>(dueAt.value);
    }
    if (repeatRule.present) {
      map['repeat_rule'] = Variable<String>(repeatRule.value);
    }
    if (timezone.present) {
      map['timezone'] = Variable<String>(timezone.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (priority.present) {
      map['priority'] = Variable<int>(priority.value);
    }
    if (snoozedUntil.present) {
      map['snoozed_until'] = Variable<DateTime>(snoozedUntil.value);
    }
    if (lastTriggeredAt.present) {
      map['last_triggered_at'] = Variable<DateTime>(lastTriggeredAt.value);
    }
    if (nextTriggerAt.present) {
      map['next_trigger_at'] = Variable<DateTime>(nextTriggerAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RemindersCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('clientId: $clientId, ')
          ..write('rev: $rev, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('type: $type, ')
          ..write('triggerAt: $triggerAt, ')
          ..write('dueAt: $dueAt, ')
          ..write('repeatRule: $repeatRule, ')
          ..write('timezone: $timezone, ')
          ..write('status: $status, ')
          ..write('priority: $priority, ')
          ..write('snoozedUntil: $snoozedUntil, ')
          ..write('lastTriggeredAt: $lastTriggeredAt, ')
          ..write('nextTriggerAt: $nextTriggerAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class DeferredRemoteItems extends Table
    with TableInfo<DeferredRemoteItems, DeferredRemoteItemsData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  DeferredRemoteItems(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
      'entity_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> clientId = GeneratedColumn<String>(
      'client_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> data = GeneratedColumn<String>(
      'data', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<DateTime> parkedAt = GeneratedColumn<DateTime>(
      'parked_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: const CustomExpression('CURRENT_TIMESTAMP'));
  @override
  List<GeneratedColumn> get $columns => [entityType, clientId, data, parkedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'deferred_remote_items';
  @override
  Set<GeneratedColumn> get $primaryKey => {entityType, clientId};
  @override
  DeferredRemoteItemsData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DeferredRemoteItemsData(
      entityType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_type'])!,
      clientId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}client_id'])!,
      data: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}data'])!,
      parkedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}parked_at'])!,
    );
  }

  @override
  DeferredRemoteItems createAlias(String alias) {
    return DeferredRemoteItems(attachedDatabase, alias);
  }
}

class DeferredRemoteItemsData extends DataClass
    implements Insertable<DeferredRemoteItemsData> {
  final String entityType;
  final String clientId;
  final String data;
  final DateTime parkedAt;
  const DeferredRemoteItemsData(
      {required this.entityType,
      required this.clientId,
      required this.data,
      required this.parkedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['entity_type'] = Variable<String>(entityType);
    map['client_id'] = Variable<String>(clientId);
    map['data'] = Variable<String>(data);
    map['parked_at'] = Variable<DateTime>(parkedAt);
    return map;
  }

  DeferredRemoteItemsCompanion toCompanion(bool nullToAbsent) {
    return DeferredRemoteItemsCompanion(
      entityType: Value(entityType),
      clientId: Value(clientId),
      data: Value(data),
      parkedAt: Value(parkedAt),
    );
  }

  factory DeferredRemoteItemsData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DeferredRemoteItemsData(
      entityType: serializer.fromJson<String>(json['entityType']),
      clientId: serializer.fromJson<String>(json['clientId']),
      data: serializer.fromJson<String>(json['data']),
      parkedAt: serializer.fromJson<DateTime>(json['parkedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'entityType': serializer.toJson<String>(entityType),
      'clientId': serializer.toJson<String>(clientId),
      'data': serializer.toJson<String>(data),
      'parkedAt': serializer.toJson<DateTime>(parkedAt),
    };
  }

  DeferredRemoteItemsData copyWith(
          {String? entityType,
          String? clientId,
          String? data,
          DateTime? parkedAt}) =>
      DeferredRemoteItemsData(
        entityType: entityType ?? this.entityType,
        clientId: clientId ?? this.clientId,
        data: data ?? this.data,
        parkedAt: parkedAt ?? this.parkedAt,
      );
  DeferredRemoteItemsData copyWithCompanion(DeferredRemoteItemsCompanion data) {
    return DeferredRemoteItemsData(
      entityType:
          data.entityType.present ? data.entityType.value : this.entityType,
      clientId: data.clientId.present ? data.clientId.value : this.clientId,
      data: data.data.present ? data.data.value : this.data,
      parkedAt: data.parkedAt.present ? data.parkedAt.value : this.parkedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DeferredRemoteItemsData(')
          ..write('entityType: $entityType, ')
          ..write('clientId: $clientId, ')
          ..write('data: $data, ')
          ..write('parkedAt: $parkedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(entityType, clientId, data, parkedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DeferredRemoteItemsData &&
          other.entityType == this.entityType &&
          other.clientId == this.clientId &&
          other.data == this.data &&
          other.parkedAt == this.parkedAt);
}

class DeferredRemoteItemsCompanion
    extends UpdateCompanion<DeferredRemoteItemsData> {
  final Value<String> entityType;
  final Value<String> clientId;
  final Value<String> data;
  final Value<DateTime> parkedAt;
  final Value<int> rowid;
  const DeferredRemoteItemsCompanion({
    this.entityType = const Value.absent(),
    this.clientId = const Value.absent(),
    this.data = const Value.absent(),
    this.parkedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DeferredRemoteItemsCompanion.insert({
    required String entityType,
    required String clientId,
    required String data,
    this.parkedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : entityType = Value(entityType),
        clientId = Value(clientId),
        data = Value(data);
  static Insertable<DeferredRemoteItemsData> custom({
    Expression<String>? entityType,
    Expression<String>? clientId,
    Expression<String>? data,
    Expression<DateTime>? parkedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (entityType != null) 'entity_type': entityType,
      if (clientId != null) 'client_id': clientId,
      if (data != null) 'data': data,
      if (parkedAt != null) 'parked_at': parkedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DeferredRemoteItemsCompanion copyWith(
      {Value<String>? entityType,
      Value<String>? clientId,
      Value<String>? data,
      Value<DateTime>? parkedAt,
      Value<int>? rowid}) {
    return DeferredRemoteItemsCompanion(
      entityType: entityType ?? this.entityType,
      clientId: clientId ?? this.clientId,
      data: data ?? this.data,
      parkedAt: parkedAt ?? this.parkedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (clientId.present) {
      map['client_id'] = Variable<String>(clientId.value);
    }
    if (data.present) {
      map['data'] = Variable<String>(data.value);
    }
    if (parkedAt.present) {
      map['parked_at'] = Variable<DateTime>(parkedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DeferredRemoteItemsCompanion(')
          ..write('entityType: $entityType, ')
          ..write('clientId: $clientId, ')
          ..write('data: $data, ')
          ..write('parkedAt: $parkedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class DatabaseAtV9 extends GeneratedDatabase {
  DatabaseAtV9(QueryExecutor e) : super(e);
  late final Wallets wallets = Wallets(this);
  late final Parties parties = Parties(this);
  late final Groups groups = Groups(this);
  late final Transactions transactions = Transactions(this);
  late final Categories categories = Categories(this);
  late final Configs configs = Configs(this);
  late final Users users = Users(this);
  late final LocalChanges localChanges = LocalChanges(this);
  late final SyncMetadata syncMetadata = SyncMetadata(this);
  late final Categorizables categorizables = Categorizables(this);
  late final Notifications notifications = Notifications(this);
  late final MediaFiles mediaFiles = MediaFiles(this);
  late final Transfers transfers = Transfers(this);
  late final Budgets budgets = Budgets(this);
  late final BudgetTargets budgetTargets = BudgetTargets(this);
  late final BudgetPeriodStates budgetPeriodStates = BudgetPeriodStates(this);
  late final Holdings holdings = Holdings(this);
  late final FinancialPositionCache financialPositionCache =
      FinancialPositionCache(this);
  late final Reminders reminders = Reminders(this);
  late final DeferredRemoteItems deferredRemoteItems =
      DeferredRemoteItems(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        wallets,
        parties,
        groups,
        transactions,
        categories,
        configs,
        users,
        localChanges,
        syncMetadata,
        categorizables,
        notifications,
        mediaFiles,
        transfers,
        budgets,
        budgetTargets,
        budgetPeriodStates,
        holdings,
        financialPositionCache,
        reminders,
        deferredRemoteItems
      ];
  @override
  int get schemaVersion => 9;
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}

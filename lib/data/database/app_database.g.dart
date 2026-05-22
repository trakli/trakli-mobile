// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $WalletsTable extends Wallets with TableInfo<$WalletsTable, Wallet> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WalletsTable(this.attachedDatabase, [this._alias]);
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<String> clientId = GeneratedColumn<String>(
      'client_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(defaultClientId));
  @override
  late final GeneratedColumn<String> rev = GeneratedColumn<String>(
      'rev', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('1'));
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<DateTime> lastSyncedAt = GeneratedColumn<DateTime>(
      'last_synced_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<WalletType, String> type =
      GeneratedColumn<String>('type', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<WalletType>($WalletsTable.$convertertype);
  @override
  late final GeneratedColumn<double> balance = GeneratedColumn<double>(
      'balance', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
      'currency', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  late final GeneratedColumnWithTypeConverter<WalletStats?, String> stats =
      GeneratedColumn<String>('stats', aliasedName, true,
              type: DriftSqlType.string, requiredDuringInsert: false)
          .withConverter<WalletStats?>($WalletsTable.$converterstatsn);
  @override
  late final GeneratedColumnWithTypeConverter<Media?, String> icon =
      GeneratedColumn<String>('icon', aliasedName, true,
              type: DriftSqlType.string, requiredDuringInsert: false)
          .withConverter<Media?>($WalletsTable.$convertericonn);
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
  Wallet map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Wallet(
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
      type: $WalletsTable.$convertertype.fromSql(attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!),
      balance: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}balance'])!,
      currency: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}currency'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      stats: $WalletsTable.$converterstatsn.fromSql(attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}stats'])),
      icon: $WalletsTable.$convertericonn.fromSql(attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}icon'])),
    );
  }

  @override
  $WalletsTable createAlias(String alias) {
    return $WalletsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<WalletType, String, String> $convertertype =
      const WalletTypeConverter();
  static JsonTypeConverter2<WalletStats, String, Map<String, Object?>>
      $converterstats = const WalletStatsConverter();
  static JsonTypeConverter2<WalletStats?, String?, Map<String, Object?>?>
      $converterstatsn = JsonTypeConverter2.asNullable($converterstats);
  static JsonTypeConverter2<Media, String, Map<String, Object?>>
      $convertericon = const MediaConverter();
  static JsonTypeConverter2<Media?, String?, Map<String, Object?>?>
      $convertericonn = JsonTypeConverter2.asNullable($convertericon);
}

class Wallet extends DataClass implements Insertable<Wallet> {
  final int? id;
  final int? userId;
  final String clientId;
  final String? rev;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final DateTime? lastSyncedAt;
  final String name;
  final WalletType type;
  final double balance;
  final String currency;
  final String? description;
  final WalletStats? stats;
  final Media? icon;
  const Wallet(
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
    {
      map['type'] = Variable<String>($WalletsTable.$convertertype.toSql(type));
    }
    map['balance'] = Variable<double>(balance);
    map['currency'] = Variable<String>(currency);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || stats != null) {
      map['stats'] =
          Variable<String>($WalletsTable.$converterstatsn.toSql(stats));
    }
    if (!nullToAbsent || icon != null) {
      map['icon'] = Variable<String>($WalletsTable.$convertericonn.toSql(icon));
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

  factory Wallet.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Wallet(
      id: serializer.fromJson<int?>(json['id']),
      userId: serializer.fromJson<int?>(json['user_id']),
      clientId: serializer.fromJson<String>(json['client_generated_id']),
      rev: serializer.fromJson<String?>(json['rev']),
      createdAt: serializer.fromJson<DateTime>(json['created_at']),
      updatedAt: serializer.fromJson<DateTime>(json['updated_at']),
      deletedAt: serializer.fromJson<DateTime?>(json['deleted_at']),
      lastSyncedAt: serializer.fromJson<DateTime?>(json['last_synced_at']),
      name: serializer.fromJson<String>(json['name']),
      type: $WalletsTable.$convertertype
          .fromJson(serializer.fromJson<String>(json['type'])),
      balance: serializer.fromJson<double>(json['balance']),
      currency: serializer.fromJson<String>(json['currency']),
      description: serializer.fromJson<String?>(json['description']),
      stats: $WalletsTable.$converterstatsn
          .fromJson(serializer.fromJson<Map<String, Object?>?>(json['stats'])),
      icon: $WalletsTable.$convertericonn
          .fromJson(serializer.fromJson<Map<String, Object?>?>(json['icon'])),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int?>(id),
      'user_id': serializer.toJson<int?>(userId),
      'client_generated_id': serializer.toJson<String>(clientId),
      'rev': serializer.toJson<String?>(rev),
      'created_at': serializer.toJson<DateTime>(createdAt),
      'updated_at': serializer.toJson<DateTime>(updatedAt),
      'deleted_at': serializer.toJson<DateTime?>(deletedAt),
      'last_synced_at': serializer.toJson<DateTime?>(lastSyncedAt),
      'name': serializer.toJson<String>(name),
      'type':
          serializer.toJson<String>($WalletsTable.$convertertype.toJson(type)),
      'balance': serializer.toJson<double>(balance),
      'currency': serializer.toJson<String>(currency),
      'description': serializer.toJson<String?>(description),
      'stats': serializer.toJson<Map<String, Object?>?>(
          $WalletsTable.$converterstatsn.toJson(stats)),
      'icon': serializer.toJson<Map<String, Object?>?>(
          $WalletsTable.$convertericonn.toJson(icon)),
    };
  }

  Wallet copyWith(
          {Value<int?> id = const Value.absent(),
          Value<int?> userId = const Value.absent(),
          String? clientId,
          Value<String?> rev = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<DateTime?> deletedAt = const Value.absent(),
          Value<DateTime?> lastSyncedAt = const Value.absent(),
          String? name,
          WalletType? type,
          double? balance,
          String? currency,
          Value<String?> description = const Value.absent(),
          Value<WalletStats?> stats = const Value.absent(),
          Value<Media?> icon = const Value.absent()}) =>
      Wallet(
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
  Wallet copyWithCompanion(WalletsCompanion data) {
    return Wallet(
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
    return (StringBuffer('Wallet(')
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
      (other is Wallet &&
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

class WalletsCompanion extends UpdateCompanion<Wallet> {
  final Value<int?> id;
  final Value<int?> userId;
  final Value<String> clientId;
  final Value<String?> rev;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<DateTime?> lastSyncedAt;
  final Value<String> name;
  final Value<WalletType> type;
  final Value<double> balance;
  final Value<String> currency;
  final Value<String?> description;
  final Value<WalletStats?> stats;
  final Value<Media?> icon;
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
    required WalletType type,
    this.balance = const Value.absent(),
    required String currency,
    this.description = const Value.absent(),
    this.stats = const Value.absent(),
    this.icon = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : name = Value(name),
        type = Value(type),
        currency = Value(currency);
  static Insertable<Wallet> custom({
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
      Value<WalletType>? type,
      Value<double>? balance,
      Value<String>? currency,
      Value<String?>? description,
      Value<WalletStats?>? stats,
      Value<Media?>? icon,
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
      map['type'] =
          Variable<String>($WalletsTable.$convertertype.toSql(type.value));
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
      map['stats'] =
          Variable<String>($WalletsTable.$converterstatsn.toSql(stats.value));
    }
    if (icon.present) {
      map['icon'] =
          Variable<String>($WalletsTable.$convertericonn.toSql(icon.value));
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

class $PartiesTable extends Parties with TableInfo<$PartiesTable, Party> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PartiesTable(this.attachedDatabase, [this._alias]);
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<String> clientId = GeneratedColumn<String>(
      'client_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(defaultClientId));
  @override
  late final GeneratedColumn<String> rev = GeneratedColumn<String>(
      'rev', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('1'));
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<DateTime> lastSyncedAt = GeneratedColumn<DateTime>(
      'last_synced_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  late final GeneratedColumnWithTypeConverter<Media?, String> icon =
      GeneratedColumn<String>('icon', aliasedName, true,
              type: DriftSqlType.string, requiredDuringInsert: false)
          .withConverter<Media?>($PartiesTable.$convertericonn);
  @override
  late final GeneratedColumnWithTypeConverter<PartyType?, String> type =
      GeneratedColumn<String>('type', aliasedName, true,
              type: DriftSqlType.string, requiredDuringInsert: false)
          .withConverter<PartyType?>($PartiesTable.$convertertypen);
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
  Party map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Party(
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
      icon: $PartiesTable.$convertericonn.fromSql(attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}icon'])),
      type: $PartiesTable.$convertertypen.fromSql(attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])),
    );
  }

  @override
  $PartiesTable createAlias(String alias) {
    return $PartiesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<Media, String, Map<String, Object?>>
      $convertericon = const MediaConverter();
  static JsonTypeConverter2<Media?, String?, Map<String, Object?>?>
      $convertericonn = JsonTypeConverter2.asNullable($convertericon);
  static JsonTypeConverter2<PartyType, String, String> $convertertype =
      const PartyTypeConverter();
  static JsonTypeConverter2<PartyType?, String?, String?> $convertertypen =
      JsonTypeConverter2.asNullable($convertertype);
}

class Party extends DataClass implements Insertable<Party> {
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
  final Media? icon;
  final PartyType? type;
  const Party(
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
      map['icon'] = Variable<String>($PartiesTable.$convertericonn.toSql(icon));
    }
    if (!nullToAbsent || type != null) {
      map['type'] = Variable<String>($PartiesTable.$convertertypen.toSql(type));
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

  factory Party.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Party(
      id: serializer.fromJson<int?>(json['id']),
      userId: serializer.fromJson<int?>(json['user_id']),
      clientId: serializer.fromJson<String>(json['client_generated_id']),
      rev: serializer.fromJson<String?>(json['rev']),
      createdAt: serializer.fromJson<DateTime>(json['created_at']),
      updatedAt: serializer.fromJson<DateTime>(json['updated_at']),
      deletedAt: serializer.fromJson<DateTime?>(json['deleted_at']),
      lastSyncedAt: serializer.fromJson<DateTime?>(json['last_synced_at']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      icon: $PartiesTable.$convertericonn
          .fromJson(serializer.fromJson<Map<String, Object?>?>(json['icon'])),
      type: $PartiesTable.$convertertypen
          .fromJson(serializer.fromJson<String?>(json['type'])),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int?>(id),
      'user_id': serializer.toJson<int?>(userId),
      'client_generated_id': serializer.toJson<String>(clientId),
      'rev': serializer.toJson<String?>(rev),
      'created_at': serializer.toJson<DateTime>(createdAt),
      'updated_at': serializer.toJson<DateTime>(updatedAt),
      'deleted_at': serializer.toJson<DateTime?>(deletedAt),
      'last_synced_at': serializer.toJson<DateTime?>(lastSyncedAt),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'icon': serializer.toJson<Map<String, Object?>?>(
          $PartiesTable.$convertericonn.toJson(icon)),
      'type': serializer
          .toJson<String?>($PartiesTable.$convertertypen.toJson(type)),
    };
  }

  Party copyWith(
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
          Value<Media?> icon = const Value.absent(),
          Value<PartyType?> type = const Value.absent()}) =>
      Party(
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
  Party copyWithCompanion(PartiesCompanion data) {
    return Party(
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
    return (StringBuffer('Party(')
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
      (other is Party &&
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

class PartiesCompanion extends UpdateCompanion<Party> {
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
  final Value<Media?> icon;
  final Value<PartyType?> type;
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
  static Insertable<Party> custom({
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
      Value<Media?>? icon,
      Value<PartyType?>? type,
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
      map['icon'] =
          Variable<String>($PartiesTable.$convertericonn.toSql(icon.value));
    }
    if (type.present) {
      map['type'] =
          Variable<String>($PartiesTable.$convertertypen.toSql(type.value));
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

class $GroupsTable extends Groups with TableInfo<$GroupsTable, Group> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GroupsTable(this.attachedDatabase, [this._alias]);
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<String> clientId = GeneratedColumn<String>(
      'client_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(defaultClientId));
  @override
  late final GeneratedColumn<String> rev = GeneratedColumn<String>(
      'rev', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('1'));
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<DateTime> lastSyncedAt = GeneratedColumn<DateTime>(
      'last_synced_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  late final GeneratedColumnWithTypeConverter<Media?, String> icon =
      GeneratedColumn<String>('icon', aliasedName, true,
              type: DriftSqlType.string, requiredDuringInsert: false)
          .withConverter<Media?>($GroupsTable.$convertericonn);
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
  Group map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Group(
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
      icon: $GroupsTable.$convertericonn.fromSql(attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}icon'])),
    );
  }

  @override
  $GroupsTable createAlias(String alias) {
    return $GroupsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<Media, String, Map<String, Object?>>
      $convertericon = const MediaConverter();
  static JsonTypeConverter2<Media?, String?, Map<String, Object?>?>
      $convertericonn = JsonTypeConverter2.asNullable($convertericon);
}

class Group extends DataClass implements Insertable<Group> {
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
  final Media? icon;
  const Group(
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
      map['icon'] = Variable<String>($GroupsTable.$convertericonn.toSql(icon));
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

  factory Group.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Group(
      id: serializer.fromJson<int?>(json['id']),
      userId: serializer.fromJson<int?>(json['user_id']),
      clientId: serializer.fromJson<String>(json['client_generated_id']),
      rev: serializer.fromJson<String?>(json['rev']),
      createdAt: serializer.fromJson<DateTime>(json['created_at']),
      updatedAt: serializer.fromJson<DateTime>(json['updated_at']),
      deletedAt: serializer.fromJson<DateTime?>(json['deleted_at']),
      lastSyncedAt: serializer.fromJson<DateTime?>(json['last_synced_at']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      icon: $GroupsTable.$convertericonn
          .fromJson(serializer.fromJson<Map<String, Object?>?>(json['icon'])),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int?>(id),
      'user_id': serializer.toJson<int?>(userId),
      'client_generated_id': serializer.toJson<String>(clientId),
      'rev': serializer.toJson<String?>(rev),
      'created_at': serializer.toJson<DateTime>(createdAt),
      'updated_at': serializer.toJson<DateTime>(updatedAt),
      'deleted_at': serializer.toJson<DateTime?>(deletedAt),
      'last_synced_at': serializer.toJson<DateTime?>(lastSyncedAt),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'icon': serializer.toJson<Map<String, Object?>?>(
          $GroupsTable.$convertericonn.toJson(icon)),
    };
  }

  Group copyWith(
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
          Value<Media?> icon = const Value.absent()}) =>
      Group(
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
  Group copyWithCompanion(GroupsCompanion data) {
    return Group(
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
    return (StringBuffer('Group(')
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
      (other is Group &&
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

class GroupsCompanion extends UpdateCompanion<Group> {
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
  final Value<Media?> icon;
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
  static Insertable<Group> custom({
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
      Value<Media?>? icon,
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
      map['icon'] =
          Variable<String>($GroupsTable.$convertericonn.toSql(icon.value));
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

class $TransactionsTable extends Transactions
    with TableInfo<$TransactionsTable, Transaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionsTable(this.attachedDatabase, [this._alias]);
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<String> clientId = GeneratedColumn<String>(
      'client_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(defaultClientId));
  @override
  late final GeneratedColumn<String> rev = GeneratedColumn<String>(
      'rev', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('1'));
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<DateTime> lastSyncedAt = GeneratedColumn<DateTime>(
      'last_synced_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<TransactionType, String> type =
      GeneratedColumn<String>('type', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<TransactionType>($TransactionsTable.$convertertype);
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<DateTime> datetime = GeneratedColumn<DateTime>(
      'datetime', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<int> partyId = GeneratedColumn<int>(
      'party_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<int> walletId = GeneratedColumn<int>(
      'wallet_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<int> groupId = GeneratedColumn<int>(
      'group_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<String> walletClientId = GeneratedColumn<String>(
      'wallet_client_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES wallets (client_id)'));
  @override
  late final GeneratedColumn<String> partyClientId = GeneratedColumn<String>(
      'party_client_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES parties (client_id)'));
  @override
  late final GeneratedColumn<String> groupClientId = GeneratedColumn<String>(
      'group_client_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES "groups" (client_id)'));
  @override
  late final GeneratedColumn<int> transferId = GeneratedColumn<int>(
      'transfer_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<String> transferClientId = GeneratedColumn<String>(
      'transfer_client_id', aliasedName, true,
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
        amount,
        type,
        description,
        datetime,
        partyId,
        walletId,
        groupId,
        walletClientId,
        partyClientId,
        groupClientId,
        transferId,
        transferClientId
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transactions';
  @override
  Set<GeneratedColumn> get $primaryKey => {clientId};
  @override
  Transaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Transaction(
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
      type: $TransactionsTable.$convertertype.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!),
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
    );
  }

  @override
  $TransactionsTable createAlias(String alias) {
    return $TransactionsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TransactionType, String, String> $convertertype =
      const EnumNameConverter<TransactionType>(TransactionType.values);
}

class Transaction extends DataClass implements Insertable<Transaction> {
  final int? id;
  final int? userId;
  final String clientId;
  final String? rev;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final DateTime? lastSyncedAt;
  final double amount;
  final TransactionType type;
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
  const Transaction(
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
      this.description,
      this.datetime,
      this.partyId,
      this.walletId,
      this.groupId,
      required this.walletClientId,
      this.partyClientId,
      this.groupClientId,
      this.transferId,
      this.transferClientId});
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
    {
      map['type'] =
          Variable<String>($TransactionsTable.$convertertype.toSql(type));
    }
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
    );
  }

  factory Transaction.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Transaction(
      id: serializer.fromJson<int?>(json['id']),
      userId: serializer.fromJson<int?>(json['user_id']),
      clientId: serializer.fromJson<String>(json['client_generated_id']),
      rev: serializer.fromJson<String?>(json['rev']),
      createdAt: serializer.fromJson<DateTime>(json['created_at']),
      updatedAt: serializer.fromJson<DateTime>(json['updated_at']),
      deletedAt: serializer.fromJson<DateTime?>(json['deleted_at']),
      lastSyncedAt: serializer.fromJson<DateTime?>(json['last_synced_at']),
      amount: serializer.fromJson<double>(json['amount']),
      type: $TransactionsTable.$convertertype
          .fromJson(serializer.fromJson<String>(json['type'])),
      description: serializer.fromJson<String?>(json['description']),
      datetime: serializer.fromJson<DateTime?>(json['datetime']),
      partyId: serializer.fromJson<int?>(json['party_id']),
      walletId: serializer.fromJson<int?>(json['wallet_id']),
      groupId: serializer.fromJson<int?>(json['group_id']),
      walletClientId: serializer.fromJson<String>(json['walletClientId']),
      partyClientId: serializer.fromJson<String?>(json['partyClientId']),
      groupClientId: serializer.fromJson<String?>(json['groupClientId']),
      transferId: serializer.fromJson<int?>(json['transfer_id']),
      transferClientId:
          serializer.fromJson<String?>(json['transfer_client_id']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int?>(id),
      'user_id': serializer.toJson<int?>(userId),
      'client_generated_id': serializer.toJson<String>(clientId),
      'rev': serializer.toJson<String?>(rev),
      'created_at': serializer.toJson<DateTime>(createdAt),
      'updated_at': serializer.toJson<DateTime>(updatedAt),
      'deleted_at': serializer.toJson<DateTime?>(deletedAt),
      'last_synced_at': serializer.toJson<DateTime?>(lastSyncedAt),
      'amount': serializer.toJson<double>(amount),
      'type': serializer
          .toJson<String>($TransactionsTable.$convertertype.toJson(type)),
      'description': serializer.toJson<String?>(description),
      'datetime': serializer.toJson<DateTime?>(datetime),
      'party_id': serializer.toJson<int?>(partyId),
      'wallet_id': serializer.toJson<int?>(walletId),
      'group_id': serializer.toJson<int?>(groupId),
      'walletClientId': serializer.toJson<String>(walletClientId),
      'partyClientId': serializer.toJson<String?>(partyClientId),
      'groupClientId': serializer.toJson<String?>(groupClientId),
      'transfer_id': serializer.toJson<int?>(transferId),
      'transfer_client_id': serializer.toJson<String?>(transferClientId),
    };
  }

  Transaction copyWith(
          {Value<int?> id = const Value.absent(),
          Value<int?> userId = const Value.absent(),
          String? clientId,
          Value<String?> rev = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<DateTime?> deletedAt = const Value.absent(),
          Value<DateTime?> lastSyncedAt = const Value.absent(),
          double? amount,
          TransactionType? type,
          Value<String?> description = const Value.absent(),
          Value<DateTime?> datetime = const Value.absent(),
          Value<int?> partyId = const Value.absent(),
          Value<int?> walletId = const Value.absent(),
          Value<int?> groupId = const Value.absent(),
          String? walletClientId,
          Value<String?> partyClientId = const Value.absent(),
          Value<String?> groupClientId = const Value.absent(),
          Value<int?> transferId = const Value.absent(),
          Value<String?> transferClientId = const Value.absent()}) =>
      Transaction(
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
      );
  Transaction copyWithCompanion(TransactionsCompanion data) {
    return Transaction(
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
    );
  }

  @override
  String toString() {
    return (StringBuffer('Transaction(')
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
          ..write('description: $description, ')
          ..write('datetime: $datetime, ')
          ..write('partyId: $partyId, ')
          ..write('walletId: $walletId, ')
          ..write('groupId: $groupId, ')
          ..write('walletClientId: $walletClientId, ')
          ..write('partyClientId: $partyClientId, ')
          ..write('groupClientId: $groupClientId, ')
          ..write('transferId: $transferId, ')
          ..write('transferClientId: $transferClientId')
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
      type,
      description,
      datetime,
      partyId,
      walletId,
      groupId,
      walletClientId,
      partyClientId,
      groupClientId,
      transferId,
      transferClientId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Transaction &&
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
          other.description == this.description &&
          other.datetime == this.datetime &&
          other.partyId == this.partyId &&
          other.walletId == this.walletId &&
          other.groupId == this.groupId &&
          other.walletClientId == this.walletClientId &&
          other.partyClientId == this.partyClientId &&
          other.groupClientId == this.groupClientId &&
          other.transferId == this.transferId &&
          other.transferClientId == this.transferClientId);
}

class TransactionsCompanion extends UpdateCompanion<Transaction> {
  final Value<int?> id;
  final Value<int?> userId;
  final Value<String> clientId;
  final Value<String?> rev;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<DateTime?> lastSyncedAt;
  final Value<double> amount;
  final Value<TransactionType> type;
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
    required TransactionType type,
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
    this.rowid = const Value.absent(),
  })  : amount = Value(amount),
        type = Value(type),
        walletClientId = Value(walletClientId);
  static Insertable<Transaction> custom({
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
      Value<TransactionType>? type,
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
      map['type'] =
          Variable<String>($TransactionsTable.$convertertype.toSql(type.value));
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
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, Category> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<String> clientId = GeneratedColumn<String>(
      'client_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(defaultClientId));
  @override
  late final GeneratedColumn<String> rev = GeneratedColumn<String>(
      'rev', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('1'));
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<DateTime> lastSyncedAt = GeneratedColumn<DateTime>(
      'last_synced_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  @override
  late final GeneratedColumn<String> slug = GeneratedColumn<String>(
      'slug', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  late final GeneratedColumnWithTypeConverter<TransactionType, String> type =
      GeneratedColumn<String>('type', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<TransactionType>($CategoriesTable.$convertertype);
  @override
  late final GeneratedColumnWithTypeConverter<Media?, String> icon =
      GeneratedColumn<String>('icon', aliasedName, true,
              type: DriftSqlType.string, requiredDuringInsert: false)
          .withConverter<Media?>($CategoriesTable.$convertericonn);
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
  Category map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Category(
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
      type: $CategoriesTable.$convertertype.fromSql(attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!),
      icon: $CategoriesTable.$convertericonn.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}icon'])),
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TransactionType, String, String> $convertertype =
      const EnumNameConverter<TransactionType>(TransactionType.values);
  static JsonTypeConverter2<Media, String, Map<String, Object?>>
      $convertericon = const MediaConverter();
  static JsonTypeConverter2<Media?, String?, Map<String, Object?>?>
      $convertericonn = JsonTypeConverter2.asNullable($convertericon);
}

class Category extends DataClass implements Insertable<Category> {
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
  final TransactionType type;
  final Media? icon;
  const Category(
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
    {
      map['type'] =
          Variable<String>($CategoriesTable.$convertertype.toSql(type));
    }
    if (!nullToAbsent || icon != null) {
      map['icon'] =
          Variable<String>($CategoriesTable.$convertericonn.toSql(icon));
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

  factory Category.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Category(
      id: serializer.fromJson<int?>(json['id']),
      userId: serializer.fromJson<int?>(json['user_id']),
      clientId: serializer.fromJson<String>(json['client_generated_id']),
      rev: serializer.fromJson<String?>(json['rev']),
      createdAt: serializer.fromJson<DateTime>(json['created_at']),
      updatedAt: serializer.fromJson<DateTime>(json['updated_at']),
      deletedAt: serializer.fromJson<DateTime?>(json['deleted_at']),
      lastSyncedAt: serializer.fromJson<DateTime?>(json['last_synced_at']),
      name: serializer.fromJson<String>(json['name']),
      slug: serializer.fromJson<String>(json['slug']),
      description: serializer.fromJson<String?>(json['description']),
      type: $CategoriesTable.$convertertype
          .fromJson(serializer.fromJson<String>(json['type'])),
      icon: $CategoriesTable.$convertericonn
          .fromJson(serializer.fromJson<Map<String, Object?>?>(json['icon'])),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int?>(id),
      'user_id': serializer.toJson<int?>(userId),
      'client_generated_id': serializer.toJson<String>(clientId),
      'rev': serializer.toJson<String?>(rev),
      'created_at': serializer.toJson<DateTime>(createdAt),
      'updated_at': serializer.toJson<DateTime>(updatedAt),
      'deleted_at': serializer.toJson<DateTime?>(deletedAt),
      'last_synced_at': serializer.toJson<DateTime?>(lastSyncedAt),
      'name': serializer.toJson<String>(name),
      'slug': serializer.toJson<String>(slug),
      'description': serializer.toJson<String?>(description),
      'type': serializer
          .toJson<String>($CategoriesTable.$convertertype.toJson(type)),
      'icon': serializer.toJson<Map<String, Object?>?>(
          $CategoriesTable.$convertericonn.toJson(icon)),
    };
  }

  Category copyWith(
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
          TransactionType? type,
          Value<Media?> icon = const Value.absent()}) =>
      Category(
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
  Category copyWithCompanion(CategoriesCompanion data) {
    return Category(
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
    return (StringBuffer('Category(')
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
      (other is Category &&
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

class CategoriesCompanion extends UpdateCompanion<Category> {
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
  final Value<TransactionType> type;
  final Value<Media?> icon;
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
    required TransactionType type,
    this.icon = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : name = Value(name),
        slug = Value(slug),
        type = Value(type);
  static Insertable<Category> custom({
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
      Value<TransactionType>? type,
      Value<Media?>? icon,
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
      map['type'] =
          Variable<String>($CategoriesTable.$convertertype.toSql(type.value));
    }
    if (icon.present) {
      map['icon'] =
          Variable<String>($CategoriesTable.$convertericonn.toSql(icon.value));
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

class $ConfigsTable extends Configs with TableInfo<$ConfigsTable, Config> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ConfigsTable(this.attachedDatabase, [this._alias]);
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<String> clientId = GeneratedColumn<String>(
      'client_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(defaultClientId));
  @override
  late final GeneratedColumn<String> rev = GeneratedColumn<String>(
      'rev', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('1'));
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<DateTime> lastSyncedAt = GeneratedColumn<DateTime>(
      'last_synced_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
      'key', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  @override
  late final GeneratedColumnWithTypeConverter<ConfigType, String> type =
      GeneratedColumn<String>('type', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<ConfigType>($ConfigsTable.$convertertype);
  @override
  late final GeneratedColumnWithTypeConverter<dynamic, String> value =
      GeneratedColumn<String>('value', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<dynamic>($ConfigsTable.$convertervalue);
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
  Config map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Config(
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
      type: $ConfigsTable.$convertertype.fromSql(attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!),
      value: $ConfigsTable.$convertervalue.fromSql(attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}value'])!),
    );
  }

  @override
  $ConfigsTable createAlias(String alias) {
    return $ConfigsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ConfigType, String, String> $convertertype =
      const EnumNameConverter<ConfigType>(ConfigType.values);
  static TypeConverter<dynamic, String> $convertervalue =
      const ConfigValueConverter();
}

class Config extends DataClass implements Insertable<Config> {
  final int? id;
  final int? userId;
  final String clientId;
  final String? rev;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final DateTime? lastSyncedAt;
  final String key;
  final ConfigType type;
  final dynamic value;
  const Config(
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
      this.value});
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
    {
      map['type'] = Variable<String>($ConfigsTable.$convertertype.toSql(type));
    }
    if (!nullToAbsent || value != null) {
      map['value'] =
          Variable<String>($ConfigsTable.$convertervalue.toSql(value));
    }
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
      value:
          value == null && nullToAbsent ? const Value.absent() : Value(value),
    );
  }

  factory Config.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Config(
      id: serializer.fromJson<int?>(json['id']),
      userId: serializer.fromJson<int?>(json['user_id']),
      clientId: serializer.fromJson<String>(json['client_generated_id']),
      rev: serializer.fromJson<String?>(json['rev']),
      createdAt: serializer.fromJson<DateTime>(json['created_at']),
      updatedAt: serializer.fromJson<DateTime>(json['updated_at']),
      deletedAt: serializer.fromJson<DateTime?>(json['deleted_at']),
      lastSyncedAt: serializer.fromJson<DateTime?>(json['last_synced_at']),
      key: serializer.fromJson<String>(json['key']),
      type: $ConfigsTable.$convertertype
          .fromJson(serializer.fromJson<String>(json['type'])),
      value: serializer.fromJson<dynamic>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int?>(id),
      'user_id': serializer.toJson<int?>(userId),
      'client_generated_id': serializer.toJson<String>(clientId),
      'rev': serializer.toJson<String?>(rev),
      'created_at': serializer.toJson<DateTime>(createdAt),
      'updated_at': serializer.toJson<DateTime>(updatedAt),
      'deleted_at': serializer.toJson<DateTime?>(deletedAt),
      'last_synced_at': serializer.toJson<DateTime?>(lastSyncedAt),
      'key': serializer.toJson<String>(key),
      'type':
          serializer.toJson<String>($ConfigsTable.$convertertype.toJson(type)),
      'value': serializer.toJson<dynamic>(value),
    };
  }

  Config copyWith(
          {Value<int?> id = const Value.absent(),
          Value<int?> userId = const Value.absent(),
          String? clientId,
          Value<String?> rev = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<DateTime?> deletedAt = const Value.absent(),
          Value<DateTime?> lastSyncedAt = const Value.absent(),
          String? key,
          ConfigType? type,
          Value<dynamic> value = const Value.absent()}) =>
      Config(
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
        value: value.present ? value.value : this.value,
      );
  Config copyWithCompanion(ConfigsCompanion data) {
    return Config(
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
    return (StringBuffer('Config(')
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
      (other is Config &&
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

class ConfigsCompanion extends UpdateCompanion<Config> {
  final Value<int?> id;
  final Value<int?> userId;
  final Value<String> clientId;
  final Value<String?> rev;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<DateTime?> lastSyncedAt;
  final Value<String> key;
  final Value<ConfigType> type;
  final Value<dynamic> value;
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
    required ConfigType type,
    required dynamic value,
    this.rowid = const Value.absent(),
  })  : key = Value(key),
        type = Value(type),
        value = Value(value);
  static Insertable<Config> custom({
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
      Value<ConfigType>? type,
      Value<dynamic>? value,
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
      map['type'] =
          Variable<String>($ConfigsTable.$convertertype.toSql(type.value));
    }
    if (value.present) {
      map['value'] =
          Variable<String>($ConfigsTable.$convertervalue.toSql(value.value));
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

class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  @override
  late final GeneratedColumn<String> firstName = GeneratedColumn<String>(
      'first_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> lastName = GeneratedColumn<String>(
      'last_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
      'username', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
      'phone', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<String> avatar = GeneratedColumn<String>(
      'avatar', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
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
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
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
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class User extends DataClass implements Insertable<User> {
  final int id;
  final String email;
  final String firstName;
  final String? lastName;
  final String? username;
  final String? phone;
  final String? avatar;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  const User(
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

  factory User.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<int>(json['id']),
      email: serializer.fromJson<String>(json['email']),
      firstName: serializer.fromJson<String>(json['first_name']),
      lastName: serializer.fromJson<String?>(json['last_name']),
      username: serializer.fromJson<String?>(json['username']),
      phone: serializer.fromJson<String?>(json['phone']),
      avatar: serializer.fromJson<String?>(json['avatar']),
      createdAt: serializer.fromJson<DateTime?>(json['created_at']),
      updatedAt: serializer.fromJson<DateTime?>(json['updated_at']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'email': serializer.toJson<String>(email),
      'first_name': serializer.toJson<String>(firstName),
      'last_name': serializer.toJson<String?>(lastName),
      'username': serializer.toJson<String?>(username),
      'phone': serializer.toJson<String?>(phone),
      'avatar': serializer.toJson<String?>(avatar),
      'created_at': serializer.toJson<DateTime?>(createdAt),
      'updated_at': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  User copyWith(
          {int? id,
          String? email,
          String? firstName,
          Value<String?> lastName = const Value.absent(),
          Value<String?> username = const Value.absent(),
          Value<String?> phone = const Value.absent(),
          Value<String?> avatar = const Value.absent(),
          Value<DateTime?> createdAt = const Value.absent(),
          Value<DateTime?> updatedAt = const Value.absent()}) =>
      User(
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
  User copyWithCompanion(UsersCompanion data) {
    return User(
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
    return (StringBuffer('User(')
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
      (other is User &&
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

class UsersCompanion extends UpdateCompanion<User> {
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
  static Insertable<User> custom({
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

class $LocalChangesTable extends LocalChanges
    with TableInfo<$LocalChangesTable, LocalChange> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalChangesTable(this.attachedDatabase, [this._alias]);
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
      'entity_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
      'entity_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> entityRev = GeneratedColumn<String>(
      'entity_rev', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
      'deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("deleted" IN (0, 1))'));
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, dynamic>, String>
      data = GeneratedColumn<String>('data', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<Map<String, dynamic>>(
              $LocalChangesTable.$converterdata);
  @override
  late final GeneratedColumn<DateTime> createAt = GeneratedColumn<DateTime>(
      'create_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<bool> concluded = GeneratedColumn<bool>(
      'concluded', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("concluded" IN (0, 1))'));
  @override
  late final GeneratedColumn<DateTime> concludedMoment =
      GeneratedColumn<DateTime>('concluded_moment', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<String> error = GeneratedColumn<String>(
      'error', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<bool> dismissed = GeneratedColumn<bool>(
      'dismissed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("dismissed" IN (0, 1))'));
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
        dismissed
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_changes';
  @override
  Set<GeneratedColumn> get $primaryKey => {entityId, entityType};
  @override
  LocalChange map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalChange(
      entityType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_type'])!,
      entityId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_id'])!,
      entityRev: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_rev'])!,
      deleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}deleted'])!,
      data: $LocalChangesTable.$converterdata.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}data'])!),
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
    );
  }

  @override
  $LocalChangesTable createAlias(String alias) {
    return $LocalChangesTable(attachedDatabase, alias);
  }

  static TypeConverter<Map<String, dynamic>, String> $converterdata =
      const JsonMapConverter();
}

class LocalChange extends DataClass implements Insertable<LocalChange> {
  final String entityType;
  final String entityId;
  final String entityRev;
  final bool deleted;
  final Map<String, dynamic> data;
  final DateTime createAt;
  final bool concluded;
  final DateTime? concludedMoment;
  final String? error;
  final bool dismissed;
  const LocalChange(
      {required this.entityType,
      required this.entityId,
      required this.entityRev,
      required this.deleted,
      required this.data,
      required this.createAt,
      required this.concluded,
      this.concludedMoment,
      this.error,
      required this.dismissed});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['entity_type'] = Variable<String>(entityType);
    map['entity_id'] = Variable<String>(entityId);
    map['entity_rev'] = Variable<String>(entityRev);
    map['deleted'] = Variable<bool>(deleted);
    {
      map['data'] =
          Variable<String>($LocalChangesTable.$converterdata.toSql(data));
    }
    map['create_at'] = Variable<DateTime>(createAt);
    map['concluded'] = Variable<bool>(concluded);
    if (!nullToAbsent || concludedMoment != null) {
      map['concluded_moment'] = Variable<DateTime>(concludedMoment);
    }
    if (!nullToAbsent || error != null) {
      map['error'] = Variable<String>(error);
    }
    map['dismissed'] = Variable<bool>(dismissed);
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
    );
  }

  factory LocalChange.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalChange(
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<String>(json['entityId']),
      entityRev: serializer.fromJson<String>(json['entityRev']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      data: serializer.fromJson<Map<String, dynamic>>(json['data']),
      createAt: serializer.fromJson<DateTime>(json['createAt']),
      concluded: serializer.fromJson<bool>(json['concluded']),
      concludedMoment: serializer.fromJson<DateTime?>(json['concludedMoment']),
      error: serializer.fromJson<String?>(json['error']),
      dismissed: serializer.fromJson<bool>(json['dismissed']),
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
      'data': serializer.toJson<Map<String, dynamic>>(data),
      'createAt': serializer.toJson<DateTime>(createAt),
      'concluded': serializer.toJson<bool>(concluded),
      'concludedMoment': serializer.toJson<DateTime?>(concludedMoment),
      'error': serializer.toJson<String?>(error),
      'dismissed': serializer.toJson<bool>(dismissed),
    };
  }

  LocalChange copyWith(
          {String? entityType,
          String? entityId,
          String? entityRev,
          bool? deleted,
          Map<String, dynamic>? data,
          DateTime? createAt,
          bool? concluded,
          Value<DateTime?> concludedMoment = const Value.absent(),
          Value<String?> error = const Value.absent(),
          bool? dismissed}) =>
      LocalChange(
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
      );
  LocalChange copyWithCompanion(LocalChangesCompanion data) {
    return LocalChange(
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
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalChange(')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('entityRev: $entityRev, ')
          ..write('deleted: $deleted, ')
          ..write('data: $data, ')
          ..write('createAt: $createAt, ')
          ..write('concluded: $concluded, ')
          ..write('concludedMoment: $concludedMoment, ')
          ..write('error: $error, ')
          ..write('dismissed: $dismissed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(entityType, entityId, entityRev, deleted,
      data, createAt, concluded, concludedMoment, error, dismissed);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalChange &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.entityRev == this.entityRev &&
          other.deleted == this.deleted &&
          other.data == this.data &&
          other.createAt == this.createAt &&
          other.concluded == this.concluded &&
          other.concludedMoment == this.concludedMoment &&
          other.error == this.error &&
          other.dismissed == this.dismissed);
}

class LocalChangesCompanion extends UpdateCompanion<LocalChange> {
  final Value<String> entityType;
  final Value<String> entityId;
  final Value<String> entityRev;
  final Value<bool> deleted;
  final Value<Map<String, dynamic>> data;
  final Value<DateTime> createAt;
  final Value<bool> concluded;
  final Value<DateTime?> concludedMoment;
  final Value<String?> error;
  final Value<bool> dismissed;
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
    this.rowid = const Value.absent(),
  });
  LocalChangesCompanion.insert({
    required String entityType,
    required String entityId,
    required String entityRev,
    required bool deleted,
    required Map<String, dynamic> data,
    required DateTime createAt,
    required bool concluded,
    this.concludedMoment = const Value.absent(),
    this.error = const Value.absent(),
    required bool dismissed,
    this.rowid = const Value.absent(),
  })  : entityType = Value(entityType),
        entityId = Value(entityId),
        entityRev = Value(entityRev),
        deleted = Value(deleted),
        data = Value(data),
        createAt = Value(createAt),
        concluded = Value(concluded),
        dismissed = Value(dismissed);
  static Insertable<LocalChange> custom({
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
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalChangesCompanion copyWith(
      {Value<String>? entityType,
      Value<String>? entityId,
      Value<String>? entityRev,
      Value<bool>? deleted,
      Value<Map<String, dynamic>>? data,
      Value<DateTime>? createAt,
      Value<bool>? concluded,
      Value<DateTime?>? concludedMoment,
      Value<String?>? error,
      Value<bool>? dismissed,
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
      map['data'] =
          Variable<String>($LocalChangesTable.$converterdata.toSql(data.value));
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
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncMetadataTable extends SyncMetadata
    with TableInfo<$SyncMetadataTable, SyncMetadatas> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncMetadataTable(this.attachedDatabase, [this._alias]);
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
      'entity_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<DateTime> lastSyncedAt = GeneratedColumn<DateTime>(
      'last_synced_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [entityType, lastSyncedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_metadata';
  @override
  Set<GeneratedColumn> get $primaryKey => {entityType};
  @override
  SyncMetadatas map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncMetadatas(
      entityType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_type'])!,
      lastSyncedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_synced_at']),
    );
  }

  @override
  $SyncMetadataTable createAlias(String alias) {
    return $SyncMetadataTable(attachedDatabase, alias);
  }
}

class SyncMetadatas extends DataClass implements Insertable<SyncMetadatas> {
  final String entityType;
  final DateTime? lastSyncedAt;
  const SyncMetadatas({required this.entityType, this.lastSyncedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['entity_type'] = Variable<String>(entityType);
    if (!nullToAbsent || lastSyncedAt != null) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt);
    }
    return map;
  }

  SyncMetadataCompanion toCompanion(bool nullToAbsent) {
    return SyncMetadataCompanion(
      entityType: Value(entityType),
      lastSyncedAt: lastSyncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncedAt),
    );
  }

  factory SyncMetadatas.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncMetadatas(
      entityType: serializer.fromJson<String>(json['entityType']),
      lastSyncedAt: serializer.fromJson<DateTime?>(json['lastSyncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'entityType': serializer.toJson<String>(entityType),
      'lastSyncedAt': serializer.toJson<DateTime?>(lastSyncedAt),
    };
  }

  SyncMetadatas copyWith(
          {String? entityType,
          Value<DateTime?> lastSyncedAt = const Value.absent()}) =>
      SyncMetadatas(
        entityType: entityType ?? this.entityType,
        lastSyncedAt:
            lastSyncedAt.present ? lastSyncedAt.value : this.lastSyncedAt,
      );
  SyncMetadatas copyWithCompanion(SyncMetadataCompanion data) {
    return SyncMetadatas(
      entityType:
          data.entityType.present ? data.entityType.value : this.entityType,
      lastSyncedAt: data.lastSyncedAt.present
          ? data.lastSyncedAt.value
          : this.lastSyncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncMetadatas(')
          ..write('entityType: $entityType, ')
          ..write('lastSyncedAt: $lastSyncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(entityType, lastSyncedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncMetadatas &&
          other.entityType == this.entityType &&
          other.lastSyncedAt == this.lastSyncedAt);
}

class SyncMetadataCompanion extends UpdateCompanion<SyncMetadatas> {
  final Value<String> entityType;
  final Value<DateTime?> lastSyncedAt;
  final Value<int> rowid;
  const SyncMetadataCompanion({
    this.entityType = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncMetadataCompanion.insert({
    required String entityType,
    this.lastSyncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : entityType = Value(entityType);
  static Insertable<SyncMetadatas> custom({
    Expression<String>? entityType,
    Expression<DateTime>? lastSyncedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (entityType != null) 'entity_type': entityType,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncMetadataCompanion copyWith(
      {Value<String>? entityType,
      Value<DateTime?>? lastSyncedAt,
      Value<int>? rowid}) {
    return SyncMetadataCompanion(
      entityType: entityType ?? this.entityType,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
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
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CategorizablesTable extends Categorizables
    with TableInfo<$CategorizablesTable, Categorizable> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategorizablesTable(this.attachedDatabase, [this._alias]);
  @override
  late final GeneratedColumn<String> categorizableId = GeneratedColumn<String>(
      'categorizable_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<CategorizableType, String>
      categorizableType = GeneratedColumn<String>(
              'categorizable_type', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<CategorizableType>(
              $CategorizablesTable.$convertercategorizableType);
  @override
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
  Categorizable map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Categorizable(
      categorizableId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}categorizable_id'])!,
      categorizableType: $CategorizablesTable.$convertercategorizableType
          .fromSql(attachedDatabase.typeMapping.read(DriftSqlType.string,
              data['${effectivePrefix}categorizable_type'])!),
      categoryClientId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}category_client_id'])!,
    );
  }

  @override
  $CategorizablesTable createAlias(String alias) {
    return $CategorizablesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<CategorizableType, String, String>
      $convertercategorizableType =
      const EnumNameConverter<CategorizableType>(CategorizableType.values);
}

class Categorizable extends DataClass implements Insertable<Categorizable> {
  final String categorizableId;
  final CategorizableType categorizableType;
  final String categoryClientId;
  const Categorizable(
      {required this.categorizableId,
      required this.categorizableType,
      required this.categoryClientId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['categorizable_id'] = Variable<String>(categorizableId);
    {
      map['categorizable_type'] = Variable<String>($CategorizablesTable
          .$convertercategorizableType
          .toSql(categorizableType));
    }
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

  factory Categorizable.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Categorizable(
      categorizableId: serializer.fromJson<String>(json['categorizableId']),
      categorizableType: $CategorizablesTable.$convertercategorizableType
          .fromJson(serializer.fromJson<String>(json['categorizableType'])),
      categoryClientId: serializer.fromJson<String>(json['categoryClientId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'categorizableId': serializer.toJson<String>(categorizableId),
      'categorizableType': serializer.toJson<String>($CategorizablesTable
          .$convertercategorizableType
          .toJson(categorizableType)),
      'categoryClientId': serializer.toJson<String>(categoryClientId),
    };
  }

  Categorizable copyWith(
          {String? categorizableId,
          CategorizableType? categorizableType,
          String? categoryClientId}) =>
      Categorizable(
        categorizableId: categorizableId ?? this.categorizableId,
        categorizableType: categorizableType ?? this.categorizableType,
        categoryClientId: categoryClientId ?? this.categoryClientId,
      );
  Categorizable copyWithCompanion(CategorizablesCompanion data) {
    return Categorizable(
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
    return (StringBuffer('Categorizable(')
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
      (other is Categorizable &&
          other.categorizableId == this.categorizableId &&
          other.categorizableType == this.categorizableType &&
          other.categoryClientId == this.categoryClientId);
}

class CategorizablesCompanion extends UpdateCompanion<Categorizable> {
  final Value<String> categorizableId;
  final Value<CategorizableType> categorizableType;
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
    required CategorizableType categorizableType,
    required String categoryClientId,
    this.rowid = const Value.absent(),
  })  : categorizableId = Value(categorizableId),
        categorizableType = Value(categorizableType),
        categoryClientId = Value(categoryClientId);
  static Insertable<Categorizable> custom({
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
      Value<CategorizableType>? categorizableType,
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
      map['categorizable_type'] = Variable<String>($CategorizablesTable
          .$convertercategorizableType
          .toSql(categorizableType.value));
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

class $NotificationsTable extends Notifications
    with TableInfo<$NotificationsTable, Notification> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotificationsTable(this.attachedDatabase, [this._alias]);
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<String> clientId = GeneratedColumn<String>(
      'client_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(defaultClientId));
  @override
  late final GeneratedColumn<String> rev = GeneratedColumn<String>(
      'rev', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('1'));
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<DateTime> lastSyncedAt = GeneratedColumn<DateTime>(
      'last_synced_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  late final GeneratedColumnWithTypeConverter<NotificationType, String> type =
      GeneratedColumn<String>('type', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<NotificationType>($NotificationsTable.$convertertype);
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
      'body', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, dynamic>, String>
      data = GeneratedColumn<String>('data', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<Map<String, dynamic>>(
              $NotificationsTable.$converterdata);
  @override
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
  Notification map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Notification(
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
      type: $NotificationsTable.$convertertype.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!),
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      body: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}body'])!,
      data: $NotificationsTable.$converterdata.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}data'])!),
      readAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}read_at']),
    );
  }

  @override
  $NotificationsTable createAlias(String alias) {
    return $NotificationsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<NotificationType, String, String> $convertertype =
      const EnumNameConverter<NotificationType>(NotificationType.values);
  static TypeConverter<Map<String, dynamic>, String> $converterdata =
      const JsonMapConverter();
}

class Notification extends DataClass implements Insertable<Notification> {
  final int? id;
  final int? userId;
  final String clientId;
  final String? rev;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final DateTime? lastSyncedAt;
  final NotificationType type;
  final String title;
  final String body;
  final Map<String, dynamic> data;
  final DateTime? readAt;
  const Notification(
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
    {
      map['type'] =
          Variable<String>($NotificationsTable.$convertertype.toSql(type));
    }
    map['title'] = Variable<String>(title);
    map['body'] = Variable<String>(body);
    {
      map['data'] =
          Variable<String>($NotificationsTable.$converterdata.toSql(data));
    }
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

  factory Notification.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Notification(
      id: serializer.fromJson<int?>(json['id']),
      userId: serializer.fromJson<int?>(json['user_id']),
      clientId: serializer.fromJson<String>(json['client_generated_id']),
      rev: serializer.fromJson<String?>(json['rev']),
      createdAt: serializer.fromJson<DateTime>(json['created_at']),
      updatedAt: serializer.fromJson<DateTime>(json['updated_at']),
      deletedAt: serializer.fromJson<DateTime?>(json['deleted_at']),
      lastSyncedAt: serializer.fromJson<DateTime?>(json['last_synced_at']),
      type: $NotificationsTable.$convertertype
          .fromJson(serializer.fromJson<String>(json['type'])),
      title: serializer.fromJson<String>(json['title']),
      body: serializer.fromJson<String>(json['body']),
      data: serializer.fromJson<Map<String, dynamic>>(json['data']),
      readAt: serializer.fromJson<DateTime?>(json['read_at']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int?>(id),
      'user_id': serializer.toJson<int?>(userId),
      'client_generated_id': serializer.toJson<String>(clientId),
      'rev': serializer.toJson<String?>(rev),
      'created_at': serializer.toJson<DateTime>(createdAt),
      'updated_at': serializer.toJson<DateTime>(updatedAt),
      'deleted_at': serializer.toJson<DateTime?>(deletedAt),
      'last_synced_at': serializer.toJson<DateTime?>(lastSyncedAt),
      'type': serializer
          .toJson<String>($NotificationsTable.$convertertype.toJson(type)),
      'title': serializer.toJson<String>(title),
      'body': serializer.toJson<String>(body),
      'data': serializer.toJson<Map<String, dynamic>>(data),
      'read_at': serializer.toJson<DateTime?>(readAt),
    };
  }

  Notification copyWith(
          {Value<int?> id = const Value.absent(),
          Value<int?> userId = const Value.absent(),
          String? clientId,
          Value<String?> rev = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<DateTime?> deletedAt = const Value.absent(),
          Value<DateTime?> lastSyncedAt = const Value.absent(),
          NotificationType? type,
          String? title,
          String? body,
          Map<String, dynamic>? data,
          Value<DateTime?> readAt = const Value.absent()}) =>
      Notification(
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
  Notification copyWithCompanion(NotificationsCompanion data) {
    return Notification(
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
    return (StringBuffer('Notification(')
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
      (other is Notification &&
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

class NotificationsCompanion extends UpdateCompanion<Notification> {
  final Value<int?> id;
  final Value<int?> userId;
  final Value<String> clientId;
  final Value<String?> rev;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<DateTime?> lastSyncedAt;
  final Value<NotificationType> type;
  final Value<String> title;
  final Value<String> body;
  final Value<Map<String, dynamic>> data;
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
    required NotificationType type,
    required String title,
    required String body,
    required Map<String, dynamic> data,
    this.readAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : type = Value(type),
        title = Value(title),
        body = Value(body),
        data = Value(data);
  static Insertable<Notification> custom({
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
      Value<NotificationType>? type,
      Value<String>? title,
      Value<String>? body,
      Value<Map<String, dynamic>>? data,
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
      map['type'] = Variable<String>(
          $NotificationsTable.$convertertype.toSql(type.value));
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (data.present) {
      map['data'] = Variable<String>(
          $NotificationsTable.$converterdata.toSql(data.value));
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

class $MediaFilesTable extends MediaFiles
    with TableInfo<$MediaFilesTable, MediaFile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MediaFilesTable(this.attachedDatabase, [this._alias]);
  @override
  late final GeneratedColumn<String> path = GeneratedColumn<String>(
      'path', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<String> fileableType = GeneratedColumn<String>(
      'fileable_type', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<int> fileableId = GeneratedColumn<int>(
      'fileable_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<String> localFileableType =
      GeneratedColumn<String>('local_fileable_type', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<String> localFileableId = GeneratedColumn<String>(
      'local_fileable_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
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
  MediaFile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MediaFile(
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
  $MediaFilesTable createAlias(String alias) {
    return $MediaFilesTable(attachedDatabase, alias);
  }
}

class MediaFile extends DataClass implements Insertable<MediaFile> {
  /// Storage path (e.g. "transactions/19YH5k1aHr4z23UMLCOUs3FS7aCBFB0a7vzaB2k9.png").
  /// Primary key.
  final String path;

  /// Server-assigned id (optional).
  final int? id;

  /// Media type (e.g. "file").
  final String? type;

  /// Server polymorphic type (e.g. "App\\Models\\Transaction").
  final String? fileableType;

  /// Server polymorphic id (e.g. transaction id on server).
  final int? fileableId;

  /// Local polymorphic type (e.g. transaction client id or type).
  final String? localFileableType;

  /// Local polymorphic id (e.g. transaction client_id).
  final String? localFileableId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  const MediaFile(
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

  factory MediaFile.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MediaFile(
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

  MediaFile copyWith(
          {String? path,
          Value<int?> id = const Value.absent(),
          Value<String?> type = const Value.absent(),
          Value<String?> fileableType = const Value.absent(),
          Value<int?> fileableId = const Value.absent(),
          Value<String?> localFileableType = const Value.absent(),
          Value<String?> localFileableId = const Value.absent(),
          Value<DateTime?> createdAt = const Value.absent(),
          Value<DateTime?> updatedAt = const Value.absent()}) =>
      MediaFile(
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
  MediaFile copyWithCompanion(MediaFilesCompanion data) {
    return MediaFile(
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
    return (StringBuffer('MediaFile(')
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
      (other is MediaFile &&
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

class MediaFilesCompanion extends UpdateCompanion<MediaFile> {
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
  static Insertable<MediaFile> custom({
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

class $TransfersTable extends Transfers
    with TableInfo<$TransfersTable, Transfer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransfersTable(this.attachedDatabase, [this._alias]);
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<String> clientId = GeneratedColumn<String>(
      'client_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(defaultClientId));
  @override
  late final GeneratedColumn<String> rev = GeneratedColumn<String>(
      'rev', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('1'));
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<DateTime> lastSyncedAt = GeneratedColumn<DateTime>(
      'last_synced_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<int> fromWalletId = GeneratedColumn<int>(
      'from_wallet_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<int> toWalletId = GeneratedColumn<int>(
      'to_wallet_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<String> fromWalletClientId =
      GeneratedColumn<String>('from_wallet_client_id', aliasedName, true,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintIsAlways(
              'REFERENCES wallets (client_id)'));
  @override
  late final GeneratedColumn<String> toWalletClientId = GeneratedColumn<String>(
      'to_wallet_client_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES wallets (client_id)'));
  @override
  late final GeneratedColumn<double> exchangeRate = GeneratedColumn<double>(
      'exchange_rate', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<DateTime> datetime = GeneratedColumn<DateTime>(
      'datetime', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> expenseTransactionClientId =
      GeneratedColumn<String>(
          'expense_transaction_client_id', aliasedName, true,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintIsAlways(
              'REFERENCES transactions (client_id)'));
  @override
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
  Transfer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Transfer(
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
  $TransfersTable createAlias(String alias) {
    return $TransfersTable(attachedDatabase, alias);
  }
}

class Transfer extends DataClass implements Insertable<Transfer> {
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
  const Transfer(
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

  factory Transfer.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Transfer(
      id: serializer.fromJson<int?>(json['id']),
      userId: serializer.fromJson<int?>(json['user_id']),
      clientId: serializer.fromJson<String>(json['client_generated_id']),
      rev: serializer.fromJson<String?>(json['rev']),
      createdAt: serializer.fromJson<DateTime>(json['created_at']),
      updatedAt: serializer.fromJson<DateTime>(json['updated_at']),
      deletedAt: serializer.fromJson<DateTime?>(json['deleted_at']),
      lastSyncedAt: serializer.fromJson<DateTime?>(json['last_synced_at']),
      amount: serializer.fromJson<double>(json['amount']),
      fromWalletId: serializer.fromJson<int?>(json['from_wallet_id']),
      toWalletId: serializer.fromJson<int?>(json['to_wallet_id']),
      fromWalletClientId:
          serializer.fromJson<String?>(json['from_wallet_client_id']),
      toWalletClientId:
          serializer.fromJson<String?>(json['to_wallet_client_id']),
      exchangeRate: serializer.fromJson<double?>(json['exchange_rate']),
      datetime: serializer.fromJson<DateTime>(json['datetime']),
      expenseTransactionClientId:
          serializer.fromJson<String?>(json['expense_transaction_client_id']),
      incomeTransactionClientId:
          serializer.fromJson<String?>(json['income_transaction_client_id']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int?>(id),
      'user_id': serializer.toJson<int?>(userId),
      'client_generated_id': serializer.toJson<String>(clientId),
      'rev': serializer.toJson<String?>(rev),
      'created_at': serializer.toJson<DateTime>(createdAt),
      'updated_at': serializer.toJson<DateTime>(updatedAt),
      'deleted_at': serializer.toJson<DateTime?>(deletedAt),
      'last_synced_at': serializer.toJson<DateTime?>(lastSyncedAt),
      'amount': serializer.toJson<double>(amount),
      'from_wallet_id': serializer.toJson<int?>(fromWalletId),
      'to_wallet_id': serializer.toJson<int?>(toWalletId),
      'from_wallet_client_id': serializer.toJson<String?>(fromWalletClientId),
      'to_wallet_client_id': serializer.toJson<String?>(toWalletClientId),
      'exchange_rate': serializer.toJson<double?>(exchangeRate),
      'datetime': serializer.toJson<DateTime>(datetime),
      'expense_transaction_client_id':
          serializer.toJson<String?>(expenseTransactionClientId),
      'income_transaction_client_id':
          serializer.toJson<String?>(incomeTransactionClientId),
    };
  }

  Transfer copyWith(
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
      Transfer(
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
  Transfer copyWithCompanion(TransfersCompanion data) {
    return Transfer(
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
    return (StringBuffer('Transfer(')
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
      (other is Transfer &&
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

class TransfersCompanion extends UpdateCompanion<Transfer> {
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
  static Insertable<Transfer> custom({
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

class $BudgetsTable extends Budgets with TableInfo<$BudgetsTable, Budget> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BudgetsTable(this.attachedDatabase, [this._alias]);
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<String> clientId = GeneratedColumn<String>(
      'client_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(defaultClientId));
  @override
  late final GeneratedColumn<String> rev = GeneratedColumn<String>(
      'rev', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('1'));
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<DateTime> lastSyncedAt = GeneratedColumn<DateTime>(
      'last_synced_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> slug = GeneratedColumn<String>(
      'slug', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
      'currency', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<BudgetPeriodType, String>
      periodType = GeneratedColumn<String>('period_type', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<BudgetPeriodType>($BudgetsTable.$converterperiodType);
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
      'start_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
      'end_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<bool> rolloverEnabled = GeneratedColumn<bool>(
      'rollover_enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("rollover_enabled" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  late final GeneratedColumn<int> thresholdPercent = GeneratedColumn<int>(
      'threshold_percent', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(80));
  @override
  late final GeneratedColumn<bool> forecastAlertsEnabled =
      GeneratedColumn<bool>('forecast_alerts_enabled', aliasedName, false,
          type: DriftSqlType.bool,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintIsAlways(
              'CHECK ("forecast_alerts_enabled" IN (0, 1))'),
          defaultValue: const Constant(false));
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  late final GeneratedColumn<String> ownerType = GeneratedColumn<String>(
      'owner_type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('user'));
  @override
  late final GeneratedColumn<int> ownerId = GeneratedColumn<int>(
      'owner_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
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
        ownerId
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'budgets';
  @override
  Set<GeneratedColumn> get $primaryKey => {clientId};
  @override
  Budget map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Budget(
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
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      currency: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}currency'])!,
      periodType: $BudgetsTable.$converterperiodType.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}period_type'])!),
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
    );
  }

  @override
  $BudgetsTable createAlias(String alias) {
    return $BudgetsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<BudgetPeriodType, String, String>
      $converterperiodType =
      const EnumNameConverter<BudgetPeriodType>(BudgetPeriodType.values);
}

class Budget extends DataClass implements Insertable<Budget> {
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
  final double amount;
  final String currency;
  final BudgetPeriodType periodType;
  final DateTime startDate;
  final DateTime? endDate;
  final bool rolloverEnabled;
  final int thresholdPercent;
  final bool forecastAlertsEnabled;
  final bool isActive;
  final String ownerType;
  final int? ownerId;
  const Budget(
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
      this.ownerId});
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
    map['amount'] = Variable<double>(amount);
    map['currency'] = Variable<String>(currency);
    {
      map['period_type'] = Variable<String>(
          $BudgetsTable.$converterperiodType.toSql(periodType));
    }
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
    );
  }

  factory Budget.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Budget(
      id: serializer.fromJson<int?>(json['id']),
      userId: serializer.fromJson<int?>(json['user_id']),
      clientId: serializer.fromJson<String>(json['client_generated_id']),
      rev: serializer.fromJson<String?>(json['rev']),
      createdAt: serializer.fromJson<DateTime>(json['created_at']),
      updatedAt: serializer.fromJson<DateTime>(json['updated_at']),
      deletedAt: serializer.fromJson<DateTime?>(json['deleted_at']),
      lastSyncedAt: serializer.fromJson<DateTime?>(json['last_synced_at']),
      name: serializer.fromJson<String>(json['name']),
      slug: serializer.fromJson<String>(json['slug']),
      description: serializer.fromJson<String?>(json['description']),
      amount: serializer.fromJson<double>(json['amount']),
      currency: serializer.fromJson<String>(json['currency']),
      periodType: $BudgetsTable.$converterperiodType
          .fromJson(serializer.fromJson<String>(json['periodType'])),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime?>(json['endDate']),
      rolloverEnabled: serializer.fromJson<bool>(json['rolloverEnabled']),
      thresholdPercent: serializer.fromJson<int>(json['thresholdPercent']),
      forecastAlertsEnabled:
          serializer.fromJson<bool>(json['forecastAlertsEnabled']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      ownerType: serializer.fromJson<String>(json['ownerType']),
      ownerId: serializer.fromJson<int?>(json['ownerId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int?>(id),
      'user_id': serializer.toJson<int?>(userId),
      'client_generated_id': serializer.toJson<String>(clientId),
      'rev': serializer.toJson<String?>(rev),
      'created_at': serializer.toJson<DateTime>(createdAt),
      'updated_at': serializer.toJson<DateTime>(updatedAt),
      'deleted_at': serializer.toJson<DateTime?>(deletedAt),
      'last_synced_at': serializer.toJson<DateTime?>(lastSyncedAt),
      'name': serializer.toJson<String>(name),
      'slug': serializer.toJson<String>(slug),
      'description': serializer.toJson<String?>(description),
      'amount': serializer.toJson<double>(amount),
      'currency': serializer.toJson<String>(currency),
      'periodType': serializer.toJson<String>(
          $BudgetsTable.$converterperiodType.toJson(periodType)),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime?>(endDate),
      'rolloverEnabled': serializer.toJson<bool>(rolloverEnabled),
      'thresholdPercent': serializer.toJson<int>(thresholdPercent),
      'forecastAlertsEnabled': serializer.toJson<bool>(forecastAlertsEnabled),
      'isActive': serializer.toJson<bool>(isActive),
      'ownerType': serializer.toJson<String>(ownerType),
      'ownerId': serializer.toJson<int?>(ownerId),
    };
  }

  Budget copyWith(
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
          double? amount,
          String? currency,
          BudgetPeriodType? periodType,
          DateTime? startDate,
          Value<DateTime?> endDate = const Value.absent(),
          bool? rolloverEnabled,
          int? thresholdPercent,
          bool? forecastAlertsEnabled,
          bool? isActive,
          String? ownerType,
          Value<int?> ownerId = const Value.absent()}) =>
      Budget(
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
      );
  Budget copyWithCompanion(BudgetsCompanion data) {
    return Budget(
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
    );
  }

  @override
  String toString() {
    return (StringBuffer('Budget(')
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
          ..write('ownerId: $ownerId')
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
        ownerId
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Budget &&
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
          other.ownerId == this.ownerId);
}

class BudgetsCompanion extends UpdateCompanion<Budget> {
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
  final Value<double> amount;
  final Value<String> currency;
  final Value<BudgetPeriodType> periodType;
  final Value<DateTime> startDate;
  final Value<DateTime?> endDate;
  final Value<bool> rolloverEnabled;
  final Value<int> thresholdPercent;
  final Value<bool> forecastAlertsEnabled;
  final Value<bool> isActive;
  final Value<String> ownerType;
  final Value<int?> ownerId;
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
    required double amount,
    required String currency,
    required BudgetPeriodType periodType,
    required DateTime startDate,
    this.endDate = const Value.absent(),
    this.rolloverEnabled = const Value.absent(),
    this.thresholdPercent = const Value.absent(),
    this.forecastAlertsEnabled = const Value.absent(),
    this.isActive = const Value.absent(),
    this.ownerType = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : name = Value(name),
        slug = Value(slug),
        amount = Value(amount),
        currency = Value(currency),
        periodType = Value(periodType),
        startDate = Value(startDate);
  static Insertable<Budget> custom({
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
    Expression<double>? amount,
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
      Value<double>? amount,
      Value<String>? currency,
      Value<BudgetPeriodType>? periodType,
      Value<DateTime>? startDate,
      Value<DateTime?>? endDate,
      Value<bool>? rolloverEnabled,
      Value<int>? thresholdPercent,
      Value<bool>? forecastAlertsEnabled,
      Value<bool>? isActive,
      Value<String>? ownerType,
      Value<int?>? ownerId,
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
      map['amount'] = Variable<double>(amount.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (periodType.present) {
      map['period_type'] = Variable<String>(
          $BudgetsTable.$converterperiodType.toSql(periodType.value));
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
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BudgetablesTable extends Budgetables
    with TableInfo<$BudgetablesTable, Budgetable> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BudgetablesTable(this.attachedDatabase, [this._alias]);
  @override
  late final GeneratedColumn<String> budgetClientId = GeneratedColumn<String>(
      'budget_client_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES budgets (client_id)'));
  @override
  late final GeneratedColumnWithTypeConverter<BudgetTargetType, String>
      targetType = GeneratedColumn<String>('target_type', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<BudgetTargetType>(
              $BudgetablesTable.$convertertargetType);
  @override
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
  static const String $name = 'budgetables';
  @override
  Set<GeneratedColumn> get $primaryKey =>
      {budgetClientId, targetType, targetClientId};
  @override
  Budgetable map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Budgetable(
      budgetClientId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}budget_client_id'])!,
      targetType: $BudgetablesTable.$convertertargetType.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.string, data['${effectivePrefix}target_type'])!),
      targetClientId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}target_client_id'])!,
    );
  }

  @override
  $BudgetablesTable createAlias(String alias) {
    return $BudgetablesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<BudgetTargetType, String, String>
      $convertertargetType =
      const EnumNameConverter<BudgetTargetType>(BudgetTargetType.values);
}

class Budgetable extends DataClass implements Insertable<Budgetable> {
  final String budgetClientId;
  final BudgetTargetType targetType;
  final String targetClientId;
  const Budgetable(
      {required this.budgetClientId,
      required this.targetType,
      required this.targetClientId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['budget_client_id'] = Variable<String>(budgetClientId);
    {
      map['target_type'] = Variable<String>(
          $BudgetablesTable.$convertertargetType.toSql(targetType));
    }
    map['target_client_id'] = Variable<String>(targetClientId);
    return map;
  }

  BudgetablesCompanion toCompanion(bool nullToAbsent) {
    return BudgetablesCompanion(
      budgetClientId: Value(budgetClientId),
      targetType: Value(targetType),
      targetClientId: Value(targetClientId),
    );
  }

  factory Budgetable.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Budgetable(
      budgetClientId: serializer.fromJson<String>(json['budgetClientId']),
      targetType: $BudgetablesTable.$convertertargetType
          .fromJson(serializer.fromJson<String>(json['targetType'])),
      targetClientId: serializer.fromJson<String>(json['targetClientId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'budgetClientId': serializer.toJson<String>(budgetClientId),
      'targetType': serializer.toJson<String>(
          $BudgetablesTable.$convertertargetType.toJson(targetType)),
      'targetClientId': serializer.toJson<String>(targetClientId),
    };
  }

  Budgetable copyWith(
          {String? budgetClientId,
          BudgetTargetType? targetType,
          String? targetClientId}) =>
      Budgetable(
        budgetClientId: budgetClientId ?? this.budgetClientId,
        targetType: targetType ?? this.targetType,
        targetClientId: targetClientId ?? this.targetClientId,
      );
  Budgetable copyWithCompanion(BudgetablesCompanion data) {
    return Budgetable(
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
    return (StringBuffer('Budgetable(')
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
      (other is Budgetable &&
          other.budgetClientId == this.budgetClientId &&
          other.targetType == this.targetType &&
          other.targetClientId == this.targetClientId);
}

class BudgetablesCompanion extends UpdateCompanion<Budgetable> {
  final Value<String> budgetClientId;
  final Value<BudgetTargetType> targetType;
  final Value<String> targetClientId;
  final Value<int> rowid;
  const BudgetablesCompanion({
    this.budgetClientId = const Value.absent(),
    this.targetType = const Value.absent(),
    this.targetClientId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BudgetablesCompanion.insert({
    required String budgetClientId,
    required BudgetTargetType targetType,
    required String targetClientId,
    this.rowid = const Value.absent(),
  })  : budgetClientId = Value(budgetClientId),
        targetType = Value(targetType),
        targetClientId = Value(targetClientId);
  static Insertable<Budgetable> custom({
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

  BudgetablesCompanion copyWith(
      {Value<String>? budgetClientId,
      Value<BudgetTargetType>? targetType,
      Value<String>? targetClientId,
      Value<int>? rowid}) {
    return BudgetablesCompanion(
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
      map['target_type'] = Variable<String>(
          $BudgetablesTable.$convertertargetType.toSql(targetType.value));
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
    return (StringBuffer('BudgetablesCompanion(')
          ..write('budgetClientId: $budgetClientId, ')
          ..write('targetType: $targetType, ')
          ..write('targetClientId: $targetClientId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BudgetPeriodStatesTable extends BudgetPeriodStates
    with TableInfo<$BudgetPeriodStatesTable, BudgetPeriodState> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BudgetPeriodStatesTable(this.attachedDatabase, [this._alias]);
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<String> clientId = GeneratedColumn<String>(
      'client_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(defaultClientId));
  @override
  late final GeneratedColumn<String> rev = GeneratedColumn<String>(
      'rev', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('1'));
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<DateTime> lastSyncedAt = GeneratedColumn<DateTime>(
      'last_synced_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<String> budgetClientId = GeneratedColumn<String>(
      'budget_client_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES budgets (client_id)'));
  @override
  late final GeneratedColumn<DateTime> periodStart = GeneratedColumn<DateTime>(
      'period_start', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<DateTime> periodEnd = GeneratedColumn<DateTime>(
      'period_end', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<double> netSpent = GeneratedColumn<double>(
      'net_spent', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  @override
  late final GeneratedColumn<double> rolloverIn = GeneratedColumn<double>(
      'rollover_in', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  @override
  late final GeneratedColumn<double> rolloverOut = GeneratedColumn<double>(
      'rollover_out', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  @override
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
  BudgetPeriodState map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BudgetPeriodState(
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
  $BudgetPeriodStatesTable createAlias(String alias) {
    return $BudgetPeriodStatesTable(attachedDatabase, alias);
  }
}

class BudgetPeriodState extends DataClass
    implements Insertable<BudgetPeriodState> {
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
  const BudgetPeriodState(
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

  factory BudgetPeriodState.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BudgetPeriodState(
      id: serializer.fromJson<int?>(json['id']),
      userId: serializer.fromJson<int?>(json['user_id']),
      clientId: serializer.fromJson<String>(json['client_generated_id']),
      rev: serializer.fromJson<String?>(json['rev']),
      createdAt: serializer.fromJson<DateTime>(json['created_at']),
      updatedAt: serializer.fromJson<DateTime>(json['updated_at']),
      deletedAt: serializer.fromJson<DateTime?>(json['deleted_at']),
      lastSyncedAt: serializer.fromJson<DateTime?>(json['last_synced_at']),
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
      'user_id': serializer.toJson<int?>(userId),
      'client_generated_id': serializer.toJson<String>(clientId),
      'rev': serializer.toJson<String?>(rev),
      'created_at': serializer.toJson<DateTime>(createdAt),
      'updated_at': serializer.toJson<DateTime>(updatedAt),
      'deleted_at': serializer.toJson<DateTime?>(deletedAt),
      'last_synced_at': serializer.toJson<DateTime?>(lastSyncedAt),
      'budgetClientId': serializer.toJson<String>(budgetClientId),
      'periodStart': serializer.toJson<DateTime>(periodStart),
      'periodEnd': serializer.toJson<DateTime>(periodEnd),
      'netSpent': serializer.toJson<double>(netSpent),
      'rolloverIn': serializer.toJson<double>(rolloverIn),
      'rolloverOut': serializer.toJson<double>(rolloverOut),
      'closedAt': serializer.toJson<DateTime?>(closedAt),
    };
  }

  BudgetPeriodState copyWith(
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
      BudgetPeriodState(
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
  BudgetPeriodState copyWithCompanion(BudgetPeriodStatesCompanion data) {
    return BudgetPeriodState(
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
    return (StringBuffer('BudgetPeriodState(')
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
      (other is BudgetPeriodState &&
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

class BudgetPeriodStatesCompanion extends UpdateCompanion<BudgetPeriodState> {
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
  static Insertable<BudgetPeriodState> custom({
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

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $WalletsTable wallets = $WalletsTable(this);
  late final $PartiesTable parties = $PartiesTable(this);
  late final $GroupsTable groups = $GroupsTable(this);
  late final $TransactionsTable transactions = $TransactionsTable(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $ConfigsTable configs = $ConfigsTable(this);
  late final $UsersTable users = $UsersTable(this);
  late final $LocalChangesTable localChanges = $LocalChangesTable(this);
  late final $SyncMetadataTable syncMetadata = $SyncMetadataTable(this);
  late final $CategorizablesTable categorizables = $CategorizablesTable(this);
  late final $NotificationsTable notifications = $NotificationsTable(this);
  late final $MediaFilesTable mediaFiles = $MediaFilesTable(this);
  late final $TransfersTable transfers = $TransfersTable(this);
  late final $BudgetsTable budgets = $BudgetsTable(this);
  late final $BudgetablesTable budgetables = $BudgetablesTable(this);
  late final $BudgetPeriodStatesTable budgetPeriodStates =
      $BudgetPeriodStatesTable(this);
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
        budgetables,
        budgetPeriodStates
      ];
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}

typedef $$WalletsTableCreateCompanionBuilder = WalletsCompanion Function({
  Value<int?> id,
  Value<int?> userId,
  Value<String> clientId,
  Value<String?> rev,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<DateTime?> lastSyncedAt,
  required String name,
  required WalletType type,
  Value<double> balance,
  required String currency,
  Value<String?> description,
  Value<WalletStats?> stats,
  Value<Media?> icon,
  Value<int> rowid,
});
typedef $$WalletsTableUpdateCompanionBuilder = WalletsCompanion Function({
  Value<int?> id,
  Value<int?> userId,
  Value<String> clientId,
  Value<String?> rev,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<DateTime?> lastSyncedAt,
  Value<String> name,
  Value<WalletType> type,
  Value<double> balance,
  Value<String> currency,
  Value<String?> description,
  Value<WalletStats?> stats,
  Value<Media?> icon,
  Value<int> rowid,
});

final class $$WalletsTableReferences
    extends BaseReferences<_$AppDatabase, $WalletsTable, Wallet> {
  $$WalletsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TransactionsTable, List<Transaction>>
      _transactionsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.transactions,
              aliasName: $_aliasNameGenerator(
                  db.wallets.clientId, db.transactions.walletClientId));

  $$TransactionsTableProcessedTableManager get transactionsRefs {
    final manager = $$TransactionsTableTableManager($_db, $_db.transactions)
        .filter((f) => f.walletClientId.clientId
            .sqlEquals($_itemColumn<String>('client_id')!));

    final cache = $_typedResult.readTableOrNull(_transactionsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$WalletsTableFilterComposer
    extends Composer<_$AppDatabase, $WalletsTable> {
  $$WalletsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get clientId => $composableBuilder(
      column: $table.clientId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get rev => $composableBuilder(
      column: $table.rev, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastSyncedAt => $composableBuilder(
      column: $table.lastSyncedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<WalletType, WalletType, String> get type =>
      $composableBuilder(
          column: $table.type,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<double> get balance => $composableBuilder(
      column: $table.balance, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<WalletStats?, WalletStats, String> get stats =>
      $composableBuilder(
          column: $table.stats,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<Media?, Media, String> get icon =>
      $composableBuilder(
          column: $table.icon,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  Expression<bool> transactionsRefs(
      Expression<bool> Function($$TransactionsTableFilterComposer f) f) {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.clientId,
        referencedTable: $db.transactions,
        getReferencedColumn: (t) => t.walletClientId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionsTableFilterComposer(
              $db: $db,
              $table: $db.transactions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$WalletsTableOrderingComposer
    extends Composer<_$AppDatabase, $WalletsTable> {
  $$WalletsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get clientId => $composableBuilder(
      column: $table.clientId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get rev => $composableBuilder(
      column: $table.rev, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastSyncedAt => $composableBuilder(
      column: $table.lastSyncedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get balance => $composableBuilder(
      column: $table.balance, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get stats => $composableBuilder(
      column: $table.stats, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get icon => $composableBuilder(
      column: $table.icon, builder: (column) => ColumnOrderings(column));
}

class $$WalletsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WalletsTable> {
  $$WalletsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get clientId =>
      $composableBuilder(column: $table.clientId, builder: (column) => column);

  GeneratedColumn<String> get rev =>
      $composableBuilder(column: $table.rev, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSyncedAt => $composableBuilder(
      column: $table.lastSyncedAt, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<WalletType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<double> get balance =>
      $composableBuilder(column: $table.balance, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumnWithTypeConverter<WalletStats?, String> get stats =>
      $composableBuilder(column: $table.stats, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Media?, String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  Expression<T> transactionsRefs<T extends Object>(
      Expression<T> Function($$TransactionsTableAnnotationComposer a) f) {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.clientId,
        referencedTable: $db.transactions,
        getReferencedColumn: (t) => t.walletClientId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionsTableAnnotationComposer(
              $db: $db,
              $table: $db.transactions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$WalletsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $WalletsTable,
    Wallet,
    $$WalletsTableFilterComposer,
    $$WalletsTableOrderingComposer,
    $$WalletsTableAnnotationComposer,
    $$WalletsTableCreateCompanionBuilder,
    $$WalletsTableUpdateCompanionBuilder,
    (Wallet, $$WalletsTableReferences),
    Wallet,
    PrefetchHooks Function({bool transactionsRefs})> {
  $$WalletsTableTableManager(_$AppDatabase db, $WalletsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WalletsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WalletsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WalletsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int?> id = const Value.absent(),
            Value<int?> userId = const Value.absent(),
            Value<String> clientId = const Value.absent(),
            Value<String?> rev = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<DateTime?> lastSyncedAt = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<WalletType> type = const Value.absent(),
            Value<double> balance = const Value.absent(),
            Value<String> currency = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<WalletStats?> stats = const Value.absent(),
            Value<Media?> icon = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              WalletsCompanion(
            id: id,
            userId: userId,
            clientId: clientId,
            rev: rev,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            lastSyncedAt: lastSyncedAt,
            name: name,
            type: type,
            balance: balance,
            currency: currency,
            description: description,
            stats: stats,
            icon: icon,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<int?> id = const Value.absent(),
            Value<int?> userId = const Value.absent(),
            Value<String> clientId = const Value.absent(),
            Value<String?> rev = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<DateTime?> lastSyncedAt = const Value.absent(),
            required String name,
            required WalletType type,
            Value<double> balance = const Value.absent(),
            required String currency,
            Value<String?> description = const Value.absent(),
            Value<WalletStats?> stats = const Value.absent(),
            Value<Media?> icon = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              WalletsCompanion.insert(
            id: id,
            userId: userId,
            clientId: clientId,
            rev: rev,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            lastSyncedAt: lastSyncedAt,
            name: name,
            type: type,
            balance: balance,
            currency: currency,
            description: description,
            stats: stats,
            icon: icon,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$WalletsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({transactionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (transactionsRefs) db.transactions],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (transactionsRefs)
                    await $_getPrefetchedData<Wallet, $WalletsTable,
                            Transaction>(
                        currentTable: table,
                        referencedTable:
                            $$WalletsTableReferences._transactionsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$WalletsTableReferences(db, table, p0)
                                .transactionsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems.where(
                                (e) => e.walletClientId == item.clientId),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$WalletsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $WalletsTable,
    Wallet,
    $$WalletsTableFilterComposer,
    $$WalletsTableOrderingComposer,
    $$WalletsTableAnnotationComposer,
    $$WalletsTableCreateCompanionBuilder,
    $$WalletsTableUpdateCompanionBuilder,
    (Wallet, $$WalletsTableReferences),
    Wallet,
    PrefetchHooks Function({bool transactionsRefs})>;
typedef $$PartiesTableCreateCompanionBuilder = PartiesCompanion Function({
  Value<int?> id,
  Value<int?> userId,
  Value<String> clientId,
  Value<String?> rev,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<DateTime?> lastSyncedAt,
  required String name,
  Value<String?> description,
  Value<Media?> icon,
  Value<PartyType?> type,
  Value<int> rowid,
});
typedef $$PartiesTableUpdateCompanionBuilder = PartiesCompanion Function({
  Value<int?> id,
  Value<int?> userId,
  Value<String> clientId,
  Value<String?> rev,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<DateTime?> lastSyncedAt,
  Value<String> name,
  Value<String?> description,
  Value<Media?> icon,
  Value<PartyType?> type,
  Value<int> rowid,
});

final class $$PartiesTableReferences
    extends BaseReferences<_$AppDatabase, $PartiesTable, Party> {
  $$PartiesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TransactionsTable, List<Transaction>>
      _transactionsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.transactions,
              aliasName: $_aliasNameGenerator(
                  db.parties.clientId, db.transactions.partyClientId));

  $$TransactionsTableProcessedTableManager get transactionsRefs {
    final manager = $$TransactionsTableTableManager($_db, $_db.transactions)
        .filter((f) => f.partyClientId.clientId
            .sqlEquals($_itemColumn<String>('client_id')!));

    final cache = $_typedResult.readTableOrNull(_transactionsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$PartiesTableFilterComposer
    extends Composer<_$AppDatabase, $PartiesTable> {
  $$PartiesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get clientId => $composableBuilder(
      column: $table.clientId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get rev => $composableBuilder(
      column: $table.rev, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastSyncedAt => $composableBuilder(
      column: $table.lastSyncedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<Media?, Media, String> get icon =>
      $composableBuilder(
          column: $table.icon,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<PartyType?, PartyType, String> get type =>
      $composableBuilder(
          column: $table.type,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  Expression<bool> transactionsRefs(
      Expression<bool> Function($$TransactionsTableFilterComposer f) f) {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.clientId,
        referencedTable: $db.transactions,
        getReferencedColumn: (t) => t.partyClientId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionsTableFilterComposer(
              $db: $db,
              $table: $db.transactions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$PartiesTableOrderingComposer
    extends Composer<_$AppDatabase, $PartiesTable> {
  $$PartiesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get clientId => $composableBuilder(
      column: $table.clientId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get rev => $composableBuilder(
      column: $table.rev, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastSyncedAt => $composableBuilder(
      column: $table.lastSyncedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get icon => $composableBuilder(
      column: $table.icon, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));
}

class $$PartiesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PartiesTable> {
  $$PartiesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get clientId =>
      $composableBuilder(column: $table.clientId, builder: (column) => column);

  GeneratedColumn<String> get rev =>
      $composableBuilder(column: $table.rev, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSyncedAt => $composableBuilder(
      column: $table.lastSyncedAt, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Media?, String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumnWithTypeConverter<PartyType?, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  Expression<T> transactionsRefs<T extends Object>(
      Expression<T> Function($$TransactionsTableAnnotationComposer a) f) {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.clientId,
        referencedTable: $db.transactions,
        getReferencedColumn: (t) => t.partyClientId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionsTableAnnotationComposer(
              $db: $db,
              $table: $db.transactions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$PartiesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PartiesTable,
    Party,
    $$PartiesTableFilterComposer,
    $$PartiesTableOrderingComposer,
    $$PartiesTableAnnotationComposer,
    $$PartiesTableCreateCompanionBuilder,
    $$PartiesTableUpdateCompanionBuilder,
    (Party, $$PartiesTableReferences),
    Party,
    PrefetchHooks Function({bool transactionsRefs})> {
  $$PartiesTableTableManager(_$AppDatabase db, $PartiesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PartiesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PartiesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PartiesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int?> id = const Value.absent(),
            Value<int?> userId = const Value.absent(),
            Value<String> clientId = const Value.absent(),
            Value<String?> rev = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<DateTime?> lastSyncedAt = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<Media?> icon = const Value.absent(),
            Value<PartyType?> type = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PartiesCompanion(
            id: id,
            userId: userId,
            clientId: clientId,
            rev: rev,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            lastSyncedAt: lastSyncedAt,
            name: name,
            description: description,
            icon: icon,
            type: type,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<int?> id = const Value.absent(),
            Value<int?> userId = const Value.absent(),
            Value<String> clientId = const Value.absent(),
            Value<String?> rev = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<DateTime?> lastSyncedAt = const Value.absent(),
            required String name,
            Value<String?> description = const Value.absent(),
            Value<Media?> icon = const Value.absent(),
            Value<PartyType?> type = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PartiesCompanion.insert(
            id: id,
            userId: userId,
            clientId: clientId,
            rev: rev,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            lastSyncedAt: lastSyncedAt,
            name: name,
            description: description,
            icon: icon,
            type: type,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$PartiesTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({transactionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (transactionsRefs) db.transactions],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (transactionsRefs)
                    await $_getPrefetchedData<Party, $PartiesTable,
                            Transaction>(
                        currentTable: table,
                        referencedTable:
                            $$PartiesTableReferences._transactionsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$PartiesTableReferences(db, table, p0)
                                .transactionsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.partyClientId == item.clientId),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$PartiesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PartiesTable,
    Party,
    $$PartiesTableFilterComposer,
    $$PartiesTableOrderingComposer,
    $$PartiesTableAnnotationComposer,
    $$PartiesTableCreateCompanionBuilder,
    $$PartiesTableUpdateCompanionBuilder,
    (Party, $$PartiesTableReferences),
    Party,
    PrefetchHooks Function({bool transactionsRefs})>;
typedef $$GroupsTableCreateCompanionBuilder = GroupsCompanion Function({
  Value<int?> id,
  Value<int?> userId,
  Value<String> clientId,
  Value<String?> rev,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<DateTime?> lastSyncedAt,
  required String name,
  Value<String?> description,
  Value<Media?> icon,
  Value<int> rowid,
});
typedef $$GroupsTableUpdateCompanionBuilder = GroupsCompanion Function({
  Value<int?> id,
  Value<int?> userId,
  Value<String> clientId,
  Value<String?> rev,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<DateTime?> lastSyncedAt,
  Value<String> name,
  Value<String?> description,
  Value<Media?> icon,
  Value<int> rowid,
});

final class $$GroupsTableReferences
    extends BaseReferences<_$AppDatabase, $GroupsTable, Group> {
  $$GroupsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TransactionsTable, List<Transaction>>
      _transactionsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.transactions,
              aliasName: $_aliasNameGenerator(
                  db.groups.clientId, db.transactions.groupClientId));

  $$TransactionsTableProcessedTableManager get transactionsRefs {
    final manager = $$TransactionsTableTableManager($_db, $_db.transactions)
        .filter((f) => f.groupClientId.clientId
            .sqlEquals($_itemColumn<String>('client_id')!));

    final cache = $_typedResult.readTableOrNull(_transactionsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$GroupsTableFilterComposer
    extends Composer<_$AppDatabase, $GroupsTable> {
  $$GroupsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get clientId => $composableBuilder(
      column: $table.clientId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get rev => $composableBuilder(
      column: $table.rev, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastSyncedAt => $composableBuilder(
      column: $table.lastSyncedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<Media?, Media, String> get icon =>
      $composableBuilder(
          column: $table.icon,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  Expression<bool> transactionsRefs(
      Expression<bool> Function($$TransactionsTableFilterComposer f) f) {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.clientId,
        referencedTable: $db.transactions,
        getReferencedColumn: (t) => t.groupClientId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionsTableFilterComposer(
              $db: $db,
              $table: $db.transactions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$GroupsTableOrderingComposer
    extends Composer<_$AppDatabase, $GroupsTable> {
  $$GroupsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get clientId => $composableBuilder(
      column: $table.clientId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get rev => $composableBuilder(
      column: $table.rev, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastSyncedAt => $composableBuilder(
      column: $table.lastSyncedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get icon => $composableBuilder(
      column: $table.icon, builder: (column) => ColumnOrderings(column));
}

class $$GroupsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GroupsTable> {
  $$GroupsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get clientId =>
      $composableBuilder(column: $table.clientId, builder: (column) => column);

  GeneratedColumn<String> get rev =>
      $composableBuilder(column: $table.rev, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSyncedAt => $composableBuilder(
      column: $table.lastSyncedAt, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Media?, String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  Expression<T> transactionsRefs<T extends Object>(
      Expression<T> Function($$TransactionsTableAnnotationComposer a) f) {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.clientId,
        referencedTable: $db.transactions,
        getReferencedColumn: (t) => t.groupClientId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionsTableAnnotationComposer(
              $db: $db,
              $table: $db.transactions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$GroupsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $GroupsTable,
    Group,
    $$GroupsTableFilterComposer,
    $$GroupsTableOrderingComposer,
    $$GroupsTableAnnotationComposer,
    $$GroupsTableCreateCompanionBuilder,
    $$GroupsTableUpdateCompanionBuilder,
    (Group, $$GroupsTableReferences),
    Group,
    PrefetchHooks Function({bool transactionsRefs})> {
  $$GroupsTableTableManager(_$AppDatabase db, $GroupsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GroupsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GroupsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GroupsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int?> id = const Value.absent(),
            Value<int?> userId = const Value.absent(),
            Value<String> clientId = const Value.absent(),
            Value<String?> rev = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<DateTime?> lastSyncedAt = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<Media?> icon = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              GroupsCompanion(
            id: id,
            userId: userId,
            clientId: clientId,
            rev: rev,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            lastSyncedAt: lastSyncedAt,
            name: name,
            description: description,
            icon: icon,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<int?> id = const Value.absent(),
            Value<int?> userId = const Value.absent(),
            Value<String> clientId = const Value.absent(),
            Value<String?> rev = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<DateTime?> lastSyncedAt = const Value.absent(),
            required String name,
            Value<String?> description = const Value.absent(),
            Value<Media?> icon = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              GroupsCompanion.insert(
            id: id,
            userId: userId,
            clientId: clientId,
            rev: rev,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            lastSyncedAt: lastSyncedAt,
            name: name,
            description: description,
            icon: icon,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$GroupsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({transactionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (transactionsRefs) db.transactions],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (transactionsRefs)
                    await $_getPrefetchedData<Group, $GroupsTable, Transaction>(
                        currentTable: table,
                        referencedTable:
                            $$GroupsTableReferences._transactionsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$GroupsTableReferences(db, table, p0)
                                .transactionsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.groupClientId == item.clientId),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$GroupsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $GroupsTable,
    Group,
    $$GroupsTableFilterComposer,
    $$GroupsTableOrderingComposer,
    $$GroupsTableAnnotationComposer,
    $$GroupsTableCreateCompanionBuilder,
    $$GroupsTableUpdateCompanionBuilder,
    (Group, $$GroupsTableReferences),
    Group,
    PrefetchHooks Function({bool transactionsRefs})>;
typedef $$TransactionsTableCreateCompanionBuilder = TransactionsCompanion
    Function({
  Value<int?> id,
  Value<int?> userId,
  Value<String> clientId,
  Value<String?> rev,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<DateTime?> lastSyncedAt,
  required double amount,
  required TransactionType type,
  Value<String?> description,
  Value<DateTime?> datetime,
  Value<int?> partyId,
  Value<int?> walletId,
  Value<int?> groupId,
  required String walletClientId,
  Value<String?> partyClientId,
  Value<String?> groupClientId,
  Value<int?> transferId,
  Value<String?> transferClientId,
  Value<int> rowid,
});
typedef $$TransactionsTableUpdateCompanionBuilder = TransactionsCompanion
    Function({
  Value<int?> id,
  Value<int?> userId,
  Value<String> clientId,
  Value<String?> rev,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<DateTime?> lastSyncedAt,
  Value<double> amount,
  Value<TransactionType> type,
  Value<String?> description,
  Value<DateTime?> datetime,
  Value<int?> partyId,
  Value<int?> walletId,
  Value<int?> groupId,
  Value<String> walletClientId,
  Value<String?> partyClientId,
  Value<String?> groupClientId,
  Value<int?> transferId,
  Value<String?> transferClientId,
  Value<int> rowid,
});

final class $$TransactionsTableReferences
    extends BaseReferences<_$AppDatabase, $TransactionsTable, Transaction> {
  $$TransactionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $WalletsTable _walletClientIdTable(_$AppDatabase db) =>
      db.wallets.createAlias($_aliasNameGenerator(
          db.transactions.walletClientId, db.wallets.clientId));

  $$WalletsTableProcessedTableManager get walletClientId {
    final $_column = $_itemColumn<String>('wallet_client_id')!;

    final manager = $$WalletsTableTableManager($_db, $_db.wallets)
        .filter((f) => f.clientId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_walletClientIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $PartiesTable _partyClientIdTable(_$AppDatabase db) =>
      db.parties.createAlias($_aliasNameGenerator(
          db.transactions.partyClientId, db.parties.clientId));

  $$PartiesTableProcessedTableManager? get partyClientId {
    final $_column = $_itemColumn<String>('party_client_id');
    if ($_column == null) return null;
    final manager = $$PartiesTableTableManager($_db, $_db.parties)
        .filter((f) => f.clientId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_partyClientIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $GroupsTable _groupClientIdTable(_$AppDatabase db) =>
      db.groups.createAlias($_aliasNameGenerator(
          db.transactions.groupClientId, db.groups.clientId));

  $$GroupsTableProcessedTableManager? get groupClientId {
    final $_column = $_itemColumn<String>('group_client_id');
    if ($_column == null) return null;
    final manager = $$GroupsTableTableManager($_db, $_db.groups)
        .filter((f) => f.clientId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_groupClientIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$TransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get clientId => $composableBuilder(
      column: $table.clientId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get rev => $composableBuilder(
      column: $table.rev, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastSyncedAt => $composableBuilder(
      column: $table.lastSyncedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<TransactionType, TransactionType, String>
      get type => $composableBuilder(
          column: $table.type,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get datetime => $composableBuilder(
      column: $table.datetime, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get partyId => $composableBuilder(
      column: $table.partyId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get walletId => $composableBuilder(
      column: $table.walletId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get groupId => $composableBuilder(
      column: $table.groupId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get transferId => $composableBuilder(
      column: $table.transferId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get transferClientId => $composableBuilder(
      column: $table.transferClientId,
      builder: (column) => ColumnFilters(column));

  $$WalletsTableFilterComposer get walletClientId {
    final $$WalletsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.walletClientId,
        referencedTable: $db.wallets,
        getReferencedColumn: (t) => t.clientId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WalletsTableFilterComposer(
              $db: $db,
              $table: $db.wallets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$PartiesTableFilterComposer get partyClientId {
    final $$PartiesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.partyClientId,
        referencedTable: $db.parties,
        getReferencedColumn: (t) => t.clientId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PartiesTableFilterComposer(
              $db: $db,
              $table: $db.parties,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$GroupsTableFilterComposer get groupClientId {
    final $$GroupsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.groupClientId,
        referencedTable: $db.groups,
        getReferencedColumn: (t) => t.clientId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GroupsTableFilterComposer(
              $db: $db,
              $table: $db.groups,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get clientId => $composableBuilder(
      column: $table.clientId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get rev => $composableBuilder(
      column: $table.rev, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastSyncedAt => $composableBuilder(
      column: $table.lastSyncedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get datetime => $composableBuilder(
      column: $table.datetime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get partyId => $composableBuilder(
      column: $table.partyId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get walletId => $composableBuilder(
      column: $table.walletId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get groupId => $composableBuilder(
      column: $table.groupId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get transferId => $composableBuilder(
      column: $table.transferId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get transferClientId => $composableBuilder(
      column: $table.transferClientId,
      builder: (column) => ColumnOrderings(column));

  $$WalletsTableOrderingComposer get walletClientId {
    final $$WalletsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.walletClientId,
        referencedTable: $db.wallets,
        getReferencedColumn: (t) => t.clientId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WalletsTableOrderingComposer(
              $db: $db,
              $table: $db.wallets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$PartiesTableOrderingComposer get partyClientId {
    final $$PartiesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.partyClientId,
        referencedTable: $db.parties,
        getReferencedColumn: (t) => t.clientId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PartiesTableOrderingComposer(
              $db: $db,
              $table: $db.parties,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$GroupsTableOrderingComposer get groupClientId {
    final $$GroupsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.groupClientId,
        referencedTable: $db.groups,
        getReferencedColumn: (t) => t.clientId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GroupsTableOrderingComposer(
              $db: $db,
              $table: $db.groups,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get clientId =>
      $composableBuilder(column: $table.clientId, builder: (column) => column);

  GeneratedColumn<String> get rev =>
      $composableBuilder(column: $table.rev, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSyncedAt => $composableBuilder(
      column: $table.lastSyncedAt, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TransactionType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<DateTime> get datetime =>
      $composableBuilder(column: $table.datetime, builder: (column) => column);

  GeneratedColumn<int> get partyId =>
      $composableBuilder(column: $table.partyId, builder: (column) => column);

  GeneratedColumn<int> get walletId =>
      $composableBuilder(column: $table.walletId, builder: (column) => column);

  GeneratedColumn<int> get groupId =>
      $composableBuilder(column: $table.groupId, builder: (column) => column);

  GeneratedColumn<int> get transferId => $composableBuilder(
      column: $table.transferId, builder: (column) => column);

  GeneratedColumn<String> get transferClientId => $composableBuilder(
      column: $table.transferClientId, builder: (column) => column);

  $$WalletsTableAnnotationComposer get walletClientId {
    final $$WalletsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.walletClientId,
        referencedTable: $db.wallets,
        getReferencedColumn: (t) => t.clientId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WalletsTableAnnotationComposer(
              $db: $db,
              $table: $db.wallets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$PartiesTableAnnotationComposer get partyClientId {
    final $$PartiesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.partyClientId,
        referencedTable: $db.parties,
        getReferencedColumn: (t) => t.clientId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PartiesTableAnnotationComposer(
              $db: $db,
              $table: $db.parties,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$GroupsTableAnnotationComposer get groupClientId {
    final $$GroupsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.groupClientId,
        referencedTable: $db.groups,
        getReferencedColumn: (t) => t.clientId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GroupsTableAnnotationComposer(
              $db: $db,
              $table: $db.groups,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TransactionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TransactionsTable,
    Transaction,
    $$TransactionsTableFilterComposer,
    $$TransactionsTableOrderingComposer,
    $$TransactionsTableAnnotationComposer,
    $$TransactionsTableCreateCompanionBuilder,
    $$TransactionsTableUpdateCompanionBuilder,
    (Transaction, $$TransactionsTableReferences),
    Transaction,
    PrefetchHooks Function(
        {bool walletClientId, bool partyClientId, bool groupClientId})> {
  $$TransactionsTableTableManager(_$AppDatabase db, $TransactionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int?> id = const Value.absent(),
            Value<int?> userId = const Value.absent(),
            Value<String> clientId = const Value.absent(),
            Value<String?> rev = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<DateTime?> lastSyncedAt = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<TransactionType> type = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<DateTime?> datetime = const Value.absent(),
            Value<int?> partyId = const Value.absent(),
            Value<int?> walletId = const Value.absent(),
            Value<int?> groupId = const Value.absent(),
            Value<String> walletClientId = const Value.absent(),
            Value<String?> partyClientId = const Value.absent(),
            Value<String?> groupClientId = const Value.absent(),
            Value<int?> transferId = const Value.absent(),
            Value<String?> transferClientId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TransactionsCompanion(
            id: id,
            userId: userId,
            clientId: clientId,
            rev: rev,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            lastSyncedAt: lastSyncedAt,
            amount: amount,
            type: type,
            description: description,
            datetime: datetime,
            partyId: partyId,
            walletId: walletId,
            groupId: groupId,
            walletClientId: walletClientId,
            partyClientId: partyClientId,
            groupClientId: groupClientId,
            transferId: transferId,
            transferClientId: transferClientId,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<int?> id = const Value.absent(),
            Value<int?> userId = const Value.absent(),
            Value<String> clientId = const Value.absent(),
            Value<String?> rev = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<DateTime?> lastSyncedAt = const Value.absent(),
            required double amount,
            required TransactionType type,
            Value<String?> description = const Value.absent(),
            Value<DateTime?> datetime = const Value.absent(),
            Value<int?> partyId = const Value.absent(),
            Value<int?> walletId = const Value.absent(),
            Value<int?> groupId = const Value.absent(),
            required String walletClientId,
            Value<String?> partyClientId = const Value.absent(),
            Value<String?> groupClientId = const Value.absent(),
            Value<int?> transferId = const Value.absent(),
            Value<String?> transferClientId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TransactionsCompanion.insert(
            id: id,
            userId: userId,
            clientId: clientId,
            rev: rev,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            lastSyncedAt: lastSyncedAt,
            amount: amount,
            type: type,
            description: description,
            datetime: datetime,
            partyId: partyId,
            walletId: walletId,
            groupId: groupId,
            walletClientId: walletClientId,
            partyClientId: partyClientId,
            groupClientId: groupClientId,
            transferId: transferId,
            transferClientId: transferClientId,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$TransactionsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {walletClientId = false,
              partyClientId = false,
              groupClientId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (walletClientId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.walletClientId,
                    referencedTable:
                        $$TransactionsTableReferences._walletClientIdTable(db),
                    referencedColumn: $$TransactionsTableReferences
                        ._walletClientIdTable(db)
                        .clientId,
                  ) as T;
                }
                if (partyClientId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.partyClientId,
                    referencedTable:
                        $$TransactionsTableReferences._partyClientIdTable(db),
                    referencedColumn: $$TransactionsTableReferences
                        ._partyClientIdTable(db)
                        .clientId,
                  ) as T;
                }
                if (groupClientId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.groupClientId,
                    referencedTable:
                        $$TransactionsTableReferences._groupClientIdTable(db),
                    referencedColumn: $$TransactionsTableReferences
                        ._groupClientIdTable(db)
                        .clientId,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$TransactionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TransactionsTable,
    Transaction,
    $$TransactionsTableFilterComposer,
    $$TransactionsTableOrderingComposer,
    $$TransactionsTableAnnotationComposer,
    $$TransactionsTableCreateCompanionBuilder,
    $$TransactionsTableUpdateCompanionBuilder,
    (Transaction, $$TransactionsTableReferences),
    Transaction,
    PrefetchHooks Function(
        {bool walletClientId, bool partyClientId, bool groupClientId})>;
typedef $$CategoriesTableCreateCompanionBuilder = CategoriesCompanion Function({
  Value<int?> id,
  Value<int?> userId,
  Value<String> clientId,
  Value<String?> rev,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<DateTime?> lastSyncedAt,
  required String name,
  required String slug,
  Value<String?> description,
  required TransactionType type,
  Value<Media?> icon,
  Value<int> rowid,
});
typedef $$CategoriesTableUpdateCompanionBuilder = CategoriesCompanion Function({
  Value<int?> id,
  Value<int?> userId,
  Value<String> clientId,
  Value<String?> rev,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<DateTime?> lastSyncedAt,
  Value<String> name,
  Value<String> slug,
  Value<String?> description,
  Value<TransactionType> type,
  Value<Media?> icon,
  Value<int> rowid,
});

final class $$CategoriesTableReferences
    extends BaseReferences<_$AppDatabase, $CategoriesTable, Category> {
  $$CategoriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$CategorizablesTable, List<Categorizable>>
      _categorizablesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.categorizables,
              aliasName: $_aliasNameGenerator(
                  db.categories.clientId, db.categorizables.categoryClientId));

  $$CategorizablesTableProcessedTableManager get categorizablesRefs {
    final manager = $$CategorizablesTableTableManager($_db, $_db.categorizables)
        .filter((f) => f.categoryClientId.clientId
            .sqlEquals($_itemColumn<String>('client_id')!));

    final cache = $_typedResult.readTableOrNull(_categorizablesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$CategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get clientId => $composableBuilder(
      column: $table.clientId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get rev => $composableBuilder(
      column: $table.rev, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastSyncedAt => $composableBuilder(
      column: $table.lastSyncedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get slug => $composableBuilder(
      column: $table.slug, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<TransactionType, TransactionType, String>
      get type => $composableBuilder(
          column: $table.type,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<Media?, Media, String> get icon =>
      $composableBuilder(
          column: $table.icon,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  Expression<bool> categorizablesRefs(
      Expression<bool> Function($$CategorizablesTableFilterComposer f) f) {
    final $$CategorizablesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.clientId,
        referencedTable: $db.categorizables,
        getReferencedColumn: (t) => t.categoryClientId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategorizablesTableFilterComposer(
              $db: $db,
              $table: $db.categorizables,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get clientId => $composableBuilder(
      column: $table.clientId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get rev => $composableBuilder(
      column: $table.rev, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastSyncedAt => $composableBuilder(
      column: $table.lastSyncedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get slug => $composableBuilder(
      column: $table.slug, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get icon => $composableBuilder(
      column: $table.icon, builder: (column) => ColumnOrderings(column));
}

class $$CategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get clientId =>
      $composableBuilder(column: $table.clientId, builder: (column) => column);

  GeneratedColumn<String> get rev =>
      $composableBuilder(column: $table.rev, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSyncedAt => $composableBuilder(
      column: $table.lastSyncedAt, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get slug =>
      $composableBuilder(column: $table.slug, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TransactionType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Media?, String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  Expression<T> categorizablesRefs<T extends Object>(
      Expression<T> Function($$CategorizablesTableAnnotationComposer a) f) {
    final $$CategorizablesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.clientId,
        referencedTable: $db.categorizables,
        getReferencedColumn: (t) => t.categoryClientId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategorizablesTableAnnotationComposer(
              $db: $db,
              $table: $db.categorizables,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CategoriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CategoriesTable,
    Category,
    $$CategoriesTableFilterComposer,
    $$CategoriesTableOrderingComposer,
    $$CategoriesTableAnnotationComposer,
    $$CategoriesTableCreateCompanionBuilder,
    $$CategoriesTableUpdateCompanionBuilder,
    (Category, $$CategoriesTableReferences),
    Category,
    PrefetchHooks Function({bool categorizablesRefs})> {
  $$CategoriesTableTableManager(_$AppDatabase db, $CategoriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int?> id = const Value.absent(),
            Value<int?> userId = const Value.absent(),
            Value<String> clientId = const Value.absent(),
            Value<String?> rev = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<DateTime?> lastSyncedAt = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> slug = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<TransactionType> type = const Value.absent(),
            Value<Media?> icon = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CategoriesCompanion(
            id: id,
            userId: userId,
            clientId: clientId,
            rev: rev,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            lastSyncedAt: lastSyncedAt,
            name: name,
            slug: slug,
            description: description,
            type: type,
            icon: icon,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<int?> id = const Value.absent(),
            Value<int?> userId = const Value.absent(),
            Value<String> clientId = const Value.absent(),
            Value<String?> rev = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<DateTime?> lastSyncedAt = const Value.absent(),
            required String name,
            required String slug,
            Value<String?> description = const Value.absent(),
            required TransactionType type,
            Value<Media?> icon = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CategoriesCompanion.insert(
            id: id,
            userId: userId,
            clientId: clientId,
            rev: rev,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            lastSyncedAt: lastSyncedAt,
            name: name,
            slug: slug,
            description: description,
            type: type,
            icon: icon,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$CategoriesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({categorizablesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (categorizablesRefs) db.categorizables
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (categorizablesRefs)
                    await $_getPrefetchedData<Category, $CategoriesTable,
                            Categorizable>(
                        currentTable: table,
                        referencedTable: $$CategoriesTableReferences
                            ._categorizablesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CategoriesTableReferences(db, table, p0)
                                .categorizablesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems.where(
                                (e) => e.categoryClientId == item.clientId),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$CategoriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CategoriesTable,
    Category,
    $$CategoriesTableFilterComposer,
    $$CategoriesTableOrderingComposer,
    $$CategoriesTableAnnotationComposer,
    $$CategoriesTableCreateCompanionBuilder,
    $$CategoriesTableUpdateCompanionBuilder,
    (Category, $$CategoriesTableReferences),
    Category,
    PrefetchHooks Function({bool categorizablesRefs})>;
typedef $$ConfigsTableCreateCompanionBuilder = ConfigsCompanion Function({
  Value<int?> id,
  Value<int?> userId,
  Value<String> clientId,
  Value<String?> rev,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<DateTime?> lastSyncedAt,
  required String key,
  required ConfigType type,
  required dynamic value,
  Value<int> rowid,
});
typedef $$ConfigsTableUpdateCompanionBuilder = ConfigsCompanion Function({
  Value<int?> id,
  Value<int?> userId,
  Value<String> clientId,
  Value<String?> rev,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<DateTime?> lastSyncedAt,
  Value<String> key,
  Value<ConfigType> type,
  Value<dynamic> value,
  Value<int> rowid,
});

class $$ConfigsTableFilterComposer
    extends Composer<_$AppDatabase, $ConfigsTable> {
  $$ConfigsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get clientId => $composableBuilder(
      column: $table.clientId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get rev => $composableBuilder(
      column: $table.rev, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastSyncedAt => $composableBuilder(
      column: $table.lastSyncedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<ConfigType, ConfigType, String> get type =>
      $composableBuilder(
          column: $table.type,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<dynamic, dynamic, String> get value =>
      $composableBuilder(
          column: $table.value,
          builder: (column) => ColumnWithTypeConverterFilters(column));
}

class $$ConfigsTableOrderingComposer
    extends Composer<_$AppDatabase, $ConfigsTable> {
  $$ConfigsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get clientId => $composableBuilder(
      column: $table.clientId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get rev => $composableBuilder(
      column: $table.rev, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastSyncedAt => $composableBuilder(
      column: $table.lastSyncedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnOrderings(column));
}

class $$ConfigsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ConfigsTable> {
  $$ConfigsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get clientId =>
      $composableBuilder(column: $table.clientId, builder: (column) => column);

  GeneratedColumn<String> get rev =>
      $composableBuilder(column: $table.rev, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSyncedAt => $composableBuilder(
      column: $table.lastSyncedAt, builder: (column) => column);

  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ConfigType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumnWithTypeConverter<dynamic, String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$ConfigsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ConfigsTable,
    Config,
    $$ConfigsTableFilterComposer,
    $$ConfigsTableOrderingComposer,
    $$ConfigsTableAnnotationComposer,
    $$ConfigsTableCreateCompanionBuilder,
    $$ConfigsTableUpdateCompanionBuilder,
    (Config, BaseReferences<_$AppDatabase, $ConfigsTable, Config>),
    Config,
    PrefetchHooks Function()> {
  $$ConfigsTableTableManager(_$AppDatabase db, $ConfigsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ConfigsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ConfigsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ConfigsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int?> id = const Value.absent(),
            Value<int?> userId = const Value.absent(),
            Value<String> clientId = const Value.absent(),
            Value<String?> rev = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<DateTime?> lastSyncedAt = const Value.absent(),
            Value<String> key = const Value.absent(),
            Value<ConfigType> type = const Value.absent(),
            Value<dynamic> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ConfigsCompanion(
            id: id,
            userId: userId,
            clientId: clientId,
            rev: rev,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            lastSyncedAt: lastSyncedAt,
            key: key,
            type: type,
            value: value,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<int?> id = const Value.absent(),
            Value<int?> userId = const Value.absent(),
            Value<String> clientId = const Value.absent(),
            Value<String?> rev = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<DateTime?> lastSyncedAt = const Value.absent(),
            required String key,
            required ConfigType type,
            required dynamic value,
            Value<int> rowid = const Value.absent(),
          }) =>
              ConfigsCompanion.insert(
            id: id,
            userId: userId,
            clientId: clientId,
            rev: rev,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            lastSyncedAt: lastSyncedAt,
            key: key,
            type: type,
            value: value,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ConfigsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ConfigsTable,
    Config,
    $$ConfigsTableFilterComposer,
    $$ConfigsTableOrderingComposer,
    $$ConfigsTableAnnotationComposer,
    $$ConfigsTableCreateCompanionBuilder,
    $$ConfigsTableUpdateCompanionBuilder,
    (Config, BaseReferences<_$AppDatabase, $ConfigsTable, Config>),
    Config,
    PrefetchHooks Function()>;
typedef $$UsersTableCreateCompanionBuilder = UsersCompanion Function({
  Value<int> id,
  required String email,
  required String firstName,
  Value<String?> lastName,
  Value<String?> username,
  Value<String?> phone,
  Value<String?> avatar,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
});
typedef $$UsersTableUpdateCompanionBuilder = UsersCompanion Function({
  Value<int> id,
  Value<String> email,
  Value<String> firstName,
  Value<String?> lastName,
  Value<String?> username,
  Value<String?> phone,
  Value<String?> avatar,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
});

class $$UsersTableFilterComposer extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get firstName => $composableBuilder(
      column: $table.firstName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastName => $composableBuilder(
      column: $table.lastName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get username => $composableBuilder(
      column: $table.username, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get avatar => $composableBuilder(
      column: $table.avatar, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$UsersTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get firstName => $composableBuilder(
      column: $table.firstName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastName => $composableBuilder(
      column: $table.lastName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get username => $composableBuilder(
      column: $table.username, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get avatar => $composableBuilder(
      column: $table.avatar, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$UsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get firstName =>
      $composableBuilder(column: $table.firstName, builder: (column) => column);

  GeneratedColumn<String> get lastName =>
      $composableBuilder(column: $table.lastName, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get avatar =>
      $composableBuilder(column: $table.avatar, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$UsersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UsersTable,
    User,
    $$UsersTableFilterComposer,
    $$UsersTableOrderingComposer,
    $$UsersTableAnnotationComposer,
    $$UsersTableCreateCompanionBuilder,
    $$UsersTableUpdateCompanionBuilder,
    (User, BaseReferences<_$AppDatabase, $UsersTable, User>),
    User,
    PrefetchHooks Function()> {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> email = const Value.absent(),
            Value<String> firstName = const Value.absent(),
            Value<String?> lastName = const Value.absent(),
            Value<String?> username = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            Value<String?> avatar = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
          }) =>
              UsersCompanion(
            id: id,
            email: email,
            firstName: firstName,
            lastName: lastName,
            username: username,
            phone: phone,
            avatar: avatar,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String email,
            required String firstName,
            Value<String?> lastName = const Value.absent(),
            Value<String?> username = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            Value<String?> avatar = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
          }) =>
              UsersCompanion.insert(
            id: id,
            email: email,
            firstName: firstName,
            lastName: lastName,
            username: username,
            phone: phone,
            avatar: avatar,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UsersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UsersTable,
    User,
    $$UsersTableFilterComposer,
    $$UsersTableOrderingComposer,
    $$UsersTableAnnotationComposer,
    $$UsersTableCreateCompanionBuilder,
    $$UsersTableUpdateCompanionBuilder,
    (User, BaseReferences<_$AppDatabase, $UsersTable, User>),
    User,
    PrefetchHooks Function()>;
typedef $$LocalChangesTableCreateCompanionBuilder = LocalChangesCompanion
    Function({
  required String entityType,
  required String entityId,
  required String entityRev,
  required bool deleted,
  required Map<String, dynamic> data,
  required DateTime createAt,
  required bool concluded,
  Value<DateTime?> concludedMoment,
  Value<String?> error,
  required bool dismissed,
  Value<int> rowid,
});
typedef $$LocalChangesTableUpdateCompanionBuilder = LocalChangesCompanion
    Function({
  Value<String> entityType,
  Value<String> entityId,
  Value<String> entityRev,
  Value<bool> deleted,
  Value<Map<String, dynamic>> data,
  Value<DateTime> createAt,
  Value<bool> concluded,
  Value<DateTime?> concludedMoment,
  Value<String?> error,
  Value<bool> dismissed,
  Value<int> rowid,
});

class $$LocalChangesTableFilterComposer
    extends Composer<_$AppDatabase, $LocalChangesTable> {
  $$LocalChangesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entityId => $composableBuilder(
      column: $table.entityId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entityRev => $composableBuilder(
      column: $table.entityRev, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get deleted => $composableBuilder(
      column: $table.deleted, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<Map<String, dynamic>, Map<String, dynamic>,
          String>
      get data => $composableBuilder(
          column: $table.data,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<DateTime> get createAt => $composableBuilder(
      column: $table.createAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get concluded => $composableBuilder(
      column: $table.concluded, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get concludedMoment => $composableBuilder(
      column: $table.concludedMoment,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get error => $composableBuilder(
      column: $table.error, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get dismissed => $composableBuilder(
      column: $table.dismissed, builder: (column) => ColumnFilters(column));
}

class $$LocalChangesTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalChangesTable> {
  $$LocalChangesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entityId => $composableBuilder(
      column: $table.entityId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entityRev => $composableBuilder(
      column: $table.entityRev, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get deleted => $composableBuilder(
      column: $table.deleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get data => $composableBuilder(
      column: $table.data, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createAt => $composableBuilder(
      column: $table.createAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get concluded => $composableBuilder(
      column: $table.concluded, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get concludedMoment => $composableBuilder(
      column: $table.concludedMoment,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get error => $composableBuilder(
      column: $table.error, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get dismissed => $composableBuilder(
      column: $table.dismissed, builder: (column) => ColumnOrderings(column));
}

class $$LocalChangesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalChangesTable> {
  $$LocalChangesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => column);

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get entityRev =>
      $composableBuilder(column: $table.entityRev, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Map<String, dynamic>, String> get data =>
      $composableBuilder(column: $table.data, builder: (column) => column);

  GeneratedColumn<DateTime> get createAt =>
      $composableBuilder(column: $table.createAt, builder: (column) => column);

  GeneratedColumn<bool> get concluded =>
      $composableBuilder(column: $table.concluded, builder: (column) => column);

  GeneratedColumn<DateTime> get concludedMoment => $composableBuilder(
      column: $table.concludedMoment, builder: (column) => column);

  GeneratedColumn<String> get error =>
      $composableBuilder(column: $table.error, builder: (column) => column);

  GeneratedColumn<bool> get dismissed =>
      $composableBuilder(column: $table.dismissed, builder: (column) => column);
}

class $$LocalChangesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LocalChangesTable,
    LocalChange,
    $$LocalChangesTableFilterComposer,
    $$LocalChangesTableOrderingComposer,
    $$LocalChangesTableAnnotationComposer,
    $$LocalChangesTableCreateCompanionBuilder,
    $$LocalChangesTableUpdateCompanionBuilder,
    (
      LocalChange,
      BaseReferences<_$AppDatabase, $LocalChangesTable, LocalChange>
    ),
    LocalChange,
    PrefetchHooks Function()> {
  $$LocalChangesTableTableManager(_$AppDatabase db, $LocalChangesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalChangesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalChangesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalChangesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> entityType = const Value.absent(),
            Value<String> entityId = const Value.absent(),
            Value<String> entityRev = const Value.absent(),
            Value<bool> deleted = const Value.absent(),
            Value<Map<String, dynamic>> data = const Value.absent(),
            Value<DateTime> createAt = const Value.absent(),
            Value<bool> concluded = const Value.absent(),
            Value<DateTime?> concludedMoment = const Value.absent(),
            Value<String?> error = const Value.absent(),
            Value<bool> dismissed = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LocalChangesCompanion(
            entityType: entityType,
            entityId: entityId,
            entityRev: entityRev,
            deleted: deleted,
            data: data,
            createAt: createAt,
            concluded: concluded,
            concludedMoment: concludedMoment,
            error: error,
            dismissed: dismissed,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String entityType,
            required String entityId,
            required String entityRev,
            required bool deleted,
            required Map<String, dynamic> data,
            required DateTime createAt,
            required bool concluded,
            Value<DateTime?> concludedMoment = const Value.absent(),
            Value<String?> error = const Value.absent(),
            required bool dismissed,
            Value<int> rowid = const Value.absent(),
          }) =>
              LocalChangesCompanion.insert(
            entityType: entityType,
            entityId: entityId,
            entityRev: entityRev,
            deleted: deleted,
            data: data,
            createAt: createAt,
            concluded: concluded,
            concludedMoment: concludedMoment,
            error: error,
            dismissed: dismissed,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$LocalChangesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LocalChangesTable,
    LocalChange,
    $$LocalChangesTableFilterComposer,
    $$LocalChangesTableOrderingComposer,
    $$LocalChangesTableAnnotationComposer,
    $$LocalChangesTableCreateCompanionBuilder,
    $$LocalChangesTableUpdateCompanionBuilder,
    (
      LocalChange,
      BaseReferences<_$AppDatabase, $LocalChangesTable, LocalChange>
    ),
    LocalChange,
    PrefetchHooks Function()>;
typedef $$SyncMetadataTableCreateCompanionBuilder = SyncMetadataCompanion
    Function({
  required String entityType,
  Value<DateTime?> lastSyncedAt,
  Value<int> rowid,
});
typedef $$SyncMetadataTableUpdateCompanionBuilder = SyncMetadataCompanion
    Function({
  Value<String> entityType,
  Value<DateTime?> lastSyncedAt,
  Value<int> rowid,
});

class $$SyncMetadataTableFilterComposer
    extends Composer<_$AppDatabase, $SyncMetadataTable> {
  $$SyncMetadataTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastSyncedAt => $composableBuilder(
      column: $table.lastSyncedAt, builder: (column) => ColumnFilters(column));
}

class $$SyncMetadataTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncMetadataTable> {
  $$SyncMetadataTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastSyncedAt => $composableBuilder(
      column: $table.lastSyncedAt,
      builder: (column) => ColumnOrderings(column));
}

class $$SyncMetadataTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncMetadataTable> {
  $$SyncMetadataTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSyncedAt => $composableBuilder(
      column: $table.lastSyncedAt, builder: (column) => column);
}

class $$SyncMetadataTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SyncMetadataTable,
    SyncMetadatas,
    $$SyncMetadataTableFilterComposer,
    $$SyncMetadataTableOrderingComposer,
    $$SyncMetadataTableAnnotationComposer,
    $$SyncMetadataTableCreateCompanionBuilder,
    $$SyncMetadataTableUpdateCompanionBuilder,
    (
      SyncMetadatas,
      BaseReferences<_$AppDatabase, $SyncMetadataTable, SyncMetadatas>
    ),
    SyncMetadatas,
    PrefetchHooks Function()> {
  $$SyncMetadataTableTableManager(_$AppDatabase db, $SyncMetadataTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncMetadataTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncMetadataTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncMetadataTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> entityType = const Value.absent(),
            Value<DateTime?> lastSyncedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SyncMetadataCompanion(
            entityType: entityType,
            lastSyncedAt: lastSyncedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String entityType,
            Value<DateTime?> lastSyncedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SyncMetadataCompanion.insert(
            entityType: entityType,
            lastSyncedAt: lastSyncedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SyncMetadataTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SyncMetadataTable,
    SyncMetadatas,
    $$SyncMetadataTableFilterComposer,
    $$SyncMetadataTableOrderingComposer,
    $$SyncMetadataTableAnnotationComposer,
    $$SyncMetadataTableCreateCompanionBuilder,
    $$SyncMetadataTableUpdateCompanionBuilder,
    (
      SyncMetadatas,
      BaseReferences<_$AppDatabase, $SyncMetadataTable, SyncMetadatas>
    ),
    SyncMetadatas,
    PrefetchHooks Function()>;
typedef $$CategorizablesTableCreateCompanionBuilder = CategorizablesCompanion
    Function({
  required String categorizableId,
  required CategorizableType categorizableType,
  required String categoryClientId,
  Value<int> rowid,
});
typedef $$CategorizablesTableUpdateCompanionBuilder = CategorizablesCompanion
    Function({
  Value<String> categorizableId,
  Value<CategorizableType> categorizableType,
  Value<String> categoryClientId,
  Value<int> rowid,
});

final class $$CategorizablesTableReferences
    extends BaseReferences<_$AppDatabase, $CategorizablesTable, Categorizable> {
  $$CategorizablesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $CategoriesTable _categoryClientIdTable(_$AppDatabase db) =>
      db.categories.createAlias($_aliasNameGenerator(
          db.categorizables.categoryClientId, db.categories.clientId));

  $$CategoriesTableProcessedTableManager get categoryClientId {
    final $_column = $_itemColumn<String>('category_client_id')!;

    final manager = $$CategoriesTableTableManager($_db, $_db.categories)
        .filter((f) => f.clientId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryClientIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$CategorizablesTableFilterComposer
    extends Composer<_$AppDatabase, $CategorizablesTable> {
  $$CategorizablesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get categorizableId => $composableBuilder(
      column: $table.categorizableId,
      builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<CategorizableType, CategorizableType, String>
      get categorizableType => $composableBuilder(
          column: $table.categorizableType,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  $$CategoriesTableFilterComposer get categoryClientId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryClientId,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.clientId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoriesTableFilterComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$CategorizablesTableOrderingComposer
    extends Composer<_$AppDatabase, $CategorizablesTable> {
  $$CategorizablesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get categorizableId => $composableBuilder(
      column: $table.categorizableId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get categorizableType => $composableBuilder(
      column: $table.categorizableType,
      builder: (column) => ColumnOrderings(column));

  $$CategoriesTableOrderingComposer get categoryClientId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryClientId,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.clientId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoriesTableOrderingComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$CategorizablesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategorizablesTable> {
  $$CategorizablesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get categorizableId => $composableBuilder(
      column: $table.categorizableId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<CategorizableType, String>
      get categorizableType => $composableBuilder(
          column: $table.categorizableType, builder: (column) => column);

  $$CategoriesTableAnnotationComposer get categoryClientId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryClientId,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.clientId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoriesTableAnnotationComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$CategorizablesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CategorizablesTable,
    Categorizable,
    $$CategorizablesTableFilterComposer,
    $$CategorizablesTableOrderingComposer,
    $$CategorizablesTableAnnotationComposer,
    $$CategorizablesTableCreateCompanionBuilder,
    $$CategorizablesTableUpdateCompanionBuilder,
    (Categorizable, $$CategorizablesTableReferences),
    Categorizable,
    PrefetchHooks Function({bool categoryClientId})> {
  $$CategorizablesTableTableManager(
      _$AppDatabase db, $CategorizablesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategorizablesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategorizablesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategorizablesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> categorizableId = const Value.absent(),
            Value<CategorizableType> categorizableType = const Value.absent(),
            Value<String> categoryClientId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CategorizablesCompanion(
            categorizableId: categorizableId,
            categorizableType: categorizableType,
            categoryClientId: categoryClientId,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String categorizableId,
            required CategorizableType categorizableType,
            required String categoryClientId,
            Value<int> rowid = const Value.absent(),
          }) =>
              CategorizablesCompanion.insert(
            categorizableId: categorizableId,
            categorizableType: categorizableType,
            categoryClientId: categoryClientId,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$CategorizablesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({categoryClientId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (categoryClientId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.categoryClientId,
                    referencedTable: $$CategorizablesTableReferences
                        ._categoryClientIdTable(db),
                    referencedColumn: $$CategorizablesTableReferences
                        ._categoryClientIdTable(db)
                        .clientId,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$CategorizablesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CategorizablesTable,
    Categorizable,
    $$CategorizablesTableFilterComposer,
    $$CategorizablesTableOrderingComposer,
    $$CategorizablesTableAnnotationComposer,
    $$CategorizablesTableCreateCompanionBuilder,
    $$CategorizablesTableUpdateCompanionBuilder,
    (Categorizable, $$CategorizablesTableReferences),
    Categorizable,
    PrefetchHooks Function({bool categoryClientId})>;
typedef $$NotificationsTableCreateCompanionBuilder = NotificationsCompanion
    Function({
  Value<int?> id,
  Value<int?> userId,
  Value<String> clientId,
  Value<String?> rev,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<DateTime?> lastSyncedAt,
  required NotificationType type,
  required String title,
  required String body,
  required Map<String, dynamic> data,
  Value<DateTime?> readAt,
  Value<int> rowid,
});
typedef $$NotificationsTableUpdateCompanionBuilder = NotificationsCompanion
    Function({
  Value<int?> id,
  Value<int?> userId,
  Value<String> clientId,
  Value<String?> rev,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<DateTime?> lastSyncedAt,
  Value<NotificationType> type,
  Value<String> title,
  Value<String> body,
  Value<Map<String, dynamic>> data,
  Value<DateTime?> readAt,
  Value<int> rowid,
});

class $$NotificationsTableFilterComposer
    extends Composer<_$AppDatabase, $NotificationsTable> {
  $$NotificationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get clientId => $composableBuilder(
      column: $table.clientId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get rev => $composableBuilder(
      column: $table.rev, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastSyncedAt => $composableBuilder(
      column: $table.lastSyncedAt, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<NotificationType, NotificationType, String>
      get type => $composableBuilder(
          column: $table.type,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get body => $composableBuilder(
      column: $table.body, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<Map<String, dynamic>, Map<String, dynamic>,
          String>
      get data => $composableBuilder(
          column: $table.data,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<DateTime> get readAt => $composableBuilder(
      column: $table.readAt, builder: (column) => ColumnFilters(column));
}

class $$NotificationsTableOrderingComposer
    extends Composer<_$AppDatabase, $NotificationsTable> {
  $$NotificationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get clientId => $composableBuilder(
      column: $table.clientId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get rev => $composableBuilder(
      column: $table.rev, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastSyncedAt => $composableBuilder(
      column: $table.lastSyncedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get body => $composableBuilder(
      column: $table.body, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get data => $composableBuilder(
      column: $table.data, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get readAt => $composableBuilder(
      column: $table.readAt, builder: (column) => ColumnOrderings(column));
}

class $$NotificationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $NotificationsTable> {
  $$NotificationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get clientId =>
      $composableBuilder(column: $table.clientId, builder: (column) => column);

  GeneratedColumn<String> get rev =>
      $composableBuilder(column: $table.rev, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSyncedAt => $composableBuilder(
      column: $table.lastSyncedAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<NotificationType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Map<String, dynamic>, String> get data =>
      $composableBuilder(column: $table.data, builder: (column) => column);

  GeneratedColumn<DateTime> get readAt =>
      $composableBuilder(column: $table.readAt, builder: (column) => column);
}

class $$NotificationsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $NotificationsTable,
    Notification,
    $$NotificationsTableFilterComposer,
    $$NotificationsTableOrderingComposer,
    $$NotificationsTableAnnotationComposer,
    $$NotificationsTableCreateCompanionBuilder,
    $$NotificationsTableUpdateCompanionBuilder,
    (
      Notification,
      BaseReferences<_$AppDatabase, $NotificationsTable, Notification>
    ),
    Notification,
    PrefetchHooks Function()> {
  $$NotificationsTableTableManager(_$AppDatabase db, $NotificationsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NotificationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NotificationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NotificationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int?> id = const Value.absent(),
            Value<int?> userId = const Value.absent(),
            Value<String> clientId = const Value.absent(),
            Value<String?> rev = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<DateTime?> lastSyncedAt = const Value.absent(),
            Value<NotificationType> type = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> body = const Value.absent(),
            Value<Map<String, dynamic>> data = const Value.absent(),
            Value<DateTime?> readAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              NotificationsCompanion(
            id: id,
            userId: userId,
            clientId: clientId,
            rev: rev,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            lastSyncedAt: lastSyncedAt,
            type: type,
            title: title,
            body: body,
            data: data,
            readAt: readAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<int?> id = const Value.absent(),
            Value<int?> userId = const Value.absent(),
            Value<String> clientId = const Value.absent(),
            Value<String?> rev = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<DateTime?> lastSyncedAt = const Value.absent(),
            required NotificationType type,
            required String title,
            required String body,
            required Map<String, dynamic> data,
            Value<DateTime?> readAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              NotificationsCompanion.insert(
            id: id,
            userId: userId,
            clientId: clientId,
            rev: rev,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            lastSyncedAt: lastSyncedAt,
            type: type,
            title: title,
            body: body,
            data: data,
            readAt: readAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$NotificationsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $NotificationsTable,
    Notification,
    $$NotificationsTableFilterComposer,
    $$NotificationsTableOrderingComposer,
    $$NotificationsTableAnnotationComposer,
    $$NotificationsTableCreateCompanionBuilder,
    $$NotificationsTableUpdateCompanionBuilder,
    (
      Notification,
      BaseReferences<_$AppDatabase, $NotificationsTable, Notification>
    ),
    Notification,
    PrefetchHooks Function()>;
typedef $$MediaFilesTableCreateCompanionBuilder = MediaFilesCompanion Function({
  required String path,
  Value<int?> id,
  Value<String?> type,
  Value<String?> fileableType,
  Value<int?> fileableId,
  Value<String?> localFileableType,
  Value<String?> localFileableId,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
  Value<int> rowid,
});
typedef $$MediaFilesTableUpdateCompanionBuilder = MediaFilesCompanion Function({
  Value<String> path,
  Value<int?> id,
  Value<String?> type,
  Value<String?> fileableType,
  Value<int?> fileableId,
  Value<String?> localFileableType,
  Value<String?> localFileableId,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
  Value<int> rowid,
});

class $$MediaFilesTableFilterComposer
    extends Composer<_$AppDatabase, $MediaFilesTable> {
  $$MediaFilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get path => $composableBuilder(
      column: $table.path, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fileableType => $composableBuilder(
      column: $table.fileableType, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get fileableId => $composableBuilder(
      column: $table.fileableId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get localFileableType => $composableBuilder(
      column: $table.localFileableType,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get localFileableId => $composableBuilder(
      column: $table.localFileableId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$MediaFilesTableOrderingComposer
    extends Composer<_$AppDatabase, $MediaFilesTable> {
  $$MediaFilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get path => $composableBuilder(
      column: $table.path, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fileableType => $composableBuilder(
      column: $table.fileableType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get fileableId => $composableBuilder(
      column: $table.fileableId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get localFileableType => $composableBuilder(
      column: $table.localFileableType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get localFileableId => $composableBuilder(
      column: $table.localFileableId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$MediaFilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MediaFilesTable> {
  $$MediaFilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get path =>
      $composableBuilder(column: $table.path, builder: (column) => column);

  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get fileableType => $composableBuilder(
      column: $table.fileableType, builder: (column) => column);

  GeneratedColumn<int> get fileableId => $composableBuilder(
      column: $table.fileableId, builder: (column) => column);

  GeneratedColumn<String> get localFileableType => $composableBuilder(
      column: $table.localFileableType, builder: (column) => column);

  GeneratedColumn<String> get localFileableId => $composableBuilder(
      column: $table.localFileableId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$MediaFilesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MediaFilesTable,
    MediaFile,
    $$MediaFilesTableFilterComposer,
    $$MediaFilesTableOrderingComposer,
    $$MediaFilesTableAnnotationComposer,
    $$MediaFilesTableCreateCompanionBuilder,
    $$MediaFilesTableUpdateCompanionBuilder,
    (MediaFile, BaseReferences<_$AppDatabase, $MediaFilesTable, MediaFile>),
    MediaFile,
    PrefetchHooks Function()> {
  $$MediaFilesTableTableManager(_$AppDatabase db, $MediaFilesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MediaFilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MediaFilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MediaFilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> path = const Value.absent(),
            Value<int?> id = const Value.absent(),
            Value<String?> type = const Value.absent(),
            Value<String?> fileableType = const Value.absent(),
            Value<int?> fileableId = const Value.absent(),
            Value<String?> localFileableType = const Value.absent(),
            Value<String?> localFileableId = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MediaFilesCompanion(
            path: path,
            id: id,
            type: type,
            fileableType: fileableType,
            fileableId: fileableId,
            localFileableType: localFileableType,
            localFileableId: localFileableId,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String path,
            Value<int?> id = const Value.absent(),
            Value<String?> type = const Value.absent(),
            Value<String?> fileableType = const Value.absent(),
            Value<int?> fileableId = const Value.absent(),
            Value<String?> localFileableType = const Value.absent(),
            Value<String?> localFileableId = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MediaFilesCompanion.insert(
            path: path,
            id: id,
            type: type,
            fileableType: fileableType,
            fileableId: fileableId,
            localFileableType: localFileableType,
            localFileableId: localFileableId,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$MediaFilesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MediaFilesTable,
    MediaFile,
    $$MediaFilesTableFilterComposer,
    $$MediaFilesTableOrderingComposer,
    $$MediaFilesTableAnnotationComposer,
    $$MediaFilesTableCreateCompanionBuilder,
    $$MediaFilesTableUpdateCompanionBuilder,
    (MediaFile, BaseReferences<_$AppDatabase, $MediaFilesTable, MediaFile>),
    MediaFile,
    PrefetchHooks Function()>;
typedef $$TransfersTableCreateCompanionBuilder = TransfersCompanion Function({
  Value<int?> id,
  Value<int?> userId,
  Value<String> clientId,
  Value<String?> rev,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<DateTime?> lastSyncedAt,
  required double amount,
  Value<int?> fromWalletId,
  Value<int?> toWalletId,
  Value<String?> fromWalletClientId,
  Value<String?> toWalletClientId,
  Value<double?> exchangeRate,
  required DateTime datetime,
  Value<String?> expenseTransactionClientId,
  Value<String?> incomeTransactionClientId,
  Value<int> rowid,
});
typedef $$TransfersTableUpdateCompanionBuilder = TransfersCompanion Function({
  Value<int?> id,
  Value<int?> userId,
  Value<String> clientId,
  Value<String?> rev,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<DateTime?> lastSyncedAt,
  Value<double> amount,
  Value<int?> fromWalletId,
  Value<int?> toWalletId,
  Value<String?> fromWalletClientId,
  Value<String?> toWalletClientId,
  Value<double?> exchangeRate,
  Value<DateTime> datetime,
  Value<String?> expenseTransactionClientId,
  Value<String?> incomeTransactionClientId,
  Value<int> rowid,
});

final class $$TransfersTableReferences
    extends BaseReferences<_$AppDatabase, $TransfersTable, Transfer> {
  $$TransfersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $WalletsTable _fromWalletClientIdTable(_$AppDatabase db) =>
      db.wallets.createAlias($_aliasNameGenerator(
          db.transfers.fromWalletClientId, db.wallets.clientId));

  $$WalletsTableProcessedTableManager? get fromWalletClientId {
    final $_column = $_itemColumn<String>('from_wallet_client_id');
    if ($_column == null) return null;
    final manager = $$WalletsTableTableManager($_db, $_db.wallets)
        .filter((f) => f.clientId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_fromWalletClientIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $WalletsTable _toWalletClientIdTable(_$AppDatabase db) =>
      db.wallets.createAlias($_aliasNameGenerator(
          db.transfers.toWalletClientId, db.wallets.clientId));

  $$WalletsTableProcessedTableManager? get toWalletClientId {
    final $_column = $_itemColumn<String>('to_wallet_client_id');
    if ($_column == null) return null;
    final manager = $$WalletsTableTableManager($_db, $_db.wallets)
        .filter((f) => f.clientId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_toWalletClientIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $TransactionsTable _expenseTransactionClientIdTable(
          _$AppDatabase db) =>
      db.transactions.createAlias($_aliasNameGenerator(
          db.transfers.expenseTransactionClientId, db.transactions.clientId));

  $$TransactionsTableProcessedTableManager? get expenseTransactionClientId {
    final $_column = $_itemColumn<String>('expense_transaction_client_id');
    if ($_column == null) return null;
    final manager = $$TransactionsTableTableManager($_db, $_db.transactions)
        .filter((f) => f.clientId.sqlEquals($_column));
    final item =
        $_typedResult.readTableOrNull(_expenseTransactionClientIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $TransactionsTable _incomeTransactionClientIdTable(_$AppDatabase db) =>
      db.transactions.createAlias($_aliasNameGenerator(
          db.transfers.incomeTransactionClientId, db.transactions.clientId));

  $$TransactionsTableProcessedTableManager? get incomeTransactionClientId {
    final $_column = $_itemColumn<String>('income_transaction_client_id');
    if ($_column == null) return null;
    final manager = $$TransactionsTableTableManager($_db, $_db.transactions)
        .filter((f) => f.clientId.sqlEquals($_column));
    final item =
        $_typedResult.readTableOrNull(_incomeTransactionClientIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$TransfersTableFilterComposer
    extends Composer<_$AppDatabase, $TransfersTable> {
  $$TransfersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get clientId => $composableBuilder(
      column: $table.clientId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get rev => $composableBuilder(
      column: $table.rev, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastSyncedAt => $composableBuilder(
      column: $table.lastSyncedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get fromWalletId => $composableBuilder(
      column: $table.fromWalletId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get toWalletId => $composableBuilder(
      column: $table.toWalletId, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get exchangeRate => $composableBuilder(
      column: $table.exchangeRate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get datetime => $composableBuilder(
      column: $table.datetime, builder: (column) => ColumnFilters(column));

  $$WalletsTableFilterComposer get fromWalletClientId {
    final $$WalletsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.fromWalletClientId,
        referencedTable: $db.wallets,
        getReferencedColumn: (t) => t.clientId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WalletsTableFilterComposer(
              $db: $db,
              $table: $db.wallets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$WalletsTableFilterComposer get toWalletClientId {
    final $$WalletsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.toWalletClientId,
        referencedTable: $db.wallets,
        getReferencedColumn: (t) => t.clientId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WalletsTableFilterComposer(
              $db: $db,
              $table: $db.wallets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$TransactionsTableFilterComposer get expenseTransactionClientId {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.expenseTransactionClientId,
        referencedTable: $db.transactions,
        getReferencedColumn: (t) => t.clientId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionsTableFilterComposer(
              $db: $db,
              $table: $db.transactions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$TransactionsTableFilterComposer get incomeTransactionClientId {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.incomeTransactionClientId,
        referencedTable: $db.transactions,
        getReferencedColumn: (t) => t.clientId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionsTableFilterComposer(
              $db: $db,
              $table: $db.transactions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TransfersTableOrderingComposer
    extends Composer<_$AppDatabase, $TransfersTable> {
  $$TransfersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get clientId => $composableBuilder(
      column: $table.clientId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get rev => $composableBuilder(
      column: $table.rev, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastSyncedAt => $composableBuilder(
      column: $table.lastSyncedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get fromWalletId => $composableBuilder(
      column: $table.fromWalletId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get toWalletId => $composableBuilder(
      column: $table.toWalletId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get exchangeRate => $composableBuilder(
      column: $table.exchangeRate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get datetime => $composableBuilder(
      column: $table.datetime, builder: (column) => ColumnOrderings(column));

  $$WalletsTableOrderingComposer get fromWalletClientId {
    final $$WalletsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.fromWalletClientId,
        referencedTable: $db.wallets,
        getReferencedColumn: (t) => t.clientId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WalletsTableOrderingComposer(
              $db: $db,
              $table: $db.wallets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$WalletsTableOrderingComposer get toWalletClientId {
    final $$WalletsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.toWalletClientId,
        referencedTable: $db.wallets,
        getReferencedColumn: (t) => t.clientId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WalletsTableOrderingComposer(
              $db: $db,
              $table: $db.wallets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$TransactionsTableOrderingComposer get expenseTransactionClientId {
    final $$TransactionsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.expenseTransactionClientId,
        referencedTable: $db.transactions,
        getReferencedColumn: (t) => t.clientId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionsTableOrderingComposer(
              $db: $db,
              $table: $db.transactions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$TransactionsTableOrderingComposer get incomeTransactionClientId {
    final $$TransactionsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.incomeTransactionClientId,
        referencedTable: $db.transactions,
        getReferencedColumn: (t) => t.clientId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionsTableOrderingComposer(
              $db: $db,
              $table: $db.transactions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TransfersTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransfersTable> {
  $$TransfersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get clientId =>
      $composableBuilder(column: $table.clientId, builder: (column) => column);

  GeneratedColumn<String> get rev =>
      $composableBuilder(column: $table.rev, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSyncedAt => $composableBuilder(
      column: $table.lastSyncedAt, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<int> get fromWalletId => $composableBuilder(
      column: $table.fromWalletId, builder: (column) => column);

  GeneratedColumn<int> get toWalletId => $composableBuilder(
      column: $table.toWalletId, builder: (column) => column);

  GeneratedColumn<double> get exchangeRate => $composableBuilder(
      column: $table.exchangeRate, builder: (column) => column);

  GeneratedColumn<DateTime> get datetime =>
      $composableBuilder(column: $table.datetime, builder: (column) => column);

  $$WalletsTableAnnotationComposer get fromWalletClientId {
    final $$WalletsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.fromWalletClientId,
        referencedTable: $db.wallets,
        getReferencedColumn: (t) => t.clientId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WalletsTableAnnotationComposer(
              $db: $db,
              $table: $db.wallets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$WalletsTableAnnotationComposer get toWalletClientId {
    final $$WalletsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.toWalletClientId,
        referencedTable: $db.wallets,
        getReferencedColumn: (t) => t.clientId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WalletsTableAnnotationComposer(
              $db: $db,
              $table: $db.wallets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$TransactionsTableAnnotationComposer get expenseTransactionClientId {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.expenseTransactionClientId,
        referencedTable: $db.transactions,
        getReferencedColumn: (t) => t.clientId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionsTableAnnotationComposer(
              $db: $db,
              $table: $db.transactions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$TransactionsTableAnnotationComposer get incomeTransactionClientId {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.incomeTransactionClientId,
        referencedTable: $db.transactions,
        getReferencedColumn: (t) => t.clientId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionsTableAnnotationComposer(
              $db: $db,
              $table: $db.transactions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TransfersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TransfersTable,
    Transfer,
    $$TransfersTableFilterComposer,
    $$TransfersTableOrderingComposer,
    $$TransfersTableAnnotationComposer,
    $$TransfersTableCreateCompanionBuilder,
    $$TransfersTableUpdateCompanionBuilder,
    (Transfer, $$TransfersTableReferences),
    Transfer,
    PrefetchHooks Function(
        {bool fromWalletClientId,
        bool toWalletClientId,
        bool expenseTransactionClientId,
        bool incomeTransactionClientId})> {
  $$TransfersTableTableManager(_$AppDatabase db, $TransfersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransfersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransfersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransfersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int?> id = const Value.absent(),
            Value<int?> userId = const Value.absent(),
            Value<String> clientId = const Value.absent(),
            Value<String?> rev = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<DateTime?> lastSyncedAt = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<int?> fromWalletId = const Value.absent(),
            Value<int?> toWalletId = const Value.absent(),
            Value<String?> fromWalletClientId = const Value.absent(),
            Value<String?> toWalletClientId = const Value.absent(),
            Value<double?> exchangeRate = const Value.absent(),
            Value<DateTime> datetime = const Value.absent(),
            Value<String?> expenseTransactionClientId = const Value.absent(),
            Value<String?> incomeTransactionClientId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TransfersCompanion(
            id: id,
            userId: userId,
            clientId: clientId,
            rev: rev,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            lastSyncedAt: lastSyncedAt,
            amount: amount,
            fromWalletId: fromWalletId,
            toWalletId: toWalletId,
            fromWalletClientId: fromWalletClientId,
            toWalletClientId: toWalletClientId,
            exchangeRate: exchangeRate,
            datetime: datetime,
            expenseTransactionClientId: expenseTransactionClientId,
            incomeTransactionClientId: incomeTransactionClientId,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<int?> id = const Value.absent(),
            Value<int?> userId = const Value.absent(),
            Value<String> clientId = const Value.absent(),
            Value<String?> rev = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<DateTime?> lastSyncedAt = const Value.absent(),
            required double amount,
            Value<int?> fromWalletId = const Value.absent(),
            Value<int?> toWalletId = const Value.absent(),
            Value<String?> fromWalletClientId = const Value.absent(),
            Value<String?> toWalletClientId = const Value.absent(),
            Value<double?> exchangeRate = const Value.absent(),
            required DateTime datetime,
            Value<String?> expenseTransactionClientId = const Value.absent(),
            Value<String?> incomeTransactionClientId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TransfersCompanion.insert(
            id: id,
            userId: userId,
            clientId: clientId,
            rev: rev,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            lastSyncedAt: lastSyncedAt,
            amount: amount,
            fromWalletId: fromWalletId,
            toWalletId: toWalletId,
            fromWalletClientId: fromWalletClientId,
            toWalletClientId: toWalletClientId,
            exchangeRate: exchangeRate,
            datetime: datetime,
            expenseTransactionClientId: expenseTransactionClientId,
            incomeTransactionClientId: incomeTransactionClientId,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$TransfersTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {fromWalletClientId = false,
              toWalletClientId = false,
              expenseTransactionClientId = false,
              incomeTransactionClientId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (fromWalletClientId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.fromWalletClientId,
                    referencedTable:
                        $$TransfersTableReferences._fromWalletClientIdTable(db),
                    referencedColumn: $$TransfersTableReferences
                        ._fromWalletClientIdTable(db)
                        .clientId,
                  ) as T;
                }
                if (toWalletClientId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.toWalletClientId,
                    referencedTable:
                        $$TransfersTableReferences._toWalletClientIdTable(db),
                    referencedColumn: $$TransfersTableReferences
                        ._toWalletClientIdTable(db)
                        .clientId,
                  ) as T;
                }
                if (expenseTransactionClientId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.expenseTransactionClientId,
                    referencedTable: $$TransfersTableReferences
                        ._expenseTransactionClientIdTable(db),
                    referencedColumn: $$TransfersTableReferences
                        ._expenseTransactionClientIdTable(db)
                        .clientId,
                  ) as T;
                }
                if (incomeTransactionClientId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.incomeTransactionClientId,
                    referencedTable: $$TransfersTableReferences
                        ._incomeTransactionClientIdTable(db),
                    referencedColumn: $$TransfersTableReferences
                        ._incomeTransactionClientIdTable(db)
                        .clientId,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$TransfersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TransfersTable,
    Transfer,
    $$TransfersTableFilterComposer,
    $$TransfersTableOrderingComposer,
    $$TransfersTableAnnotationComposer,
    $$TransfersTableCreateCompanionBuilder,
    $$TransfersTableUpdateCompanionBuilder,
    (Transfer, $$TransfersTableReferences),
    Transfer,
    PrefetchHooks Function(
        {bool fromWalletClientId,
        bool toWalletClientId,
        bool expenseTransactionClientId,
        bool incomeTransactionClientId})>;
typedef $$BudgetsTableCreateCompanionBuilder = BudgetsCompanion Function({
  Value<int?> id,
  Value<int?> userId,
  Value<String> clientId,
  Value<String?> rev,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<DateTime?> lastSyncedAt,
  required String name,
  required String slug,
  Value<String?> description,
  required double amount,
  required String currency,
  required BudgetPeriodType periodType,
  required DateTime startDate,
  Value<DateTime?> endDate,
  Value<bool> rolloverEnabled,
  Value<int> thresholdPercent,
  Value<bool> forecastAlertsEnabled,
  Value<bool> isActive,
  Value<String> ownerType,
  Value<int?> ownerId,
  Value<int> rowid,
});
typedef $$BudgetsTableUpdateCompanionBuilder = BudgetsCompanion Function({
  Value<int?> id,
  Value<int?> userId,
  Value<String> clientId,
  Value<String?> rev,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<DateTime?> lastSyncedAt,
  Value<String> name,
  Value<String> slug,
  Value<String?> description,
  Value<double> amount,
  Value<String> currency,
  Value<BudgetPeriodType> periodType,
  Value<DateTime> startDate,
  Value<DateTime?> endDate,
  Value<bool> rolloverEnabled,
  Value<int> thresholdPercent,
  Value<bool> forecastAlertsEnabled,
  Value<bool> isActive,
  Value<String> ownerType,
  Value<int?> ownerId,
  Value<int> rowid,
});

final class $$BudgetsTableReferences
    extends BaseReferences<_$AppDatabase, $BudgetsTable, Budget> {
  $$BudgetsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$BudgetablesTable, List<Budgetable>>
      _budgetablesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.budgetables,
              aliasName: $_aliasNameGenerator(
                  db.budgets.clientId, db.budgetables.budgetClientId));

  $$BudgetablesTableProcessedTableManager get budgetablesRefs {
    final manager = $$BudgetablesTableTableManager($_db, $_db.budgetables)
        .filter((f) => f.budgetClientId.clientId
            .sqlEquals($_itemColumn<String>('client_id')!));

    final cache = $_typedResult.readTableOrNull(_budgetablesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$BudgetPeriodStatesTable, List<BudgetPeriodState>>
      _budgetPeriodStatesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.budgetPeriodStates,
              aliasName: $_aliasNameGenerator(
                  db.budgets.clientId, db.budgetPeriodStates.budgetClientId));

  $$BudgetPeriodStatesTableProcessedTableManager get budgetPeriodStatesRefs {
    final manager =
        $$BudgetPeriodStatesTableTableManager($_db, $_db.budgetPeriodStates)
            .filter((f) => f.budgetClientId.clientId
                .sqlEquals($_itemColumn<String>('client_id')!));

    final cache =
        $_typedResult.readTableOrNull(_budgetPeriodStatesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$BudgetsTableFilterComposer
    extends Composer<_$AppDatabase, $BudgetsTable> {
  $$BudgetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get clientId => $composableBuilder(
      column: $table.clientId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get rev => $composableBuilder(
      column: $table.rev, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastSyncedAt => $composableBuilder(
      column: $table.lastSyncedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get slug => $composableBuilder(
      column: $table.slug, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<BudgetPeriodType, BudgetPeriodType, String>
      get periodType => $composableBuilder(
          column: $table.periodType,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get endDate => $composableBuilder(
      column: $table.endDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get rolloverEnabled => $composableBuilder(
      column: $table.rolloverEnabled,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get thresholdPercent => $composableBuilder(
      column: $table.thresholdPercent,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get forecastAlertsEnabled => $composableBuilder(
      column: $table.forecastAlertsEnabled,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get ownerType => $composableBuilder(
      column: $table.ownerType, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get ownerId => $composableBuilder(
      column: $table.ownerId, builder: (column) => ColumnFilters(column));

  Expression<bool> budgetablesRefs(
      Expression<bool> Function($$BudgetablesTableFilterComposer f) f) {
    final $$BudgetablesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.clientId,
        referencedTable: $db.budgetables,
        getReferencedColumn: (t) => t.budgetClientId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BudgetablesTableFilterComposer(
              $db: $db,
              $table: $db.budgetables,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> budgetPeriodStatesRefs(
      Expression<bool> Function($$BudgetPeriodStatesTableFilterComposer f) f) {
    final $$BudgetPeriodStatesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.clientId,
        referencedTable: $db.budgetPeriodStates,
        getReferencedColumn: (t) => t.budgetClientId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BudgetPeriodStatesTableFilterComposer(
              $db: $db,
              $table: $db.budgetPeriodStates,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$BudgetsTableOrderingComposer
    extends Composer<_$AppDatabase, $BudgetsTable> {
  $$BudgetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get clientId => $composableBuilder(
      column: $table.clientId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get rev => $composableBuilder(
      column: $table.rev, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastSyncedAt => $composableBuilder(
      column: $table.lastSyncedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get slug => $composableBuilder(
      column: $table.slug, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get periodType => $composableBuilder(
      column: $table.periodType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
      column: $table.endDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get rolloverEnabled => $composableBuilder(
      column: $table.rolloverEnabled,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get thresholdPercent => $composableBuilder(
      column: $table.thresholdPercent,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get forecastAlertsEnabled => $composableBuilder(
      column: $table.forecastAlertsEnabled,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get ownerType => $composableBuilder(
      column: $table.ownerType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get ownerId => $composableBuilder(
      column: $table.ownerId, builder: (column) => ColumnOrderings(column));
}

class $$BudgetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BudgetsTable> {
  $$BudgetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get clientId =>
      $composableBuilder(column: $table.clientId, builder: (column) => column);

  GeneratedColumn<String> get rev =>
      $composableBuilder(column: $table.rev, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSyncedAt => $composableBuilder(
      column: $table.lastSyncedAt, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get slug =>
      $composableBuilder(column: $table.slug, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumnWithTypeConverter<BudgetPeriodType, String> get periodType =>
      $composableBuilder(
          column: $table.periodType, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<bool> get rolloverEnabled => $composableBuilder(
      column: $table.rolloverEnabled, builder: (column) => column);

  GeneratedColumn<int> get thresholdPercent => $composableBuilder(
      column: $table.thresholdPercent, builder: (column) => column);

  GeneratedColumn<bool> get forecastAlertsEnabled => $composableBuilder(
      column: $table.forecastAlertsEnabled, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<String> get ownerType =>
      $composableBuilder(column: $table.ownerType, builder: (column) => column);

  GeneratedColumn<int> get ownerId =>
      $composableBuilder(column: $table.ownerId, builder: (column) => column);

  Expression<T> budgetablesRefs<T extends Object>(
      Expression<T> Function($$BudgetablesTableAnnotationComposer a) f) {
    final $$BudgetablesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.clientId,
        referencedTable: $db.budgetables,
        getReferencedColumn: (t) => t.budgetClientId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BudgetablesTableAnnotationComposer(
              $db: $db,
              $table: $db.budgetables,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> budgetPeriodStatesRefs<T extends Object>(
      Expression<T> Function($$BudgetPeriodStatesTableAnnotationComposer a) f) {
    final $$BudgetPeriodStatesTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.clientId,
            referencedTable: $db.budgetPeriodStates,
            getReferencedColumn: (t) => t.budgetClientId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$BudgetPeriodStatesTableAnnotationComposer(
                  $db: $db,
                  $table: $db.budgetPeriodStates,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$BudgetsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BudgetsTable,
    Budget,
    $$BudgetsTableFilterComposer,
    $$BudgetsTableOrderingComposer,
    $$BudgetsTableAnnotationComposer,
    $$BudgetsTableCreateCompanionBuilder,
    $$BudgetsTableUpdateCompanionBuilder,
    (Budget, $$BudgetsTableReferences),
    Budget,
    PrefetchHooks Function(
        {bool budgetablesRefs, bool budgetPeriodStatesRefs})> {
  $$BudgetsTableTableManager(_$AppDatabase db, $BudgetsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BudgetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BudgetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BudgetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int?> id = const Value.absent(),
            Value<int?> userId = const Value.absent(),
            Value<String> clientId = const Value.absent(),
            Value<String?> rev = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<DateTime?> lastSyncedAt = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> slug = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<String> currency = const Value.absent(),
            Value<BudgetPeriodType> periodType = const Value.absent(),
            Value<DateTime> startDate = const Value.absent(),
            Value<DateTime?> endDate = const Value.absent(),
            Value<bool> rolloverEnabled = const Value.absent(),
            Value<int> thresholdPercent = const Value.absent(),
            Value<bool> forecastAlertsEnabled = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<String> ownerType = const Value.absent(),
            Value<int?> ownerId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BudgetsCompanion(
            id: id,
            userId: userId,
            clientId: clientId,
            rev: rev,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            lastSyncedAt: lastSyncedAt,
            name: name,
            slug: slug,
            description: description,
            amount: amount,
            currency: currency,
            periodType: periodType,
            startDate: startDate,
            endDate: endDate,
            rolloverEnabled: rolloverEnabled,
            thresholdPercent: thresholdPercent,
            forecastAlertsEnabled: forecastAlertsEnabled,
            isActive: isActive,
            ownerType: ownerType,
            ownerId: ownerId,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<int?> id = const Value.absent(),
            Value<int?> userId = const Value.absent(),
            Value<String> clientId = const Value.absent(),
            Value<String?> rev = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<DateTime?> lastSyncedAt = const Value.absent(),
            required String name,
            required String slug,
            Value<String?> description = const Value.absent(),
            required double amount,
            required String currency,
            required BudgetPeriodType periodType,
            required DateTime startDate,
            Value<DateTime?> endDate = const Value.absent(),
            Value<bool> rolloverEnabled = const Value.absent(),
            Value<int> thresholdPercent = const Value.absent(),
            Value<bool> forecastAlertsEnabled = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<String> ownerType = const Value.absent(),
            Value<int?> ownerId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BudgetsCompanion.insert(
            id: id,
            userId: userId,
            clientId: clientId,
            rev: rev,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            lastSyncedAt: lastSyncedAt,
            name: name,
            slug: slug,
            description: description,
            amount: amount,
            currency: currency,
            periodType: periodType,
            startDate: startDate,
            endDate: endDate,
            rolloverEnabled: rolloverEnabled,
            thresholdPercent: thresholdPercent,
            forecastAlertsEnabled: forecastAlertsEnabled,
            isActive: isActive,
            ownerType: ownerType,
            ownerId: ownerId,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$BudgetsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {budgetablesRefs = false, budgetPeriodStatesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (budgetablesRefs) db.budgetables,
                if (budgetPeriodStatesRefs) db.budgetPeriodStates
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (budgetablesRefs)
                    await $_getPrefetchedData<Budget, $BudgetsTable,
                            Budgetable>(
                        currentTable: table,
                        referencedTable:
                            $$BudgetsTableReferences._budgetablesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$BudgetsTableReferences(db, table, p0)
                                .budgetablesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems.where(
                                (e) => e.budgetClientId == item.clientId),
                        typedResults: items),
                  if (budgetPeriodStatesRefs)
                    await $_getPrefetchedData<Budget, $BudgetsTable,
                            BudgetPeriodState>(
                        currentTable: table,
                        referencedTable: $$BudgetsTableReferences
                            ._budgetPeriodStatesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$BudgetsTableReferences(db, table, p0)
                                .budgetPeriodStatesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems.where(
                                (e) => e.budgetClientId == item.clientId),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$BudgetsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $BudgetsTable,
    Budget,
    $$BudgetsTableFilterComposer,
    $$BudgetsTableOrderingComposer,
    $$BudgetsTableAnnotationComposer,
    $$BudgetsTableCreateCompanionBuilder,
    $$BudgetsTableUpdateCompanionBuilder,
    (Budget, $$BudgetsTableReferences),
    Budget,
    PrefetchHooks Function(
        {bool budgetablesRefs, bool budgetPeriodStatesRefs})>;
typedef $$BudgetablesTableCreateCompanionBuilder = BudgetablesCompanion
    Function({
  required String budgetClientId,
  required BudgetTargetType targetType,
  required String targetClientId,
  Value<int> rowid,
});
typedef $$BudgetablesTableUpdateCompanionBuilder = BudgetablesCompanion
    Function({
  Value<String> budgetClientId,
  Value<BudgetTargetType> targetType,
  Value<String> targetClientId,
  Value<int> rowid,
});

final class $$BudgetablesTableReferences
    extends BaseReferences<_$AppDatabase, $BudgetablesTable, Budgetable> {
  $$BudgetablesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $BudgetsTable _budgetClientIdTable(_$AppDatabase db) =>
      db.budgets.createAlias($_aliasNameGenerator(
          db.budgetables.budgetClientId, db.budgets.clientId));

  $$BudgetsTableProcessedTableManager get budgetClientId {
    final $_column = $_itemColumn<String>('budget_client_id')!;

    final manager = $$BudgetsTableTableManager($_db, $_db.budgets)
        .filter((f) => f.clientId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_budgetClientIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$BudgetablesTableFilterComposer
    extends Composer<_$AppDatabase, $BudgetablesTable> {
  $$BudgetablesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnWithTypeConverterFilters<BudgetTargetType, BudgetTargetType, String>
      get targetType => $composableBuilder(
          column: $table.targetType,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get targetClientId => $composableBuilder(
      column: $table.targetClientId,
      builder: (column) => ColumnFilters(column));

  $$BudgetsTableFilterComposer get budgetClientId {
    final $$BudgetsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.budgetClientId,
        referencedTable: $db.budgets,
        getReferencedColumn: (t) => t.clientId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BudgetsTableFilterComposer(
              $db: $db,
              $table: $db.budgets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$BudgetablesTableOrderingComposer
    extends Composer<_$AppDatabase, $BudgetablesTable> {
  $$BudgetablesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get targetType => $composableBuilder(
      column: $table.targetType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get targetClientId => $composableBuilder(
      column: $table.targetClientId,
      builder: (column) => ColumnOrderings(column));

  $$BudgetsTableOrderingComposer get budgetClientId {
    final $$BudgetsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.budgetClientId,
        referencedTable: $db.budgets,
        getReferencedColumn: (t) => t.clientId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BudgetsTableOrderingComposer(
              $db: $db,
              $table: $db.budgets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$BudgetablesTableAnnotationComposer
    extends Composer<_$AppDatabase, $BudgetablesTable> {
  $$BudgetablesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumnWithTypeConverter<BudgetTargetType, String> get targetType =>
      $composableBuilder(
          column: $table.targetType, builder: (column) => column);

  GeneratedColumn<String> get targetClientId => $composableBuilder(
      column: $table.targetClientId, builder: (column) => column);

  $$BudgetsTableAnnotationComposer get budgetClientId {
    final $$BudgetsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.budgetClientId,
        referencedTable: $db.budgets,
        getReferencedColumn: (t) => t.clientId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BudgetsTableAnnotationComposer(
              $db: $db,
              $table: $db.budgets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$BudgetablesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BudgetablesTable,
    Budgetable,
    $$BudgetablesTableFilterComposer,
    $$BudgetablesTableOrderingComposer,
    $$BudgetablesTableAnnotationComposer,
    $$BudgetablesTableCreateCompanionBuilder,
    $$BudgetablesTableUpdateCompanionBuilder,
    (Budgetable, $$BudgetablesTableReferences),
    Budgetable,
    PrefetchHooks Function({bool budgetClientId})> {
  $$BudgetablesTableTableManager(_$AppDatabase db, $BudgetablesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BudgetablesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BudgetablesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BudgetablesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> budgetClientId = const Value.absent(),
            Value<BudgetTargetType> targetType = const Value.absent(),
            Value<String> targetClientId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BudgetablesCompanion(
            budgetClientId: budgetClientId,
            targetType: targetType,
            targetClientId: targetClientId,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String budgetClientId,
            required BudgetTargetType targetType,
            required String targetClientId,
            Value<int> rowid = const Value.absent(),
          }) =>
              BudgetablesCompanion.insert(
            budgetClientId: budgetClientId,
            targetType: targetType,
            targetClientId: targetClientId,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$BudgetablesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({budgetClientId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (budgetClientId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.budgetClientId,
                    referencedTable:
                        $$BudgetablesTableReferences._budgetClientIdTable(db),
                    referencedColumn: $$BudgetablesTableReferences
                        ._budgetClientIdTable(db)
                        .clientId,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$BudgetablesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $BudgetablesTable,
    Budgetable,
    $$BudgetablesTableFilterComposer,
    $$BudgetablesTableOrderingComposer,
    $$BudgetablesTableAnnotationComposer,
    $$BudgetablesTableCreateCompanionBuilder,
    $$BudgetablesTableUpdateCompanionBuilder,
    (Budgetable, $$BudgetablesTableReferences),
    Budgetable,
    PrefetchHooks Function({bool budgetClientId})>;
typedef $$BudgetPeriodStatesTableCreateCompanionBuilder
    = BudgetPeriodStatesCompanion Function({
  Value<int?> id,
  Value<int?> userId,
  Value<String> clientId,
  Value<String?> rev,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<DateTime?> lastSyncedAt,
  required String budgetClientId,
  required DateTime periodStart,
  required DateTime periodEnd,
  Value<double> netSpent,
  Value<double> rolloverIn,
  Value<double> rolloverOut,
  Value<DateTime?> closedAt,
  Value<int> rowid,
});
typedef $$BudgetPeriodStatesTableUpdateCompanionBuilder
    = BudgetPeriodStatesCompanion Function({
  Value<int?> id,
  Value<int?> userId,
  Value<String> clientId,
  Value<String?> rev,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<DateTime?> lastSyncedAt,
  Value<String> budgetClientId,
  Value<DateTime> periodStart,
  Value<DateTime> periodEnd,
  Value<double> netSpent,
  Value<double> rolloverIn,
  Value<double> rolloverOut,
  Value<DateTime?> closedAt,
  Value<int> rowid,
});

final class $$BudgetPeriodStatesTableReferences extends BaseReferences<
    _$AppDatabase, $BudgetPeriodStatesTable, BudgetPeriodState> {
  $$BudgetPeriodStatesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $BudgetsTable _budgetClientIdTable(_$AppDatabase db) =>
      db.budgets.createAlias($_aliasNameGenerator(
          db.budgetPeriodStates.budgetClientId, db.budgets.clientId));

  $$BudgetsTableProcessedTableManager get budgetClientId {
    final $_column = $_itemColumn<String>('budget_client_id')!;

    final manager = $$BudgetsTableTableManager($_db, $_db.budgets)
        .filter((f) => f.clientId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_budgetClientIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$BudgetPeriodStatesTableFilterComposer
    extends Composer<_$AppDatabase, $BudgetPeriodStatesTable> {
  $$BudgetPeriodStatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get clientId => $composableBuilder(
      column: $table.clientId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get rev => $composableBuilder(
      column: $table.rev, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastSyncedAt => $composableBuilder(
      column: $table.lastSyncedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get periodStart => $composableBuilder(
      column: $table.periodStart, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get periodEnd => $composableBuilder(
      column: $table.periodEnd, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get netSpent => $composableBuilder(
      column: $table.netSpent, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get rolloverIn => $composableBuilder(
      column: $table.rolloverIn, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get rolloverOut => $composableBuilder(
      column: $table.rolloverOut, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get closedAt => $composableBuilder(
      column: $table.closedAt, builder: (column) => ColumnFilters(column));

  $$BudgetsTableFilterComposer get budgetClientId {
    final $$BudgetsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.budgetClientId,
        referencedTable: $db.budgets,
        getReferencedColumn: (t) => t.clientId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BudgetsTableFilterComposer(
              $db: $db,
              $table: $db.budgets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$BudgetPeriodStatesTableOrderingComposer
    extends Composer<_$AppDatabase, $BudgetPeriodStatesTable> {
  $$BudgetPeriodStatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get clientId => $composableBuilder(
      column: $table.clientId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get rev => $composableBuilder(
      column: $table.rev, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastSyncedAt => $composableBuilder(
      column: $table.lastSyncedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get periodStart => $composableBuilder(
      column: $table.periodStart, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get periodEnd => $composableBuilder(
      column: $table.periodEnd, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get netSpent => $composableBuilder(
      column: $table.netSpent, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get rolloverIn => $composableBuilder(
      column: $table.rolloverIn, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get rolloverOut => $composableBuilder(
      column: $table.rolloverOut, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get closedAt => $composableBuilder(
      column: $table.closedAt, builder: (column) => ColumnOrderings(column));

  $$BudgetsTableOrderingComposer get budgetClientId {
    final $$BudgetsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.budgetClientId,
        referencedTable: $db.budgets,
        getReferencedColumn: (t) => t.clientId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BudgetsTableOrderingComposer(
              $db: $db,
              $table: $db.budgets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$BudgetPeriodStatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $BudgetPeriodStatesTable> {
  $$BudgetPeriodStatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get clientId =>
      $composableBuilder(column: $table.clientId, builder: (column) => column);

  GeneratedColumn<String> get rev =>
      $composableBuilder(column: $table.rev, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSyncedAt => $composableBuilder(
      column: $table.lastSyncedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get periodStart => $composableBuilder(
      column: $table.periodStart, builder: (column) => column);

  GeneratedColumn<DateTime> get periodEnd =>
      $composableBuilder(column: $table.periodEnd, builder: (column) => column);

  GeneratedColumn<double> get netSpent =>
      $composableBuilder(column: $table.netSpent, builder: (column) => column);

  GeneratedColumn<double> get rolloverIn => $composableBuilder(
      column: $table.rolloverIn, builder: (column) => column);

  GeneratedColumn<double> get rolloverOut => $composableBuilder(
      column: $table.rolloverOut, builder: (column) => column);

  GeneratedColumn<DateTime> get closedAt =>
      $composableBuilder(column: $table.closedAt, builder: (column) => column);

  $$BudgetsTableAnnotationComposer get budgetClientId {
    final $$BudgetsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.budgetClientId,
        referencedTable: $db.budgets,
        getReferencedColumn: (t) => t.clientId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BudgetsTableAnnotationComposer(
              $db: $db,
              $table: $db.budgets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$BudgetPeriodStatesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BudgetPeriodStatesTable,
    BudgetPeriodState,
    $$BudgetPeriodStatesTableFilterComposer,
    $$BudgetPeriodStatesTableOrderingComposer,
    $$BudgetPeriodStatesTableAnnotationComposer,
    $$BudgetPeriodStatesTableCreateCompanionBuilder,
    $$BudgetPeriodStatesTableUpdateCompanionBuilder,
    (BudgetPeriodState, $$BudgetPeriodStatesTableReferences),
    BudgetPeriodState,
    PrefetchHooks Function({bool budgetClientId})> {
  $$BudgetPeriodStatesTableTableManager(
      _$AppDatabase db, $BudgetPeriodStatesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BudgetPeriodStatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BudgetPeriodStatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BudgetPeriodStatesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int?> id = const Value.absent(),
            Value<int?> userId = const Value.absent(),
            Value<String> clientId = const Value.absent(),
            Value<String?> rev = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<DateTime?> lastSyncedAt = const Value.absent(),
            Value<String> budgetClientId = const Value.absent(),
            Value<DateTime> periodStart = const Value.absent(),
            Value<DateTime> periodEnd = const Value.absent(),
            Value<double> netSpent = const Value.absent(),
            Value<double> rolloverIn = const Value.absent(),
            Value<double> rolloverOut = const Value.absent(),
            Value<DateTime?> closedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BudgetPeriodStatesCompanion(
            id: id,
            userId: userId,
            clientId: clientId,
            rev: rev,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            lastSyncedAt: lastSyncedAt,
            budgetClientId: budgetClientId,
            periodStart: periodStart,
            periodEnd: periodEnd,
            netSpent: netSpent,
            rolloverIn: rolloverIn,
            rolloverOut: rolloverOut,
            closedAt: closedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<int?> id = const Value.absent(),
            Value<int?> userId = const Value.absent(),
            Value<String> clientId = const Value.absent(),
            Value<String?> rev = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<DateTime?> lastSyncedAt = const Value.absent(),
            required String budgetClientId,
            required DateTime periodStart,
            required DateTime periodEnd,
            Value<double> netSpent = const Value.absent(),
            Value<double> rolloverIn = const Value.absent(),
            Value<double> rolloverOut = const Value.absent(),
            Value<DateTime?> closedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BudgetPeriodStatesCompanion.insert(
            id: id,
            userId: userId,
            clientId: clientId,
            rev: rev,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            lastSyncedAt: lastSyncedAt,
            budgetClientId: budgetClientId,
            periodStart: periodStart,
            periodEnd: periodEnd,
            netSpent: netSpent,
            rolloverIn: rolloverIn,
            rolloverOut: rolloverOut,
            closedAt: closedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$BudgetPeriodStatesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({budgetClientId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (budgetClientId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.budgetClientId,
                    referencedTable: $$BudgetPeriodStatesTableReferences
                        ._budgetClientIdTable(db),
                    referencedColumn: $$BudgetPeriodStatesTableReferences
                        ._budgetClientIdTable(db)
                        .clientId,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$BudgetPeriodStatesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $BudgetPeriodStatesTable,
    BudgetPeriodState,
    $$BudgetPeriodStatesTableFilterComposer,
    $$BudgetPeriodStatesTableOrderingComposer,
    $$BudgetPeriodStatesTableAnnotationComposer,
    $$BudgetPeriodStatesTableCreateCompanionBuilder,
    $$BudgetPeriodStatesTableUpdateCompanionBuilder,
    (BudgetPeriodState, $$BudgetPeriodStatesTableReferences),
    BudgetPeriodState,
    PrefetchHooks Function({bool budgetClientId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$WalletsTableTableManager get wallets =>
      $$WalletsTableTableManager(_db, _db.wallets);
  $$PartiesTableTableManager get parties =>
      $$PartiesTableTableManager(_db, _db.parties);
  $$GroupsTableTableManager get groups =>
      $$GroupsTableTableManager(_db, _db.groups);
  $$TransactionsTableTableManager get transactions =>
      $$TransactionsTableTableManager(_db, _db.transactions);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
  $$ConfigsTableTableManager get configs =>
      $$ConfigsTableTableManager(_db, _db.configs);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$LocalChangesTableTableManager get localChanges =>
      $$LocalChangesTableTableManager(_db, _db.localChanges);
  $$SyncMetadataTableTableManager get syncMetadata =>
      $$SyncMetadataTableTableManager(_db, _db.syncMetadata);
  $$CategorizablesTableTableManager get categorizables =>
      $$CategorizablesTableTableManager(_db, _db.categorizables);
  $$NotificationsTableTableManager get notifications =>
      $$NotificationsTableTableManager(_db, _db.notifications);
  $$MediaFilesTableTableManager get mediaFiles =>
      $$MediaFilesTableTableManager(_db, _db.mediaFiles);
  $$TransfersTableTableManager get transfers =>
      $$TransfersTableTableManager(_db, _db.transfers);
  $$BudgetsTableTableManager get budgets =>
      $$BudgetsTableTableManager(_db, _db.budgets);
  $$BudgetablesTableTableManager get budgetables =>
      $$BudgetablesTableTableManager(_db, _db.budgetables);
  $$BudgetPeriodStatesTableTableManager get budgetPeriodStates =>
      $$BudgetPeriodStatesTableTableManager(_db, _db.budgetPeriodStates);
}

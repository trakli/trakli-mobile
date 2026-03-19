// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transfer_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TransferDto _$TransferDtoFromJson(Map<String, dynamic> json) {
  return _TransferDto.fromJson(json);
}

/// @nodoc
mixin _$TransferDto {
  int? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  int? get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'client_generated_id', defaultValue: defaultClientId)
  String get clientId => throw _privateConstructorUsedError;
  String? get rev => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'deleted_at')
  DateTime? get deletedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_synced_at')
  DateTime? get lastSyncedAt => throw _privateConstructorUsedError;
  @JsonKey(fromJson: parseAmount)
  double get amount => throw _privateConstructorUsedError;
  @JsonKey(name: 'from_wallet_id')
  int? get fromWalletId => throw _privateConstructorUsedError;
  @JsonKey(name: 'to_wallet_id')
  int? get toWalletId => throw _privateConstructorUsedError;
  @JsonKey(name: 'from_wallet_client_id')
  String? get fromWalletClientId => throw _privateConstructorUsedError;
  @JsonKey(name: 'to_wallet_client_id')
  String? get toWalletClientId => throw _privateConstructorUsedError;
  @JsonKey(name: 'exchange_rate', fromJson: parseAmountNullable)
  double? get exchangeRate => throw _privateConstructorUsedError;
  DateTime get datetime => throw _privateConstructorUsedError;
  @JsonKey(name: 'expense_transaction_client_id')
  String? get expenseTransactionClientId => throw _privateConstructorUsedError;
  @JsonKey(name: 'income_transaction_client_id')
  String? get incomeTransactionClientId => throw _privateConstructorUsedError;

  /// Serializes this TransferDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TransferDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransferDtoCopyWith<TransferDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransferDtoCopyWith<$Res> {
  factory $TransferDtoCopyWith(
          TransferDto value, $Res Function(TransferDto) then) =
      _$TransferDtoCopyWithImpl<$Res, TransferDto>;
  @useResult
  $Res call(
      {int? id,
      @JsonKey(name: 'user_id') int? userId,
      @JsonKey(name: 'client_generated_id', defaultValue: defaultClientId)
      String clientId,
      String? rev,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      @JsonKey(name: 'deleted_at') DateTime? deletedAt,
      @JsonKey(name: 'last_synced_at') DateTime? lastSyncedAt,
      @JsonKey(fromJson: parseAmount) double amount,
      @JsonKey(name: 'from_wallet_id') int? fromWalletId,
      @JsonKey(name: 'to_wallet_id') int? toWalletId,
      @JsonKey(name: 'from_wallet_client_id') String? fromWalletClientId,
      @JsonKey(name: 'to_wallet_client_id') String? toWalletClientId,
      @JsonKey(name: 'exchange_rate', fromJson: parseAmountNullable)
      double? exchangeRate,
      DateTime datetime,
      @JsonKey(name: 'expense_transaction_client_id')
      String? expenseTransactionClientId,
      @JsonKey(name: 'income_transaction_client_id')
      String? incomeTransactionClientId});
}

/// @nodoc
class _$TransferDtoCopyWithImpl<$Res, $Val extends TransferDto>
    implements $TransferDtoCopyWith<$Res> {
  _$TransferDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TransferDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? userId = freezed,
    Object? clientId = null,
    Object? rev = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? deletedAt = freezed,
    Object? lastSyncedAt = freezed,
    Object? amount = null,
    Object? fromWalletId = freezed,
    Object? toWalletId = freezed,
    Object? fromWalletClientId = freezed,
    Object? toWalletClientId = freezed,
    Object? exchangeRate = freezed,
    Object? datetime = null,
    Object? expenseTransactionClientId = freezed,
    Object? incomeTransactionClientId = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int?,
      clientId: null == clientId
          ? _value.clientId
          : clientId // ignore: cast_nullable_to_non_nullable
              as String,
      rev: freezed == rev
          ? _value.rev
          : rev // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      deletedAt: freezed == deletedAt
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastSyncedAt: freezed == lastSyncedAt
          ? _value.lastSyncedAt
          : lastSyncedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      fromWalletId: freezed == fromWalletId
          ? _value.fromWalletId
          : fromWalletId // ignore: cast_nullable_to_non_nullable
              as int?,
      toWalletId: freezed == toWalletId
          ? _value.toWalletId
          : toWalletId // ignore: cast_nullable_to_non_nullable
              as int?,
      fromWalletClientId: freezed == fromWalletClientId
          ? _value.fromWalletClientId
          : fromWalletClientId // ignore: cast_nullable_to_non_nullable
              as String?,
      toWalletClientId: freezed == toWalletClientId
          ? _value.toWalletClientId
          : toWalletClientId // ignore: cast_nullable_to_non_nullable
              as String?,
      exchangeRate: freezed == exchangeRate
          ? _value.exchangeRate
          : exchangeRate // ignore: cast_nullable_to_non_nullable
              as double?,
      datetime: null == datetime
          ? _value.datetime
          : datetime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      expenseTransactionClientId: freezed == expenseTransactionClientId
          ? _value.expenseTransactionClientId
          : expenseTransactionClientId // ignore: cast_nullable_to_non_nullable
              as String?,
      incomeTransactionClientId: freezed == incomeTransactionClientId
          ? _value.incomeTransactionClientId
          : incomeTransactionClientId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TransferDtoImplCopyWith<$Res>
    implements $TransferDtoCopyWith<$Res> {
  factory _$$TransferDtoImplCopyWith(
          _$TransferDtoImpl value, $Res Function(_$TransferDtoImpl) then) =
      __$$TransferDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      @JsonKey(name: 'user_id') int? userId,
      @JsonKey(name: 'client_generated_id', defaultValue: defaultClientId)
      String clientId,
      String? rev,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      @JsonKey(name: 'deleted_at') DateTime? deletedAt,
      @JsonKey(name: 'last_synced_at') DateTime? lastSyncedAt,
      @JsonKey(fromJson: parseAmount) double amount,
      @JsonKey(name: 'from_wallet_id') int? fromWalletId,
      @JsonKey(name: 'to_wallet_id') int? toWalletId,
      @JsonKey(name: 'from_wallet_client_id') String? fromWalletClientId,
      @JsonKey(name: 'to_wallet_client_id') String? toWalletClientId,
      @JsonKey(name: 'exchange_rate', fromJson: parseAmountNullable)
      double? exchangeRate,
      DateTime datetime,
      @JsonKey(name: 'expense_transaction_client_id')
      String? expenseTransactionClientId,
      @JsonKey(name: 'income_transaction_client_id')
      String? incomeTransactionClientId});
}

/// @nodoc
class __$$TransferDtoImplCopyWithImpl<$Res>
    extends _$TransferDtoCopyWithImpl<$Res, _$TransferDtoImpl>
    implements _$$TransferDtoImplCopyWith<$Res> {
  __$$TransferDtoImplCopyWithImpl(
      _$TransferDtoImpl _value, $Res Function(_$TransferDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of TransferDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? userId = freezed,
    Object? clientId = null,
    Object? rev = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? deletedAt = freezed,
    Object? lastSyncedAt = freezed,
    Object? amount = null,
    Object? fromWalletId = freezed,
    Object? toWalletId = freezed,
    Object? fromWalletClientId = freezed,
    Object? toWalletClientId = freezed,
    Object? exchangeRate = freezed,
    Object? datetime = null,
    Object? expenseTransactionClientId = freezed,
    Object? incomeTransactionClientId = freezed,
  }) {
    return _then(_$TransferDtoImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int?,
      clientId: null == clientId
          ? _value.clientId
          : clientId // ignore: cast_nullable_to_non_nullable
              as String,
      rev: freezed == rev
          ? _value.rev
          : rev // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      deletedAt: freezed == deletedAt
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastSyncedAt: freezed == lastSyncedAt
          ? _value.lastSyncedAt
          : lastSyncedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      fromWalletId: freezed == fromWalletId
          ? _value.fromWalletId
          : fromWalletId // ignore: cast_nullable_to_non_nullable
              as int?,
      toWalletId: freezed == toWalletId
          ? _value.toWalletId
          : toWalletId // ignore: cast_nullable_to_non_nullable
              as int?,
      fromWalletClientId: freezed == fromWalletClientId
          ? _value.fromWalletClientId
          : fromWalletClientId // ignore: cast_nullable_to_non_nullable
              as String?,
      toWalletClientId: freezed == toWalletClientId
          ? _value.toWalletClientId
          : toWalletClientId // ignore: cast_nullable_to_non_nullable
              as String?,
      exchangeRate: freezed == exchangeRate
          ? _value.exchangeRate
          : exchangeRate // ignore: cast_nullable_to_non_nullable
              as double?,
      datetime: null == datetime
          ? _value.datetime
          : datetime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      expenseTransactionClientId: freezed == expenseTransactionClientId
          ? _value.expenseTransactionClientId
          : expenseTransactionClientId // ignore: cast_nullable_to_non_nullable
              as String?,
      incomeTransactionClientId: freezed == incomeTransactionClientId
          ? _value.incomeTransactionClientId
          : incomeTransactionClientId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TransferDtoImpl extends _TransferDto {
  const _$TransferDtoImpl(
      {this.id,
      @JsonKey(name: 'user_id') this.userId,
      @JsonKey(name: 'client_generated_id', defaultValue: defaultClientId)
      required this.clientId,
      this.rev,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') required this.updatedAt,
      @JsonKey(name: 'deleted_at') this.deletedAt,
      @JsonKey(name: 'last_synced_at') this.lastSyncedAt,
      @JsonKey(fromJson: parseAmount) required this.amount,
      @JsonKey(name: 'from_wallet_id') this.fromWalletId,
      @JsonKey(name: 'to_wallet_id') this.toWalletId,
      @JsonKey(name: 'from_wallet_client_id') this.fromWalletClientId,
      @JsonKey(name: 'to_wallet_client_id') this.toWalletClientId,
      @JsonKey(name: 'exchange_rate', fromJson: parseAmountNullable)
      this.exchangeRate,
      required this.datetime,
      @JsonKey(name: 'expense_transaction_client_id')
      this.expenseTransactionClientId,
      @JsonKey(name: 'income_transaction_client_id')
      this.incomeTransactionClientId})
      : super._();

  factory _$TransferDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransferDtoImplFromJson(json);

  @override
  final int? id;
  @override
  @JsonKey(name: 'user_id')
  final int? userId;
  @override
  @JsonKey(name: 'client_generated_id', defaultValue: defaultClientId)
  final String clientId;
  @override
  final String? rev;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  @override
  @JsonKey(name: 'deleted_at')
  final DateTime? deletedAt;
  @override
  @JsonKey(name: 'last_synced_at')
  final DateTime? lastSyncedAt;
  @override
  @JsonKey(fromJson: parseAmount)
  final double amount;
  @override
  @JsonKey(name: 'from_wallet_id')
  final int? fromWalletId;
  @override
  @JsonKey(name: 'to_wallet_id')
  final int? toWalletId;
  @override
  @JsonKey(name: 'from_wallet_client_id')
  final String? fromWalletClientId;
  @override
  @JsonKey(name: 'to_wallet_client_id')
  final String? toWalletClientId;
  @override
  @JsonKey(name: 'exchange_rate', fromJson: parseAmountNullable)
  final double? exchangeRate;
  @override
  final DateTime datetime;
  @override
  @JsonKey(name: 'expense_transaction_client_id')
  final String? expenseTransactionClientId;
  @override
  @JsonKey(name: 'income_transaction_client_id')
  final String? incomeTransactionClientId;

  @override
  String toString() {
    return 'TransferDto(id: $id, userId: $userId, clientId: $clientId, rev: $rev, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, lastSyncedAt: $lastSyncedAt, amount: $amount, fromWalletId: $fromWalletId, toWalletId: $toWalletId, fromWalletClientId: $fromWalletClientId, toWalletClientId: $toWalletClientId, exchangeRate: $exchangeRate, datetime: $datetime, expenseTransactionClientId: $expenseTransactionClientId, incomeTransactionClientId: $incomeTransactionClientId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransferDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.clientId, clientId) ||
                other.clientId == clientId) &&
            (identical(other.rev, rev) || other.rev == rev) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt) &&
            (identical(other.lastSyncedAt, lastSyncedAt) ||
                other.lastSyncedAt == lastSyncedAt) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.fromWalletId, fromWalletId) ||
                other.fromWalletId == fromWalletId) &&
            (identical(other.toWalletId, toWalletId) ||
                other.toWalletId == toWalletId) &&
            (identical(other.fromWalletClientId, fromWalletClientId) ||
                other.fromWalletClientId == fromWalletClientId) &&
            (identical(other.toWalletClientId, toWalletClientId) ||
                other.toWalletClientId == toWalletClientId) &&
            (identical(other.exchangeRate, exchangeRate) ||
                other.exchangeRate == exchangeRate) &&
            (identical(other.datetime, datetime) ||
                other.datetime == datetime) &&
            (identical(other.expenseTransactionClientId,
                    expenseTransactionClientId) ||
                other.expenseTransactionClientId ==
                    expenseTransactionClientId) &&
            (identical(other.incomeTransactionClientId,
                    incomeTransactionClientId) ||
                other.incomeTransactionClientId == incomeTransactionClientId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
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

  /// Create a copy of TransferDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransferDtoImplCopyWith<_$TransferDtoImpl> get copyWith =>
      __$$TransferDtoImplCopyWithImpl<_$TransferDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TransferDtoImplToJson(
      this,
    );
  }
}

abstract class _TransferDto extends TransferDto {
  const factory _TransferDto(
      {final int? id,
      @JsonKey(name: 'user_id') final int? userId,
      @JsonKey(name: 'client_generated_id', defaultValue: defaultClientId)
      required final String clientId,
      final String? rev,
      @JsonKey(name: 'created_at') required final DateTime createdAt,
      @JsonKey(name: 'updated_at') required final DateTime updatedAt,
      @JsonKey(name: 'deleted_at') final DateTime? deletedAt,
      @JsonKey(name: 'last_synced_at') final DateTime? lastSyncedAt,
      @JsonKey(fromJson: parseAmount) required final double amount,
      @JsonKey(name: 'from_wallet_id') final int? fromWalletId,
      @JsonKey(name: 'to_wallet_id') final int? toWalletId,
      @JsonKey(name: 'from_wallet_client_id') final String? fromWalletClientId,
      @JsonKey(name: 'to_wallet_client_id') final String? toWalletClientId,
      @JsonKey(name: 'exchange_rate', fromJson: parseAmountNullable)
      final double? exchangeRate,
      required final DateTime datetime,
      @JsonKey(name: 'expense_transaction_client_id')
      final String? expenseTransactionClientId,
      @JsonKey(name: 'income_transaction_client_id')
      final String? incomeTransactionClientId}) = _$TransferDtoImpl;
  const _TransferDto._() : super._();

  factory _TransferDto.fromJson(Map<String, dynamic> json) =
      _$TransferDtoImpl.fromJson;

  @override
  int? get id;
  @override
  @JsonKey(name: 'user_id')
  int? get userId;
  @override
  @JsonKey(name: 'client_generated_id', defaultValue: defaultClientId)
  String get clientId;
  @override
  String? get rev;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;
  @override
  @JsonKey(name: 'deleted_at')
  DateTime? get deletedAt;
  @override
  @JsonKey(name: 'last_synced_at')
  DateTime? get lastSyncedAt;
  @override
  @JsonKey(fromJson: parseAmount)
  double get amount;
  @override
  @JsonKey(name: 'from_wallet_id')
  int? get fromWalletId;
  @override
  @JsonKey(name: 'to_wallet_id')
  int? get toWalletId;
  @override
  @JsonKey(name: 'from_wallet_client_id')
  String? get fromWalletClientId;
  @override
  @JsonKey(name: 'to_wallet_client_id')
  String? get toWalletClientId;
  @override
  @JsonKey(name: 'exchange_rate', fromJson: parseAmountNullable)
  double? get exchangeRate;
  @override
  DateTime get datetime;
  @override
  @JsonKey(name: 'expense_transaction_client_id')
  String? get expenseTransactionClientId;
  @override
  @JsonKey(name: 'income_transaction_client_id')
  String? get incomeTransactionClientId;

  /// Create a copy of TransferDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransferDtoImplCopyWith<_$TransferDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

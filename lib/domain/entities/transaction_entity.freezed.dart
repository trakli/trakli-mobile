// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TransactionEntity _$TransactionEntityFromJson(Map<String, dynamic> json) {
  return _TransactionEntity.fromJson(json);
}

/// @nodoc
mixin _$TransactionEntity {
  String get clientId => throw _privateConstructorUsedError;
  int? get id => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  DateTime get datetime => throw _privateConstructorUsedError;
  TransactionType get type => throw _privateConstructorUsedError;
  TransactionIntent get intent => throw _privateConstructorUsedError;
  bool get isRefund => throw _privateConstructorUsedError;
  int? get refundOfTransactionId => throw _privateConstructorUsedError;
  String? get recurrencePeriod => throw _privateConstructorUsedError;
  int? get recurrenceInterval => throw _privateConstructorUsedError;
  DateTime? get recurrenceEndsAt => throw _privateConstructorUsedError;
  DateTime? get recurrenceNextScheduledAt => throw _privateConstructorUsedError;
  DateTime? get lastSyncedAt => throw _privateConstructorUsedError;
  String get rev => throw _privateConstructorUsedError;
  String get walletClientId => throw _privateConstructorUsedError;
  String? get partyClientId => throw _privateConstructorUsedError;
  String? get groupClientId => throw _privateConstructorUsedError;
  int? get transferId => throw _privateConstructorUsedError;
  String? get transferClientId => throw _privateConstructorUsedError;

  /// Serializes this TransactionEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TransactionEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransactionEntityCopyWith<TransactionEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransactionEntityCopyWith<$Res> {
  factory $TransactionEntityCopyWith(
          TransactionEntity value, $Res Function(TransactionEntity) then) =
      _$TransactionEntityCopyWithImpl<$Res, TransactionEntity>;
  @useResult
  $Res call(
      {String clientId,
      int? id,
      double amount,
      String description,
      DateTime createdAt,
      DateTime updatedAt,
      DateTime datetime,
      TransactionType type,
      TransactionIntent intent,
      bool isRefund,
      int? refundOfTransactionId,
      String? recurrencePeriod,
      int? recurrenceInterval,
      DateTime? recurrenceEndsAt,
      DateTime? recurrenceNextScheduledAt,
      DateTime? lastSyncedAt,
      String rev,
      String walletClientId,
      String? partyClientId,
      String? groupClientId,
      int? transferId,
      String? transferClientId});
}

/// @nodoc
class _$TransactionEntityCopyWithImpl<$Res, $Val extends TransactionEntity>
    implements $TransactionEntityCopyWith<$Res> {
  _$TransactionEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TransactionEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? clientId = null,
    Object? id = freezed,
    Object? amount = null,
    Object? description = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? datetime = null,
    Object? type = null,
    Object? intent = null,
    Object? isRefund = null,
    Object? refundOfTransactionId = freezed,
    Object? recurrencePeriod = freezed,
    Object? recurrenceInterval = freezed,
    Object? recurrenceEndsAt = freezed,
    Object? recurrenceNextScheduledAt = freezed,
    Object? lastSyncedAt = freezed,
    Object? rev = null,
    Object? walletClientId = null,
    Object? partyClientId = freezed,
    Object? groupClientId = freezed,
    Object? transferId = freezed,
    Object? transferClientId = freezed,
  }) {
    return _then(_value.copyWith(
      clientId: null == clientId
          ? _value.clientId
          : clientId // ignore: cast_nullable_to_non_nullable
              as String,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      datetime: null == datetime
          ? _value.datetime
          : datetime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as TransactionType,
      intent: null == intent
          ? _value.intent
          : intent // ignore: cast_nullable_to_non_nullable
              as TransactionIntent,
      isRefund: null == isRefund
          ? _value.isRefund
          : isRefund // ignore: cast_nullable_to_non_nullable
              as bool,
      refundOfTransactionId: freezed == refundOfTransactionId
          ? _value.refundOfTransactionId
          : refundOfTransactionId // ignore: cast_nullable_to_non_nullable
              as int?,
      recurrencePeriod: freezed == recurrencePeriod
          ? _value.recurrencePeriod
          : recurrencePeriod // ignore: cast_nullable_to_non_nullable
              as String?,
      recurrenceInterval: freezed == recurrenceInterval
          ? _value.recurrenceInterval
          : recurrenceInterval // ignore: cast_nullable_to_non_nullable
              as int?,
      recurrenceEndsAt: freezed == recurrenceEndsAt
          ? _value.recurrenceEndsAt
          : recurrenceEndsAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      recurrenceNextScheduledAt: freezed == recurrenceNextScheduledAt
          ? _value.recurrenceNextScheduledAt
          : recurrenceNextScheduledAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastSyncedAt: freezed == lastSyncedAt
          ? _value.lastSyncedAt
          : lastSyncedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      rev: null == rev
          ? _value.rev
          : rev // ignore: cast_nullable_to_non_nullable
              as String,
      walletClientId: null == walletClientId
          ? _value.walletClientId
          : walletClientId // ignore: cast_nullable_to_non_nullable
              as String,
      partyClientId: freezed == partyClientId
          ? _value.partyClientId
          : partyClientId // ignore: cast_nullable_to_non_nullable
              as String?,
      groupClientId: freezed == groupClientId
          ? _value.groupClientId
          : groupClientId // ignore: cast_nullable_to_non_nullable
              as String?,
      transferId: freezed == transferId
          ? _value.transferId
          : transferId // ignore: cast_nullable_to_non_nullable
              as int?,
      transferClientId: freezed == transferClientId
          ? _value.transferClientId
          : transferClientId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TransactionEntityImplCopyWith<$Res>
    implements $TransactionEntityCopyWith<$Res> {
  factory _$$TransactionEntityImplCopyWith(_$TransactionEntityImpl value,
          $Res Function(_$TransactionEntityImpl) then) =
      __$$TransactionEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String clientId,
      int? id,
      double amount,
      String description,
      DateTime createdAt,
      DateTime updatedAt,
      DateTime datetime,
      TransactionType type,
      TransactionIntent intent,
      bool isRefund,
      int? refundOfTransactionId,
      String? recurrencePeriod,
      int? recurrenceInterval,
      DateTime? recurrenceEndsAt,
      DateTime? recurrenceNextScheduledAt,
      DateTime? lastSyncedAt,
      String rev,
      String walletClientId,
      String? partyClientId,
      String? groupClientId,
      int? transferId,
      String? transferClientId});
}

/// @nodoc
class __$$TransactionEntityImplCopyWithImpl<$Res>
    extends _$TransactionEntityCopyWithImpl<$Res, _$TransactionEntityImpl>
    implements _$$TransactionEntityImplCopyWith<$Res> {
  __$$TransactionEntityImplCopyWithImpl(_$TransactionEntityImpl _value,
      $Res Function(_$TransactionEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of TransactionEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? clientId = null,
    Object? id = freezed,
    Object? amount = null,
    Object? description = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? datetime = null,
    Object? type = null,
    Object? intent = null,
    Object? isRefund = null,
    Object? refundOfTransactionId = freezed,
    Object? recurrencePeriod = freezed,
    Object? recurrenceInterval = freezed,
    Object? recurrenceEndsAt = freezed,
    Object? recurrenceNextScheduledAt = freezed,
    Object? lastSyncedAt = freezed,
    Object? rev = null,
    Object? walletClientId = null,
    Object? partyClientId = freezed,
    Object? groupClientId = freezed,
    Object? transferId = freezed,
    Object? transferClientId = freezed,
  }) {
    return _then(_$TransactionEntityImpl(
      clientId: null == clientId
          ? _value.clientId
          : clientId // ignore: cast_nullable_to_non_nullable
              as String,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      datetime: null == datetime
          ? _value.datetime
          : datetime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as TransactionType,
      intent: null == intent
          ? _value.intent
          : intent // ignore: cast_nullable_to_non_nullable
              as TransactionIntent,
      isRefund: null == isRefund
          ? _value.isRefund
          : isRefund // ignore: cast_nullable_to_non_nullable
              as bool,
      refundOfTransactionId: freezed == refundOfTransactionId
          ? _value.refundOfTransactionId
          : refundOfTransactionId // ignore: cast_nullable_to_non_nullable
              as int?,
      recurrencePeriod: freezed == recurrencePeriod
          ? _value.recurrencePeriod
          : recurrencePeriod // ignore: cast_nullable_to_non_nullable
              as String?,
      recurrenceInterval: freezed == recurrenceInterval
          ? _value.recurrenceInterval
          : recurrenceInterval // ignore: cast_nullable_to_non_nullable
              as int?,
      recurrenceEndsAt: freezed == recurrenceEndsAt
          ? _value.recurrenceEndsAt
          : recurrenceEndsAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      recurrenceNextScheduledAt: freezed == recurrenceNextScheduledAt
          ? _value.recurrenceNextScheduledAt
          : recurrenceNextScheduledAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastSyncedAt: freezed == lastSyncedAt
          ? _value.lastSyncedAt
          : lastSyncedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      rev: null == rev
          ? _value.rev
          : rev // ignore: cast_nullable_to_non_nullable
              as String,
      walletClientId: null == walletClientId
          ? _value.walletClientId
          : walletClientId // ignore: cast_nullable_to_non_nullable
              as String,
      partyClientId: freezed == partyClientId
          ? _value.partyClientId
          : partyClientId // ignore: cast_nullable_to_non_nullable
              as String?,
      groupClientId: freezed == groupClientId
          ? _value.groupClientId
          : groupClientId // ignore: cast_nullable_to_non_nullable
              as String?,
      transferId: freezed == transferId
          ? _value.transferId
          : transferId // ignore: cast_nullable_to_non_nullable
              as int?,
      transferClientId: freezed == transferClientId
          ? _value.transferClientId
          : transferClientId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TransactionEntityImpl implements _TransactionEntity {
  const _$TransactionEntityImpl(
      {required this.clientId,
      this.id,
      required this.amount,
      required this.description,
      required this.createdAt,
      required this.updatedAt,
      required this.datetime,
      required this.type,
      this.intent = TransactionIntent.regular,
      this.isRefund = false,
      this.refundOfTransactionId,
      this.recurrencePeriod,
      this.recurrenceInterval,
      this.recurrenceEndsAt,
      this.recurrenceNextScheduledAt,
      this.lastSyncedAt,
      this.rev = '1',
      required this.walletClientId,
      this.partyClientId,
      this.groupClientId,
      this.transferId,
      this.transferClientId});

  factory _$TransactionEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransactionEntityImplFromJson(json);

  @override
  final String clientId;
  @override
  final int? id;
  @override
  final double amount;
  @override
  final String description;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final DateTime datetime;
  @override
  final TransactionType type;
  @override
  @JsonKey()
  final TransactionIntent intent;
  @override
  @JsonKey()
  final bool isRefund;
  @override
  final int? refundOfTransactionId;
  @override
  final String? recurrencePeriod;
  @override
  final int? recurrenceInterval;
  @override
  final DateTime? recurrenceEndsAt;
  @override
  final DateTime? recurrenceNextScheduledAt;
  @override
  final DateTime? lastSyncedAt;
  @override
  @JsonKey()
  final String rev;
  @override
  final String walletClientId;
  @override
  final String? partyClientId;
  @override
  final String? groupClientId;
  @override
  final int? transferId;
  @override
  final String? transferClientId;

  @override
  String toString() {
    return 'TransactionEntity(clientId: $clientId, id: $id, amount: $amount, description: $description, createdAt: $createdAt, updatedAt: $updatedAt, datetime: $datetime, type: $type, intent: $intent, isRefund: $isRefund, refundOfTransactionId: $refundOfTransactionId, recurrencePeriod: $recurrencePeriod, recurrenceInterval: $recurrenceInterval, recurrenceEndsAt: $recurrenceEndsAt, recurrenceNextScheduledAt: $recurrenceNextScheduledAt, lastSyncedAt: $lastSyncedAt, rev: $rev, walletClientId: $walletClientId, partyClientId: $partyClientId, groupClientId: $groupClientId, transferId: $transferId, transferClientId: $transferClientId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionEntityImpl &&
            (identical(other.clientId, clientId) ||
                other.clientId == clientId) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.datetime, datetime) ||
                other.datetime == datetime) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.intent, intent) || other.intent == intent) &&
            (identical(other.isRefund, isRefund) ||
                other.isRefund == isRefund) &&
            (identical(other.refundOfTransactionId, refundOfTransactionId) ||
                other.refundOfTransactionId == refundOfTransactionId) &&
            (identical(other.recurrencePeriod, recurrencePeriod) ||
                other.recurrencePeriod == recurrencePeriod) &&
            (identical(other.recurrenceInterval, recurrenceInterval) ||
                other.recurrenceInterval == recurrenceInterval) &&
            (identical(other.recurrenceEndsAt, recurrenceEndsAt) ||
                other.recurrenceEndsAt == recurrenceEndsAt) &&
            (identical(other.recurrenceNextScheduledAt,
                    recurrenceNextScheduledAt) ||
                other.recurrenceNextScheduledAt == recurrenceNextScheduledAt) &&
            (identical(other.lastSyncedAt, lastSyncedAt) ||
                other.lastSyncedAt == lastSyncedAt) &&
            (identical(other.rev, rev) || other.rev == rev) &&
            (identical(other.walletClientId, walletClientId) ||
                other.walletClientId == walletClientId) &&
            (identical(other.partyClientId, partyClientId) ||
                other.partyClientId == partyClientId) &&
            (identical(other.groupClientId, groupClientId) ||
                other.groupClientId == groupClientId) &&
            (identical(other.transferId, transferId) ||
                other.transferId == transferId) &&
            (identical(other.transferClientId, transferClientId) ||
                other.transferClientId == transferClientId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        clientId,
        id,
        amount,
        description,
        createdAt,
        updatedAt,
        datetime,
        type,
        intent,
        isRefund,
        refundOfTransactionId,
        recurrencePeriod,
        recurrenceInterval,
        recurrenceEndsAt,
        recurrenceNextScheduledAt,
        lastSyncedAt,
        rev,
        walletClientId,
        partyClientId,
        groupClientId,
        transferId,
        transferClientId
      ]);

  /// Create a copy of TransactionEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransactionEntityImplCopyWith<_$TransactionEntityImpl> get copyWith =>
      __$$TransactionEntityImplCopyWithImpl<_$TransactionEntityImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TransactionEntityImplToJson(
      this,
    );
  }
}

abstract class _TransactionEntity implements TransactionEntity {
  const factory _TransactionEntity(
      {required final String clientId,
      final int? id,
      required final double amount,
      required final String description,
      required final DateTime createdAt,
      required final DateTime updatedAt,
      required final DateTime datetime,
      required final TransactionType type,
      final TransactionIntent intent,
      final bool isRefund,
      final int? refundOfTransactionId,
      final String? recurrencePeriod,
      final int? recurrenceInterval,
      final DateTime? recurrenceEndsAt,
      final DateTime? recurrenceNextScheduledAt,
      final DateTime? lastSyncedAt,
      final String rev,
      required final String walletClientId,
      final String? partyClientId,
      final String? groupClientId,
      final int? transferId,
      final String? transferClientId}) = _$TransactionEntityImpl;

  factory _TransactionEntity.fromJson(Map<String, dynamic> json) =
      _$TransactionEntityImpl.fromJson;

  @override
  String get clientId;
  @override
  int? get id;
  @override
  double get amount;
  @override
  String get description;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  DateTime get datetime;
  @override
  TransactionType get type;
  @override
  TransactionIntent get intent;
  @override
  bool get isRefund;
  @override
  int? get refundOfTransactionId;
  @override
  String? get recurrencePeriod;
  @override
  int? get recurrenceInterval;
  @override
  DateTime? get recurrenceEndsAt;
  @override
  DateTime? get recurrenceNextScheduledAt;
  @override
  DateTime? get lastSyncedAt;
  @override
  String get rev;
  @override
  String get walletClientId;
  @override
  String? get partyClientId;
  @override
  String? get groupClientId;
  @override
  int? get transferId;
  @override
  String? get transferClientId;

  /// Create a copy of TransactionEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransactionEntityImplCopyWith<_$TransactionEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

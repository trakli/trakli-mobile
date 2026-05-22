// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'budget_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$BudgetEntity {
  String get clientId => throw _privateConstructorUsedError;
  int? get id => throw _privateConstructorUsedError;
  int? get userId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get slug => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  BudgetPeriodType get periodType => throw _privateConstructorUsedError;
  DateTime get startDate => throw _privateConstructorUsedError;
  DateTime? get endDate => throw _privateConstructorUsedError;
  bool get rolloverEnabled => throw _privateConstructorUsedError;
  int get thresholdPercent => throw _privateConstructorUsedError;
  bool get forecastAlertsEnabled => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  String get ownerType => throw _privateConstructorUsedError;
  int? get ownerId => throw _privateConstructorUsedError;
  List<BudgetTargetEntity> get targets => throw _privateConstructorUsedError;
  BudgetProgressEntity? get progress => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  DateTime? get lastSyncedAt => throw _privateConstructorUsedError;

  /// Create a copy of BudgetEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BudgetEntityCopyWith<BudgetEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BudgetEntityCopyWith<$Res> {
  factory $BudgetEntityCopyWith(
          BudgetEntity value, $Res Function(BudgetEntity) then) =
      _$BudgetEntityCopyWithImpl<$Res, BudgetEntity>;
  @useResult
  $Res call(
      {String clientId,
      int? id,
      int? userId,
      String name,
      String? slug,
      String? description,
      double amount,
      String currency,
      BudgetPeriodType periodType,
      DateTime startDate,
      DateTime? endDate,
      bool rolloverEnabled,
      int thresholdPercent,
      bool forecastAlertsEnabled,
      bool isActive,
      String ownerType,
      int? ownerId,
      List<BudgetTargetEntity> targets,
      BudgetProgressEntity? progress,
      DateTime createdAt,
      DateTime? updatedAt,
      DateTime? lastSyncedAt});

  $BudgetProgressEntityCopyWith<$Res>? get progress;
}

/// @nodoc
class _$BudgetEntityCopyWithImpl<$Res, $Val extends BudgetEntity>
    implements $BudgetEntityCopyWith<$Res> {
  _$BudgetEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BudgetEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? clientId = null,
    Object? id = freezed,
    Object? userId = freezed,
    Object? name = null,
    Object? slug = freezed,
    Object? description = freezed,
    Object? amount = null,
    Object? currency = null,
    Object? periodType = null,
    Object? startDate = null,
    Object? endDate = freezed,
    Object? rolloverEnabled = null,
    Object? thresholdPercent = null,
    Object? forecastAlertsEnabled = null,
    Object? isActive = null,
    Object? ownerType = null,
    Object? ownerId = freezed,
    Object? targets = null,
    Object? progress = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? lastSyncedAt = freezed,
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
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      slug: freezed == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      periodType: null == periodType
          ? _value.periodType
          : periodType // ignore: cast_nullable_to_non_nullable
              as BudgetPeriodType,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      rolloverEnabled: null == rolloverEnabled
          ? _value.rolloverEnabled
          : rolloverEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      thresholdPercent: null == thresholdPercent
          ? _value.thresholdPercent
          : thresholdPercent // ignore: cast_nullable_to_non_nullable
              as int,
      forecastAlertsEnabled: null == forecastAlertsEnabled
          ? _value.forecastAlertsEnabled
          : forecastAlertsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      ownerType: null == ownerType
          ? _value.ownerType
          : ownerType // ignore: cast_nullable_to_non_nullable
              as String,
      ownerId: freezed == ownerId
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as int?,
      targets: null == targets
          ? _value.targets
          : targets // ignore: cast_nullable_to_non_nullable
              as List<BudgetTargetEntity>,
      progress: freezed == progress
          ? _value.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as BudgetProgressEntity?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastSyncedAt: freezed == lastSyncedAt
          ? _value.lastSyncedAt
          : lastSyncedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }

  /// Create a copy of BudgetEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BudgetProgressEntityCopyWith<$Res>? get progress {
    if (_value.progress == null) {
      return null;
    }

    return $BudgetProgressEntityCopyWith<$Res>(_value.progress!, (value) {
      return _then(_value.copyWith(progress: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$BudgetEntityImplCopyWith<$Res>
    implements $BudgetEntityCopyWith<$Res> {
  factory _$$BudgetEntityImplCopyWith(
          _$BudgetEntityImpl value, $Res Function(_$BudgetEntityImpl) then) =
      __$$BudgetEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String clientId,
      int? id,
      int? userId,
      String name,
      String? slug,
      String? description,
      double amount,
      String currency,
      BudgetPeriodType periodType,
      DateTime startDate,
      DateTime? endDate,
      bool rolloverEnabled,
      int thresholdPercent,
      bool forecastAlertsEnabled,
      bool isActive,
      String ownerType,
      int? ownerId,
      List<BudgetTargetEntity> targets,
      BudgetProgressEntity? progress,
      DateTime createdAt,
      DateTime? updatedAt,
      DateTime? lastSyncedAt});

  @override
  $BudgetProgressEntityCopyWith<$Res>? get progress;
}

/// @nodoc
class __$$BudgetEntityImplCopyWithImpl<$Res>
    extends _$BudgetEntityCopyWithImpl<$Res, _$BudgetEntityImpl>
    implements _$$BudgetEntityImplCopyWith<$Res> {
  __$$BudgetEntityImplCopyWithImpl(
      _$BudgetEntityImpl _value, $Res Function(_$BudgetEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of BudgetEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? clientId = null,
    Object? id = freezed,
    Object? userId = freezed,
    Object? name = null,
    Object? slug = freezed,
    Object? description = freezed,
    Object? amount = null,
    Object? currency = null,
    Object? periodType = null,
    Object? startDate = null,
    Object? endDate = freezed,
    Object? rolloverEnabled = null,
    Object? thresholdPercent = null,
    Object? forecastAlertsEnabled = null,
    Object? isActive = null,
    Object? ownerType = null,
    Object? ownerId = freezed,
    Object? targets = null,
    Object? progress = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? lastSyncedAt = freezed,
  }) {
    return _then(_$BudgetEntityImpl(
      clientId: null == clientId
          ? _value.clientId
          : clientId // ignore: cast_nullable_to_non_nullable
              as String,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      slug: freezed == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      periodType: null == periodType
          ? _value.periodType
          : periodType // ignore: cast_nullable_to_non_nullable
              as BudgetPeriodType,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      rolloverEnabled: null == rolloverEnabled
          ? _value.rolloverEnabled
          : rolloverEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      thresholdPercent: null == thresholdPercent
          ? _value.thresholdPercent
          : thresholdPercent // ignore: cast_nullable_to_non_nullable
              as int,
      forecastAlertsEnabled: null == forecastAlertsEnabled
          ? _value.forecastAlertsEnabled
          : forecastAlertsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      ownerType: null == ownerType
          ? _value.ownerType
          : ownerType // ignore: cast_nullable_to_non_nullable
              as String,
      ownerId: freezed == ownerId
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as int?,
      targets: null == targets
          ? _value._targets
          : targets // ignore: cast_nullable_to_non_nullable
              as List<BudgetTargetEntity>,
      progress: freezed == progress
          ? _value.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as BudgetProgressEntity?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastSyncedAt: freezed == lastSyncedAt
          ? _value.lastSyncedAt
          : lastSyncedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$BudgetEntityImpl implements _BudgetEntity {
  const _$BudgetEntityImpl(
      {required this.clientId,
      this.id,
      this.userId,
      required this.name,
      this.slug,
      this.description,
      required this.amount,
      required this.currency,
      required this.periodType,
      required this.startDate,
      this.endDate,
      this.rolloverEnabled = false,
      this.thresholdPercent = 80,
      this.forecastAlertsEnabled = false,
      this.isActive = true,
      this.ownerType = 'user',
      this.ownerId,
      final List<BudgetTargetEntity> targets = const [],
      this.progress,
      required this.createdAt,
      this.updatedAt,
      this.lastSyncedAt})
      : _targets = targets;

  @override
  final String clientId;
  @override
  final int? id;
  @override
  final int? userId;
  @override
  final String name;
  @override
  final String? slug;
  @override
  final String? description;
  @override
  final double amount;
  @override
  final String currency;
  @override
  final BudgetPeriodType periodType;
  @override
  final DateTime startDate;
  @override
  final DateTime? endDate;
  @override
  @JsonKey()
  final bool rolloverEnabled;
  @override
  @JsonKey()
  final int thresholdPercent;
  @override
  @JsonKey()
  final bool forecastAlertsEnabled;
  @override
  @JsonKey()
  final bool isActive;
  @override
  @JsonKey()
  final String ownerType;
  @override
  final int? ownerId;
  final List<BudgetTargetEntity> _targets;
  @override
  @JsonKey()
  List<BudgetTargetEntity> get targets {
    if (_targets is EqualUnmodifiableListView) return _targets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_targets);
  }

  @override
  final BudgetProgressEntity? progress;
  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;
  @override
  final DateTime? lastSyncedAt;

  @override
  String toString() {
    return 'BudgetEntity(clientId: $clientId, id: $id, userId: $userId, name: $name, slug: $slug, description: $description, amount: $amount, currency: $currency, periodType: $periodType, startDate: $startDate, endDate: $endDate, rolloverEnabled: $rolloverEnabled, thresholdPercent: $thresholdPercent, forecastAlertsEnabled: $forecastAlertsEnabled, isActive: $isActive, ownerType: $ownerType, ownerId: $ownerId, targets: $targets, progress: $progress, createdAt: $createdAt, updatedAt: $updatedAt, lastSyncedAt: $lastSyncedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BudgetEntityImpl &&
            (identical(other.clientId, clientId) ||
                other.clientId == clientId) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.periodType, periodType) ||
                other.periodType == periodType) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.rolloverEnabled, rolloverEnabled) ||
                other.rolloverEnabled == rolloverEnabled) &&
            (identical(other.thresholdPercent, thresholdPercent) ||
                other.thresholdPercent == thresholdPercent) &&
            (identical(other.forecastAlertsEnabled, forecastAlertsEnabled) ||
                other.forecastAlertsEnabled == forecastAlertsEnabled) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.ownerType, ownerType) ||
                other.ownerType == ownerType) &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId) &&
            const DeepCollectionEquality().equals(other._targets, _targets) &&
            (identical(other.progress, progress) ||
                other.progress == progress) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.lastSyncedAt, lastSyncedAt) ||
                other.lastSyncedAt == lastSyncedAt));
  }

  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        clientId,
        id,
        userId,
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
        const DeepCollectionEquality().hash(_targets),
        progress,
        createdAt,
        updatedAt,
        lastSyncedAt
      ]);

  /// Create a copy of BudgetEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BudgetEntityImplCopyWith<_$BudgetEntityImpl> get copyWith =>
      __$$BudgetEntityImplCopyWithImpl<_$BudgetEntityImpl>(this, _$identity);
}

abstract class _BudgetEntity implements BudgetEntity {
  const factory _BudgetEntity(
      {required final String clientId,
      final int? id,
      final int? userId,
      required final String name,
      final String? slug,
      final String? description,
      required final double amount,
      required final String currency,
      required final BudgetPeriodType periodType,
      required final DateTime startDate,
      final DateTime? endDate,
      final bool rolloverEnabled,
      final int thresholdPercent,
      final bool forecastAlertsEnabled,
      final bool isActive,
      final String ownerType,
      final int? ownerId,
      final List<BudgetTargetEntity> targets,
      final BudgetProgressEntity? progress,
      required final DateTime createdAt,
      final DateTime? updatedAt,
      final DateTime? lastSyncedAt}) = _$BudgetEntityImpl;

  @override
  String get clientId;
  @override
  int? get id;
  @override
  int? get userId;
  @override
  String get name;
  @override
  String? get slug;
  @override
  String? get description;
  @override
  double get amount;
  @override
  String get currency;
  @override
  BudgetPeriodType get periodType;
  @override
  DateTime get startDate;
  @override
  DateTime? get endDate;
  @override
  bool get rolloverEnabled;
  @override
  int get thresholdPercent;
  @override
  bool get forecastAlertsEnabled;
  @override
  bool get isActive;
  @override
  String get ownerType;
  @override
  int? get ownerId;
  @override
  List<BudgetTargetEntity> get targets;
  @override
  BudgetProgressEntity? get progress;
  @override
  DateTime get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  DateTime? get lastSyncedAt;

  /// Create a copy of BudgetEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BudgetEntityImplCopyWith<_$BudgetEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

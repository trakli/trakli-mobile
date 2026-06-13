// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'budget_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$BudgetState {
  List<BudgetEntity> get budgets => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isSaving => throw _privateConstructorUsedError;
  bool get isDeleting => throw _privateConstructorUsedError;
  bool get isProgressLoading => throw _privateConstructorUsedError;
  bool get isClosingPeriod => throw _privateConstructorUsedError;
  BudgetProgressEntity? get selectedBudgetProgress =>
      throw _privateConstructorUsedError;
  List<BudgetTargetEntity> get selectedBudgetTargets =>
      throw _privateConstructorUsedError;
  List<BudgetPeriodStateEntity> get selectedBudgetPeriodStates =>
      throw _privateConstructorUsedError;
  Failure get failure => throw _privateConstructorUsedError;

  /// Create a copy of BudgetState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BudgetStateCopyWith<BudgetState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BudgetStateCopyWith<$Res> {
  factory $BudgetStateCopyWith(
          BudgetState value, $Res Function(BudgetState) then) =
      _$BudgetStateCopyWithImpl<$Res, BudgetState>;
  @useResult
  $Res call(
      {List<BudgetEntity> budgets,
      bool isLoading,
      bool isSaving,
      bool isDeleting,
      bool isProgressLoading,
      bool isClosingPeriod,
      BudgetProgressEntity? selectedBudgetProgress,
      List<BudgetTargetEntity> selectedBudgetTargets,
      List<BudgetPeriodStateEntity> selectedBudgetPeriodStates,
      Failure failure});

  $BudgetProgressEntityCopyWith<$Res>? get selectedBudgetProgress;
  $FailureCopyWith<$Res> get failure;
}

/// @nodoc
class _$BudgetStateCopyWithImpl<$Res, $Val extends BudgetState>
    implements $BudgetStateCopyWith<$Res> {
  _$BudgetStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BudgetState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? budgets = null,
    Object? isLoading = null,
    Object? isSaving = null,
    Object? isDeleting = null,
    Object? isProgressLoading = null,
    Object? isClosingPeriod = null,
    Object? selectedBudgetProgress = freezed,
    Object? selectedBudgetTargets = null,
    Object? selectedBudgetPeriodStates = null,
    Object? failure = null,
  }) {
    return _then(_value.copyWith(
      budgets: null == budgets
          ? _value.budgets
          : budgets // ignore: cast_nullable_to_non_nullable
              as List<BudgetEntity>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isSaving: null == isSaving
          ? _value.isSaving
          : isSaving // ignore: cast_nullable_to_non_nullable
              as bool,
      isDeleting: null == isDeleting
          ? _value.isDeleting
          : isDeleting // ignore: cast_nullable_to_non_nullable
              as bool,
      isProgressLoading: null == isProgressLoading
          ? _value.isProgressLoading
          : isProgressLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isClosingPeriod: null == isClosingPeriod
          ? _value.isClosingPeriod
          : isClosingPeriod // ignore: cast_nullable_to_non_nullable
              as bool,
      selectedBudgetProgress: freezed == selectedBudgetProgress
          ? _value.selectedBudgetProgress
          : selectedBudgetProgress // ignore: cast_nullable_to_non_nullable
              as BudgetProgressEntity?,
      selectedBudgetTargets: null == selectedBudgetTargets
          ? _value.selectedBudgetTargets
          : selectedBudgetTargets // ignore: cast_nullable_to_non_nullable
              as List<BudgetTargetEntity>,
      selectedBudgetPeriodStates: null == selectedBudgetPeriodStates
          ? _value.selectedBudgetPeriodStates
          : selectedBudgetPeriodStates // ignore: cast_nullable_to_non_nullable
              as List<BudgetPeriodStateEntity>,
      failure: null == failure
          ? _value.failure
          : failure // ignore: cast_nullable_to_non_nullable
              as Failure,
    ) as $Val);
  }

  /// Create a copy of BudgetState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BudgetProgressEntityCopyWith<$Res>? get selectedBudgetProgress {
    if (_value.selectedBudgetProgress == null) {
      return null;
    }

    return $BudgetProgressEntityCopyWith<$Res>(_value.selectedBudgetProgress!,
        (value) {
      return _then(_value.copyWith(selectedBudgetProgress: value) as $Val);
    });
  }

  /// Create a copy of BudgetState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FailureCopyWith<$Res> get failure {
    return $FailureCopyWith<$Res>(_value.failure, (value) {
      return _then(_value.copyWith(failure: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$BudgetStateImplCopyWith<$Res>
    implements $BudgetStateCopyWith<$Res> {
  factory _$$BudgetStateImplCopyWith(
          _$BudgetStateImpl value, $Res Function(_$BudgetStateImpl) then) =
      __$$BudgetStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<BudgetEntity> budgets,
      bool isLoading,
      bool isSaving,
      bool isDeleting,
      bool isProgressLoading,
      bool isClosingPeriod,
      BudgetProgressEntity? selectedBudgetProgress,
      List<BudgetTargetEntity> selectedBudgetTargets,
      List<BudgetPeriodStateEntity> selectedBudgetPeriodStates,
      Failure failure});

  @override
  $BudgetProgressEntityCopyWith<$Res>? get selectedBudgetProgress;
  @override
  $FailureCopyWith<$Res> get failure;
}

/// @nodoc
class __$$BudgetStateImplCopyWithImpl<$Res>
    extends _$BudgetStateCopyWithImpl<$Res, _$BudgetStateImpl>
    implements _$$BudgetStateImplCopyWith<$Res> {
  __$$BudgetStateImplCopyWithImpl(
      _$BudgetStateImpl _value, $Res Function(_$BudgetStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of BudgetState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? budgets = null,
    Object? isLoading = null,
    Object? isSaving = null,
    Object? isDeleting = null,
    Object? isProgressLoading = null,
    Object? isClosingPeriod = null,
    Object? selectedBudgetProgress = freezed,
    Object? selectedBudgetTargets = null,
    Object? selectedBudgetPeriodStates = null,
    Object? failure = null,
  }) {
    return _then(_$BudgetStateImpl(
      budgets: null == budgets
          ? _value._budgets
          : budgets // ignore: cast_nullable_to_non_nullable
              as List<BudgetEntity>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isSaving: null == isSaving
          ? _value.isSaving
          : isSaving // ignore: cast_nullable_to_non_nullable
              as bool,
      isDeleting: null == isDeleting
          ? _value.isDeleting
          : isDeleting // ignore: cast_nullable_to_non_nullable
              as bool,
      isProgressLoading: null == isProgressLoading
          ? _value.isProgressLoading
          : isProgressLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isClosingPeriod: null == isClosingPeriod
          ? _value.isClosingPeriod
          : isClosingPeriod // ignore: cast_nullable_to_non_nullable
              as bool,
      selectedBudgetProgress: freezed == selectedBudgetProgress
          ? _value.selectedBudgetProgress
          : selectedBudgetProgress // ignore: cast_nullable_to_non_nullable
              as BudgetProgressEntity?,
      selectedBudgetTargets: null == selectedBudgetTargets
          ? _value._selectedBudgetTargets
          : selectedBudgetTargets // ignore: cast_nullable_to_non_nullable
              as List<BudgetTargetEntity>,
      selectedBudgetPeriodStates: null == selectedBudgetPeriodStates
          ? _value._selectedBudgetPeriodStates
          : selectedBudgetPeriodStates // ignore: cast_nullable_to_non_nullable
              as List<BudgetPeriodStateEntity>,
      failure: null == failure
          ? _value.failure
          : failure // ignore: cast_nullable_to_non_nullable
              as Failure,
    ));
  }
}

/// @nodoc

class _$BudgetStateImpl implements _BudgetState {
  const _$BudgetStateImpl(
      {required final List<BudgetEntity> budgets,
      required this.isLoading,
      required this.isSaving,
      required this.isDeleting,
      required this.isProgressLoading,
      required this.isClosingPeriod,
      this.selectedBudgetProgress,
      required final List<BudgetTargetEntity> selectedBudgetTargets,
      required final List<BudgetPeriodStateEntity> selectedBudgetPeriodStates,
      required this.failure})
      : _budgets = budgets,
        _selectedBudgetTargets = selectedBudgetTargets,
        _selectedBudgetPeriodStates = selectedBudgetPeriodStates;

  final List<BudgetEntity> _budgets;
  @override
  List<BudgetEntity> get budgets {
    if (_budgets is EqualUnmodifiableListView) return _budgets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_budgets);
  }

  @override
  final bool isLoading;
  @override
  final bool isSaving;
  @override
  final bool isDeleting;
  @override
  final bool isProgressLoading;
  @override
  final bool isClosingPeriod;
  @override
  final BudgetProgressEntity? selectedBudgetProgress;
  final List<BudgetTargetEntity> _selectedBudgetTargets;
  @override
  List<BudgetTargetEntity> get selectedBudgetTargets {
    if (_selectedBudgetTargets is EqualUnmodifiableListView)
      return _selectedBudgetTargets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_selectedBudgetTargets);
  }

  final List<BudgetPeriodStateEntity> _selectedBudgetPeriodStates;
  @override
  List<BudgetPeriodStateEntity> get selectedBudgetPeriodStates {
    if (_selectedBudgetPeriodStates is EqualUnmodifiableListView)
      return _selectedBudgetPeriodStates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_selectedBudgetPeriodStates);
  }

  @override
  final Failure failure;

  @override
  String toString() {
    return 'BudgetState(budgets: $budgets, isLoading: $isLoading, isSaving: $isSaving, isDeleting: $isDeleting, isProgressLoading: $isProgressLoading, isClosingPeriod: $isClosingPeriod, selectedBudgetProgress: $selectedBudgetProgress, selectedBudgetTargets: $selectedBudgetTargets, selectedBudgetPeriodStates: $selectedBudgetPeriodStates, failure: $failure)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BudgetStateImpl &&
            const DeepCollectionEquality().equals(other._budgets, _budgets) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isSaving, isSaving) ||
                other.isSaving == isSaving) &&
            (identical(other.isDeleting, isDeleting) ||
                other.isDeleting == isDeleting) &&
            (identical(other.isProgressLoading, isProgressLoading) ||
                other.isProgressLoading == isProgressLoading) &&
            (identical(other.isClosingPeriod, isClosingPeriod) ||
                other.isClosingPeriod == isClosingPeriod) &&
            (identical(other.selectedBudgetProgress, selectedBudgetProgress) ||
                other.selectedBudgetProgress == selectedBudgetProgress) &&
            const DeepCollectionEquality()
                .equals(other._selectedBudgetTargets, _selectedBudgetTargets) &&
            const DeepCollectionEquality().equals(
                other._selectedBudgetPeriodStates,
                _selectedBudgetPeriodStates) &&
            (identical(other.failure, failure) || other.failure == failure));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_budgets),
      isLoading,
      isSaving,
      isDeleting,
      isProgressLoading,
      isClosingPeriod,
      selectedBudgetProgress,
      const DeepCollectionEquality().hash(_selectedBudgetTargets),
      const DeepCollectionEquality().hash(_selectedBudgetPeriodStates),
      failure);

  /// Create a copy of BudgetState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BudgetStateImplCopyWith<_$BudgetStateImpl> get copyWith =>
      __$$BudgetStateImplCopyWithImpl<_$BudgetStateImpl>(this, _$identity);
}

abstract class _BudgetState implements BudgetState {
  const factory _BudgetState(
      {required final List<BudgetEntity> budgets,
      required final bool isLoading,
      required final bool isSaving,
      required final bool isDeleting,
      required final bool isProgressLoading,
      required final bool isClosingPeriod,
      final BudgetProgressEntity? selectedBudgetProgress,
      required final List<BudgetTargetEntity> selectedBudgetTargets,
      required final List<BudgetPeriodStateEntity> selectedBudgetPeriodStates,
      required final Failure failure}) = _$BudgetStateImpl;

  @override
  List<BudgetEntity> get budgets;
  @override
  bool get isLoading;
  @override
  bool get isSaving;
  @override
  bool get isDeleting;
  @override
  bool get isProgressLoading;
  @override
  bool get isClosingPeriod;
  @override
  BudgetProgressEntity? get selectedBudgetProgress;
  @override
  List<BudgetTargetEntity> get selectedBudgetTargets;
  @override
  List<BudgetPeriodStateEntity> get selectedBudgetPeriodStates;
  @override
  Failure get failure;

  /// Create a copy of BudgetState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BudgetStateImplCopyWith<_$BudgetStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

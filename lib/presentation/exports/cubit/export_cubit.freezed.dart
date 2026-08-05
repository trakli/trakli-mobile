// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'export_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ExportedFile {
  Uint8List get bytes => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get mimeType => throw _privateConstructorUsedError;

  /// Create a copy of ExportedFile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExportedFileCopyWith<ExportedFile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExportedFileCopyWith<$Res> {
  factory $ExportedFileCopyWith(
          ExportedFile value, $Res Function(ExportedFile) then) =
      _$ExportedFileCopyWithImpl<$Res, ExportedFile>;
  @useResult
  $Res call({Uint8List bytes, String name, String mimeType});
}

/// @nodoc
class _$ExportedFileCopyWithImpl<$Res, $Val extends ExportedFile>
    implements $ExportedFileCopyWith<$Res> {
  _$ExportedFileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExportedFile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bytes = null,
    Object? name = null,
    Object? mimeType = null,
  }) {
    return _then(_value.copyWith(
      bytes: null == bytes
          ? _value.bytes
          : bytes // ignore: cast_nullable_to_non_nullable
              as Uint8List,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      mimeType: null == mimeType
          ? _value.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ExportedFileImplCopyWith<$Res>
    implements $ExportedFileCopyWith<$Res> {
  factory _$$ExportedFileImplCopyWith(
          _$ExportedFileImpl value, $Res Function(_$ExportedFileImpl) then) =
      __$$ExportedFileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Uint8List bytes, String name, String mimeType});
}

/// @nodoc
class __$$ExportedFileImplCopyWithImpl<$Res>
    extends _$ExportedFileCopyWithImpl<$Res, _$ExportedFileImpl>
    implements _$$ExportedFileImplCopyWith<$Res> {
  __$$ExportedFileImplCopyWithImpl(
      _$ExportedFileImpl _value, $Res Function(_$ExportedFileImpl) _then)
      : super(_value, _then);

  /// Create a copy of ExportedFile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bytes = null,
    Object? name = null,
    Object? mimeType = null,
  }) {
    return _then(_$ExportedFileImpl(
      bytes: null == bytes
          ? _value.bytes
          : bytes // ignore: cast_nullable_to_non_nullable
              as Uint8List,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      mimeType: null == mimeType
          ? _value.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ExportedFileImpl implements _ExportedFile {
  const _$ExportedFileImpl(
      {required this.bytes, required this.name, required this.mimeType});

  @override
  final Uint8List bytes;
  @override
  final String name;
  @override
  final String mimeType;

  @override
  String toString() {
    return 'ExportedFile(bytes: $bytes, name: $name, mimeType: $mimeType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExportedFileImpl &&
            const DeepCollectionEquality().equals(other.bytes, bytes) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.mimeType, mimeType) ||
                other.mimeType == mimeType));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(bytes), name, mimeType);

  /// Create a copy of ExportedFile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExportedFileImplCopyWith<_$ExportedFileImpl> get copyWith =>
      __$$ExportedFileImplCopyWithImpl<_$ExportedFileImpl>(this, _$identity);
}

abstract class _ExportedFile implements ExportedFile {
  const factory _ExportedFile(
      {required final Uint8List bytes,
      required final String name,
      required final String mimeType}) = _$ExportedFileImpl;

  @override
  Uint8List get bytes;
  @override
  String get name;
  @override
  String get mimeType;

  /// Create a copy of ExportedFile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExportedFileImplCopyWith<_$ExportedFileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ExportState {
  ExportFormat? get inProgress => throw _privateConstructorUsedError;
  Failure get failure => throw _privateConstructorUsedError;
  ExportedFile? get file => throw _privateConstructorUsedError;
  ExportBlocker get blocker => throw _privateConstructorUsedError;

  /// Create a copy of ExportState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExportStateCopyWith<ExportState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExportStateCopyWith<$Res> {
  factory $ExportStateCopyWith(
          ExportState value, $Res Function(ExportState) then) =
      _$ExportStateCopyWithImpl<$Res, ExportState>;
  @useResult
  $Res call(
      {ExportFormat? inProgress,
      Failure failure,
      ExportedFile? file,
      ExportBlocker blocker});

  $FailureCopyWith<$Res> get failure;
  $ExportedFileCopyWith<$Res>? get file;
}

/// @nodoc
class _$ExportStateCopyWithImpl<$Res, $Val extends ExportState>
    implements $ExportStateCopyWith<$Res> {
  _$ExportStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExportState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? inProgress = freezed,
    Object? failure = null,
    Object? file = freezed,
    Object? blocker = null,
  }) {
    return _then(_value.copyWith(
      inProgress: freezed == inProgress
          ? _value.inProgress
          : inProgress // ignore: cast_nullable_to_non_nullable
              as ExportFormat?,
      failure: null == failure
          ? _value.failure
          : failure // ignore: cast_nullable_to_non_nullable
              as Failure,
      file: freezed == file
          ? _value.file
          : file // ignore: cast_nullable_to_non_nullable
              as ExportedFile?,
      blocker: null == blocker
          ? _value.blocker
          : blocker // ignore: cast_nullable_to_non_nullable
              as ExportBlocker,
    ) as $Val);
  }

  /// Create a copy of ExportState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FailureCopyWith<$Res> get failure {
    return $FailureCopyWith<$Res>(_value.failure, (value) {
      return _then(_value.copyWith(failure: value) as $Val);
    });
  }

  /// Create a copy of ExportState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ExportedFileCopyWith<$Res>? get file {
    if (_value.file == null) {
      return null;
    }

    return $ExportedFileCopyWith<$Res>(_value.file!, (value) {
      return _then(_value.copyWith(file: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ExportStateImplCopyWith<$Res>
    implements $ExportStateCopyWith<$Res> {
  factory _$$ExportStateImplCopyWith(
          _$ExportStateImpl value, $Res Function(_$ExportStateImpl) then) =
      __$$ExportStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {ExportFormat? inProgress,
      Failure failure,
      ExportedFile? file,
      ExportBlocker blocker});

  @override
  $FailureCopyWith<$Res> get failure;
  @override
  $ExportedFileCopyWith<$Res>? get file;
}

/// @nodoc
class __$$ExportStateImplCopyWithImpl<$Res>
    extends _$ExportStateCopyWithImpl<$Res, _$ExportStateImpl>
    implements _$$ExportStateImplCopyWith<$Res> {
  __$$ExportStateImplCopyWithImpl(
      _$ExportStateImpl _value, $Res Function(_$ExportStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of ExportState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? inProgress = freezed,
    Object? failure = null,
    Object? file = freezed,
    Object? blocker = null,
  }) {
    return _then(_$ExportStateImpl(
      inProgress: freezed == inProgress
          ? _value.inProgress
          : inProgress // ignore: cast_nullable_to_non_nullable
              as ExportFormat?,
      failure: null == failure
          ? _value.failure
          : failure // ignore: cast_nullable_to_non_nullable
              as Failure,
      file: freezed == file
          ? _value.file
          : file // ignore: cast_nullable_to_non_nullable
              as ExportedFile?,
      blocker: null == blocker
          ? _value.blocker
          : blocker // ignore: cast_nullable_to_non_nullable
              as ExportBlocker,
    ));
  }
}

/// @nodoc

class _$ExportStateImpl extends _ExportState {
  const _$ExportStateImpl(
      {this.inProgress,
      this.failure = const Failure.none(),
      this.file,
      this.blocker = ExportBlocker.none})
      : super._();

  @override
  final ExportFormat? inProgress;
  @override
  @JsonKey()
  final Failure failure;
  @override
  final ExportedFile? file;
  @override
  @JsonKey()
  final ExportBlocker blocker;

  @override
  String toString() {
    return 'ExportState(inProgress: $inProgress, failure: $failure, file: $file, blocker: $blocker)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExportStateImpl &&
            (identical(other.inProgress, inProgress) ||
                other.inProgress == inProgress) &&
            (identical(other.failure, failure) || other.failure == failure) &&
            (identical(other.file, file) || other.file == file) &&
            (identical(other.blocker, blocker) || other.blocker == blocker));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, inProgress, failure, file, blocker);

  /// Create a copy of ExportState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExportStateImplCopyWith<_$ExportStateImpl> get copyWith =>
      __$$ExportStateImplCopyWithImpl<_$ExportStateImpl>(this, _$identity);
}

abstract class _ExportState extends ExportState {
  const factory _ExportState(
      {final ExportFormat? inProgress,
      final Failure failure,
      final ExportedFile? file,
      final ExportBlocker blocker}) = _$ExportStateImpl;
  const _ExportState._() : super._();

  @override
  ExportFormat? get inProgress;
  @override
  Failure get failure;
  @override
  ExportedFile? get file;
  @override
  ExportBlocker get blocker;

  /// Create a copy of ExportState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExportStateImplCopyWith<_$ExportStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

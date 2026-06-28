// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_chat_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AiChatState {
  bool get isInitializing => throw _privateConstructorUsedError;
  bool get isSending => throw _privateConstructorUsedError;
  bool get isPolling => throw _privateConstructorUsedError;
  ChatSessionDto? get session => throw _privateConstructorUsedError;
  ChatSessionDto? get recentSession => throw _privateConstructorUsedError;
  List<ChatMessageDto> get messages => throw _privateConstructorUsedError;
  Failure? get failure => throw _privateConstructorUsedError;

  /// Create a copy of AiChatState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AiChatStateCopyWith<AiChatState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AiChatStateCopyWith<$Res> {
  factory $AiChatStateCopyWith(
          AiChatState value, $Res Function(AiChatState) then) =
      _$AiChatStateCopyWithImpl<$Res, AiChatState>;
  @useResult
  $Res call(
      {bool isInitializing,
      bool isSending,
      bool isPolling,
      ChatSessionDto? session,
      ChatSessionDto? recentSession,
      List<ChatMessageDto> messages,
      Failure? failure});

  $ChatSessionDtoCopyWith<$Res>? get session;
  $ChatSessionDtoCopyWith<$Res>? get recentSession;
  $FailureCopyWith<$Res>? get failure;
}

/// @nodoc
class _$AiChatStateCopyWithImpl<$Res, $Val extends AiChatState>
    implements $AiChatStateCopyWith<$Res> {
  _$AiChatStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AiChatState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isInitializing = null,
    Object? isSending = null,
    Object? isPolling = null,
    Object? session = freezed,
    Object? recentSession = freezed,
    Object? messages = null,
    Object? failure = freezed,
  }) {
    return _then(_value.copyWith(
      isInitializing: null == isInitializing
          ? _value.isInitializing
          : isInitializing // ignore: cast_nullable_to_non_nullable
              as bool,
      isSending: null == isSending
          ? _value.isSending
          : isSending // ignore: cast_nullable_to_non_nullable
              as bool,
      isPolling: null == isPolling
          ? _value.isPolling
          : isPolling // ignore: cast_nullable_to_non_nullable
              as bool,
      session: freezed == session
          ? _value.session
          : session // ignore: cast_nullable_to_non_nullable
              as ChatSessionDto?,
      recentSession: freezed == recentSession
          ? _value.recentSession
          : recentSession // ignore: cast_nullable_to_non_nullable
              as ChatSessionDto?,
      messages: null == messages
          ? _value.messages
          : messages // ignore: cast_nullable_to_non_nullable
              as List<ChatMessageDto>,
      failure: freezed == failure
          ? _value.failure
          : failure // ignore: cast_nullable_to_non_nullable
              as Failure?,
    ) as $Val);
  }

  /// Create a copy of AiChatState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ChatSessionDtoCopyWith<$Res>? get session {
    if (_value.session == null) {
      return null;
    }

    return $ChatSessionDtoCopyWith<$Res>(_value.session!, (value) {
      return _then(_value.copyWith(session: value) as $Val);
    });
  }

  /// Create a copy of AiChatState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ChatSessionDtoCopyWith<$Res>? get recentSession {
    if (_value.recentSession == null) {
      return null;
    }

    return $ChatSessionDtoCopyWith<$Res>(_value.recentSession!, (value) {
      return _then(_value.copyWith(recentSession: value) as $Val);
    });
  }

  /// Create a copy of AiChatState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FailureCopyWith<$Res>? get failure {
    if (_value.failure == null) {
      return null;
    }

    return $FailureCopyWith<$Res>(_value.failure!, (value) {
      return _then(_value.copyWith(failure: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AiChatStateImplCopyWith<$Res>
    implements $AiChatStateCopyWith<$Res> {
  factory _$$AiChatStateImplCopyWith(
          _$AiChatStateImpl value, $Res Function(_$AiChatStateImpl) then) =
      __$$AiChatStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isInitializing,
      bool isSending,
      bool isPolling,
      ChatSessionDto? session,
      ChatSessionDto? recentSession,
      List<ChatMessageDto> messages,
      Failure? failure});

  @override
  $ChatSessionDtoCopyWith<$Res>? get session;
  @override
  $ChatSessionDtoCopyWith<$Res>? get recentSession;
  @override
  $FailureCopyWith<$Res>? get failure;
}

/// @nodoc
class __$$AiChatStateImplCopyWithImpl<$Res>
    extends _$AiChatStateCopyWithImpl<$Res, _$AiChatStateImpl>
    implements _$$AiChatStateImplCopyWith<$Res> {
  __$$AiChatStateImplCopyWithImpl(
      _$AiChatStateImpl _value, $Res Function(_$AiChatStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of AiChatState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isInitializing = null,
    Object? isSending = null,
    Object? isPolling = null,
    Object? session = freezed,
    Object? recentSession = freezed,
    Object? messages = null,
    Object? failure = freezed,
  }) {
    return _then(_$AiChatStateImpl(
      isInitializing: null == isInitializing
          ? _value.isInitializing
          : isInitializing // ignore: cast_nullable_to_non_nullable
              as bool,
      isSending: null == isSending
          ? _value.isSending
          : isSending // ignore: cast_nullable_to_non_nullable
              as bool,
      isPolling: null == isPolling
          ? _value.isPolling
          : isPolling // ignore: cast_nullable_to_non_nullable
              as bool,
      session: freezed == session
          ? _value.session
          : session // ignore: cast_nullable_to_non_nullable
              as ChatSessionDto?,
      recentSession: freezed == recentSession
          ? _value.recentSession
          : recentSession // ignore: cast_nullable_to_non_nullable
              as ChatSessionDto?,
      messages: null == messages
          ? _value._messages
          : messages // ignore: cast_nullable_to_non_nullable
              as List<ChatMessageDto>,
      failure: freezed == failure
          ? _value.failure
          : failure // ignore: cast_nullable_to_non_nullable
              as Failure?,
    ));
  }
}

/// @nodoc

class _$AiChatStateImpl extends _AiChatState {
  const _$AiChatStateImpl(
      {this.isInitializing = false,
      this.isSending = false,
      this.isPolling = false,
      this.session,
      this.recentSession,
      final List<ChatMessageDto> messages = const <ChatMessageDto>[],
      this.failure})
      : _messages = messages,
        super._();

  @override
  @JsonKey()
  final bool isInitializing;
  @override
  @JsonKey()
  final bool isSending;
  @override
  @JsonKey()
  final bool isPolling;
  @override
  final ChatSessionDto? session;
  @override
  final ChatSessionDto? recentSession;
  final List<ChatMessageDto> _messages;
  @override
  @JsonKey()
  List<ChatMessageDto> get messages {
    if (_messages is EqualUnmodifiableListView) return _messages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_messages);
  }

  @override
  final Failure? failure;

  @override
  String toString() {
    return 'AiChatState(isInitializing: $isInitializing, isSending: $isSending, isPolling: $isPolling, session: $session, recentSession: $recentSession, messages: $messages, failure: $failure)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AiChatStateImpl &&
            (identical(other.isInitializing, isInitializing) ||
                other.isInitializing == isInitializing) &&
            (identical(other.isSending, isSending) ||
                other.isSending == isSending) &&
            (identical(other.isPolling, isPolling) ||
                other.isPolling == isPolling) &&
            (identical(other.session, session) || other.session == session) &&
            (identical(other.recentSession, recentSession) ||
                other.recentSession == recentSession) &&
            const DeepCollectionEquality().equals(other._messages, _messages) &&
            (identical(other.failure, failure) || other.failure == failure));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isInitializing,
      isSending,
      isPolling,
      session,
      recentSession,
      const DeepCollectionEquality().hash(_messages),
      failure);

  /// Create a copy of AiChatState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AiChatStateImplCopyWith<_$AiChatStateImpl> get copyWith =>
      __$$AiChatStateImplCopyWithImpl<_$AiChatStateImpl>(this, _$identity);
}

abstract class _AiChatState extends AiChatState {
  const factory _AiChatState(
      {final bool isInitializing,
      final bool isSending,
      final bool isPolling,
      final ChatSessionDto? session,
      final ChatSessionDto? recentSession,
      final List<ChatMessageDto> messages,
      final Failure? failure}) = _$AiChatStateImpl;
  const _AiChatState._() : super._();

  @override
  bool get isInitializing;
  @override
  bool get isSending;
  @override
  bool get isPolling;
  @override
  ChatSessionDto? get session;
  @override
  ChatSessionDto? get recentSession;
  @override
  List<ChatMessageDto> get messages;
  @override
  Failure? get failure;

  /// Create a copy of AiChatState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AiChatStateImplCopyWith<_$AiChatStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

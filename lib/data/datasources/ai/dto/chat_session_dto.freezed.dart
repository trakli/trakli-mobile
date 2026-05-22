// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_session_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ChatSessionDto _$ChatSessionDtoFromJson(Map<String, dynamic> json) {
  return _ChatSessionDto.fromJson(json);
}

/// @nodoc
mixin _$ChatSessionDto {
  int get id => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at', fromJson: DateTime.parse)
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at', fromJson: DateTime.parse)
  DateTime get updatedAt => throw _privateConstructorUsedError;
  List<ChatMessageDto> get messages => throw _privateConstructorUsedError;

  /// Serializes this ChatSessionDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChatSessionDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChatSessionDtoCopyWith<ChatSessionDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatSessionDtoCopyWith<$Res> {
  factory $ChatSessionDtoCopyWith(
          ChatSessionDto value, $Res Function(ChatSessionDto) then) =
      _$ChatSessionDtoCopyWithImpl<$Res, ChatSessionDto>;
  @useResult
  $Res call(
      {int id,
      String? title,
      @JsonKey(name: 'created_at', fromJson: DateTime.parse) DateTime createdAt,
      @JsonKey(name: 'updated_at', fromJson: DateTime.parse) DateTime updatedAt,
      List<ChatMessageDto> messages});
}

/// @nodoc
class _$ChatSessionDtoCopyWithImpl<$Res, $Val extends ChatSessionDto>
    implements $ChatSessionDtoCopyWith<$Res> {
  _$ChatSessionDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChatSessionDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? messages = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      messages: null == messages
          ? _value.messages
          : messages // ignore: cast_nullable_to_non_nullable
              as List<ChatMessageDto>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChatSessionDtoImplCopyWith<$Res>
    implements $ChatSessionDtoCopyWith<$Res> {
  factory _$$ChatSessionDtoImplCopyWith(_$ChatSessionDtoImpl value,
          $Res Function(_$ChatSessionDtoImpl) then) =
      __$$ChatSessionDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String? title,
      @JsonKey(name: 'created_at', fromJson: DateTime.parse) DateTime createdAt,
      @JsonKey(name: 'updated_at', fromJson: DateTime.parse) DateTime updatedAt,
      List<ChatMessageDto> messages});
}

/// @nodoc
class __$$ChatSessionDtoImplCopyWithImpl<$Res>
    extends _$ChatSessionDtoCopyWithImpl<$Res, _$ChatSessionDtoImpl>
    implements _$$ChatSessionDtoImplCopyWith<$Res> {
  __$$ChatSessionDtoImplCopyWithImpl(
      _$ChatSessionDtoImpl _value, $Res Function(_$ChatSessionDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of ChatSessionDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? messages = null,
  }) {
    return _then(_$ChatSessionDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      messages: null == messages
          ? _value._messages
          : messages // ignore: cast_nullable_to_non_nullable
              as List<ChatMessageDto>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChatSessionDtoImpl implements _ChatSessionDto {
  const _$ChatSessionDtoImpl(
      {required this.id,
      this.title,
      @JsonKey(name: 'created_at', fromJson: DateTime.parse)
      required this.createdAt,
      @JsonKey(name: 'updated_at', fromJson: DateTime.parse)
      required this.updatedAt,
      final List<ChatMessageDto> messages = const <ChatMessageDto>[]})
      : _messages = messages;

  factory _$ChatSessionDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatSessionDtoImplFromJson(json);

  @override
  final int id;
  @override
  final String? title;
  @override
  @JsonKey(name: 'created_at', fromJson: DateTime.parse)
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at', fromJson: DateTime.parse)
  final DateTime updatedAt;
  final List<ChatMessageDto> _messages;
  @override
  @JsonKey()
  List<ChatMessageDto> get messages {
    if (_messages is EqualUnmodifiableListView) return _messages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_messages);
  }

  @override
  String toString() {
    return 'ChatSessionDto(id: $id, title: $title, createdAt: $createdAt, updatedAt: $updatedAt, messages: $messages)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatSessionDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(other._messages, _messages));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, createdAt, updatedAt,
      const DeepCollectionEquality().hash(_messages));

  /// Create a copy of ChatSessionDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatSessionDtoImplCopyWith<_$ChatSessionDtoImpl> get copyWith =>
      __$$ChatSessionDtoImplCopyWithImpl<_$ChatSessionDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatSessionDtoImplToJson(
      this,
    );
  }
}

abstract class _ChatSessionDto implements ChatSessionDto {
  const factory _ChatSessionDto(
      {required final int id,
      final String? title,
      @JsonKey(name: 'created_at', fromJson: DateTime.parse)
      required final DateTime createdAt,
      @JsonKey(name: 'updated_at', fromJson: DateTime.parse)
      required final DateTime updatedAt,
      final List<ChatMessageDto> messages}) = _$ChatSessionDtoImpl;

  factory _ChatSessionDto.fromJson(Map<String, dynamic> json) =
      _$ChatSessionDtoImpl.fromJson;

  @override
  int get id;
  @override
  String? get title;
  @override
  @JsonKey(name: 'created_at', fromJson: DateTime.parse)
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at', fromJson: DateTime.parse)
  DateTime get updatedAt;
  @override
  List<ChatMessageDto> get messages;

  /// Create a copy of ChatSessionDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatSessionDtoImplCopyWith<_$ChatSessionDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

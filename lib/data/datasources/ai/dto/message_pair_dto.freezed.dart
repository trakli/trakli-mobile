// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message_pair_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MessagePairDto _$MessagePairDtoFromJson(Map<String, dynamic> json) {
  return _MessagePairDto.fromJson(json);
}

/// @nodoc
mixin _$MessagePairDto {
  ChatMessageDto get user => throw _privateConstructorUsedError;
  ChatMessageDto get assistant => throw _privateConstructorUsedError;

  /// Serializes this MessagePairDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MessagePairDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MessagePairDtoCopyWith<MessagePairDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessagePairDtoCopyWith<$Res> {
  factory $MessagePairDtoCopyWith(
          MessagePairDto value, $Res Function(MessagePairDto) then) =
      _$MessagePairDtoCopyWithImpl<$Res, MessagePairDto>;
  @useResult
  $Res call({ChatMessageDto user, ChatMessageDto assistant});

  $ChatMessageDtoCopyWith<$Res> get user;
  $ChatMessageDtoCopyWith<$Res> get assistant;
}

/// @nodoc
class _$MessagePairDtoCopyWithImpl<$Res, $Val extends MessagePairDto>
    implements $MessagePairDtoCopyWith<$Res> {
  _$MessagePairDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MessagePairDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = null,
    Object? assistant = null,
  }) {
    return _then(_value.copyWith(
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as ChatMessageDto,
      assistant: null == assistant
          ? _value.assistant
          : assistant // ignore: cast_nullable_to_non_nullable
              as ChatMessageDto,
    ) as $Val);
  }

  /// Create a copy of MessagePairDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ChatMessageDtoCopyWith<$Res> get user {
    return $ChatMessageDtoCopyWith<$Res>(_value.user, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }

  /// Create a copy of MessagePairDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ChatMessageDtoCopyWith<$Res> get assistant {
    return $ChatMessageDtoCopyWith<$Res>(_value.assistant, (value) {
      return _then(_value.copyWith(assistant: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MessagePairDtoImplCopyWith<$Res>
    implements $MessagePairDtoCopyWith<$Res> {
  factory _$$MessagePairDtoImplCopyWith(_$MessagePairDtoImpl value,
          $Res Function(_$MessagePairDtoImpl) then) =
      __$$MessagePairDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({ChatMessageDto user, ChatMessageDto assistant});

  @override
  $ChatMessageDtoCopyWith<$Res> get user;
  @override
  $ChatMessageDtoCopyWith<$Res> get assistant;
}

/// @nodoc
class __$$MessagePairDtoImplCopyWithImpl<$Res>
    extends _$MessagePairDtoCopyWithImpl<$Res, _$MessagePairDtoImpl>
    implements _$$MessagePairDtoImplCopyWith<$Res> {
  __$$MessagePairDtoImplCopyWithImpl(
      _$MessagePairDtoImpl _value, $Res Function(_$MessagePairDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of MessagePairDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = null,
    Object? assistant = null,
  }) {
    return _then(_$MessagePairDtoImpl(
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as ChatMessageDto,
      assistant: null == assistant
          ? _value.assistant
          : assistant // ignore: cast_nullable_to_non_nullable
              as ChatMessageDto,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MessagePairDtoImpl implements _MessagePairDto {
  const _$MessagePairDtoImpl({required this.user, required this.assistant});

  factory _$MessagePairDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$MessagePairDtoImplFromJson(json);

  @override
  final ChatMessageDto user;
  @override
  final ChatMessageDto assistant;

  @override
  String toString() {
    return 'MessagePairDto(user: $user, assistant: $assistant)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessagePairDtoImpl &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.assistant, assistant) ||
                other.assistant == assistant));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, user, assistant);

  /// Create a copy of MessagePairDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MessagePairDtoImplCopyWith<_$MessagePairDtoImpl> get copyWith =>
      __$$MessagePairDtoImplCopyWithImpl<_$MessagePairDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MessagePairDtoImplToJson(
      this,
    );
  }
}

abstract class _MessagePairDto implements MessagePairDto {
  const factory _MessagePairDto(
      {required final ChatMessageDto user,
      required final ChatMessageDto assistant}) = _$MessagePairDtoImpl;

  factory _MessagePairDto.fromJson(Map<String, dynamic> json) =
      _$MessagePairDtoImpl.fromJson;

  @override
  ChatMessageDto get user;
  @override
  ChatMessageDto get assistant;

  /// Create a copy of MessagePairDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MessagePairDtoImplCopyWith<_$MessagePairDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

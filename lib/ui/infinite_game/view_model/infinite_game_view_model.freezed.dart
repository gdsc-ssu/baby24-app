// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'infinite_game_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$InfiniteGameState {
  List<Game> get games => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $InfiniteGameStateCopyWith<InfiniteGameState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InfiniteGameStateCopyWith<$Res> {
  factory $InfiniteGameStateCopyWith(
          InfiniteGameState value, $Res Function(InfiniteGameState) then) =
      _$InfiniteGameStateCopyWithImpl<$Res, InfiniteGameState>;
  @useResult
  $Res call({List<Game> games, bool isLoading, String? error});
}

/// @nodoc
class _$InfiniteGameStateCopyWithImpl<$Res, $Val extends InfiniteGameState>
    implements $InfiniteGameStateCopyWith<$Res> {
  _$InfiniteGameStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? games = null,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      games: null == games
          ? _value.games
          : games // ignore: cast_nullable_to_non_nullable
              as List<Game>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InfiniteGameStateImplCopyWith<$Res>
    implements $InfiniteGameStateCopyWith<$Res> {
  factory _$$InfiniteGameStateImplCopyWith(_$InfiniteGameStateImpl value,
          $Res Function(_$InfiniteGameStateImpl) then) =
      __$$InfiniteGameStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<Game> games, bool isLoading, String? error});
}

/// @nodoc
class __$$InfiniteGameStateImplCopyWithImpl<$Res>
    extends _$InfiniteGameStateCopyWithImpl<$Res, _$InfiniteGameStateImpl>
    implements _$$InfiniteGameStateImplCopyWith<$Res> {
  __$$InfiniteGameStateImplCopyWithImpl(_$InfiniteGameStateImpl _value,
      $Res Function(_$InfiniteGameStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? games = null,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(_$InfiniteGameStateImpl(
      games: null == games
          ? _value._games
          : games // ignore: cast_nullable_to_non_nullable
              as List<Game>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$InfiniteGameStateImpl implements _InfiniteGameState {
  const _$InfiniteGameStateImpl(
      {final List<Game> games = const [],
      this.isLoading = false,
      this.error = null})
      : _games = games;

  final List<Game> _games;
  @override
  @JsonKey()
  List<Game> get games {
    if (_games is EqualUnmodifiableListView) return _games;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_games);
  }

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final String? error;

  @override
  String toString() {
    return 'InfiniteGameState(games: $games, isLoading: $isLoading, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InfiniteGameStateImpl &&
            const DeepCollectionEquality().equals(other._games, _games) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_games), isLoading, error);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InfiniteGameStateImplCopyWith<_$InfiniteGameStateImpl> get copyWith =>
      __$$InfiniteGameStateImplCopyWithImpl<_$InfiniteGameStateImpl>(
          this, _$identity);
}

abstract class _InfiniteGameState implements InfiniteGameState {
  const factory _InfiniteGameState(
      {final List<Game> games,
      final bool isLoading,
      final String? error}) = _$InfiniteGameStateImpl;

  @override
  List<Game> get games;
  @override
  bool get isLoading;
  @override
  String? get error;
  @override
  @JsonKey(ignore: true)
  _$$InfiniteGameStateImplCopyWith<_$InfiniteGameStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$HomeState {
  List<Game> get games => throw _privateConstructorUsedError;
  int get currentPage => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  String get searchQuery => throw _privateConstructorUsedError;
  String get sortBy => throw _privateConstructorUsedError;
  bool get isInfiniteMode => throw _privateConstructorUsedError;
  bool get showInfiniteModeHelper => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $HomeStateCopyWith<HomeState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HomeStateCopyWith<$Res> {
  factory $HomeStateCopyWith(HomeState value, $Res Function(HomeState) then) =
      _$HomeStateCopyWithImpl<$Res, HomeState>;
  @useResult
  $Res call(
      {List<Game> games,
      int currentPage,
      bool isLoading,
      String? error,
      String searchQuery,
      String sortBy,
      bool isInfiniteMode,
      bool showInfiniteModeHelper});
}

/// @nodoc
class _$HomeStateCopyWithImpl<$Res, $Val extends HomeState>
    implements $HomeStateCopyWith<$Res> {
  _$HomeStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? games = null,
    Object? currentPage = null,
    Object? isLoading = null,
    Object? error = freezed,
    Object? searchQuery = null,
    Object? sortBy = null,
    Object? isInfiniteMode = null,
    Object? showInfiniteModeHelper = null,
  }) {
    return _then(_value.copyWith(
      games: null == games
          ? _value.games
          : games // ignore: cast_nullable_to_non_nullable
              as List<Game>,
      currentPage: null == currentPage
          ? _value.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      searchQuery: null == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String,
      sortBy: null == sortBy
          ? _value.sortBy
          : sortBy // ignore: cast_nullable_to_non_nullable
              as String,
      isInfiniteMode: null == isInfiniteMode
          ? _value.isInfiniteMode
          : isInfiniteMode // ignore: cast_nullable_to_non_nullable
              as bool,
      showInfiniteModeHelper: null == showInfiniteModeHelper
          ? _value.showInfiniteModeHelper
          : showInfiniteModeHelper // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HomeStateImplCopyWith<$Res>
    implements $HomeStateCopyWith<$Res> {
  factory _$$HomeStateImplCopyWith(
          _$HomeStateImpl value, $Res Function(_$HomeStateImpl) then) =
      __$$HomeStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<Game> games,
      int currentPage,
      bool isLoading,
      String? error,
      String searchQuery,
      String sortBy,
      bool isInfiniteMode,
      bool showInfiniteModeHelper});
}

/// @nodoc
class __$$HomeStateImplCopyWithImpl<$Res>
    extends _$HomeStateCopyWithImpl<$Res, _$HomeStateImpl>
    implements _$$HomeStateImplCopyWith<$Res> {
  __$$HomeStateImplCopyWithImpl(
      _$HomeStateImpl _value, $Res Function(_$HomeStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? games = null,
    Object? currentPage = null,
    Object? isLoading = null,
    Object? error = freezed,
    Object? searchQuery = null,
    Object? sortBy = null,
    Object? isInfiniteMode = null,
    Object? showInfiniteModeHelper = null,
  }) {
    return _then(_$HomeStateImpl(
      games: null == games
          ? _value._games
          : games // ignore: cast_nullable_to_non_nullable
              as List<Game>,
      currentPage: null == currentPage
          ? _value.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      searchQuery: null == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String,
      sortBy: null == sortBy
          ? _value.sortBy
          : sortBy // ignore: cast_nullable_to_non_nullable
              as String,
      isInfiniteMode: null == isInfiniteMode
          ? _value.isInfiniteMode
          : isInfiniteMode // ignore: cast_nullable_to_non_nullable
              as bool,
      showInfiniteModeHelper: null == showInfiniteModeHelper
          ? _value.showInfiniteModeHelper
          : showInfiniteModeHelper // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$HomeStateImpl implements _HomeState {
  const _$HomeStateImpl(
      {final List<Game> games = const [],
      this.currentPage = 1,
      this.isLoading = false,
      this.error = null,
      this.searchQuery = '',
      this.sortBy = '인기순',
      this.isInfiniteMode = false,
      this.showInfiniteModeHelper = true})
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
  final int currentPage;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final String? error;
  @override
  @JsonKey()
  final String searchQuery;
  @override
  @JsonKey()
  final String sortBy;
  @override
  @JsonKey()
  final bool isInfiniteMode;
  @override
  @JsonKey()
  final bool showInfiniteModeHelper;

  @override
  String toString() {
    return 'HomeState(games: $games, currentPage: $currentPage, isLoading: $isLoading, error: $error, searchQuery: $searchQuery, sortBy: $sortBy, isInfiniteMode: $isInfiniteMode, showInfiniteModeHelper: $showInfiniteModeHelper)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HomeStateImpl &&
            const DeepCollectionEquality().equals(other._games, _games) &&
            (identical(other.currentPage, currentPage) ||
                other.currentPage == currentPage) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery) &&
            (identical(other.sortBy, sortBy) || other.sortBy == sortBy) &&
            (identical(other.isInfiniteMode, isInfiniteMode) ||
                other.isInfiniteMode == isInfiniteMode) &&
            (identical(other.showInfiniteModeHelper, showInfiniteModeHelper) ||
                other.showInfiniteModeHelper == showInfiniteModeHelper));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_games),
      currentPage,
      isLoading,
      error,
      searchQuery,
      sortBy,
      isInfiniteMode,
      showInfiniteModeHelper);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HomeStateImplCopyWith<_$HomeStateImpl> get copyWith =>
      __$$HomeStateImplCopyWithImpl<_$HomeStateImpl>(this, _$identity);
}

abstract class _HomeState implements HomeState {
  const factory _HomeState(
      {final List<Game> games,
      final int currentPage,
      final bool isLoading,
      final String? error,
      final String searchQuery,
      final String sortBy,
      final bool isInfiniteMode,
      final bool showInfiniteModeHelper}) = _$HomeStateImpl;

  @override
  List<Game> get games;
  @override
  int get currentPage;
  @override
  bool get isLoading;
  @override
  String? get error;
  @override
  String get searchQuery;
  @override
  String get sortBy;
  @override
  bool get isInfiniteMode;
  @override
  bool get showInfiniteModeHelper;
  @override
  @JsonKey(ignore: true)
  _$$HomeStateImplCopyWith<_$HomeStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

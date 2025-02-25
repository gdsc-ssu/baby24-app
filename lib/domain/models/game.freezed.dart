// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Game _$GameFromJson(Map<String, dynamic> json) {
  return _Game.fromJson(json);
}

/// @nodoc
mixin _$Game {
  @JsonKey(name: 'game_id')
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  int get total_matches => throw _privateConstructorUsedError;
  int get finish_matches => throw _privateConstructorUsedError;
  @JsonKey(name: 'access_level')
  String get accessLevel => throw _privateConstructorUsedError;
  DateTime get created_at => throw _privateConstructorUsedError;
  @JsonKey(name: 'normal_item_count')
  int get normalItemCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'user')
  GameUser? get user => throw _privateConstructorUsedError;
  @JsonKey(name: 'top_items')
  List<GameItem> get topItems => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GameCopyWith<Game> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameCopyWith<$Res> {
  factory $GameCopyWith(Game value, $Res Function(Game) then) =
      _$GameCopyWithImpl<$Res, Game>;
  @useResult
  $Res call(
      {@JsonKey(name: 'game_id') String id,
      String title,
      String description,
      int total_matches,
      int finish_matches,
      @JsonKey(name: 'access_level') String accessLevel,
      DateTime created_at,
      @JsonKey(name: 'normal_item_count') int normalItemCount,
      @JsonKey(name: 'user') GameUser? user,
      @JsonKey(name: 'top_items') List<GameItem> topItems});

  $GameUserCopyWith<$Res>? get user;
}

/// @nodoc
class _$GameCopyWithImpl<$Res, $Val extends Game>
    implements $GameCopyWith<$Res> {
  _$GameCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? total_matches = null,
    Object? finish_matches = null,
    Object? accessLevel = null,
    Object? created_at = null,
    Object? normalItemCount = null,
    Object? user = freezed,
    Object? topItems = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      total_matches: null == total_matches
          ? _value.total_matches
          : total_matches // ignore: cast_nullable_to_non_nullable
              as int,
      finish_matches: null == finish_matches
          ? _value.finish_matches
          : finish_matches // ignore: cast_nullable_to_non_nullable
              as int,
      accessLevel: null == accessLevel
          ? _value.accessLevel
          : accessLevel // ignore: cast_nullable_to_non_nullable
              as String,
      created_at: null == created_at
          ? _value.created_at
          : created_at // ignore: cast_nullable_to_non_nullable
              as DateTime,
      normalItemCount: null == normalItemCount
          ? _value.normalItemCount
          : normalItemCount // ignore: cast_nullable_to_non_nullable
              as int,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as GameUser?,
      topItems: null == topItems
          ? _value.topItems
          : topItems // ignore: cast_nullable_to_non_nullable
              as List<GameItem>,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $GameUserCopyWith<$Res>? get user {
    if (_value.user == null) {
      return null;
    }

    return $GameUserCopyWith<$Res>(_value.user!, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$GameImplCopyWith<$Res> implements $GameCopyWith<$Res> {
  factory _$$GameImplCopyWith(
          _$GameImpl value, $Res Function(_$GameImpl) then) =
      __$$GameImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'game_id') String id,
      String title,
      String description,
      int total_matches,
      int finish_matches,
      @JsonKey(name: 'access_level') String accessLevel,
      DateTime created_at,
      @JsonKey(name: 'normal_item_count') int normalItemCount,
      @JsonKey(name: 'user') GameUser? user,
      @JsonKey(name: 'top_items') List<GameItem> topItems});

  @override
  $GameUserCopyWith<$Res>? get user;
}

/// @nodoc
class __$$GameImplCopyWithImpl<$Res>
    extends _$GameCopyWithImpl<$Res, _$GameImpl>
    implements _$$GameImplCopyWith<$Res> {
  __$$GameImplCopyWithImpl(_$GameImpl _value, $Res Function(_$GameImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? total_matches = null,
    Object? finish_matches = null,
    Object? accessLevel = null,
    Object? created_at = null,
    Object? normalItemCount = null,
    Object? user = freezed,
    Object? topItems = null,
  }) {
    return _then(_$GameImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      total_matches: null == total_matches
          ? _value.total_matches
          : total_matches // ignore: cast_nullable_to_non_nullable
              as int,
      finish_matches: null == finish_matches
          ? _value.finish_matches
          : finish_matches // ignore: cast_nullable_to_non_nullable
              as int,
      accessLevel: null == accessLevel
          ? _value.accessLevel
          : accessLevel // ignore: cast_nullable_to_non_nullable
              as String,
      created_at: null == created_at
          ? _value.created_at
          : created_at // ignore: cast_nullable_to_non_nullable
              as DateTime,
      normalItemCount: null == normalItemCount
          ? _value.normalItemCount
          : normalItemCount // ignore: cast_nullable_to_non_nullable
              as int,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as GameUser?,
      topItems: null == topItems
          ? _value._topItems
          : topItems // ignore: cast_nullable_to_non_nullable
              as List<GameItem>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GameImpl implements _Game {
  const _$GameImpl(
      {@JsonKey(name: 'game_id') required this.id,
      this.title = '',
      this.description = '',
      this.total_matches = 0,
      this.finish_matches = 0,
      @JsonKey(name: 'access_level') this.accessLevel = 'public',
      required this.created_at,
      @JsonKey(name: 'normal_item_count') this.normalItemCount = 0,
      @JsonKey(name: 'user') this.user,
      @JsonKey(name: 'top_items') final List<GameItem> topItems = const []})
      : _topItems = topItems;

  factory _$GameImpl.fromJson(Map<String, dynamic> json) =>
      _$$GameImplFromJson(json);

  @override
  @JsonKey(name: 'game_id')
  final String id;
  @override
  @JsonKey()
  final String title;
  @override
  @JsonKey()
  final String description;
  @override
  @JsonKey()
  final int total_matches;
  @override
  @JsonKey()
  final int finish_matches;
  @override
  @JsonKey(name: 'access_level')
  final String accessLevel;
  @override
  final DateTime created_at;
  @override
  @JsonKey(name: 'normal_item_count')
  final int normalItemCount;
  @override
  @JsonKey(name: 'user')
  final GameUser? user;
  final List<GameItem> _topItems;
  @override
  @JsonKey(name: 'top_items')
  List<GameItem> get topItems {
    if (_topItems is EqualUnmodifiableListView) return _topItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_topItems);
  }

  @override
  String toString() {
    return 'Game(id: $id, title: $title, description: $description, total_matches: $total_matches, finish_matches: $finish_matches, accessLevel: $accessLevel, created_at: $created_at, normalItemCount: $normalItemCount, user: $user, topItems: $topItems)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GameImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.total_matches, total_matches) ||
                other.total_matches == total_matches) &&
            (identical(other.finish_matches, finish_matches) ||
                other.finish_matches == finish_matches) &&
            (identical(other.accessLevel, accessLevel) ||
                other.accessLevel == accessLevel) &&
            (identical(other.created_at, created_at) ||
                other.created_at == created_at) &&
            (identical(other.normalItemCount, normalItemCount) ||
                other.normalItemCount == normalItemCount) &&
            (identical(other.user, user) || other.user == user) &&
            const DeepCollectionEquality().equals(other._topItems, _topItems));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      description,
      total_matches,
      finish_matches,
      accessLevel,
      created_at,
      normalItemCount,
      user,
      const DeepCollectionEquality().hash(_topItems));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GameImplCopyWith<_$GameImpl> get copyWith =>
      __$$GameImplCopyWithImpl<_$GameImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GameImplToJson(
      this,
    );
  }
}

abstract class _Game implements Game {
  const factory _Game(
      {@JsonKey(name: 'game_id') required final String id,
      final String title,
      final String description,
      final int total_matches,
      final int finish_matches,
      @JsonKey(name: 'access_level') final String accessLevel,
      required final DateTime created_at,
      @JsonKey(name: 'normal_item_count') final int normalItemCount,
      @JsonKey(name: 'user') final GameUser? user,
      @JsonKey(name: 'top_items') final List<GameItem> topItems}) = _$GameImpl;

  factory _Game.fromJson(Map<String, dynamic> json) = _$GameImpl.fromJson;

  @override
  @JsonKey(name: 'game_id')
  String get id;
  @override
  String get title;
  @override
  String get description;
  @override
  int get total_matches;
  @override
  int get finish_matches;
  @override
  @JsonKey(name: 'access_level')
  String get accessLevel;
  @override
  DateTime get created_at;
  @override
  @JsonKey(name: 'normal_item_count')
  int get normalItemCount;
  @override
  @JsonKey(name: 'user')
  GameUser? get user;
  @override
  @JsonKey(name: 'top_items')
  List<GameItem> get topItems;
  @override
  @JsonKey(ignore: true)
  _$$GameImplCopyWith<_$GameImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GameUser _$GameUserFromJson(Map<String, dynamic> json) {
  return _GameUser.fromJson(json);
}

/// @nodoc
mixin _$GameUser {
  @JsonKey(name: 'user_id')
  String get id => throw _privateConstructorUsedError;
  String get username => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GameUserCopyWith<GameUser> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameUserCopyWith<$Res> {
  factory $GameUserCopyWith(GameUser value, $Res Function(GameUser) then) =
      _$GameUserCopyWithImpl<$Res, GameUser>;
  @useResult
  $Res call({@JsonKey(name: 'user_id') String id, String username});
}

/// @nodoc
class _$GameUserCopyWithImpl<$Res, $Val extends GameUser>
    implements $GameUserCopyWith<$Res> {
  _$GameUserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? username = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GameUserImplCopyWith<$Res>
    implements $GameUserCopyWith<$Res> {
  factory _$$GameUserImplCopyWith(
          _$GameUserImpl value, $Res Function(_$GameUserImpl) then) =
      __$$GameUserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@JsonKey(name: 'user_id') String id, String username});
}

/// @nodoc
class __$$GameUserImplCopyWithImpl<$Res>
    extends _$GameUserCopyWithImpl<$Res, _$GameUserImpl>
    implements _$$GameUserImplCopyWith<$Res> {
  __$$GameUserImplCopyWithImpl(
      _$GameUserImpl _value, $Res Function(_$GameUserImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? username = null,
  }) {
    return _then(_$GameUserImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GameUserImpl implements _GameUser {
  const _$GameUserImpl(
      {@JsonKey(name: 'user_id') required this.id, required this.username});

  factory _$GameUserImpl.fromJson(Map<String, dynamic> json) =>
      _$$GameUserImplFromJson(json);

  @override
  @JsonKey(name: 'user_id')
  final String id;
  @override
  final String username;

  @override
  String toString() {
    return 'GameUser(id: $id, username: $username)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GameUserImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.username, username) ||
                other.username == username));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, username);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GameUserImplCopyWith<_$GameUserImpl> get copyWith =>
      __$$GameUserImplCopyWithImpl<_$GameUserImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GameUserImplToJson(
      this,
    );
  }
}

abstract class _GameUser implements GameUser {
  const factory _GameUser(
      {@JsonKey(name: 'user_id') required final String id,
      required final String username}) = _$GameUserImpl;

  factory _GameUser.fromJson(Map<String, dynamic> json) =
      _$GameUserImpl.fromJson;

  @override
  @JsonKey(name: 'user_id')
  String get id;
  @override
  String get username;
  @override
  @JsonKey(ignore: true)
  _$$GameUserImplCopyWith<_$GameUserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GameItem _$GameItemFromJson(Map<String, dynamic> json) {
  return _GameItem.fromJson(json);
}

/// @nodoc
mixin _$GameItem {
  @JsonKey(name: 'item_id')
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'media_type')
  String get mediaType => throw _privateConstructorUsedError;
  @JsonKey(name: 'media_url')
  String get mediaUrl => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'win_count')
  int get winCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'final_win_count')
  int get finalWinCount => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GameItemCopyWith<GameItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameItemCopyWith<$Res> {
  factory $GameItemCopyWith(GameItem value, $Res Function(GameItem) then) =
      _$GameItemCopyWithImpl<$Res, GameItem>;
  @useResult
  $Res call(
      {@JsonKey(name: 'item_id') String id,
      @JsonKey(name: 'media_type') String mediaType,
      @JsonKey(name: 'media_url') String mediaUrl,
      String description,
      @JsonKey(name: 'win_count') int winCount,
      @JsonKey(name: 'final_win_count') int finalWinCount});
}

/// @nodoc
class _$GameItemCopyWithImpl<$Res, $Val extends GameItem>
    implements $GameItemCopyWith<$Res> {
  _$GameItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? mediaType = null,
    Object? mediaUrl = null,
    Object? description = null,
    Object? winCount = null,
    Object? finalWinCount = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      mediaType: null == mediaType
          ? _value.mediaType
          : mediaType // ignore: cast_nullable_to_non_nullable
              as String,
      mediaUrl: null == mediaUrl
          ? _value.mediaUrl
          : mediaUrl // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      winCount: null == winCount
          ? _value.winCount
          : winCount // ignore: cast_nullable_to_non_nullable
              as int,
      finalWinCount: null == finalWinCount
          ? _value.finalWinCount
          : finalWinCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GameItemImplCopyWith<$Res>
    implements $GameItemCopyWith<$Res> {
  factory _$$GameItemImplCopyWith(
          _$GameItemImpl value, $Res Function(_$GameItemImpl) then) =
      __$$GameItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'item_id') String id,
      @JsonKey(name: 'media_type') String mediaType,
      @JsonKey(name: 'media_url') String mediaUrl,
      String description,
      @JsonKey(name: 'win_count') int winCount,
      @JsonKey(name: 'final_win_count') int finalWinCount});
}

/// @nodoc
class __$$GameItemImplCopyWithImpl<$Res>
    extends _$GameItemCopyWithImpl<$Res, _$GameItemImpl>
    implements _$$GameItemImplCopyWith<$Res> {
  __$$GameItemImplCopyWithImpl(
      _$GameItemImpl _value, $Res Function(_$GameItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? mediaType = null,
    Object? mediaUrl = null,
    Object? description = null,
    Object? winCount = null,
    Object? finalWinCount = null,
  }) {
    return _then(_$GameItemImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      mediaType: null == mediaType
          ? _value.mediaType
          : mediaType // ignore: cast_nullable_to_non_nullable
              as String,
      mediaUrl: null == mediaUrl
          ? _value.mediaUrl
          : mediaUrl // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      winCount: null == winCount
          ? _value.winCount
          : winCount // ignore: cast_nullable_to_non_nullable
              as int,
      finalWinCount: null == finalWinCount
          ? _value.finalWinCount
          : finalWinCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GameItemImpl implements _GameItem {
  const _$GameItemImpl(
      {@JsonKey(name: 'item_id') required this.id,
      @JsonKey(name: 'media_type') required this.mediaType,
      @JsonKey(name: 'media_url') required this.mediaUrl,
      this.description = '',
      @JsonKey(name: 'win_count') this.winCount = 0,
      @JsonKey(name: 'final_win_count') this.finalWinCount = 0});

  factory _$GameItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$GameItemImplFromJson(json);

  @override
  @JsonKey(name: 'item_id')
  final String id;
  @override
  @JsonKey(name: 'media_type')
  final String mediaType;
  @override
  @JsonKey(name: 'media_url')
  final String mediaUrl;
  @override
  @JsonKey()
  final String description;
  @override
  @JsonKey(name: 'win_count')
  final int winCount;
  @override
  @JsonKey(name: 'final_win_count')
  final int finalWinCount;

  @override
  String toString() {
    return 'GameItem(id: $id, mediaType: $mediaType, mediaUrl: $mediaUrl, description: $description, winCount: $winCount, finalWinCount: $finalWinCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GameItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.mediaType, mediaType) ||
                other.mediaType == mediaType) &&
            (identical(other.mediaUrl, mediaUrl) ||
                other.mediaUrl == mediaUrl) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.winCount, winCount) ||
                other.winCount == winCount) &&
            (identical(other.finalWinCount, finalWinCount) ||
                other.finalWinCount == finalWinCount));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, mediaType, mediaUrl,
      description, winCount, finalWinCount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GameItemImplCopyWith<_$GameItemImpl> get copyWith =>
      __$$GameItemImplCopyWithImpl<_$GameItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GameItemImplToJson(
      this,
    );
  }
}

abstract class _GameItem implements GameItem {
  const factory _GameItem(
          {@JsonKey(name: 'item_id') required final String id,
          @JsonKey(name: 'media_type') required final String mediaType,
          @JsonKey(name: 'media_url') required final String mediaUrl,
          final String description,
          @JsonKey(name: 'win_count') final int winCount,
          @JsonKey(name: 'final_win_count') final int finalWinCount}) =
      _$GameItemImpl;

  factory _GameItem.fromJson(Map<String, dynamic> json) =
      _$GameItemImpl.fromJson;

  @override
  @JsonKey(name: 'item_id')
  String get id;
  @override
  @JsonKey(name: 'media_type')
  String get mediaType;
  @override
  @JsonKey(name: 'media_url')
  String get mediaUrl;
  @override
  String get description;
  @override
  @JsonKey(name: 'win_count')
  int get winCount;
  @override
  @JsonKey(name: 'final_win_count')
  int get finalWinCount;
  @override
  @JsonKey(ignore: true)
  _$$GameItemImplCopyWith<_$GameItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

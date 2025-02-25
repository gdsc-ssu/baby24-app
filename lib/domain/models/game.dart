import 'package:freezed_annotation/freezed_annotation.dart';

part 'game.freezed.dart';
part 'game.g.dart';

@freezed
class Game with _$Game {
  const factory Game({
    @JsonKey(name: 'game_id') required String id,
    @Default('') String title,
    @Default('') String description,
    @Default(0) int total_matches,
    @Default(0) int finish_matches,
    @JsonKey(name: 'access_level') @Default('public') String accessLevel,
    required DateTime created_at,
    @JsonKey(name: 'normal_item_count') @Default(0) int normalItemCount,
    @JsonKey(name: 'user') GameUser? user,
    @JsonKey(name: 'top_items') @Default([]) List<GameItem> topItems,
  }) = _Game;

  factory Game.fromJson(Map<String, dynamic> json) => _$GameFromJson(json);
}

@freezed
class GameUser with _$GameUser {
  const factory GameUser({
    @JsonKey(name: 'user_id') required String id,
    required String username,
  }) = _GameUser;

  factory GameUser.fromJson(Map<String, dynamic> json) =>
      _$GameUserFromJson(json);
}

@freezed
class GameItem with _$GameItem {
  const factory GameItem({
    @JsonKey(name: 'item_id') required String id,
    @JsonKey(name: 'media_type') required String mediaType,
    @JsonKey(name: 'media_url') required String mediaUrl,
    @Default('') String description,
    @JsonKey(name: 'win_count') @Default(0) int winCount,
    @JsonKey(name: 'final_win_count') @Default(0) int finalWinCount,
  }) = _GameItem;

  factory GameItem.fromJson(Map<String, dynamic> json) =>
      _$GameItemFromJson(json);
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GameImpl _$$GameImplFromJson(Map<String, dynamic> json) => _$GameImpl(
      id: json['game_id'] as String,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      total_matches: (json['total_matches'] as num?)?.toInt() ?? 0,
      finish_matches: (json['finish_matches'] as num?)?.toInt() ?? 0,
      accessLevel: json['access_level'] as String? ?? 'public',
      created_at: DateTime.parse(json['created_at'] as String),
      normalItemCount: (json['normal_item_count'] as num?)?.toInt() ?? 0,
      user: json['user'] == null
          ? null
          : GameUser.fromJson(json['user'] as Map<String, dynamic>),
      topItems: (json['top_items'] as List<dynamic>?)
              ?.map((e) => GameItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$GameImplToJson(_$GameImpl instance) =>
    <String, dynamic>{
      'game_id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'total_matches': instance.total_matches,
      'finish_matches': instance.finish_matches,
      'access_level': instance.accessLevel,
      'created_at': instance.created_at.toIso8601String(),
      'normal_item_count': instance.normalItemCount,
      'user': instance.user,
      'top_items': instance.topItems,
    };

_$GameUserImpl _$$GameUserImplFromJson(Map<String, dynamic> json) =>
    _$GameUserImpl(
      id: json['user_id'] as String,
      username: json['username'] as String,
    );

Map<String, dynamic> _$$GameUserImplToJson(_$GameUserImpl instance) =>
    <String, dynamic>{
      'user_id': instance.id,
      'username': instance.username,
    };

_$GameItemImpl _$$GameItemImplFromJson(Map<String, dynamic> json) =>
    _$GameItemImpl(
      id: json['item_id'] as String,
      mediaType: json['media_type'] as String,
      mediaUrl: json['media_url'] as String,
      description: json['description'] as String? ?? '',
      winCount: (json['win_count'] as num?)?.toInt() ?? 0,
      finalWinCount: (json['final_win_count'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$GameItemImplToJson(_$GameItemImpl instance) =>
    <String, dynamic>{
      'item_id': instance.id,
      'media_type': instance.mediaType,
      'media_url': instance.mediaUrl,
      'description': instance.description,
      'win_count': instance.winCount,
      'final_win_count': instance.finalWinCount,
    };

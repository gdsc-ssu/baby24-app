import 'package:dio/dio.dart';
import 'package:pickiverse_app/domain/models/game.dart';

abstract class GameRepository {
  Future<List<Game>> getGames({
    required int page,
    required int limit,
    String? search,
    String? sortBy,
  });

  Future<List<Game>> getPopularGames({
    required int page,
    required int limit,
  });
}

class GameRepositoryImpl implements GameRepository {
  GameRepositoryImpl({
    required this.dio,
  });

  final Dio dio;

  @override
  Future<List<Game>> getPopularGames({
    required int page,
    required int limit,
  }) async {
    final response = await dio.get(
      '/games',
      queryParameters: {
        'page': page,
        'limit': limit,
        'order': 'total_matches',
      },
    );

    final data = response.data;
    final games = data['items'] as List<dynamic>;

    return games.map((e) => Game.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<Game>> getGames({
    required int page,
    required int limit,
    String? search,
    String? sortBy,
  }) async {
    // TODO: API 호출 구현
    // 임시 데이터 반환
    return [
      Game(
        id: 'e09df',
        title: '당신의 최애곡은? 2024 케이팝 월드컵',
        description: '2024년 한 해 동안 K-POP 씬을 뜨겁게 달군 히트곡들! 당신의 최애곡을 선택해주세요!',
        total_matches: 3995,
        finish_matches: 3697,
        accessLevel: 'public',
        created_at: DateTime.parse('2025-01-29T06:02:17.594Z'),
        normalItemCount: 40,
        user: const GameUser(
          id: 'd55db81c-0d5b-4946-a4a2-b9edc057b161',
          username: 'admin',
        ),
        topItems: [
          const GameItem(
            id: 'fbb78',
            mediaType: 'image',
            mediaUrl:
                'https://pickiverse-s3.s3.ap-northeast-2.amazonaws.com/piki/games/1738130531802-GD - HOME SWEET HOME.webp',
            description: 'GD - HOME SWEET HOME',
            winCount: 90,
            finalWinCount: 672,
          ),
          const GameItem(
            id: '3292e',
            mediaType: 'image',
            mediaUrl:
                'https://pickiverse-s3.s3.ap-northeast-2.amazonaws.com/piki/games/1738130531828-아이브 - 해야 (HEYA).gif',
            description: '아이브 - 해야 (HEYA)',
            winCount: 71,
            finalWinCount: 523,
          ),
        ],
      ),
    ];
  }
}

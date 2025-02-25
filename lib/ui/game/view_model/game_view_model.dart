import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pickiverse_app/domain/models/game.dart';

part 'game_view_model.freezed.dart';

@freezed
class GameState with _$GameState {
  const factory GameState({
    Game? game,
    @Default(false) bool isLoading,
    String? error,
  }) = _GameState;
}

class GameViewModel extends Cubit<GameState> {
  GameViewModel({
    required this.gameId,
  }) : super(const GameState());

  final String gameId;

  Future<void> loadGame() async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      // TODO: API 호출 구현
      await Future.delayed(const Duration(seconds: 1)); // 임시 딜레이

      emit(state.copyWith(
        game: Game(
          id: gameId,
          title: '임시 게임 데이터',
          description: '게임 설명',
          total_matches: 0,
          finish_matches: 0,
          accessLevel: 'public',
          created_at: DateTime.now(),
          normalItemCount: 2,
          topItems: [
            const GameItem(
              id: 'temp1',
              mediaType: 'image',
              mediaUrl: 'https://example.com/image1.jpg',
              description: '이미지 1',
              winCount: 0,
              finalWinCount: 0,
            ),
            const GameItem(
              id: 'temp2',
              mediaType: 'image',
              mediaUrl: 'https://example.com/image2.jpg',
              description: '이미지 2',
              winCount: 0,
              finalWinCount: 0,
            ),
          ],
        ),
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }
}

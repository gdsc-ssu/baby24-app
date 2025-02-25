import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pickiverse_app/data/repositories/game_repository.dart';
import 'package:pickiverse_app/domain/models/game.dart';

part 'infinite_game_view_model.freezed.dart';

@freezed
class InfiniteGameState with _$InfiniteGameState {
  const factory InfiniteGameState({
    @Default([]) List<Game> games,
    @Default(false) bool isLoading,
    @Default(null) String? error,
  }) = _InfiniteGameState;
}

class InfiniteGameViewModel extends Cubit<InfiniteGameState> {
  InfiniteGameViewModel({
    required GameRepository gameRepository,
  })  : _gameRepository = gameRepository,
        super(const InfiniteGameState());

  final GameRepository _gameRepository;

  Future<void> loadGames() async {
    if (state.isLoading) return;

    emit(state.copyWith(isLoading: true, error: null));

    try {
      final games = await _gameRepository.getPopularGames(
        page: 1,
        limit: 50,
      );

      emit(state.copyWith(
        games: games,
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

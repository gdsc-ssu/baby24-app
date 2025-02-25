import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pickiverse_app/data/repositories/game_repository.dart';
import 'package:pickiverse_app/domain/models/game.dart';
import 'package:hive/hive.dart';

part 'home_view_model.freezed.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState({
    @Default([]) List<Game> games,
    @Default(1) int currentPage,
    @Default(false) bool isLoading,
    @Default(null) String? error,
    @Default('') String searchQuery,
    @Default('인기순') String sortBy,
    @Default(false) bool isInfiniteMode,
    @Default(true) bool showInfiniteModeHelper,
  }) = _HomeState;
}

class HomeViewModel extends Cubit<HomeState> {
  HomeViewModel({
    required GameRepository gameRepository,
  })  : _gameRepository = gameRepository,
        super(const HomeState()) {
    // Load infinite mode state from Hive
    final settings = Hive.box('settings');
    final isInfiniteMode =
        settings.get('isInfiniteMode', defaultValue: false) as bool;
    emit(state.copyWith(isInfiniteMode: isInfiniteMode));
    if (isInfiniteMode) {
      emit(state.copyWith(showInfiniteModeHelper: false));
    }
  }

  final GameRepository _gameRepository;

  Future<void> loadGames() async {
    if (state.isLoading) return;

    emit(state.copyWith(isLoading: true, error: null));

    try {
      final popularGames = await _gameRepository.getPopularGames(
        page: 1,
        limit: 6,
      );

      emit(state.copyWith(
        games: popularGames,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> loadRandomGame() async {
    if (state.isLoading) return;

    emit(state.copyWith(isLoading: true, error: null));

    try {
      final games = await _gameRepository.getPopularGames(
        page: 1,
        limit: 50,
      );

      if (games.isEmpty) {
        emit(state.copyWith(
          isLoading: false,
          error: '게임을 찾을 수 없습니다.',
        ));
        return;
      }

      final random = Random();
      final randomGame = games[random.nextInt(games.length)];

      emit(state.copyWith(
        games: [randomGame],
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  void toggleInfiniteMode() {
    final settings = Hive.box('settings');
    final newValue = !state.isInfiniteMode;
    settings.put('isInfiniteMode', newValue);

    emit(state.copyWith(
      isInfiniteMode: newValue,
      showInfiniteModeHelper: false,
    ));
  }

  void dismissInfiniteModeHelper() {
    emit(state.copyWith(showInfiniteModeHelper: false));
  }

  void updateSearchQuery(String query) {
    emit(state.copyWith(
      searchQuery: query,
      currentPage: 1,
    ));
    loadGames();
  }

  void updateSortBy(String sortBy) {
    emit(state.copyWith(
      sortBy: sortBy,
      currentPage: 1,
    ));
    loadGames();
  }

  void goToPage(int page) {
    emit(state.copyWith(currentPage: page));
    loadGames();
  }
}

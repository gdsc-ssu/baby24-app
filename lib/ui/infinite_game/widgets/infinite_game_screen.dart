import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pickiverse_app/data/repositories/game_repository.dart';
import 'package:pickiverse_app/l10n/l10n.dart';
import 'package:pickiverse_app/ui/infinite_game/view_model/infinite_game_view_model.dart';
import 'package:pickiverse_app/ui/infinite_game/widgets/infinite_game_view.dart';

class InfiniteGameScreen extends StatelessWidget {
  const InfiniteGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => InfiniteGameViewModel(
        gameRepository: context.read<GameRepository>(),
      )..loadGames(),
      child: const InfiniteGameScreenView(),
    );
  }
}

class InfiniteGameScreenView extends StatelessWidget {
  const InfiniteGameScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InfiniteGameViewModel, InfiniteGameState>(
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: Builder(
              builder: (context) {
                if (state.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.error != null) {
                  return Center(child: Text(state.error!));
                }

                if (state.games.isEmpty) {
                  return Center(child: Text(context.l10n.homeEmptyGamesText));
                }

                return InfiniteGameView(games: state.games);
              },
            ),
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pickiverse_app/ui/game/view_model/game_view_model.dart';
import 'package:pickiverse_app/l10n/l10n.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({
    required this.gameId,
    super.key,
  });

  final String gameId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GameViewModel(gameId: gameId)..loadGame(),
      child: const GameView(),
    );
  }
}

class GameView extends StatelessWidget {
  const GameView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<GameViewModel, GameState>(
          buildWhen: (previous, current) => previous.game != current.game,
          builder: (context, state) {
            return Text(state.game?.title ?? '');
          },
        ),
      ),
      body: BlocBuilder<GameViewModel, GameState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error != null) {
            return Center(child: Text(state.error!));
          }

          if (state.game == null) {
            return Center(child: Text(context.l10n.gameNotFoundText));
          }

          return Center(
            child: Text(context.l10n.gameImplementationText),
          );
        },
      ),
    );
  }
}

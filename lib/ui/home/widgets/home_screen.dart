import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pickiverse_app/data/repositories/game_repository.dart';
import 'package:pickiverse_app/l10n/l10n.dart';
import 'package:pickiverse_app/ui/home/view_model/home_view_model.dart';
import 'package:pickiverse_app/ui/home/widgets/home_normal_view.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeViewModel(
        gameRepository: context.read<GameRepository>(),
      )..loadGames(),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeViewModel, HomeState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Pickiverse'),
            backgroundColor: Theme.of(context).colorScheme.background,
            elevation: 0,
            scrolledUnderElevation: 0,
          ),
          body: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
            ),
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

                return HomeNormalView(games: state.games);
              },
            ),
          ),
        );
      },
    );
  }
}

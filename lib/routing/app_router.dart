import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pickiverse_app/routing/app_routes.dart';
import 'package:pickiverse_app/ui/core/ui/bottom_navigation.dart';
import 'package:pickiverse_app/ui/game/widgets/game_screen.dart';
import 'package:pickiverse_app/ui/home/widgets/home_screen.dart';
import 'package:pickiverse_app/ui/infinite_game/widgets/infinite_game_screen.dart';

final goRouter = GoRouter(
  initialLocation: AppRoutes.home,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return BottomNavigation(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.home,
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.infiniteGame,
              builder: (context, state) => const InfiniteGameScreen(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: AppRoutes.game,
      builder: (context, state) => GameScreen(
        gameId: state.pathParameters['id']!,
      ),
    ),
  ],
);

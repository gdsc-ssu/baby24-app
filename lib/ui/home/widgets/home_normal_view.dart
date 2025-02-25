import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:pickiverse_app/domain/models/game.dart';
import 'package:pickiverse_app/l10n/l10n.dart';
import 'package:pickiverse_app/ui/core/ui/cached_image.dart';
import 'package:pickiverse_app/utils/extensions/context_extension.dart';

class HomeNormalView extends StatelessWidget {
  const HomeNormalView({required this.games, super.key});

  final List<Game> games;

  @override
  Widget build(BuildContext context) {
    final topGames = games.take(6).toList();

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.homePopularGamesTitle,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.5,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                  ),
                  itemCount: topGames.length,
                  itemBuilder: (context, index) {
                    final game = topGames[index];
                    return _GameCard(
                      game: game,
                      rank: index + 1,
                    );
                  },
                ),
                const SizedBox(height: 32),
                Text(
                  context.l10n.homeAllGamesTitle,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final game = games[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _GameListItem(game: game),
                );
              },
              childCount: games.length,
            ),
          ),
        ),
      ],
    );
  }
}

class _GameCard extends StatelessWidget {
  const _GameCard({
    required this.game,
    required this.rank,
  });

  final Game game;
  final int rank;

  @override
  Widget build(BuildContext context) {
    if (game.topItems.isEmpty) return const SizedBox.shrink();

    return InkWell(
      onTap: () => context.push('/game/${game.id}'),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedImage(
              imageUrl: game.topItems[0].mediaUrl,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          Positioned(
            top: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color:
                        Theme.of(context).colorScheme.shadow.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                context.l10n.homeRankText(rank),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.8),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Text(
                game.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GameListItem extends StatelessWidget {
  const _GameListItem({
    required this.game,
  });

  final Game game;

  @override
  Widget build(BuildContext context) {
    if (game.topItems.isEmpty) return const SizedBox.shrink();

    return InkWell(
      onTap: () => context.push('/game/${game.id}'),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey.withOpacity(0.2),
          ),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(12),
              ),
              child: SizedBox(
                width: 100,
                height: double.infinity,
                child: CachedImage(
                  imageUrl: game.topItems[0].mediaUrl,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      game.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Text(
                      context.l10n.homeParticipantsText(game.total_matches),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Icon(
                Icons.chevron_right,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

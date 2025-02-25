import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:go_router/go_router.dart';
import 'package:pickiverse_app/domain/models/game.dart';
import 'package:pickiverse_app/l10n/l10n.dart';
import 'package:pickiverse_app/routing/app_routes.dart';
import 'package:pickiverse_app/ui/core/ui/cached_image.dart';
import 'package:pickiverse_app/utils/extensions/context_extension.dart';

class InfiniteGameView extends StatefulWidget {
  const InfiniteGameView({
    required this.games,
    super.key,
  });

  final List<Game> games;

  @override
  State<InfiniteGameView> createState() => _InfiniteGameViewState();
}

class _InfiniteGameViewState extends State<InfiniteGameView> {
  late final CardSwiperController controller;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    controller = CardSwiperController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: CardSwiper(
            controller: controller,
            allowedSwipeDirection:
                const AllowedSwipeDirection.only(left: true, right: true),
            cardBuilder: (context, index, _, __) {
              final game = widget.games[index % widget.games.length];
              return _InfiniteGameCard(game: game);
            },
            cardsCount: widget.games.length,
            backCardOffset: const Offset(20, 0),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            onSwipe: (previousIndex, currentIndex, direction) {
              setState(() {
                this.currentIndex = currentIndex ?? 0;
              });
              return true;
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.swipe,
                    color: Colors.grey[600],
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '좌우로 스와이프하여 다음 게임',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final game =
                        widget.games[currentIndex % widget.games.length];
                    context.push(AppRoutes.gameRoute(game.id));
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    context.l10n.homeStartButtonText,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InfiniteGameCard extends StatelessWidget {
  const _InfiniteGameCard({
    required this.game,
  });

  final Game game;

  @override
  Widget build(BuildContext context) {
    if (game.topItems.length < 2) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              game.title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Text(
              game.description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 18),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: _GameImage(
                      imageUrl: game.topItems[0].mediaUrl,
                      onTap: () => _handleImageTap(context, true),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      context.l10n.homeVersusText,
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                  ),
                  Expanded(
                    child: _GameImage(
                      imageUrl: game.topItems[1].mediaUrl,
                      onTap: () => _handleImageTap(context, false),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleImageTap(BuildContext context, bool isLeft) {
    context.push(AppRoutes.gameRoute(game.id),
        extra: {'selectedSide': isLeft ? 'left' : 'right'});
  }
}

class _GameImage extends StatelessWidget {
  const _GameImage({
    required this.imageUrl,
    required this.onTap,
  });

  final String imageUrl;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline,
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            onTap: onTap,
            child: CachedImage(imageUrl: imageUrl),
          ),
        ),
      ),
    );
  }
}

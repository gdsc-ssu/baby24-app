import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pickiverse_app/l10n/l10n.dart';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isLightMode = Theme.of(context).brightness == Brightness.light;

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: colorScheme.outline.withOpacity(0.1),
              width: 0.5,
            ),
          ),
          color: isLightMode
              ? colorScheme.surface.withOpacity(0.9)
              : colorScheme.surface.withOpacity(0.8),
        ),
        child: ClipRect(
          child: BackdropFilter(
            filter: ColorFilter.mode(
              colorScheme.surface.withOpacity(0.1),
              BlendMode.srcOver,
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _NavItem(
                      icon: Icons.home_outlined,
                      selectedIcon: Icons.home_rounded,
                      label: '홈',
                      isSelected: navigationShell.currentIndex == 0,
                      onTap: () => _onTap(context, 0),
                    ),
                    _NavItem(
                      icon: Icons.all_inclusive_outlined,
                      selectedIcon: Icons.all_inclusive,
                      label: context.l10n.homeInfiniteModeText,
                      isSelected: navigationShell.currentIndex == 1,
                      onTap: () => _onTap(context, 1),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onTap(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      customBorder: const StadiumBorder(),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: isSelected
            ? BoxDecoration(
                color: colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(24),
              )
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? selectedIcon : icon,
              color: isSelected
                  ? colorScheme.primary
                  : colorScheme.onSurface.withOpacity(0.7),
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.onSurface.withOpacity(0.7),
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

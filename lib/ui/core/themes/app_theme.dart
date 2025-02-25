import 'package:flutter/material.dart';
import 'package:pickiverse_app/ui/core/themes/color_schemes.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: lightColorScheme,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: false,
        ),
        navigationBarTheme: NavigationBarThemeData(
          height: 64,
          elevation: 0,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          indicatorColor: lightColorScheme.primary.withOpacity(0.1),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: lightColorScheme.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      );

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        colorScheme: darkColorScheme,
        scaffoldBackgroundColor: darkColorScheme.background,
        appBarTheme: AppBarTheme(
          backgroundColor: darkColorScheme.surface,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: false,
          foregroundColor: darkColorScheme.onSurface,
        ),
        navigationBarTheme: NavigationBarThemeData(
          height: 64,
          elevation: 0,
          backgroundColor: darkColorScheme.surface,
          surfaceTintColor: Colors.transparent,
          indicatorColor: darkColorScheme.primary.withOpacity(0.2),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: darkColorScheme.primary,
            foregroundColor: darkColorScheme.onPrimary,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        cardTheme: CardTheme(
          color: darkColorScheme.surfaceVariant,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: darkColorScheme.outline,
              width: 1,
            ),
          ),
        ),
        dividerTheme: DividerThemeData(
          color: darkColorScheme.outline,
          thickness: 1,
        ),
      );
}

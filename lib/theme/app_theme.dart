import 'package:cromostracker/theme/cromo_sticker_theme.dart';
import 'package:flutter/material.dart';

ThemeData buildAppTheme() {
  const seed = Color(0xFF1565C0);
  final colorScheme = ColorScheme.fromSeed(
    seedColor: seed,
    surface: Colors.white,
    surfaceContainerLowest: const Color(0xFFF5F5F5),
    surfaceContainerHighest: const Color(0xFFE8E8E8),
  );

  return ThemeData(
    colorScheme: colorScheme,
    useMaterial3: true,
    scaffoldBackgroundColor: colorScheme.surface,
    appBarTheme: AppBarTheme(
      centerTitle: false,
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      elevation: 0,
      scrolledUnderElevation: 1,
    ),
    tabBarTheme: TabBarThemeData(
      labelColor: colorScheme.primary,
      unselectedLabelColor: colorScheme.onSurfaceVariant,
      indicatorColor: colorScheme.primary,
    ),
    extensions: const [CromoStickerTheme.light],
  );
}

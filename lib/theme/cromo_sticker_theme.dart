import 'package:flutter/material.dart';

/// Colors for sticker tile states (M3 light, reference-aligned).
@immutable
class CromoStickerTheme extends ThemeExtension<CromoStickerTheme> {
  const CromoStickerTheme({
    required this.missingBackground,
    required this.missingForeground,
    required this.ownedBackground,
    required this.ownedForeground,
    required this.swapBackground,
    required this.swapForeground,
    required this.badgeBackground,
  });

  final Color missingBackground;
  final Color missingForeground;
  final Color ownedBackground;
  final Color ownedForeground;
  final Color swapBackground;
  final Color swapForeground;
  final Color badgeBackground;

  static const CromoStickerTheme light = CromoStickerTheme(
    missingBackground: Color(0xFFE8DCC8),
    missingForeground: Color(0xFF5D4E37),
    ownedBackground: Color(0xFF1E3A5F),
    ownedForeground: Color(0xFFE3E8EF),
    swapBackground: Color(0xFFE3F2FD),
    swapForeground: Color(0xFF0D47A1),
    badgeBackground: Color(0xFF1565C0),
  );

  @override
  CromoStickerTheme copyWith({
    Color? missingBackground,
    Color? missingForeground,
    Color? ownedBackground,
    Color? ownedForeground,
    Color? swapBackground,
    Color? swapForeground,
    Color? badgeBackground,
  }) {
    return CromoStickerTheme(
      missingBackground: missingBackground ?? this.missingBackground,
      missingForeground: missingForeground ?? this.missingForeground,
      ownedBackground: ownedBackground ?? this.ownedBackground,
      ownedForeground: ownedForeground ?? this.ownedForeground,
      swapBackground: swapBackground ?? this.swapBackground,
      swapForeground: swapForeground ?? this.swapForeground,
      badgeBackground: badgeBackground ?? this.badgeBackground,
    );
  }

  @override
  CromoStickerTheme lerp(
    ThemeExtension<CromoStickerTheme>? other,
    double t,
  ) {
    if (other is! CromoStickerTheme) return this;
    return CromoStickerTheme(
      missingBackground: Color.lerp(
        missingBackground,
        other.missingBackground,
        t,
      )!,
      missingForeground: Color.lerp(
        missingForeground,
        other.missingForeground,
        t,
      )!,
      ownedBackground: Color.lerp(ownedBackground, other.ownedBackground, t)!,
      ownedForeground: Color.lerp(ownedForeground, other.ownedForeground, t)!,
      swapBackground: Color.lerp(swapBackground, other.swapBackground, t)!,
      swapForeground: Color.lerp(swapForeground, other.swapForeground, t)!,
      badgeBackground: Color.lerp(badgeBackground, other.badgeBackground, t)!,
    );
  }
}

extension CromoStickerThemeX on BuildContext {
  CromoStickerTheme get cromoStickerTheme =>
      Theme.of(this).extension<CromoStickerTheme>() ?? CromoStickerTheme.light;
}

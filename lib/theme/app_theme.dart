import 'package:flutter/material.dart';

ThemeData buildAppTheme() {
  const seed = Color(0xFF1565C0);
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: seed),
    useMaterial3: true,
  );
}

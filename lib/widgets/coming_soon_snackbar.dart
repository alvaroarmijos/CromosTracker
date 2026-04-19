import 'package:flutter/material.dart';

/// Shows a single snackbar; clears any queued snackbars first (no stacking).
void showComingSoonSnackBar(BuildContext context) {
  ScaffoldMessenger.of(context)
    ..clearSnackBars()
    ..showSnackBar(
      const SnackBar(content: Text('Próximamente')),
    );
}

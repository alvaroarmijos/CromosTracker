import 'package:flutter/material.dart';

/// Stable keys for tests and selective automation. When adding l10n, keep keys
/// aligned with ARB entries.
abstract final class UiKeys {
  static const Key navAlbum = Key('nav_album');
  static const Key navStats = Key('nav_stats');

  static const Key albumTabTodos = Key('album_tab_todos');
  static const Key albumTabFaltantes = Key('album_tab_faltantes');
  static const Key albumTabIntercambios = Key('album_tab_intercambios');

  static const Key statTotalValue = Key('stat_total_value');
  static const Key statFaltantesValue = Key('stat_faltantes_value');
  static const Key statColeccionValue = Key('stat_coleccion_value');
  static const Key statIntercambiosValue = Key('stat_intercambios_value');
  static const Key statDuplicadosValue = Key('stat_duplicados_value');
  static const Key statEspecialesValue = Key('stat_especiales_value');

  static const Key statsProgresoTitle = Key('stats_progreso_title');
}

import 'package:cromostracker/constants/ui_keys.dart';
import 'package:cromostracker/features/album/cubit/album_cubit.dart';
import 'package:cromostracker/features/album/cubit/album_state.dart';
import 'package:cromostracker/widgets/coming_soon_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AlbumCubit, AlbumState>(
      builder: (context, state) {
        final album = state.album;
        final s = state.stats;
        final scheme = Theme.of(context).colorScheme;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Stats'),
            actions: [
              IconButton(
                icon: const Icon(Icons.share_outlined),
                tooltip: 'Compartir',
                onPressed: () => showComingSoonSnackBar(context),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  album.nombre,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 4),
                Text(
                  'Temporada ${album.year}',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Resumen',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.6,
                  children: [
                    _OverviewCard(
                      overviewValueKey: UiKeys.statTotalValue,
                      label: 'Total',
                      value: s.total,
                      icon: Icons.collections_outlined,
                    ),
                    _OverviewCard(
                      overviewValueKey: UiKeys.statFaltantesValue,
                      label: 'Faltantes',
                      value: s.missingCount,
                      icon: Icons.search_off_outlined,
                    ),
                    _OverviewCard(
                      overviewValueKey: UiKeys.statColeccionValue,
                      label: 'En colección',
                      value: s.ownedCount,
                      icon: Icons.inventory_2_outlined,
                    ),
                    _OverviewCard(
                      overviewValueKey: UiKeys.statIntercambiosValue,
                      label: 'Intercambios',
                      value: s.swapStickerCount,
                      icon: Icons.swap_horiz_outlined,
                    ),
                    _OverviewCard(
                      overviewValueKey: UiKeys.statDuplicadosValue,
                      label: 'Duplicados',
                      value: s.duplicateUnits,
                      icon: Icons.add_circle_outline,
                    ),
                    _OverviewCard(
                      overviewValueKey: UiKeys.statEspecialesValue,
                      label: 'Especiales',
                      value: s.specialsCount,
                      icon: Icons.star_outline,
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Text(
                  'Progreso',
                  key: UiKeys.statsProgresoTitle,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                const _ProgressChartPlaceholder(),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _OverviewCard extends StatelessWidget {
  const _OverviewCard({
    required this.overviewValueKey,
    required this.label,
    required this.value,
    required this.icon,
  });

  final Key overviewValueKey;
  final String label;
  final int value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      elevation: 0,
      color: scheme.surfaceContainerLowest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 22, color: scheme.primary),
            const Spacer(),
            Text(
              '$value',
              key: overviewValueKey,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressChartPlaceholder extends StatefulWidget {
  const _ProgressChartPlaceholder();

  @override
  State<_ProgressChartPlaceholder> createState() =>
      _ProgressChartPlaceholderState();
}

class _ProgressChartPlaceholderState extends State<_ProgressChartPlaceholder> {
  int _segment = 0;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SegmentedButton<int>(
          segments: const [
            ButtonSegment(value: 0, label: Text('Semana')),
            ButtonSegment(value: 1, label: Text('Mes')),
            ButtonSegment(value: 2, label: Text('Año')),
          ],
          selected: {_segment},
          onSelectionChanged: (s) {
            setState(() => _segment = s.first);
          },
        ),
        const SizedBox(height: 16),
        Container(
          height: 160,
          decoration: BoxDecoration(
            color: scheme.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: scheme.outlineVariant.withValues(alpha: 0.5),
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.show_chart,
                    size: 48,
                    color: scheme.outline,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Sin datos aún. ¡Empieza a añadir cromos!',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:cromostracker/constants/ui_keys.dart';
import 'package:cromostracker/features/album/cubit/album_cubit.dart';
import 'package:cromostracker/features/album/cubit/album_state.dart';
import 'package:cromostracker/features/album/widgets/cromo_sticker_tile.dart';
import 'package:cromostracker/models/album_model.dart';
import 'package:cromostracker/models/cromo_estado.dart';
import 'package:cromostracker/models/cromo_model.dart';
import 'package:cromostracker/widgets/coming_soon_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum _AlbumFilter { all, missing, swaps }

class AlbumPage extends StatelessWidget {
  const AlbumPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: BlocBuilder<AlbumCubit, AlbumState>(
            builder: (context, state) {
              final album = state.album;
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      '${album.nombre} (${album.totalCromos})',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  ExcludeSemantics(
                    child: Icon(
                      Icons.chevron_right,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              );
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.lock_outline),
              tooltip: 'Candado',
              onPressed: () => showComingSoonSnackBar(context),
            ),
            IconButton(
              icon: const Icon(Icons.share_outlined),
              tooltip: 'Compartir',
              onPressed: () => showComingSoonSnackBar(context),
            ),
            IconButton(
              icon: const Icon(Icons.more_vert),
              tooltip: 'Menú',
              onPressed: () => showComingSoonSnackBar(context),
            ),
          ],
        ),
        body: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(key: UiKeys.albumTabTodos, text: 'Todos'),
                Tab(key: UiKeys.albumTabFaltantes, text: 'Faltantes'),
                Tab(key: UiKeys.albumTabIntercambios, text: 'Intercambios'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  BlocBuilder<AlbumCubit, AlbumState>(
                    builder: (context, state) => _AlbumTabBody(
                      filter: _AlbumFilter.all,
                      album: state.album,
                    ),
                  ),
                  BlocBuilder<AlbumCubit, AlbumState>(
                    builder: (context, state) => _AlbumTabBody(
                      filter: _AlbumFilter.missing,
                      album: state.album,
                    ),
                  ),
                  BlocBuilder<AlbumCubit, AlbumState>(
                    builder: (context, state) => _AlbumTabBody(
                      filter: _AlbumFilter.swaps,
                      album: state.album,
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
}

class _AlbumTabBody extends StatelessWidget {
  const _AlbumTabBody({
    required this.filter,
    required this.album,
  });

  final _AlbumFilter filter;
  final AlbumModel album;

  List<CromoModel> _filtered() {
    return album.cromos.where((c) {
      switch (filter) {
        case _AlbumFilter.all:
          return true;
        case _AlbumFilter.missing:
          return c.estado == CromoEstado.missing;
        case _AlbumFilter.swaps:
          return c.estado == CromoEstado.swap;
      }
    }).toList();
  }

  Map<String, List<CromoModel>> _groupBySection(List<CromoModel> items) {
    final map = <String, List<CromoModel>>{};
    for (final c in items) {
      map.putIfAbsent(c.seccion, () => []).add(c);
    }
    return map;
  }

  IconData _sectionIcon(String sectionName) {
    final n = sectionName.toLowerCase();
    if (n.contains('estadio')) return Icons.stadium_outlined;
    if (n.contains('leyenda')) return Icons.military_tech_outlined;
    if (n.contains('introducción')) return Icons.info_outline;
    if (n.contains('calendario')) return Icons.event_outlined;
    if (n.contains('historia')) return Icons.auto_stories_outlined;
    if (n.contains('camino')) return Icons.route_outlined;
    if (n.contains('récord')) return Icons.leaderboard_outlined;
    if (n.contains('grupo') || n.contains('fase')) {
      return Icons.emoji_events_outlined;
    }
    return Icons.flag_outlined;
  }

  @override
  Widget build(BuildContext context) {
    final items = _filtered();
    if (items.isEmpty) {
      return _EmptyAlbumState(filter: filter);
    }

    final sections = _groupBySection(items);
    final keys = sections.keys.toList();

    // CustomScrollView + SliverGrid avoids nested ListView/GridView shrinkWrap
    // for large albums; revisit with a single SliverChildBuilderDelegate if
    // profiling shows jank with many sections.
    return LayoutBuilder(
      builder: (context, constraints) {
        final cols = _gridColumnCount(constraints.maxWidth);
        return CustomScrollView(
          slivers: [
            for (var index = 0; index < keys.length; index++) ...[
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    16,
                    index == 0 ? 16 : 24,
                    16,
                    0,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _sectionIcon(keys[index]),
                        size: 22,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          keys[index],
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: cols,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 0.92,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, i) {
                      final c = sections[keys[index]]![i];
                      return CromoStickerTile(
                        key: ValueKey<String>('cromo-${c.id}'),
                        cromo: c,
                        onTap: () => context.read<AlbumCubit>().tapCromo(c.id),
                      );
                    },
                    childCount: sections[keys[index]]!.length,
                  ),
                ),
              ),
            ],
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        );
      },
    );
  }
}

int _gridColumnCount(double width) {
  if (width >= 900) return 5;
  if (width >= 600) return 4;
  return 3;
}

class _EmptyAlbumState extends StatelessWidget {
  const _EmptyAlbumState({required this.filter});

  final _AlbumFilter filter;

  @override
  Widget build(BuildContext context) {
    if (filter != _AlbumFilter.swaps) {
      return const Center(child: Text('Nada que mostrar'));
    }
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.swap_horiz_rounded,
              size: 64,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              'Sin cromos para intercambio',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Marca repetidos en el álbum para verlos aquí.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

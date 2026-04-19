import 'package:cromostracker/features/album/cubit/album_cubit.dart';
import 'package:cromostracker/features/album/cubit/album_state.dart';
import 'package:cromostracker/models/cromo_estado.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum _AlbumFilter { all, missing, swaps }

class AlbumPage extends StatefulWidget {
  const AlbumPage({super.key});

  @override
  State<AlbumPage> createState() => _AlbumPageState();
}

class _AlbumPageState extends State<AlbumPage> {
  _AlbumFilter _filter = _AlbumFilter.all;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AlbumCubit, AlbumState>(
      builder: (context, state) {
        final album = state.album;
        final filtered = album.cromos.where((c) {
          switch (_filter) {
            case _AlbumFilter.all:
              return true;
            case _AlbumFilter.missing:
              return c.estado == CromoEstado.missing;
            case _AlbumFilter.swaps:
              return c.estado == CromoEstado.swap;
          }
        }).toList();

        return Scaffold(
          appBar: AppBar(
            title: Text('${album.nombre} (${album.totalCromos})'),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: SegmentedButton<_AlbumFilter>(
                  segments: const [
                    ButtonSegment(
                      value: _AlbumFilter.all,
                      label: Text('Todos'),
                    ),
                    ButtonSegment(
                      value: _AlbumFilter.missing,
                      label: Text('Faltantes'),
                    ),
                    ButtonSegment(
                      value: _AlbumFilter.swaps,
                      label: Text('Intercambios'),
                    ),
                  ],
                  selected: {_filter},
                  onSelectionChanged: (s) {
                    setState(() => _filter = s.first);
                  },
                ),
              ),
              Expanded(
                child: filtered.isEmpty
                    ? const Center(child: Text('Nada que mostrar'))
                    : ListView.builder(
                        itemCount: filtered.length,
                        itemBuilder: (context, i) {
                          final c = filtered[i];
                          return ListTile(
                            title: Text('#${c.numero} · ${c.seccion}'),
                            subtitle: Text(
                              '${c.estado.name} · swap ${c.swapCount}',
                            ),
                            onTap: () =>
                                context.read<AlbumCubit>().tapCromo(c.id),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

import 'package:cromostracker/features/album/cubit/album_cubit.dart';
import 'package:cromostracker/features/album/cubit/album_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AlbumCubit, AlbumState>(
      builder: (context, state) {
        final s = state.stats;
        return Scaffold(
          appBar: AppBar(title: const Text('Stats')),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                state.album.nombre,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              _StatRow(label: 'Total', value: s.total),
              _StatRow(label: 'Faltantes', value: s.missingCount),
              _StatRow(label: 'En colección', value: s.ownedCount),
              _StatRow(
                label: 'Intercambios (cromos)',
                value: s.swapStickerCount,
              ),
              _StatRow(label: 'Unidades duplicadas', value: s.duplicateUnits),
              _StatRow(label: 'Especiales', value: s.specialsCount),
            ],
          ),
        );
      },
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({required this.label, required this.value});

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text('$value', style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }
}

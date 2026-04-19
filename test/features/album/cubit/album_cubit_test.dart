import 'package:bloc_test/bloc_test.dart';
import 'package:cromostracker/features/album/cubit/album_cubit.dart';
import 'package:cromostracker/features/album/cubit/album_state.dart';
import 'package:cromostracker/models/album_model.dart';
import 'package:cromostracker/models/cromo_estado.dart';
import 'package:cromostracker/models/cromo_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AlbumCubit', () {
    late AlbumModel base;

    setUp(() {
      base = AlbumModel(
        nombre: 't',
        year: 2026,
        totalCromos: 2,
        cromos: const [
          CromoModel(
            id: 'a',
            numero: 1,
            seccion: 's',
            tipo: 'normal',
            estado: CromoEstado.missing,
          ),
          CromoModel(
            id: 'b',
            numero: 2,
            seccion: 's',
            tipo: CromoModel.tipoSpecial,
            estado: CromoEstado.owned,
          ),
        ],
      );
    });

    blocTest<AlbumCubit, AlbumState>(
      'tap updates stats for same cubit list',
      build: () => AlbumCubit(base),
      act: (c) => c.tapCromo('a'),
      expect: () => [
        isA<AlbumState>().having(
          (s) => s.album.cromos.firstWhere((x) => x.id == 'a').estado,
          'first estado',
          CromoEstado.owned,
        ),
      ],
    );
  });
}

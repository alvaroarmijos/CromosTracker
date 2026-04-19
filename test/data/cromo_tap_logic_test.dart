import 'package:cromostracker/data/cromo_tap_logic.dart';
import 'package:cromostracker/models/album_model.dart';
import 'package:cromostracker/models/cromo_estado.dart';
import 'package:cromostracker/models/cromo_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('applyTap', () {
    test('missing -> owned, swapCount 0', () {
      final album = _album(max: 9);
      const c = CromoModel(
        id: 'x',
        numero: 1,
        seccion: 's',
        tipo: 'normal',
        estado: CromoEstado.missing,
      );
      final next = applyTap(c, album);
      expect(next.estado, CromoEstado.owned);
      expect(next.swapCount, 0);
    });

    test('owned -> swap(1)', () {
      final album = _album(max: 9);
      const c = CromoModel(
        id: 'x',
        numero: 1,
        seccion: 's',
        tipo: 'normal',
        estado: CromoEstado.owned,
      );
      final next = applyTap(c, album);
      expect(next.estado, CromoEstado.swap);
      expect(next.swapCount, 1);
    });

    test('swap increments until max then missing', () {
      final album = _album(max: 3);
      var c = const CromoModel(
        id: 'x',
        numero: 1,
        seccion: 's',
        tipo: 'normal',
        estado: CromoEstado.swap,
        swapCount: 1,
      );
      c = applyTap(c, album);
      expect(c.swapCount, 2);
      c = applyTap(c, album);
      expect(c.swapCount, 3);
      c = applyTap(c, album);
      expect(c.estado, CromoEstado.missing);
      expect(c.swapCount, 0);
    });

    test('maxDuplicateCount == 1: swap(1) -> missing', () {
      final album = _album(max: 1);
      const c = CromoModel(
        id: 'x',
        numero: 1,
        seccion: 's',
        tipo: 'normal',
        estado: CromoEstado.swap,
        swapCount: 1,
      );
      final next = applyTap(c, album);
      expect(next.estado, CromoEstado.missing);
      expect(next.swapCount, 0);
    });
  });
}

AlbumModel _album({required int max}) {
  return AlbumModel(
    nombre: 't',
    year: 2026,
    totalCromos: 0,
    cromos: const [],
    maxDuplicateCount: max,
  );
}

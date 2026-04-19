import 'package:cromostracker/data/album_stats.dart';
import 'package:cromostracker/data/mock_album_data.dart';
import 'package:cromostracker/models/album_model.dart';
import 'package:cromostracker/models/cromo_estado.dart';
import 'package:cromostracker/models/cromo_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('mock album total matches list length', () {
    final a = createMockAlbum();
    expect(a.totalCromos, a.cromos.length);
  });

  test('AlbumStats matches fixture expectations', () {
    final album = AlbumModel(
      nombre: 'Test',
      year: 2026,
      totalCromos: 3,
      cromos: const [
        CromoModel(
          id: '1',
          numero: 1,
          seccion: 'A',
          tipo: CromoModel.tipoSpecial,
          estado: CromoEstado.missing,
        ),
        CromoModel(
          id: '2',
          numero: 2,
          seccion: 'A',
          tipo: 'normal',
          estado: CromoEstado.owned,
        ),
        CromoModel(
          id: '3',
          numero: 3,
          seccion: 'A',
          tipo: 'normal',
          estado: CromoEstado.swap,
          swapCount: 2,
        ),
      ],
    );
    final s = AlbumStats.fromAlbum(album);
    expect(s.total, 3);
    expect(s.missingCount, 1);
    expect(s.ownedCount, 1);
    expect(s.swapStickerCount, 1);
    expect(s.duplicateUnits, 2);
    expect(s.specialsCount, 1);
  });
}

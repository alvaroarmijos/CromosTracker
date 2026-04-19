import 'package:cromostracker/data/panini_wc26/panini_wc26_album.dart';
import 'package:cromostracker/models/cromo_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Panini WC26 album invariants: layout version, count, IDs, order', () {
    final album = buildPaniniMundial2026Album();

    expect(album.albumLayoutVersion, kPaniniMundial2026AlbumLayoutVersion);
    expect(album.totalCromos, 980);
    expect(album.cromos.length, 980);

    final ids = album.cromos.map((c) => c.id).toSet();
    expect(ids.length, 980);

    for (var i = 0; i < 980; i++) {
      final expected = 'wc26-${(i + 1).toString().padLeft(3, '0')}';
      expect(album.cromos[i].id, expected);
      expect(album.cromos[i].numero, i + 1);
    }

    expect(album.cromos.first.seccion, 'Introducción');
    expect(album.cromos[19].numero, 20);
    expect(album.cromos[20].seccion, 'Grupo A — México');
    expect(album.cromos[20].tipo, 'normal');
    const mexicoSection = 'Grupo A — México';
    final mexicoCromos = album.cromos
        .where((c) => c.seccion == mexicoSection)
        .toList();
    expect(mexicoCromos, hasLength(20));
    expect(mexicoCromos.first.tipo, 'normal');
    expect(mexicoCromos.last.tipo, CromoModel.tipoSpecial);
    expect(album.cromos.last.id, 'wc26-980');

    var teamSections = 0;
    for (final c in album.cromos) {
      if (c.seccion.startsWith('Grupo ')) {
        teamSections++;
      }
    }
    expect(teamSections, 960);

    var specials = 0;
    for (final c in album.cromos) {
      if (c.tipo == CromoModel.tipoSpecial) {
        specials++;
      }
    }
    expect(specials, 48);
  });
}

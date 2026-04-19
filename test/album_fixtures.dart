import 'package:cromostracker/models/album_model.dart';
import 'package:cromostracker/models/cromo_estado.dart';
import 'package:cromostracker/models/cromo_model.dart';

/// Small in-memory album for widget tests (avoids building 980 cromos).
///
/// Uses id `wc26-001` and sección `Introducción` so keys and semantics
/// assertions match production-shaped data.
AlbumModel createLightWidgetTestAlbum() {
  return AlbumModel(
    nombre: 'Copa Mundial FIFA 26',
    year: 2026,
    totalCromos: 1,
    cromos: const [
      CromoModel(
        id: 'wc26-001',
        numero: 1,
        seccion: 'Introducción',
        tipo: 'normal',
        estado: CromoEstado.missing,
      ),
    ],
  );
}

import 'package:cromostracker/models/album_model.dart';
import 'package:cromostracker/models/cromo_estado.dart';
import 'package:cromostracker/models/cromo_model.dart';

/// In-memory seed album for Part 1 (replace with repository later).
AlbumModel createMockAlbum() {
  const cromos = <CromoModel>[
    CromoModel(
      id: 'c-1',
      numero: 1,
      seccion: 'Fase de grupos',
      tipo: CromoModel.tipoSpecial,
      estado: CromoEstado.missing,
    ),
    CromoModel(
      id: 'c-2',
      numero: 2,
      seccion: 'Fase de grupos',
      tipo: 'normal',
      estado: CromoEstado.owned,
    ),
    CromoModel(
      id: 'c-3',
      numero: 3,
      seccion: 'Fase de grupos',
      tipo: 'normal',
      estado: CromoEstado.swap,
      swapCount: 1,
    ),
    CromoModel(
      id: 'c-4',
      numero: 10,
      seccion: 'Estadios',
      tipo: 'normal',
      estado: CromoEstado.missing,
    ),
  ];

  return AlbumModel(
    nombre: 'Mundial Demo',
    year: 2026,
    totalCromos: cromos.length,
    cromos: List<CromoModel>.from(cromos),
  );
}

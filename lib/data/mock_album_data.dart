import 'package:cromostracker/models/album_model.dart';
import 'package:cromostracker/models/cromo_estado.dart';
import 'package:cromostracker/models/cromo_model.dart';

/// Album with no stickers in [CromoEstado.swap] (empty Intercambios tab).
AlbumModel createNoSwapAlbum() {
  const cromos = <CromoModel>[
    CromoModel(
      id: 'ns-1',
      numero: 1,
      seccion: 'Demo',
      tipo: 'normal',
      estado: CromoEstado.missing,
    ),
    CromoModel(
      id: 'ns-2',
      numero: 2,
      seccion: 'Demo',
      tipo: 'normal',
      estado: CromoEstado.owned,
    ),
  ];

  return AlbumModel(
    nombre: 'Sin swaps',
    year: 2026,
    totalCromos: cromos.length,
    cromos: List<CromoModel>.from(cromos),
  );
}

/// In-memory seed album for Part 1 (replace with repository later).
AlbumModel createMockAlbum() {
  const cromos = <CromoModel>[
    CromoModel(
      id: 'c-1',
      numero: 1,
      seccion: 'Fase de grupos',
      tipo: CromoModel.tipoSpecial,
      estado: CromoEstado.missing,
      pais: 'Qatar',
    ),
    CromoModel(
      id: 'c-2',
      numero: 2,
      seccion: 'Fase de grupos',
      tipo: 'normal',
      estado: CromoEstado.owned,
      pais: 'España',
    ),
    CromoModel(
      id: 'c-3',
      numero: 3,
      seccion: 'Fase de grupos',
      tipo: 'normal',
      estado: CromoEstado.swap,
      swapCount: 1,
      pais: 'Brasil',
    ),
    CromoModel(
      id: 'c-4',
      numero: 10,
      seccion: 'Estadios',
      tipo: 'normal',
      estado: CromoEstado.missing,
    ),
    CromoModel(
      id: 'c-5',
      numero: 11,
      seccion: 'Estadios',
      tipo: 'normal',
      estado: CromoEstado.owned,
      pais: 'Ecuador',
    ),
    CromoModel(
      id: 'c-6',
      numero: 50,
      seccion: 'Leyendas',
      tipo: CromoModel.tipoSpecial,
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

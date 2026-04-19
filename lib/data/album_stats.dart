import 'package:cromostracker/models/album_model.dart';
import 'package:cromostracker/models/cromo_estado.dart';
import 'package:cromostracker/models/cromo_model.dart';
import 'package:equatable/equatable.dart';

/// Derived overview metrics (same rules as Part 2 umbrella plan).
class AlbumStats extends Equatable {
  const AlbumStats({
    required this.total,
    required this.missingCount,
    required this.ownedCount,
    required this.swapStickerCount,
    required this.duplicateUnits,
    required this.specialsCount,
  });

  factory AlbumStats.fromAlbum(AlbumModel album) {
    var missing = 0;
    var owned = 0;
    var swapStickers = 0;
    var duplicates = 0;
    var specials = 0;

    for (final c in album.cromos) {
      if (c.tipo == CromoModel.tipoSpecial) {
        specials++;
      }
      switch (c.estado) {
        case CromoEstado.missing:
          missing++;
        case CromoEstado.owned:
          owned++;
        case CromoEstado.swap:
          swapStickers++;
          duplicates += c.swapCount;
      }
    }

    return AlbumStats(
      total: album.totalCromos,
      missingCount: missing,
      ownedCount: owned,
      swapStickerCount: swapStickers,
      duplicateUnits: duplicates,
      specialsCount: specials,
    );
  }

  final int total;
  final int missingCount;
  final int ownedCount;
  final int swapStickerCount;
  final int duplicateUnits;
  final int specialsCount;

  @override
  List<Object?> get props => [
    total,
    missingCount,
    ownedCount,
    swapStickerCount,
    duplicateUnits,
    specialsCount,
  ];
}

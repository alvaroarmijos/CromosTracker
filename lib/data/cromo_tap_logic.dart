import 'package:cromostracker/models/album_model.dart';
import 'package:cromostracker/models/cromo_estado.dart';
import 'package:cromostracker/models/cromo_model.dart';

/// Applies one tap to a sticker using the album duplicate cap.
CromoModel applyTap(CromoModel cromo, AlbumModel album) {
  final maxDup = album.maxDuplicateCount;
  switch (cromo.estado) {
    case CromoEstado.missing:
      return cromo.copyWith(estado: CromoEstado.owned, swapCount: 0);
    case CromoEstado.owned:
      return cromo.copyWith(estado: CromoEstado.swap, swapCount: 1);
    case CromoEstado.swap:
      final n = cromo.swapCount;
      if (n < maxDup) {
        return cromo.copyWith(swapCount: n + 1);
      }
      return cromo.copyWith(estado: CromoEstado.missing, swapCount: 0);
  }
}

import 'package:bloc/bloc.dart';
import 'package:cromostracker/data/cromo_tap_logic.dart';
import 'package:cromostracker/features/album/cubit/album_state.dart';
import 'package:cromostracker/models/album_model.dart';

class AlbumCubit extends Cubit<AlbumState> {
  AlbumCubit(AlbumModel initial) : super(AlbumState(album: initial));

  void tapCromo(String id) {
    final album = state.album;
    final next = album.cromos.map((c) {
      if (c.id != id) return c;
      return applyTap(c, album);
    }).toList();

    emit(AlbumState(album: album.copyWith(cromos: next)));
  }
}

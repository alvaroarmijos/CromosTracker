import 'package:cromostracker/data/album_stats.dart';
import 'package:cromostracker/models/album_model.dart';
import 'package:equatable/equatable.dart';

class AlbumState extends Equatable {
  const AlbumState({required this.album});

  final AlbumModel album;

  AlbumStats get stats => AlbumStats.fromAlbum(album);

  @override
  List<Object?> get props => [album];
}

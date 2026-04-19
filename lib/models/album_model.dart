import 'package:cromostracker/models/cromo_model.dart';
import 'package:equatable/equatable.dart';

/// Album container with sticker list and swap duplicate cap.
class AlbumModel extends Equatable {
  // Cannot be const: constructor uses assert and non-const [cromos] lists.
  // ignore: prefer_const_constructors_in_immutables
  AlbumModel({
    required this.nombre,
    required this.year,
    required this.totalCromos,
    required this.cromos,
    this.maxDuplicateCount = 9,
    this.albumLayoutVersion = 1,
  }) : assert(maxDuplicateCount >= 1, 'maxDuplicateCount must be >= 1');

  final String nombre;
  final int year;

  /// Canonical total for stats; must match the length of [cromos] for seeded
  /// data.
  final int totalCromos;
  final List<CromoModel> cromos;
  final int maxDuplicateCount;

  /// Bump when sticker order/numbering changes for the same stable [CromoModel.id]s.
  final int albumLayoutVersion;

  AlbumModel copyWith({
    String? nombre,
    int? year,
    int? totalCromos,
    List<CromoModel>? cromos,
    int? maxDuplicateCount,
    int? albumLayoutVersion,
  }) {
    return AlbumModel(
      nombre: nombre ?? this.nombre,
      year: year ?? this.year,
      totalCromos: totalCromos ?? this.totalCromos,
      cromos: cromos ?? this.cromos,
      maxDuplicateCount: maxDuplicateCount ?? this.maxDuplicateCount,
      albumLayoutVersion: albumLayoutVersion ?? this.albumLayoutVersion,
    );
  }

  @override
  List<Object?> get props => [
    nombre,
    year,
    totalCromos,
    cromos,
    maxDuplicateCount,
    albumLayoutVersion,
  ];
}

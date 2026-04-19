import 'package:cromostracker/models/cromo_estado.dart';
import 'package:equatable/equatable.dart';

/// A single sticker (cromo) in an album.
class CromoModel extends Equatable {
  const CromoModel({
    required this.id,
    required this.numero,
    required this.seccion,
    required this.tipo,
    required this.estado,
    this.pais,
    this.urlBandera,
    this.swapCount = 0,
  });

  final String id;
  final int numero;
  final String seccion;

  /// Use [CromoModel.tipoSpecial] for specials counting.
  final String tipo;
  final CromoEstado estado;
  final String? pais;
  final String? urlBandera;
  final int swapCount;

  /// Normalized tipo value for specials in mock data.
  static const String tipoSpecial = 'special';

  CromoModel copyWith({
    String? id,
    int? numero,
    String? seccion,
    String? tipo,
    CromoEstado? estado,
    String? pais,
    String? urlBandera,
    int? swapCount,
  }) {
    final nextEstado = estado ?? this.estado;
    final rawSwap = swapCount ?? this.swapCount;
    final normalizedSwap = nextEstado == CromoEstado.swap ? rawSwap : 0;
    return CromoModel(
      id: id ?? this.id,
      numero: numero ?? this.numero,
      seccion: seccion ?? this.seccion,
      tipo: tipo ?? this.tipo,
      estado: nextEstado,
      pais: pais ?? this.pais,
      urlBandera: urlBandera ?? this.urlBandera,
      swapCount: normalizedSwap,
    );
  }

  @override
  List<Object?> get props => [
    id,
    numero,
    seccion,
    tipo,
    estado,
    pais,
    urlBandera,
    swapCount,
  ];
}

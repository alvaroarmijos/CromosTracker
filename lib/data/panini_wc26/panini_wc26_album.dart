// Panini Copa Mundial de la FIFA 26™ — seed data.
//
// Numeración 1…980 por bloque es PROVISIONAL hasta checklist oficial Panini.
// La app se apoya en IDs estables `wc26-001`…`wc26-980` y [albumLayoutVersion].
//
// Equipos según sorteo de grupos; validar contra la fuente primaria FIFA:
// https://www.fifa.com/en/tournaments/mens/worldcup/canadamexicousa2026/standings
//
// Las ~20 láminas "extra jugadores en acción" (paralelas / inserciones en sobres)
// NO forman parte de este listado base de 980 — son conceptos distintos de las
// 20 láminas editoriales no-equipo (980 − 960).

import 'package:cromostracker/models/album_model.dart';
import 'package:cromostracker/models/cromo_estado.dart';
import 'package:cromostracker/models/cromo_model.dart';

/// Increment when sticker order or section mapping changes (checklist oficial).
const int kPaniniMundial2026AlbumLayoutVersion = 1;

/// One national team slot: [group] is A–L, [country] display name (español).
class PaniniWc26Team {
  const PaniniWc26Team({required this.group, required this.country});

  final String group;
  final String country;
}

/// 48 selecciones en orden de sorteo: Grupo A … Grupo L, 4 equipos por grupo.
const List<PaniniWc26Team> kPaniniWc26TeamsOrdered = <PaniniWc26Team>[
  // Grupo A
  PaniniWc26Team(group: 'A', country: 'México'),
  PaniniWc26Team(group: 'A', country: 'Sudáfrica'),
  PaniniWc26Team(group: 'A', country: 'Corea del Sur'),
  PaniniWc26Team(group: 'A', country: 'República Checa'),
  // Grupo B
  PaniniWc26Team(group: 'B', country: 'Canadá'),
  PaniniWc26Team(group: 'B', country: 'Bosnia y Herzegovina'),
  PaniniWc26Team(group: 'B', country: 'Catar'),
  PaniniWc26Team(group: 'B', country: 'Suiza'),
  // Grupo C
  PaniniWc26Team(group: 'C', country: 'Brasil'),
  PaniniWc26Team(group: 'C', country: 'Marruecos'),
  PaniniWc26Team(group: 'C', country: 'Haití'),
  PaniniWc26Team(group: 'C', country: 'Escocia'),
  // Grupo D
  PaniniWc26Team(group: 'D', country: 'Estados Unidos'),
  PaniniWc26Team(group: 'D', country: 'Paraguay'),
  PaniniWc26Team(group: 'D', country: 'Australia'),
  PaniniWc26Team(group: 'D', country: 'Turquía'),
  // Grupo E
  PaniniWc26Team(group: 'E', country: 'Alemania'),
  PaniniWc26Team(group: 'E', country: 'Curazao'),
  PaniniWc26Team(group: 'E', country: 'Costa de Marfil'),
  PaniniWc26Team(group: 'E', country: 'Ecuador'),
  // Grupo F
  PaniniWc26Team(group: 'F', country: 'Países Bajos'),
  PaniniWc26Team(group: 'F', country: 'Japón'),
  PaniniWc26Team(group: 'F', country: 'Suecia'),
  PaniniWc26Team(group: 'F', country: 'Túnez'),
  // Grupo G
  PaniniWc26Team(group: 'G', country: 'Bélgica'),
  PaniniWc26Team(group: 'G', country: 'Egipto'),
  PaniniWc26Team(group: 'G', country: 'Irán'),
  PaniniWc26Team(group: 'G', country: 'Nueva Zelanda'),
  // Grupo H
  PaniniWc26Team(group: 'H', country: 'España'),
  PaniniWc26Team(group: 'H', country: 'Cabo Verde'),
  PaniniWc26Team(group: 'H', country: 'Arabia Saudita'),
  PaniniWc26Team(group: 'H', country: 'Uruguay'),
  // Grupo I
  PaniniWc26Team(group: 'I', country: 'Francia'),
  PaniniWc26Team(group: 'I', country: 'Senegal'),
  PaniniWc26Team(group: 'I', country: 'Irak'),
  PaniniWc26Team(group: 'I', country: 'Noruega'),
  // Grupo J
  PaniniWc26Team(group: 'J', country: 'Argentina'),
  PaniniWc26Team(group: 'J', country: 'Argelia'),
  PaniniWc26Team(group: 'J', country: 'Austria'),
  PaniniWc26Team(group: 'J', country: 'Jordania'),
  // Grupo K
  PaniniWc26Team(group: 'K', country: 'Portugal'),
  PaniniWc26Team(group: 'K', country: 'RD Congo'),
  PaniniWc26Team(group: 'K', country: 'Uzbekistán'),
  PaniniWc26Team(group: 'K', country: 'Colombia'),
  // Grupo L
  PaniniWc26Team(group: 'L', country: 'Inglaterra'),
  PaniniWc26Team(group: 'L', country: 'Croacia'),
  PaniniWc26Team(group: 'L', country: 'Ghana'),
  PaniniWc26Team(group: 'L', country: 'Panamá'),
];

/// Reparto provisional de las 20 láminas no ligadas a selección (números 1–20).
const List<({String seccion, int count})> kPaniniWc26GlobalStickerBlocks =
    <({String seccion, int count})>[
      (seccion: 'Introducción', count: 3),
      (seccion: 'Estadios', count: 4),
      (seccion: 'Calendario', count: 4),
      (seccion: 'Historia del Mundial', count: 3),
      (seccion: 'Camino al Mundial', count: 3),
      (seccion: 'Récords', count: 3),
    ];

String _wc26Id(int oneBasedIndex) {
  assert(
    oneBasedIndex >= 1 && oneBasedIndex <= 980,
    'wc26 index must be 1..980',
  );
  return 'wc26-${oneBasedIndex.toString().padLeft(3, '0')}';
}

String _teamSectionLabel(PaniniWc26Team team) {
  return 'Grupo ${team.group} — ${team.country}';
}

/// Álbum completo Panini Mundial 2026: 980 cromos, IDs `wc26-001`…`wc26-980`.
AlbumModel buildPaniniMundial2026Album() {
  assert(kPaniniWc26TeamsOrdered.length == 48, 'expect 48 national teams');
  var globalSum = 0;
  for (final b in kPaniniWc26GlobalStickerBlocks) {
    globalSum += b.count;
  }
  assert(globalSum == 20, 'global editorial stickers must sum to 20');

  final out = <CromoModel>[];
  var index = 1;

  for (final b in kPaniniWc26GlobalStickerBlocks) {
    for (var i = 0; i < b.count; i++) {
      out.add(
        CromoModel(
          id: _wc26Id(index),
          numero: index,
          seccion: b.seccion,
          tipo: 'normal',
          estado: CromoEstado.missing,
        ),
      );
      index++;
    }
  }

  for (final team in kPaniniWc26TeamsOrdered) {
    final section = _teamSectionLabel(team);
    for (var slot = 1; slot <= 20; slot++) {
      final isEscudo = slot == 20;
      final tipo = isEscudo ? CromoModel.tipoSpecial : 'normal';
      out.add(
        CromoModel(
          id: _wc26Id(index),
          numero: index,
          seccion: section,
          tipo: tipo,
          estado: CromoEstado.missing,
          pais: team.country,
        ),
      );
      index++;
    }
  }

  assert(index == 981, 'index ends at 981 after 980 stickers');
  assert(out.length == 980, 'output list must have 980 cromos');

  return AlbumModel(
    nombre: 'Copa Mundial FIFA 26',
    year: 2026,
    totalCromos: 980,
    cromos: out,
    // Explicit wiring so a future bump to
    // [kPaniniMundial2026AlbumLayoutVersion] is not silently dropped against
    // [AlbumModel]'s default.
    // ignore: avoid_redundant_argument_values
    albumLayoutVersion: kPaniniMundial2026AlbumLayoutVersion,
  );
}

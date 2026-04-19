---
date: 2026-04-18
topic: mundial-2026-panini-album-official-data
---

# Datos oficiales del álbum Panini Mundial 2026 + 48 selecciones (CromosTracker)

## What We're Building

Sustituir el álbum mock actual (`createMockAlbum` en `lib/data/mock_album_data.dart`) por un conjunto de datos coherente con el **álbum oficial Panini de la Copa Mundial de la FIFA 26™**, usando como fuente principal el artículo de Panini Colombia sobre páginas, láminas y formato de colección ([¿Cuántas páginas y stickers tiene el Álbum Panini 2026?](https://paninitienda.com/blogs/mundial-2026/cuantas-paginas-y-stickers-tiene-el-album-panini-mundial-2026)), y completando la lista de **48 selecciones participantes** según el sorteo del mundial (referencia cruzada: [FIFA standings](https://www.fifa.com/en/tournaments/mens/worldcup/canadamexicousa2026/standings), tabla de grupos en [Wikipedia — 2026 FIFA World Cup](https://en.wikipedia.org/wiki/2026_FIFA_World_Cup)).

El modelo existente (`AlbumModel` + `CromoModel` con `numero`, `seccion`, `tipo`, `pais`, etc.) ya admite secciones y tipos; el trabajo consiste en **definir la taxonomía de secciones**, el **mapeo número ↔ lámina** (1…980) y los metadatos por selección, sin obligar aún a persistencia ni a assets de carátulas.

## Why This Approach

Hay tres formas razonables de acercarse al problema; la recomendación favorece **datos estructurados + generación** frente a 980 líneas escritas a mano en un solo archivo Dart. **Decisión:** se adopta el enfoque **declarativo + generador** (ver *Key Decisions*).

**Generador desde definición declarativa** — **Recomendado: Sí**

Un archivo de definición (p. ej. lista de equipos ordenada, bloques de secciones especiales con rangos o recuentos) más una función Dart pura que materializa `List<CromoModel>` con IDs estables (`wc26-001` … `wc26-980`). Pros: mantenible, testeable, fácil de ajustar cuando Panini publique el checklist definitivo con números exactos por página. Cons: requiere acordar primero el **layout numérico** (ver preguntas abiertas).

- **Mejor cuando:** quieres alinear la app con el álbum real y actualizar sin reescribir cientos de líneas.

**Lista estática única en Dart**

Un solo `mock_album_data.dart` con ~980 `CromoModel` explícitos. Pros: sin capa extra, todo visible en el IDE. Cons: difícil de revisar en PR, propenso a errores de numeración, pesado para el analizador.

- **Mejor cuando:** se necesita un prototipo muy rápido y se acepta reescribir antes de release.

**Solo metadatos del álbum + placeholders por sección**

Generar 960 cromos de equipos (48×20) con números provisionales y bloques genéricos (“Estadios”, “Calendario”, …) sin asignar aún 1…980 oficial. Pros: desbloquea UI y filtros por país pronto. Cons: habrá que **renumerar** al salir el checklist Panini.

- **Mejor cuando:** el checklist oficial aún no está publicado y se prioriza demo sobre exactitud del número impreso en cada lámina.

## Key Decisions

- **Implementación de datos:** definición declarativa (listas y bloques de sección en Dart o un formato serializable) más una función pura `buildPaniniMundial2026Album()` que devuelve `AlbumModel` con `nombre`/`year` acordes y **IDs estables** (`wc26-001` … `wc26-980`). Incluir una constante **`albumLayoutVersion`** (entero) para poder cambiar el orden numérico cuando exista checklist oficial sin romper persistencia futura. Los tests deben asertar **versión + totales** (980 cromos, 48 secciones de equipo o equivalente) en lugar de depender del mock de seis ítems actual.
- **Hechos oficiales del artículo Panini (Colombia / colección):** el álbum tiene **112 páginas** y **980 láminas**; **cada sobre trae 7 láminas + 1 lámina extra insertada al azar**; **Display Box con 104 sobres**; **una variante** de álbum en versiones **Filial y Export**; **cada selección ocupa 2 páginas** con **20 láminas** (18 retratos, 1 grupal, 1 escudo en material especial); páginas temáticas adicionales: **estadios, calendario de partidos, historia del Mundial, camino al Mundial, récords**; además existen **20 láminas extra de jugadores en acción** en **4 variantes de color**, insertadas al azar (en promedio **cada 100 sobres**), en línea con el formato de 2022 — fuente: [artículo Panini Colombia citado arriba](https://paninitienda.com/blogs/mundial-2026/cuantas-paginas-y-stickers-tiene-el-album-panini-mundial-2026).
- **48 selecciones:** se toman del **sorteo de grupos** (diciembre 2025) tal como figuran en la tabla de grupos del torneo; anexo abajo con los 12 grupos (A–L) de cuatro equipos cada uno. Para implementación, **validar contra la fuente primaria FIFA** ([standings](https://www.fifa.com/en/tournaments/mens/worldcup/canadamexicousa2026/standings)); Wikipedia y prensa deportiva se usaron aquí como referencia accesible para el brainstorm.
- **Idioma en UI:** mantener **español** en nombres de sección y `pais` visibles al usuario (p. ej. “Corea del Sur”, “Estados Unidos”, “RD Congo”) salvo que el producto pida nombres FIFA en inglés.
- **Cromos “especial”:** usar `tipo: CromoModel.tipoSpecial` para **escudos en material especial** y, si se modelan aparte, para **láminas extra / paralelas** según se defina en plan (pueden vivir fuera del listado 1…980 o como subconjunto; ver preguntas abiertas).

## Risks

- **Numeración sin checklist:** cualquier orden 1…980 **provisional** será sustituible; la UI no debe asumir que el número impreso en la lámina coincide hasta validación con el PDF oficial.
- **Confusión entre dos “20”:** el artículo describe **20 láminas extra de jugadores en acción** (variantes de color, inserción en sobres) y, por aritmética del álbum, **980 − 960 = 20** láminas para páginas no ligadas a una selección (introducción, estadios, etc.). **No se asume** que sean el mismo conjunto; el plan debe separar “bloque editorial del álbum” vs “paralelas / inserciones” según el checklist.

## Open Questions

- **Numeración oficial 1…980:** el artículo Panini no publica el orden exacto de láminas por sección. ¿Se bloquea la implementación hasta un PDF/checklist oficial, o se aceptan **números provisionales** agrupados por bloques (equipos primero, luego especiales)?
- **980 vs “extras”:** el artículo habla de **980 láminas** en la colección y, por separado, de **20 láminas extra con variantes** y su frecuencia en sobres. Hay que confirmar en el checklist si esas “extra” cuentan dentro del **set base de 980** o son **paralelas** numeradas aparte (comportamiento habitual en colecciones Panini).
- **Stats / “Specials”:** definir si `AlbumStats` cuenta como *special* solo `tipo == special` o también un flag explícito si se añaden paralelas.
- **Prueba de regresión:** actualizar tests que hoy dependen de `createMockAlbum()` con recuentos fijos (pocos cromos).

## Appendix A — Selecciones por grupo (48)

Orden como en el sorteo post–diciembre 2025 (tabla de grupos). Anfitriones marcados (H) según calendario del torneo.

| Grupo | Equipos |
| --- | --- |
| A | México (H), Sudáfrica, Corea del Sur, República Checa |
| B | Canadá (H), Bosnia y Herzegovina, Catar, Suiza |
| C | Brasil, Marruecos, Haití, Escocia |
| D | Estados Unidos (H), Paraguay, Australia, Turquía |
| E | Alemania, Curazao, Costa de Marfil, Ecuador |
| F | Países Bajos, Japón, Suecia, Túnez |
| G | Bélgica, Egipto, Irán, Nueva Zelanda |
| H | España, Cabo Verde, Arabia Saudita, Uruguay |
| I | Francia, Senegal, Irak, Noruega |
| J | Argentina, Argelia, Austria, Jordania |
| K | Portugal, RD Congo, Uzbekistán, Colombia |
| L | Inglaterra, Croacia, Ghana, Panamá |

*(Nombres en español para la app; equivalencias FIFA en inglés en fuentes oficiales.)*

## Appendix B — Comprobación aritmética (orientativa)

- **48 × 20 = 960** láminas asignadas a selecciones (coincide con el desglose del artículo: 18 + 1 + 1 por equipo).
- **980 − 960 = 20** láminas restantes para **contenido no por equipo** (estadios, calendario, historia, camino, récords, etc.), pendiente de reparto exacto según el checklist impreso.

**Nota:** las **20 láminas “extra” de jugadores en acción** (cuatro variantes de color, inserción en sobres) del artículo **no se igualan** automáticamente a estas 20 plazas “editoriales”; pueden ser paralelas o rarezas. El reparto final solo puede cerrarse con el checklist oficial.

Este anexo sirve para validar el modelo de datos contra el total **980** una vez fijado el orden editorial de Panini.

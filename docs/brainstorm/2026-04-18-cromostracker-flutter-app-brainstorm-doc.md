---
date: 2026-04-18
topic: cromostracker-flutter-app
---

# CromosTracker — app Flutter para álbumes de cromos (Mundial)

## What We're Building

Aplicación Flutter nueva (`cromostracker`) para seguir la colección de cromos de un álbum tipo Mundial: marcar qué cromos faltan, cuáles están en la colección y cuáles son repetidos para intercambio, con una interfaz Material 3 clara (fondo blanco, azul para acentos y estados activos, grises para secundarios), alineada con las referencias visuales proporcionadas.

En la primera entrega el alcance funcional se centra en dos destinos del shell principal: **Álbum** (listado por secciones con rejilla de cromos, pestañas de filtrado y ciclo de estados al tocar) y **Stats** (resumen numérico, selector Week/Month/Year y estado vacío del gráfico). **Trade** y **Settings** existen en la barra inferior como anclajes de navegación con pantallas placeholder hasta una fase posterior. Los datos serán **simulados en memoria** para validar UI y flujos, dejando el modelo de dominio listo para persistencia en planificación.

## Why This Approach

Se descartó un monorepo multipaquete en la v1 para cumplir YAGNI: el alcance es una sola app con pantallas acotadas y datos mock. Una división por **features** dentro del mismo paquete (`album`, `stats`, compartidos) encaja con las prácticas VGV de mantener límites claros sin el coste de publicar paquetes internos todavía.

Para el estado del álbum (lista de cromos, cambios cíclicos de estado y contador de swaps) se elige **Cubit/Bloc** por consistencia con el ecosistema VGV, testabilidad y evolución futura hacia repositorios y almacenamiento local. Para la v1 se recomienda **barra inferior + `IndexedStack`** (o `PageStorage` si hace falta conservar scroll) por simplicidad; **`go_router` + `StatefulShellRoute`** queda como evolución natural si se añaden deep links o rutas con parámetros antes de abrir Trade en serio.

## Key Decisions

- **Ubicación del código:** Proyecto Flutter en la **raíz del workspace** `CromosTracker`; el nombre del paquete en `pubspec.yaml` será **`cromostracker`** (convención snake_case).
- **Arquitectura:** App monolítica con carpetas por feature (`lib/features/album`, `lib/features/stats`, más `lib/models`, `lib/theme`, `lib/widgets` o `app` según plantilla), sin extraer paquetes hasta que haya necesidad real.
- **Modelos (`lib/models`):** `CromoModel` con `id`, `numero`, `seccion`, `tipo`, `estado` (`owned` | `missing` | `swap`), `pais` y `urlBandera` opcionales; **`swapCount` (int, ≥ 0)** cuando `estado == swap` (en `missing`/`owned` se normaliza a 0). `AlbumModel` con `nombre`, `año`, `totalCromos` y `List<CromoModel>`.
- **Regla de ciclo al tocar (base):** **`missing` → `owned` → `swap` → `missing`**. Al pasar de `owned` a `swap`, **`swapCount = 1`** (badge **+1**). Al pasar de `swap` a `missing`, **`swapCount = 0`**. Este bucle de **tres toques** cubre el caso sin repeticiones adicionales.
- **Repetidos +2, +3 (especificación original):** Mientras el cromo permanece en **`swap`**, los toques sucesivos pueden **incrementar** `swapCount` antes de volver a **`missing`**. La transición exacta (por ejemplo: ¿cada tap incrementa hasta un máximo y el siguiente tap cierra a `missing`, o un único tap extra tras `+1` vuelve a `missing`?) se fija en **`/plan`** para evitar estados ambiguos en la UI.
- **Tema:** Material 3, tema claro, `ColorScheme` con primario azul, superficies blancas/grises suaves; tipografía y espaciado generosos como en las referencias.
- **Shell principal:** `Scaffold` + **BottomNavigationBar** con cuatro ítems fijos; solo **Álbum** y **Stats** con implementación completa; **Trade** y **Settings** con placeholders accesibles.
- **Pantalla Álbum:** AppBar con título “{nombre} ({total})” y **chevron de álbum simulado**; acciones alineadas con las referencias: **candado**, **compartir**, **menú (tres puntos)** — sin icono “Cerrar” literal en v1 salvo que el producto lo redefina. `TabBar` con “Todos / Faltantes / Intercambios” e indicador azul; `TabBarView` filtrando por estado; lista vertical de secciones con encabezados (iconos trofeo/estadio/bandera) y por sección una rejilla no desplazable (`GridView` + `shrinkWrap` + `NeverScrollableScrollPhysics`) o, si el rendimiento lo merece, **`CustomScrollView` + slivers** en una iteración posterior.
- **Interacción cromo:** Ciclo **missing → owned → swap** (incrementando contador de repeticiones en swap) → **missing**, con estilos visuales distintos (owned oscuro, missing beige/dorado, swap con badge +N).
- **Pantalla Stats:** `SingleChildScrollView`; cabecera con compartir; bloque de info del álbum; rejilla 2×3 “Overview” con métricas **derivadas de la lista de cromos** (totales, missing, owned, swaps sumando `swapCount` o contando en estado swap según se defina en plan, **Specials** = subconjunto `tipo` especial o análogo); sección Progress con control segmentado Week/Month/Year y caja vacía con icono de gráfico y texto: **“Sin datos aún. ¡Empieza a añadir cromos!”**
- **Responsividad:** Rejillas y densidad adaptadas con `LayoutBuilder` / número de columnas según ancho para móviles en distintos tamaños.

## Open Questions

- **Inicialización del proyecto:** Ejecutar Very Good CLI / `flutter create` en la raíz del workspace: esta carpeta solo contiene `docs/` por ahora; el resto de archivos del SDK Flutter se generarán sin pisar `docs/` si el flujo de creación lo respeta. Confirmar en `/plan` o `/build` el comando exacto (template `flutter_app` de Very Good CLI u otro) y el nombre del paquete `cromostracker`.
- **Repositorio Git:** El workspace no es repo git aún; conviene `git init` y rama de feature antes de implementar (skill `create-branch`).
- **Persistencia:** Decidir en planificación si v1 permanece solo en memoria o se añade persistencia mínima (p. ej. `shared_preferences`).
- **Internacionalización:** Especificación en español; decidir si las cadenas van en ARB desde el día uno o se centralizan en un segundo paso.
- **Pestaña Intercambios vacía:** Las referencias muestran un estado vacío ilustrado cuando no hay swaps; valorar si la v1 incluye solo texto centrado o también ilustración/asset para igualar la referencia.
- **Incremento de `swapCount` (+2, +3):** Cerrar en plan la máquina de estados o reglas de toque para no solapar “incrementar repetidos” con “volver a faltar”.

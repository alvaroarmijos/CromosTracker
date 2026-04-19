import 'package:cromostracker/models/cromo_estado.dart';
import 'package:cromostracker/models/cromo_model.dart';
import 'package:cromostracker/theme/cromo_sticker_theme.dart';
import 'package:flutter/material.dart';

/// Single sticker cell: state styling, optional flag, swap [+N] badge, a11y.
class CromoStickerTile extends StatelessWidget {
  const CromoStickerTile({
    required this.cromo,
    required this.onTap,
    super.key,
  });

  final CromoModel cromo;
  final VoidCallback onTap;

  String _estadoLabelEs(CromoEstado e) {
    switch (e) {
      case CromoEstado.missing:
        return 'falta';
      case CromoEstado.owned:
        return 'en colección';
      case CromoEstado.swap:
        return 'para intercambio';
    }
  }

  String _semanticLabel() {
    final base =
        'Cromo número ${cromo.numero}, sección ${cromo.seccion}, '
        '${_estadoLabelEs(cromo.estado)}';
    if (cromo.estado == CromoEstado.swap && cromo.swapCount >= 1) {
      return '$base, ${cromo.swapCount} para intercambio';
    }
    return base;
  }

  @override
  Widget build(BuildContext context) {
    final t = context.cromoStickerTheme;
    final scheme = Theme.of(context).colorScheme;

    late Color bg;
    late Color fg;
    switch (cromo.estado) {
      case CromoEstado.missing:
        bg = t.missingBackground;
        fg = t.missingForeground;
      case CromoEstado.owned:
        bg = t.ownedBackground;
        fg = t.ownedForeground;
      case CromoEstado.swap:
        bg = t.swapBackground;
        fg = t.swapForeground;
    }

    final showBadge = cromo.estado == CromoEstado.swap && cromo.swapCount >= 1;

    return Semantics(
      label: _semanticLabel(),
      button: true,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
        child: Material(
          color: bg,
          borderRadius: BorderRadius.circular(12),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          _FlagOrInitials(cromo: cromo),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '${cromo.numero}',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    color: fg,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Text(
                        cromo.seccion,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: fg.withValues(alpha: 0.85),
                        ),
                      ),
                    ],
                  ),
                ),
                if (showBadge)
                  Positioned(
                    right: 4,
                    bottom: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: t.badgeBackground,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '+${cromo.swapCount}',
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(
                              color: scheme.onPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FlagOrInitials extends StatelessWidget {
  const _FlagOrInitials({required this.cromo});

  final CromoModel cromo;

  String _initials() {
    final p = cromo.pais;
    if (p == null || p.isEmpty) return '?';
    final parts = p.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return (parts[0][0] + parts[1][0]).toUpperCase();
    }
    return p.length >= 2 ? p.substring(0, 2).toUpperCase() : p.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final url = cromo.urlBandera;
    if (url != null && url.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Image.network(
          url,
          width: 28,
          height: 20,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _placeholder(context),
        ),
      );
    }
    return _placeholder(context);
  }

  Widget _placeholder(BuildContext context) {
    return Container(
      width: 28,
      height: 20,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        _initials(),
        style: Theme.of(context).textTheme.labelSmall,
      ),
    );
  }
}

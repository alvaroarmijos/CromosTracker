---
title: "feat: CromosTracker Flutter app (album, stats, mock data)"
type: feat
date: 2026-04-18
---

> **Note:** This plan has been split into parts. Implement using the **part** files below (merge **Part 1** before **Part 2**).

## Split plans

| Order | Document | Scope |
|-------|----------|--------|
| 1 | [2026-04-18-feat-cromostracker-flutter-app-v1-part-1-plan.md](./2026-04-18-feat-cromostracker-flutter-app-v1-part-1-plan.md) | Git, Very Good scaffold, `lib/data` + immutable models, shared **AlbumCubit**, tap machine, minimal Album/Stats + shell, unit tests |
| 2 | [2026-04-18-feat-cromostracker-flutter-app-v1-part-2-plan.md](./2026-04-18-feat-cromostracker-flutter-app-v1-part-2-plan.md) | Full Album/Stats UI, AppBar, tabs, grids, Stats overview + empty chart segments, theme/a11y/widget tests |

## Umbrella summary (authoritative behavior)

- **Package**: `cromostracker` at repo root; brainstorm: [2026-04-18-cromostracker-flutter-app-brainstorm-doc](../brainstorm/2026-04-18-cromostracker-flutter-app-brainstorm-doc.md).
- **Tap machine**: `missing` → `owned` → `swap` (`swapCount = 1`) → in `swap`, increment while `n < album.maxDuplicateCount`; when `n == maxDuplicateCount`, next tap → `missing`, `swapCount = 0`.
- **Stats**: **Total** = `AlbumModel.totalCromos`; Missing / Owned / Swaps (sticker count in `swap`) / Duplicate units = `sum(swapCount)` for `swap` / Specials from `tipo`; same Cubit as Album.
- **v1**: memory-only mock; Trade & Settings placeholders.

Technical review notes incorporated: **`lib/data/`** boundary, **immutable** models, **single Cubit** for both tabs, **very_good_analysis**, locked **Total** / **Specials**, optional simplifications (e.g. **`IndexedStack` only**) are reflected in Part 1 / Part 2.

---
title: "feat: CromosTracker Album & Stats UI polish"
type: feat
date: 2026-04-18
---

## feat: CromosTracker Album & Stats UI polish — Standard

> **Part 2 of 2.** Requires: [2026-04-18-feat-cromostracker-flutter-app-v1-part-1-plan.md](./2026-04-18-feat-cromostracker-flutter-app-v1-part-1-plan.md) merged first.

## Overview

Complete **Album** and **Stats** to match the product brainstorm: **AppBar** (title `"{nombre} ({totalCromos})"`, decorative chevron, **candado / compartir / menú** with **SnackBar “Próximamente”** or no-op + **semantics**), **TabBar** **Todos / Faltantes / Intercambios** with **immediate** list updates when filters no longer match, **section headers** and **per-section grids** (`GridView` + `shrinkWrap` + `NeverScrollableScrollPhysics` until sliver optimization), **sticker visuals** (missing / owned / swap + **`+swapCount`** badge whenever `estado == swap` and `swapCount ≥ 1`), **flag** fallback. **Stats**: scrollable layout, album info, **2×3 overview** (definitions unchanged from Part 1), **Week | Month | Year** segments with **empty chart** copy **“Sin datos aún. ¡Empieza a añadir cromos!”** for each (or shared block — implement to match references). **Theme** refinement, **`LayoutBuilder`** for responsive columns as needed. **Widget tests** for shell, tab filter removal, accessibility baselines.

## Problem Statement / Motivation

Part 1 delivers correct **behavior** and **structure**; Part 2 delivers **reference-aligned UX** and **regression tests** for navigation and filtering.

## Proposed Solution

### Album UI

- **AppBar** actions: accessible labels; no throws.
- **Tabs + `TabBarView`**: filter **All** / **missing** / **swap**; items **disappear immediately** when state changes off-tab.
- **Sections**: vertical list; headers with icons per brainstorm; grids as specified.
- **Empty Intercambios**: centered empty state (illustration optional).
- **Images**: `urlBandera` null / error → initials or placeholder icon.

### Stats UI

- **Overview grid**: same formulas as Part 1; **recompute** on Cubit changes (already true — verify in UI).
- **Progress**: segmented **Week / Month / Year**; v1 **no time-series data** — show **empty** state per plan/brainstorm (three segments may each show the same empty copy, or one container — **match design references**).
- **Share** row: same snackbar/no-op rule as Album.

### Internationalization

- Lock **one** approach: **Spanish literals** in feature files **or** ARB — **no mixed** styles.

### Trade & Settings

- Unchanged placeholders unless copy tweaks needed; **Android back** safe.

### Testing (Part 2 scope)

- **Widget tests**: bottom nav, **filter removes sticker** when leaving tab, key a11y behaviors.
- **Goldens** optional per team.

## Technical Considerations

- **Nested scroll**: `shrinkWrap` grids — profile; move to **CustomScrollView** + slivers if jank.
- **Reduced motion**: respect system animation preferences where trivial for badge updates.

## Acceptance Criteria

- [ ] Album matches **AppBar**, **tabs**, **sections**, **grids**, **empty states**, **flags** above.
- [ ] **Badge**: show **`+swapCount`** for every `swap` with `swapCount ≥ 1` (including **+1**).
- [ ] **Stats** 2×3 + empty progress/chart UX per brainstorm; **Week/Month/Year** present with empty copy.
- [ ] **Theme**: M3 light blue/white/gray; distinct sticker states.
- [ ] **Responsive**: grid columns adapt via **`LayoutBuilder`** (or document fixed columns + one breakpoint).
- [ ] **a11y**: sticker semantics (number, section, state, swap count); **48×48** minimum touch targets.
- [ ] **Widget tests** for shell + tab filter behavior.
- [ ] **i18n** single strategy end-to-end.

## Success Metrics

- Visual review against references; QA can execute **swap** and **filter** flows without ambiguity.

## Dependencies & Risks

| Risk | Mitigation |
|------|------------|
| Scope creep (Trade) | Keep placeholders |

## Dependencies (merge order)

- **Requires** [Part 1](./2026-04-18-feat-cromostracker-flutter-app-v1-part-1-plan.md) merged: shared Cubit, models, mock, shell baseline.

## References & Research

- Umbrella (split): [2026-04-18-feat-cromostracker-flutter-app-v1-plan.md](./2026-04-18-feat-cromostracker-flutter-app-v1-plan.md)
- Brainstorm: [2026-04-18-cromostracker-flutter-app-brainstorm-doc](../brainstorm/2026-04-18-cromostracker-flutter-app-brainstorm-doc.md)

## Implementation todos

- [ ] Album full UI + theme polish
- [ ] Stats overview + segmented empty chart UX
- [ ] Flag fallbacks + empty Intercambios
- [ ] Widget tests + a11y pass
- [ ] Responsive columns

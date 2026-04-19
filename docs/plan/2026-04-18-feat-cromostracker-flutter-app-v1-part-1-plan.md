---
title: "feat: CromosTracker foundation (scaffold, domain, Cubit, shell)"
type: feat
date: 2026-04-18
---

## feat: CromosTracker foundation (scaffold, domain, Cubit, shell) — Standard

> **Part 1 of 2.** Next: [2026-04-18-feat-cromostracker-flutter-app-v1-part-2-plan.md](./2026-04-18-feat-cromostracker-flutter-app-v1-part-2-plan.md)

## Overview

Establish the **CromosTracker** repository and Flutter app at the **workspace root**: **Git** + **Very Good CLI `flutter_app`** (`cromostracker`), **immutable** `AlbumModel` / `CromoModel`, **mock album seed** in **`lib/data/`**, **single shared `AlbumCubit`** (or equivalent) implementing the **documented tap state machine** and **stats derivations**, **Material 3** base theme, and a **bottom navigation shell** with **`IndexedStack`** and four destinations — **Album** and **Stats** showing **minimal but real** UI wired to the **same Cubit instance** so counts update; **Trade** and **Settings** as placeholders. **Unit tests** cover the state machine and stats formulas.

## Problem Statement / Motivation

Greenfield work must land a **reviewable, analyzable** baseline before full Album/Stats UI polish. This part proves **architecture** (data boundary, immutability, single source of truth), **tooling** (`very_good_analysis`), and **correct domain behavior** without blocking on pixel-perfect UI.

## Proposed Solution

### Git and scaffold

1. **`git init`**, initial commit for existing **`docs/`**, default branch **`main`**, branch **`feat/cromostracker-flutter-app`**.
2. **Very Good CLI** `flutter_app`, package **`cromostracker`**, org/bundle id set (no template placeholder). Preserve **`docs/`** (scaffold from parent or merge tree carefully).
3. **`flutter pub get`** / packages install; **`dart analyze` / `flutter analyze`** clean under template **`very_good_analysis`** (no new ignores without justification).

### Layout (illustrative)

- `lib/app/` — `App`, theme wiring, providers.
- `lib/data/` — mock album provider / seed (single place for list mutation concerns later).
- `lib/models/` — `AlbumModel`, `CromoModel`.
- `lib/features/{album,stats,trade,settings}/` — feature UI; v1 Album/Stats can be **simple lists or stub grids** proving filters + stats.
- `lib/theme/` — M3 light seed colors (refined in Part 2).

### Domain

- **`CromoModel`**: `id`, `numero`, `seccion`, `tipo`, `estado` (`owned` | `missing` | `swap`), optional `pais`, `urlBandera`, `swapCount` (≥ 0); **immutable** (`final`, `copyWith`); **`swapCount` normalized to 0** when not `swap`.
- **`AlbumModel`**: `nombre`, `año`, **`totalCromos`** (canonical **Total** for Stats — must match seeded list length or be asserted in tests), `List<CromoModel>`, **`maxDuplicateCount`** (≥ 1, default **9** unless product locks **1**).

### Tap state machine (unchanged from umbrella spec)

| Current | Action |
|--------|--------|
| `missing` | → `owned` |
| `owned` | → `swap`, `swapCount = 1` |
| `swap`, `swapCount = n` | If `n < album.maxDuplicateCount`: stay `swap`, `swapCount = n + 1`. If `n == album.maxDuplicateCount`: → `missing`, `swapCount = 0` |

Single tap = one transition or one increment.

### State management

- **One `AlbumCubit`** (or feature-level cubit) **provided above the shell** so **Album and Stats read the same instance** — no duplicated lists.
- Transitions only inside Cubit or **pure functions** called by Cubit (tested).

### Shell

- **`Scaffold` + `BottomNavigationBar` + `IndexedStack`** (four children).
- **Trade / Settings**: `Scaffold` + title, no crashes.

### Testing (Part 1 scope)

- **Cubit / pure logic**: full transition table, `maxDuplicateCount == 1` and `> 1`, `swapCount` normalization, **stats formulas** vs fixed fixture (`Total` = `AlbumModel.totalCromos`, Missing/Owned/Swaps/Duplicate units/Specials per umbrella definitions).
- **Widget tests** optional or minimal here (shell smoke acceptable).

## Technical Considerations

- **No** `shared_preferences` in Part 1.
- **Widgets** depend on **Cubit**, not on mock lists directly.
- Document **`MaterialApp` title** (“CromosTracker”) vs Dart package **`cromostracker`**.

## Acceptance Criteria

- [ ] Git history + feature branch exist; **`docs/`** preserved.
- [ ] **`cromostracker`** Very Good app at repo root; **analyze** clean.
- [ ] **`lib/data/`** holds mock seed; **`lib/models/`** immutable models.
- [ ] **Single** album Cubit **shared** by Album + Stats tabs.
- [ ] Tap machine + **`maxDuplicateCount`** on **`AlbumModel`** implemented and **unit-tested**.
- [ ] **Stats formulas** match umbrella plan; **Total** = **`AlbumModel.totalCromos`** (tests assert consistency with mock).
- [ ] **Shell**: bottom nav + **`IndexedStack`** + four tabs; Album/Stats show **live** data from Cubit (minimal UI OK).
- [ ] **Specials**: mock `tipo` rule fixed + one test counting specials.
- [ ] **Product IDs**: Android `applicationId` / iOS bundle id set.

## Success Metrics

- App runs; changing a sticker updates **Stats** numbers **without** a second Cubit.
- CI/analyze green.

## Dependencies & Risks

| Risk | Mitigation |
|------|------------|
| CLI vs `docs/` | Dry-run tree; copy from temp dir if needed |

## Dependencies (merge order)

- **None** — merge this PR before Part 2.

## References & Research

- Umbrella (split): [2026-04-18-feat-cromostracker-flutter-app-v1-plan.md](./2026-04-18-feat-cromostracker-flutter-app-v1-plan.md)
- Brainstorm: [2026-04-18-cromostracker-flutter-app-brainstorm-doc](../brainstorm/2026-04-18-cromostracker-flutter-app-brainstorm-doc.md)

## Implementation todos

- [ ] `git init`, commit `docs/`, branch `feat/cromostracker-flutter-app`
- [ ] Scaffold `cromostracker` at root
- [ ] Models + `lib/data` mock + Cubit + provider scope
- [ ] Shell + minimal Album/Stats + placeholders
- [ ] Unit tests (state machine + stats)

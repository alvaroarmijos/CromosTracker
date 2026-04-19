import 'package:cromostracker/app/cromos_tracker_app.dart';
import 'package:cromostracker/constants/ui_keys.dart';
import 'package:cromostracker/data/mock_album_data.dart';
import 'package:cromostracker/features/album/cubit/album_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../album_fixtures.dart';
import '../../test_ui_strings.dart';

AlbumCubit _lightCubit() => AlbumCubit(createLightWidgetTestAlbum());

void main() {
  testWidgets('Faltantes tab removes sticker after tap changes state', (
    tester,
  ) async {
    await tester.pumpWidget(CromosTrackerApp(albumCubit: _lightCubit()));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(UiKeys.albumTabFaltantes));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey<String>('cromo-wc26-001')),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const ValueKey<String>('cromo-wc26-001')));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey<String>('cromo-wc26-001')), findsNothing);
  });

  testWidgets('bottom nav switches to Stats', (tester) async {
    await tester.pumpWidget(CromosTrackerApp(albumCubit: _lightCubit()));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(UiKeys.navStats));
    await tester.pumpAndSettle();

    expect(find.text('Resumen'), findsOneWidget);
    expect(find.byKey(UiKeys.statsProgresoTitle), findsOneWidget);
  });

  testWidgets('Stats Faltantes decreases after claiming a missing cromo', (
    tester,
  ) async {
    await tester.pumpWidget(CromosTrackerApp(albumCubit: _lightCubit()));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(UiKeys.navStats));
    await tester.pumpAndSettle();

    final beforeText = tester.widget<Text>(
      find.byKey(UiKeys.statFaltantesValue),
    );
    final before = int.parse(beforeText.data!);

    await tester.tap(find.byKey(UiKeys.navAlbum));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(UiKeys.albumTabFaltantes));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey<String>('cromo-wc26-001')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(UiKeys.navStats));
    await tester.pumpAndSettle();

    final afterText = tester.widget<Text>(
      find.byKey(UiKeys.statFaltantesValue),
    );
    final after = int.parse(afterText.data!);

    expect(after, before - 1);
  });

  testWidgets('Intercambios tab shows empty state when album has no swaps', (
    tester,
  ) async {
    final cubit = AlbumCubit(createNoSwapAlbum());
    await tester.pumpWidget(CromosTrackerApp(albumCubit: cubit));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(UiKeys.albumTabIntercambios));
    await tester.pumpAndSettle();

    expect(find.text(TestUiStrings.emptyIntercambiosTitle), findsOneWidget);
  });

  testWidgets('cromo tile exposes expected semantic label', (tester) async {
    await tester.pumpWidget(CromosTrackerApp(albumCubit: _lightCubit()));
    await tester.pumpAndSettle();

    final handle = tester.ensureSemantics();
    final node = tester.getSemantics(
      find.byKey(const ValueKey<String>('cromo-wc26-001')),
    );
    final label = node.label;
    handle.dispose();

    expect(label, isNotNull);
    expect(label, contains('Cromo número 1'));
    expect(label, contains('Introducción'));
    expect(label, contains('falta'));
  });
}

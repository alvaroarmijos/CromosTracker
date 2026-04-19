import 'package:cromostracker/app/cromos_tracker_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Faltantes tab removes sticker after tap changes state', (
    tester,
  ) async {
    await tester.pumpWidget(const CromosTrackerApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Faltantes'));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey<String>('cromo-c-1')), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey<String>('cromo-c-1')));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey<String>('cromo-c-1')), findsNothing);
  });

  testWidgets('bottom nav switches to Stats', (tester) async {
    await tester.pumpWidget(const CromosTrackerApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('nav_stats')));
    await tester.pumpAndSettle();

    expect(find.text('Resumen'), findsOneWidget);
    expect(find.text('Progreso'), findsOneWidget);
  });
}

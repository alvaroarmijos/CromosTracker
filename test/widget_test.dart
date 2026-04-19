import 'package:cromostracker/app/cromos_tracker_app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('app loads shell with bottom navigation', (tester) async {
    await tester.pumpWidget(const CromosTrackerApp());
    await tester.pumpAndSettle();

    expect(find.text('Mundial Demo (4)'), findsOneWidget);
    expect(find.text('Álbum'), findsOneWidget);
    expect(find.text('Stats'), findsOneWidget);
  });
}

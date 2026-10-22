import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glitchquest/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('player can complete the first case and earn progress', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(430, 932);
    tester.view.devicePixelRatio = 1;
    await tester.pumpWidget(const GlitchQuestApp());
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();

    expect(find.text('Every glitch\nleaves a clue.'), findsOneWidget);
    await tester.tap(find.text('START INVESTIGATING'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('The Corrupted Terminal'));
    await tester.pumpAndSettle();

    for (final clue in ['Midnight log', 'Sticky note', 'Index fragment']) {
      await tester.ensureVisible(find.text(clue));
      await tester.tap(find.text(clue));
      await tester.pumpAndSettle();
      await tester.tap(find.text('ADD TO CASE NOTES'));
      await tester.pumpAndSettle();
    }

    await tester.ensureVisible(find.text('DECODE THE EVIDENCE'));
    await tester.tap(find.text('DECODE THE EVIDENCE'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('RESTORE'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('NEXT PUZZLE'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), '1984');
    await tester.tap(find.text('CHECK ANSWER'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('NEXT PUZZLE'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), '8');
    await tester.tap(find.text('CHECK ANSWER'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('REVEAL THE ENDING'));
    await tester.pumpAndSettle();

    expect(find.text('PERFECT INVESTIGATION'), findsOneWidget);
    expect(find.text('300'), findsOneWidget);

    await tester.tap(find.text('RETURN TO CASE FILES'));
    await tester.pumpAndSettle();
    expect(find.text('READY TO INVESTIGATE'), findsOneWidget);
    await tester.tap(find.text('The Missing File'));
    await tester.pumpAndSettle();
    expect(find.text('INCIDENT REPORT'), findsOneWidget);

    tester.view.resetPhysicalSize();
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:glitchquest/services/progress_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('puzzle XP is awarded once and case progress is persisted', () async {
    var progress = await ProgressService.load();

    expect(progress.isCaseUnlocked('corrupted_terminal'), isTrue);
    expect(progress.isCaseUnlocked('missing_file'), isFalse);
    expect(await progress.awardPuzzle('ct_p1', 100), isTrue);
    expect(await progress.awardPuzzle('ct_p1', 100), isFalse);

    await progress.completeCase(caseId: 'corrupted_terminal', perfect: false);
    progress = await ProgressService.load();

    expect(progress.totalScore, 100);
    expect(progress.isPuzzleSolved('ct_p1'), isTrue);
    expect(progress.isCaseCompleted('corrupted_terminal'), isTrue);
    expect(progress.isCaseUnlocked('missing_file'), isTrue);
    expect(progress.achievements, contains('first_case'));
  });

  test('invalid saved progress is discarded safely', () async {
    SharedPreferences.setMockInitialValues({
      'total_score': -20,
      'completed_cases': ['unknown_case'],
      'unlocked_cases': ['unknown_case'],
      'solved_puzzles': ['unknown_puzzle'],
      'unlocked_achievements': ['unknown_achievement'],
      'perfect_cases': ['unknown_case'],
    });

    final progress = await ProgressService.load();

    expect(progress.totalScore, 0);
    expect(progress.completedCases, isEmpty);
    expect(progress.solvedPuzzles, isEmpty);
    expect(progress.achievements, isEmpty);
    expect(progress.isCaseUnlocked('corrupted_terminal'), isTrue);
    expect(progress.isCaseUnlocked('missing_file'), isFalse);
  });
}

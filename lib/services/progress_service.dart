import 'package:shared_preferences/shared_preferences.dart';

import '../data/mystery_cases.dart';

class ProgressService {
  ProgressService._(this._preferences);

  static const _completedKey = 'completed_cases';
  static const _unlockedKey = 'unlocked_cases';
  static const _solvedKey = 'solved_puzzles';
  static const _achievementsKey = 'unlocked_achievements';
  static const _scoreKey = 'total_score';
  static const _perfectKey = 'perfect_cases';

  final SharedPreferences _preferences;

  static Future<ProgressService> load() async {
    final preferences = await SharedPreferences.getInstance();
    final service = ProgressService._(preferences);
    service._repairProgress();
    return service;
  }

  Set<String> get completedCases => _safeStringSet(
    _completedKey,
    mysteryCases.map((item) => item.id).toSet(),
  );

  Set<String> get unlockedCases =>
      _safeStringSet(_unlockedKey, mysteryCases.map((item) => item.id).toSet())
        ..add(mysteryCases.first.id);

  Set<String> get solvedPuzzles => _safeStringSet(
    _solvedKey,
    mysteryCases
        .expand((item) => item.puzzles)
        .map((puzzle) => puzzle.id)
        .toSet(),
  );

  Set<String> get achievements => _safeStringSet(_achievementsKey, const {
    'first_case',
    'perfect_investigation',
    'puzzle_solver',
  });

  Set<String> get perfectCases =>
      _safeStringSet(_perfectKey, mysteryCases.map((item) => item.id).toSet());

  int get totalScore {
    final value = _preferences.get(_scoreKey);
    return value is int && value >= 0 ? value : 0;
  }

  bool isCaseUnlocked(String caseId) => unlockedCases.contains(caseId);
  bool isCaseCompleted(String caseId) => completedCases.contains(caseId);
  bool isPuzzleSolved(String puzzleId) => solvedPuzzles.contains(puzzleId);

  Future<bool> awardPuzzle(String puzzleId, int points) async {
    if (isPuzzleSolved(puzzleId)) return false;
    final solved = solvedPuzzles..add(puzzleId);
    await _preferences.setStringList(_solvedKey, solved.toList());
    await _preferences.setInt(_scoreKey, totalScore + points);
    return true;
  }

  Future<void> completeCase({
    required String caseId,
    required bool perfect,
  }) async {
    final caseIndex = mysteryCases.indexWhere((item) => item.id == caseId);
    if (caseIndex < 0) return;

    final completed = completedCases..add(caseId);
    final unlocked = unlockedCases;
    if (caseIndex + 1 < mysteryCases.length) {
      unlocked.add(mysteryCases[caseIndex + 1].id);
    }
    final perfectSet = perfectCases;
    if (perfect) perfectSet.add(caseId);

    final earned = achievements;
    earned.add('first_case');
    if (perfectSet.isNotEmpty) earned.add('perfect_investigation');
    if (solvedPuzzles.length >= 3) earned.add('puzzle_solver');

    await _preferences.setStringList(_completedKey, completed.toList());
    await _preferences.setStringList(_unlockedKey, unlocked.toList());
    await _preferences.setStringList(_perfectKey, perfectSet.toList());
    await _preferences.setStringList(_achievementsKey, earned.toList());
  }

  void _repairProgress() {
    final validCaseIds = mysteryCases.map((item) => item.id).toSet();
    final validPuzzleIds = mysteryCases
        .expand((item) => item.puzzles)
        .map((puzzle) => puzzle.id)
        .toSet();
    final completed = _readStringSet(_completedKey).intersection(validCaseIds);
    final unlocked = _readStringSet(_unlockedKey)
      ..add(mysteryCases.first.id)
      ..addAll(completed);
    for (var index = 0; index < mysteryCases.length - 1; index++) {
      if (completed.contains(mysteryCases[index].id)) {
        unlocked.add(mysteryCases[index + 1].id);
      }
    }
    final perfect = _readStringSet(_perfectKey)
      ..retainWhere(validCaseIds.contains);
    perfect.retainAll(completed);
    final solved = _readStringSet(_solvedKey).intersection(validPuzzleIds);
    final earned = <String>{
      if (completed.isNotEmpty) 'first_case',
      if (perfect.isNotEmpty) 'perfect_investigation',
      if (solved.length >= 3) 'puzzle_solver',
    };

    _preferences.setStringList(_completedKey, completed.toList());
    _preferences.setStringList(_unlockedKey, unlocked.toList());
    _preferences.setStringList(_perfectKey, perfect.toList());
    _preferences.setStringList(_solvedKey, solved.toList());
    _preferences.setStringList(_achievementsKey, earned.toList());
    final savedScore = _preferences.get(_scoreKey);
    if (savedScore is! int || savedScore < 0) {
      _preferences.setInt(_scoreKey, 0);
    }
  }

  Set<String> _safeStringSet(String key, Set<String> allowed) =>
      _readStringSet(key).intersection(allowed);

  Set<String> _readStringSet(String key) {
    final value = _preferences.get(key);
    if (value is! List<String>) return <String>{};
    return value.where((item) => item.isNotEmpty).toSet();
  }
}

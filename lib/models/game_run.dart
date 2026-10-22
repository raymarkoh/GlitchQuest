class GameRun {
  const GameRun({
    required this.caseId,
    required this.pointsEarned,
    required this.puzzlesSolved,
    required this.totalPuzzles,
    required this.cluesFound,
    required this.totalClues,
    required this.usedHint,
    required this.madeMistake,
  });

  final String caseId;
  final int pointsEarned;
  final int puzzlesSolved;
  final int totalPuzzles;
  final int cluesFound;
  final int totalClues;
  final bool usedHint;
  final bool madeMistake;

  bool get perfect => cluesFound == totalClues && !usedHint && !madeMistake;
}

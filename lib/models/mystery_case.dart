enum PuzzleType { multipleChoice, codeEntry, pattern }

class Clue {
  const Clue({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
  });

  final String id;
  final String title;
  final String description;
  final String icon;
}

class Puzzle {
  const Puzzle({
    required this.id,
    required this.type,
    required this.prompt,
    required this.answer,
    required this.hint,
    this.options = const [],
    this.pattern,
  });

  final String id;
  final PuzzleType type;
  final String prompt;
  final String answer;
  final String hint;
  final List<String> options;
  final String? pattern;
}

class MysteryCase {
  const MysteryCase({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.difficulty,
    required this.story,
    required this.ending,
    required this.clues,
    required this.puzzles,
    required this.icon,
    required this.accentHex,
  });

  final String id;
  final String title;
  final String subtitle;
  final String description;
  final String difficulty;
  final String story;
  final String ending;
  final List<Clue> clues;
  final List<Puzzle> puzzles;
  final String icon;
  final int accentHex;
}

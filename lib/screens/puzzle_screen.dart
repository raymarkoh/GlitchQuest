import 'package:flutter/material.dart';

import '../models/game_run.dart';
import '../models/mystery_case.dart';
import '../services/progress_service.dart';
import '../widgets/game_widgets.dart';
import 'result_screen.dart';

class PuzzleScreen extends StatefulWidget {
  const PuzzleScreen({
    required this.mysteryCase,
    required this.progress,
    required this.discoveredClues,
    super.key,
  });

  final MysteryCase mysteryCase;
  final ProgressService progress;
  final Set<String> discoveredClues;

  @override
  State<PuzzleScreen> createState() => _PuzzleScreenState();
}

class _PuzzleScreenState extends State<PuzzleScreen> {
  final TextEditingController _answerController = TextEditingController();
  int _puzzleIndex = 0;
  int _puzzlesSolved = 0;
  int _pointsEarned = 0;
  bool _correct = false;
  bool _usedHint = false;
  bool _madeMistake = false;
  bool _hintVisible = false;
  bool _checking = false;
  String? _feedback;
  bool? _feedbackCorrect;

  Puzzle get _puzzle => widget.mysteryCase.puzzles[_puzzleIndex];

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  String _normalize(String value) =>
      value.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');

  Future<void> _submit(String value) async {
    if (_checking || _correct) return;
    if (_normalize(value) != _normalize(_puzzle.answer)) {
      setState(() {
        _madeMistake = true;
        _feedback = 'Not quite. Recheck the evidence and try again.';
        _feedbackCorrect = false;
      });
      return;
    }

    setState(() => _checking = true);
    final firstSolve = await widget.progress.awardPuzzle(_puzzle.id, 100);
    if (!mounted) return;
    setState(() {
      _checking = false;
      _correct = true;
      _puzzlesSolved++;
      if (firstSolve) _pointsEarned += 100;
      _feedback = firstSolve
          ? 'Evidence matched. +100 XP'
          : 'Correct. This puzzle was already scored on an earlier run.';
      _feedbackCorrect = true;
    });
  }

  void _showHint() {
    setState(() {
      _hintVisible = true;
      _usedHint = true;
    });
  }

  Future<void> _nextPuzzle() async {
    if (_puzzleIndex + 1 < widget.mysteryCase.puzzles.length) {
      setState(() {
        _puzzleIndex++;
        _correct = false;
        _hintVisible = false;
        _feedback = null;
        _feedbackCorrect = null;
        _answerController.clear();
      });
      return;
    }

    final run = GameRun(
      caseId: widget.mysteryCase.id,
      pointsEarned: _pointsEarned,
      puzzlesSolved: _puzzlesSolved,
      totalPuzzles: widget.mysteryCase.puzzles.length,
      cluesFound: widget.discoveredClues.length,
      totalClues: widget.mysteryCase.clues.length,
      usedHint: _usedHint,
      madeMistake: _madeMistake,
    );
    await widget.progress.completeCase(
      caseId: widget.mysteryCase.id,
      perfect: run.perfect,
    );
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => ResultScreen(
          mysteryCase: widget.mysteryCase,
          progress: widget.progress,
          run: run,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final accent = Color(widget.mysteryCase.accentHex);
    final progressValue =
        (_puzzleIndex + (_correct ? 1 : 0)) / widget.mysteryCase.puzzles.length;
    return GameScaffold(
      title:
          'PUZZLE ${_puzzleIndex + 1} / ${widget.mysteryCase.puzzles.length}',
      child: ScreenPadding(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Expanded(child: Eyebrow('Decode the evidence')),
                Text(
                  '+$_pointsEarned XP',
                  style: const TextStyle(
                    color: GameColors.green,
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progressValue,
                minHeight: 5,
                backgroundColor: GameColors.panelLight,
                color: accent,
              ),
            ),
            const SizedBox(height: 22),
            GamePanel(
              borderColor: accent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Eyebrow(_typeLabel(_puzzle.type), color: accent),
                  const SizedBox(height: 12),
                  Text(
                    _puzzle.prompt,
                    style: const TextStyle(
                      color: GameColors.white,
                      fontSize: 21,
                      height: 1.35,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  if (_puzzle.pattern != null) ...[
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 18,
                        horizontal: 10,
                      ),
                      decoration: BoxDecoration(
                        color: GameColors.background,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        _puzzle.pattern!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: accent,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 20),
            if (_puzzle.type == PuzzleType.multipleChoice)
              for (final option in _puzzle.options) ...[
                _AnswerOption(
                  label: option,
                  enabled: !_correct && !_checking,
                  accent: accent,
                  onTap: () => _submit(option),
                ),
                const SizedBox(height: 10),
              ]
            else ...[
              TextField(
                controller: _answerController,
                enabled: !_correct && !_checking,
                textInputAction: TextInputAction.done,
                onSubmitted: _submit,
                decoration: InputDecoration(
                  labelText: _puzzle.type == PuzzleType.pattern
                      ? 'Enter the pattern'
                      : 'Enter your answer',
                  hintText: _puzzle.type == PuzzleType.codeEntry
                      ? 'Type the code'
                      : 'Use hyphens or words as shown',
                  filled: true,
                  fillColor: GameColors.panel,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Color(0xff29344c)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Color(0xff29344c)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: accent, width: 1.5),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              GameButton(
                label: _checking ? 'CHECKING...' : 'CHECK ANSWER',
                icon: Icons.fact_check_outlined,
                onPressed: _correct || _checking
                    ? null
                    : () => _submit(_answerController.text),
              ),
            ],
            if (_feedback != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(
                  color: (_feedbackCorrect! ? GameColors.green : GameColors.red)
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(13),
                  border: Border.all(
                    color:
                        (_feedbackCorrect! ? GameColors.green : GameColors.red)
                            .withValues(alpha: 0.5),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _feedbackCorrect!
                          ? Icons.check_circle_outline
                          : Icons.info_outline,
                      color: _feedbackCorrect!
                          ? GameColors.green
                          : GameColors.red,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _feedback!,
                        style: TextStyle(
                          color: _feedbackCorrect!
                              ? GameColors.green
                              : GameColors.red,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 14),
            if (_hintVisible)
              GamePanel(
                padding: const EdgeInsets.all(14),
                borderColor: GameColors.amber,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.lightbulb_outline,
                      color: GameColors.amber,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _puzzle.hint,
                        style: const TextStyle(
                          color: GameColors.white,
                          height: 1.45,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 12),
            if (_correct)
              GameButton(
                label: _puzzleIndex + 1 == widget.mysteryCase.puzzles.length
                    ? 'REVEAL THE ENDING'
                    : 'NEXT PUZZLE',
                icon: Icons.arrow_forward_rounded,
                onPressed: _nextPuzzle,
              )
            else
              TextButton.icon(
                onPressed: _hintVisible ? null : _showHint,
                icon: const Icon(Icons.lightbulb_outline),
                label: Text(_hintVisible ? 'HINT REVEALED' : 'NEED A HINT?'),
                style: TextButton.styleFrom(foregroundColor: GameColors.amber),
              ),
          ],
        ),
      ),
    );
  }

  String _typeLabel(PuzzleType type) => switch (type) {
    PuzzleType.multipleChoice => 'MULTIPLE CHOICE',
    PuzzleType.codeEntry => 'CODE ENTRY',
    PuzzleType.pattern => 'PATTERN RECOGNITION',
  };
}

class _AnswerOption extends StatelessWidget {
  const _AnswerOption({
    required this.label,
    required this.enabled,
    required this.accent,
    required this.onTap,
  });

  final String label;
  final bool enabled;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: GameColors.panel,
    borderRadius: BorderRadius.circular(15),
    child: InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xff29344c)),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Icon(Icons.radio_button_unchecked, color: accent, size: 20),
            const SizedBox(width: 13),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: GameColors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

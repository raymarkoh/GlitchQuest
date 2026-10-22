import 'package:flutter/material.dart';

import '../models/game_run.dart';
import '../models/mystery_case.dart';
import '../services/progress_service.dart';
import '../widgets/game_widgets.dart';
import 'investigation_screen.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({
    required this.mysteryCase,
    required this.progress,
    required this.run,
    super.key,
  });

  final MysteryCase mysteryCase;
  final ProgressService progress;
  final GameRun run;

  void _backToCases(BuildContext context) {
    Navigator.of(context).popUntil(ModalRoute.withName('/cases'));
  }

  void _replay(BuildContext context) {
    Navigator.of(context).popUntil(ModalRoute.withName('/cases'));
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) =>
            InvestigationScreen(mysteryCase: mysteryCase, progress: progress),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final accent = Color(mysteryCase.accentHex);
    return GameScaffold(
      title: 'CASE REPORT',
      showBack: false,
      child: ScreenPadding(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 12),
            Center(
              child: Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  color: (run.perfect ? GameColors.green : accent).withValues(
                    alpha: 0.12,
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: run.perfect ? GameColors.green : accent,
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: (run.perfect ? GameColors.green : accent)
                          .withValues(alpha: 0.12),
                      blurRadius: 24,
                    ),
                  ],
                ),
                child: Icon(
                  run.perfect ? Icons.verified_rounded : Icons.check_rounded,
                  color: run.perfect ? GameColors.green : accent,
                  size: 39,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Eyebrow(
                run.perfect ? 'Perfect investigation' : 'Case closed',
                color: run.perfect ? GameColors.green : accent,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              mysteryCase.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: GameColors.white,
                fontSize: 28,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 20),
            GamePanel(
              borderColor: accent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Eyebrow('Final transmission', color: GameColors.purple),
                  const SizedBox(height: 10),
                  Text(
                    mysteryCase.ending,
                    style: const TextStyle(
                      color: GameColors.white,
                      height: 1.6,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                _ResultStat(value: '${run.pointsEarned}', label: 'XP THIS RUN'),
                const SizedBox(width: 12),
                _ResultStat(
                  value: '${run.puzzlesSolved}/${run.totalPuzzles}',
                  label: 'PUZZLES SOLVED',
                ),
                const SizedBox(width: 12),
                _ResultStat(
                  value: '${run.cluesFound}/${run.totalClues}',
                  label: 'CLUES FOUND',
                ),
              ],
            ),
            const SizedBox(height: 14),
            GamePanel(
              padding: const EdgeInsets.all(15),
              child: Row(
                children: [
                  const Icon(Icons.stars_rounded, color: GameColors.amber),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'TOTAL ARCHIVE XP   ${progress.totalScore}',
                      style: const TextStyle(
                        color: GameColors.white,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            GameButton(
              label: 'REPLAY CASE',
              icon: Icons.replay_rounded,
              onPressed: () => _replay(context),
            ),
            const SizedBox(height: 11),
            GameButton(
              label: 'RETURN TO CASE FILES',
              icon: Icons.folder_open_rounded,
              secondary: true,
              onPressed: () => _backToCases(context),
            ),
            const SizedBox(height: 12),
            const Center(
              child: Text(
                'SOLVED PUZZLES CAN BE REPLAYED, BUT XP IS AWARDED ONCE.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: GameColors.muted,
                  fontSize: 9,
                  letterSpacing: 0.65,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultStat extends StatelessWidget {
  const _ResultStat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) => Expanded(
    child: GamePanel(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(
              color: GameColors.white,
              fontWeight: FontWeight.w900,
              fontSize: 19,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: GameColors.muted,
              fontSize: 8,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    ),
  );
}

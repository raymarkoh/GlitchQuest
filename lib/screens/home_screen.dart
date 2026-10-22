import 'package:flutter/material.dart';

import '../data/mystery_cases.dart';
import '../services/progress_service.dart';
import '../widgets/game_widgets.dart';
import 'achievements_screen.dart';
import 'case_selection_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({required this.progress, super.key});

  final ProgressService progress;

  void _openCases(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        settings: const RouteSettings(name: '/cases'),
        builder: (_) => CaseSelectionScreen(progress: progress),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final completed = progress.completedCases.length;
    return GameScaffold(
      title: 'GLITCHQUEST',
      showBack: false,
      child: ScreenPadding(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 12),
            const Eyebrow('Independent mystery bureau  /  01'),
            const SizedBox(height: 14),
            const Text(
              'Every glitch\nleaves a clue.',
              style: TextStyle(
                height: 1.04,
                fontSize: 43,
                fontWeight: FontWeight.w900,
                letterSpacing: -1.6,
                color: GameColors.white,
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'A quiet system is telling a strange story. Follow the evidence, '
              'crack the signal, and find out what really happened.',
              style: TextStyle(
                color: GameColors.muted,
                height: 1.55,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 28),
            GamePanel(
              borderColor: GameColors.cyan,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.radar_rounded, color: GameColors.cyan),
                      SizedBox(width: 10),
                      Eyebrow('Your investigation'),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      _ProgressStat(value: '$completed', label: 'CASES SOLVED'),
                      const SizedBox(width: 12),
                      _ProgressStat(
                        value: '${progress.totalScore}',
                        label: 'TOTAL XP',
                      ),
                      const SizedBox(width: 12),
                      _ProgressStat(
                        value: '${progress.achievements.length}',
                        label: 'BADGES',
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: completed / mysteryCases.length,
                      minHeight: 5,
                      backgroundColor: GameColors.panelLight,
                      color: GameColors.cyan,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$completed OF ${mysteryCases.length} CASES COMPLETE',
                    style: const TextStyle(
                      color: GameColors.muted,
                      fontSize: 10,
                      letterSpacing: 1,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            GameButton(
              label: completed == 0 ? 'START INVESTIGATING' : 'CONTINUE CASES',
              icon: Icons.play_arrow_rounded,
              onPressed: () => _openCases(context),
            ),
            const SizedBox(height: 12),
            GameButton(
              label: 'CASE FILES',
              icon: Icons.folder_copy_outlined,
              secondary: true,
              onPressed: () => _openCases(context),
            ),
            const SizedBox(height: 12),
            GameButton(
              label: 'ACHIEVEMENTS',
              icon: Icons.emoji_events_outlined,
              secondary: true,
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => AchievementsScreen(progress: progress),
                ),
              ),
            ),
            const SizedBox(height: 22),
            const Center(
              child: Text(
                'OFFLINE CASEWORK  •  NO SIGNAL REQUIRED',
                style: TextStyle(
                  color: GameColors.muted,
                  fontSize: 10,
                  letterSpacing: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressStat extends StatelessWidget {
  const _ProgressStat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) => Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: GameColors.white,
            fontSize: 24,
            fontWeight: FontWeight.w900,
          ),
        ),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: GameColors.muted,
            fontSize: 9,
            letterSpacing: 0.6,
          ),
        ),
      ],
    ),
  );
}

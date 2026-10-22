import 'package:flutter/material.dart';

import '../services/progress_service.dart';
import '../widgets/game_widgets.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({required this.progress, super.key});

  final ProgressService progress;

  static const _items = <_Achievement>[
    _Achievement(
      id: 'first_case',
      title: 'First Case Completed',
      description: 'Close your first mystery case.',
      icon: Icons.folder_special_rounded,
    ),
    _Achievement(
      id: 'perfect_investigation',
      title: 'Perfect Investigation',
      description:
          'Find every clue and solve a case without mistakes or hints.',
      icon: Icons.auto_awesome_rounded,
    ),
    _Achievement(
      id: 'puzzle_solver',
      title: 'Puzzle Solver',
      description: 'Solve three puzzles and prove your detective instincts.',
      icon: Icons.extension_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) => GameScaffold(
    title: 'ACHIEVEMENTS',
    child: ScreenPadding(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Eyebrow('Merit archive  /  Earned, never given'),
          const SizedBox(height: 9),
          const Text(
            'Your milestones.',
            style: TextStyle(
              color: GameColors.white,
              fontSize: 29,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${progress.achievements.length} OF ${_items.length} UNLOCKED',
            style: const TextStyle(
              color: GameColors.muted,
              fontSize: 11,
              letterSpacing: 1,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 20),
          for (final item in _items) ...[
            _AchievementCard(
              achievement: item,
              unlocked: progress.achievements.contains(item.id),
            ),
            const SizedBox(height: 12),
          ],
          const SizedBox(height: 8),
          GamePanel(
            child: Row(
              children: [
                const Icon(
                  Icons.military_tech_rounded,
                  color: GameColors.amber,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Complete cases carefully to unlock every achievement.',
                    style: TextStyle(
                      color: GameColors.white.withValues(alpha: 0.85),
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class _Achievement {
  const _Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
  });

  final String id;
  final String title;
  final String description;
  final IconData icon;
}

class _AchievementCard extends StatelessWidget {
  const _AchievementCard({required this.achievement, required this.unlocked});

  final _Achievement achievement;
  final bool unlocked;

  @override
  Widget build(BuildContext context) {
    final color = unlocked ? GameColors.amber : GameColors.muted;
    return GamePanel(
      borderColor: color,
      padding: const EdgeInsets.all(17),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              unlocked ? achievement.icon : Icons.lock_outline_rounded,
              color: color,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  achievement.title,
                  style: TextStyle(
                    color: unlocked ? GameColors.white : GameColors.muted,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  achievement.description,
                  style: const TextStyle(
                    color: GameColors.muted,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            unlocked ? Icons.check_circle_rounded : Icons.lock_rounded,
            color: color,
            size: 19,
          ),
        ],
      ),
    );
  }
}

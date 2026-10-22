import 'package:flutter/material.dart';

import '../data/mystery_cases.dart';
import '../models/mystery_case.dart';
import '../services/progress_service.dart';
import '../widgets/game_widgets.dart';
import 'investigation_screen.dart';

class CaseSelectionScreen extends StatefulWidget {
  const CaseSelectionScreen({required this.progress, super.key});

  final ProgressService progress;

  @override
  State<CaseSelectionScreen> createState() => _CaseSelectionScreenState();
}

class _CaseSelectionScreenState extends State<CaseSelectionScreen> {
  Future<void> _openCase(MysteryCase mysteryCase) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => InvestigationScreen(
          mysteryCase: mysteryCase,
          progress: widget.progress,
        ),
      ),
    );
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) => GameScaffold(
    title: 'CASE FILES',
    child: ScreenPadding(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Eyebrow('Select a case  /  Evidence awaits'),
          const SizedBox(height: 8),
          const Text(
            'Choose your lead.',
            style: TextStyle(
              fontSize: 29,
              fontWeight: FontWeight.w900,
              color: GameColors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'New files unlock as you close the previous case.',
            style: TextStyle(color: GameColors.muted, height: 1.4),
          ),
          const SizedBox(height: 22),
          for (var index = 0; index < mysteryCases.length; index++) ...[
            _CaseFileCard(
              mysteryCase: mysteryCases[index],
              number: index + 1,
              unlocked: widget.progress.isCaseUnlocked(mysteryCases[index].id),
              completed: widget.progress.isCaseCompleted(
                mysteryCases[index].id,
              ),
              onTap: widget.progress.isCaseUnlocked(mysteryCases[index].id)
                  ? () => _openCase(mysteryCases[index])
                  : null,
            ),
            if (index < mysteryCases.length - 1) const SizedBox(height: 14),
          ],
          const SizedBox(height: 12),
          GamePanel(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                const Icon(Icons.shield_outlined, color: GameColors.purple),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Your evidence and case progress stay on this device.',
                    style: TextStyle(
                      color: GameColors.white.withValues(alpha: 0.8),
                      fontSize: 13,
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

class _CaseFileCard extends StatelessWidget {
  const _CaseFileCard({
    required this.mysteryCase,
    required this.number,
    required this.unlocked,
    required this.completed,
    required this.onTap,
  });

  final MysteryCase mysteryCase;
  final int number;
  final bool unlocked;
  final bool completed;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final accent = Color(mysteryCase.accentHex);
    return Opacity(
      opacity: unlocked ? 1 : 0.55,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: GamePanel(
            borderColor: unlocked ? accent : GameColors.muted,
            padding: const EdgeInsets.all(17),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 58,
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(
                    unlocked
                        ? iconForName(mysteryCase.icon)
                        : Icons.lock_outline,
                    color: accent,
                    size: 25,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Eyebrow(
                        'FILE 00$number  /  ${mysteryCase.difficulty}',
                        color: accent,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        mysteryCase.title,
                        style: const TextStyle(
                          color: GameColors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        mysteryCase.description,
                        style: const TextStyle(
                          color: GameColors.muted,
                          fontSize: 12,
                          height: 1.35,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        completed
                            ? 'CASE CLOSED'
                            : unlocked
                            ? 'READY TO INVESTIGATE'
                            : 'LOCKED  •  CLOSE THE PREVIOUS CASE',
                        style: TextStyle(
                          color: completed ? GameColors.green : accent,
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  completed
                      ? Icons.check_circle_rounded
                      : unlocked
                      ? Icons.chevron_right_rounded
                      : Icons.lock_rounded,
                  color: completed ? GameColors.green : accent,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../models/mystery_case.dart';
import '../services/progress_service.dart';
import '../widgets/game_widgets.dart';
import 'puzzle_screen.dart';

class InvestigationScreen extends StatefulWidget {
  const InvestigationScreen({
    required this.mysteryCase,
    required this.progress,
    super.key,
  });

  final MysteryCase mysteryCase;
  final ProgressService progress;

  @override
  State<InvestigationScreen> createState() => _InvestigationScreenState();
}

class _InvestigationScreenState extends State<InvestigationScreen> {
  final Set<String> _discoveredClues = <String>{};

  Future<void> _inspect(Clue clue) async {
    setState(() => _discoveredClues.add(clue.id));
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: GameColors.panel,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Eyebrow(
                'Evidence recovered',
                color: Color(widget.mysteryCase.accentHex),
              ),
              const SizedBox(height: 12),
              Text(
                clue.title,
                style: const TextStyle(
                  color: GameColors.white,
                  fontSize: 23,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                clue.description,
                style: const TextStyle(
                  color: GameColors.muted,
                  height: 1.6,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 22),
              GameButton(
                label: 'ADD TO CASE NOTES',
                icon: Icons.check_rounded,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _continueToPuzzles() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => PuzzleScreen(
          mysteryCase: widget.mysteryCase,
          progress: widget.progress,
          discoveredClues: Set<String>.of(_discoveredClues),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mysteryCase = widget.mysteryCase;
    final allFound = _discoveredClues.length == mysteryCase.clues.length;
    return GameScaffold(
      title: mysteryCase.subtitle,
      child: ScreenPadding(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Eyebrow('Investigation  /  ${mysteryCase.difficulty}'),
            const SizedBox(height: 9),
            Text(
              mysteryCase.title,
              style: const TextStyle(
                color: GameColors.white,
                fontSize: 30,
                height: 1.1,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 18),
            GamePanel(
              borderColor: Color(mysteryCase.accentHex),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Eyebrow('Incident report', color: GameColors.purple),
                  const SizedBox(height: 10),
                  Text(
                    mysteryCase.story,
                    style: const TextStyle(
                      color: GameColors.white,
                      height: 1.65,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            Row(
              children: [
                const Expanded(child: Eyebrow('Evidence to inspect')),
                Text(
                  '${_discoveredClues.length}/${mysteryCase.clues.length} FOUND',
                  style: const TextStyle(
                    color: GameColors.muted,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            for (final clue in mysteryCase.clues) ...[
              _ClueTile(
                clue: clue,
                discovered: _discoveredClues.contains(clue.id),
                accent: Color(mysteryCase.accentHex),
                onTap: () => _inspect(clue),
              ),
              const SizedBox(height: 10),
            ],
            const SizedBox(height: 10),
            GameButton(
              label: allFound
                  ? 'DECODE THE EVIDENCE'
                  : 'INSPECT ALL CLUES FIRST',
              icon: Icons.extension_rounded,
              onPressed: allFound ? _continueToPuzzles : null,
            ),
            const SizedBox(height: 10),
            const Text(
              'Tap each evidence card to inspect it and add it to your notes.',
              textAlign: TextAlign.center,
              style: TextStyle(color: GameColors.muted, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}

class _ClueTile extends StatelessWidget {
  const _ClueTile({
    required this.clue,
    required this.discovered,
    required this.accent,
    required this.onTap,
  });

  final Clue clue;
  final bool discovered;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: GameColors.panel,
    borderRadius: BorderRadius.circular(16),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          border: Border.all(
            color: discovered
                ? accent.withValues(alpha: 0.7)
                : const Color(0xff29344c),
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(iconForName(clue.icon), color: accent, size: 24),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    clue.title,
                    style: const TextStyle(
                      color: GameColors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    discovered
                        ? 'Evidence added to your notes'
                        : 'Tap to inspect evidence',
                    style: const TextStyle(
                      color: GameColors.muted,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              discovered ? Icons.check_circle_rounded : Icons.search_rounded,
              color: discovered ? GameColors.green : GameColors.muted,
            ),
          ],
        ),
      ),
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../widgets/game_widgets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 950),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: GameColors.background,
    body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Semantics(
            label: 'GlitchQuest logo',
            image: true,
            child: ExcludeSemantics(
              child: SvgPicture.asset(
                'assets/images/glitchquest_logo.svg',
                width: 260,
                height: 260,
              ),
            ),
          ),
          const SizedBox(height: 18),
          const Eyebrow('Booting investigation tools'),
          const SizedBox(height: 28),
          SizedBox(
            width: 130,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) => LinearProgressIndicator(
                value: _controller.value,
                minHeight: 3,
                backgroundColor: GameColors.panelLight,
                color: GameColors.cyan,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

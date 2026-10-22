import 'package:flutter/material.dart';

class GameColors {
  static const background = Color(0xff080b16);
  static const panel = Color(0xff11182a);
  static const panelLight = Color(0xff18223a);
  static const cyan = Color(0xff70f0d1);
  static const purple = Color(0xffb99aff);
  static const green = Color(0xff8de7a6);
  static const amber = Color(0xffffc878);
  static const red = Color(0xffff858d);
  static const muted = Color(0xff8994ad);
  static const white = Color(0xfff4f6ff);
}

class GameScaffold extends StatelessWidget {
  const GameScaffold({
    required this.title,
    required this.child,
    this.showBack = true,
    super.key,
  });

  final String title;
  final Widget child;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: showBack
            ? IconButton(
                tooltip: 'Go back',
                onPressed: () => Navigator.of(context).maybePop(),
                icon: const Icon(Icons.arrow_back_rounded),
              )
            : null,
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            letterSpacing: 0.3,
            fontSize: 17,
          ),
        ),
        backgroundColor: GameColors.background,
        surfaceTintColor: Colors.transparent,
      ),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xff0d1425), GameColors.background],
          ),
        ),
        child: SafeArea(top: false, child: child),
      ),
    );
  }
}

class GamePanel extends StatelessWidget {
  const GamePanel({
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.borderColor = const Color(0xff29344c),
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: GameColors.panel.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor.withValues(alpha: 0.75)),
        boxShadow: [
          BoxShadow(
            color: borderColor.withValues(alpha: 0.07),
            blurRadius: 20,
            spreadRadius: 1,
          ),
        ],
      ),
      child: child,
    );
  }
}

class GameButton extends StatelessWidget {
  const GameButton({
    required this.label,
    required this.onPressed,
    this.icon,
    this.secondary = false,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool secondary;

  @override
  Widget build(BuildContext context) {
    final foreground = secondary ? GameColors.cyan : GameColors.background;
    final background = secondary ? GameColors.panelLight : GameColors.cyan;
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: FilledButton.icon(
        onPressed: onPressed,
        icon: Icon(icon ?? Icons.arrow_forward_rounded, size: 19),
        label: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
        style: FilledButton.styleFrom(
          foregroundColor: foreground,
          backgroundColor: background,
          disabledBackgroundColor: GameColors.panelLight,
          disabledForegroundColor: GameColors.muted,
          side: secondary ? const BorderSide(color: GameColors.cyan) : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }
}

class Eyebrow extends StatelessWidget {
  const Eyebrow(this.text, {this.color = GameColors.cyan, super.key});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) => Text(
    text.toUpperCase(),
    style: TextStyle(
      color: color,
      fontSize: 11,
      letterSpacing: 1.5,
      fontWeight: FontWeight.w800,
    ),
  );
}

IconData iconForName(String name) => switch (name) {
  'terminal' => Icons.terminal_rounded,
  'folder_open' => Icons.folder_open_rounded,
  'sensors' => Icons.sensors_rounded,
  'receipt_long' => Icons.receipt_long_rounded,
  'sticky_note_2' => Icons.sticky_note_2_rounded,
  'data_object' => Icons.data_object_rounded,
  'account_tree' => Icons.account_tree_rounded,
  'assignment' => Icons.assignment_rounded,
  'description' => Icons.description_rounded,
  'graphic_eq' => Icons.graphic_eq_rounded,
  'cloud' => Icons.cloud_rounded,
  'menu_book' => Icons.menu_book_rounded,
  _ => Icons.memory_rounded,
};

class ScreenPadding extends StatelessWidget {
  const ScreenPadding({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
    child: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 620),
        child: child,
      ),
    ),
  );
}

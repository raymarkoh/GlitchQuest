import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'screens/splash_screen.dart';
import 'services/progress_service.dart';
import 'widgets/game_widgets.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const GlitchQuestApp());
}

class GlitchQuestApp extends StatelessWidget {
  const GlitchQuestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GlitchQuest',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: GameColors.background,
        colorScheme: const ColorScheme.dark(
          primary: GameColors.cyan,
          secondary: GameColors.purple,
          surface: GameColors.panel,
          error: GameColors.red,
        ),
        fontFamily: 'Roboto',
        snackBarTheme: const SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          backgroundColor: GameColors.panel,
        ),
      ),
      home: const StartupScreen(),
    );
  }
}

class StartupScreen extends StatefulWidget {
  const StartupScreen({super.key});

  @override
  State<StartupScreen> createState() => _StartupScreenState();
}

class _StartupScreenState extends State<StartupScreen> {
  late final Future<ProgressService> _progress = _loadProgress();

  Future<ProgressService> _loadProgress() async {
    final progress = await ProgressService.load();
    await Future<void>.delayed(const Duration(milliseconds: 900));
    return progress;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ProgressService>(
      future: _progress,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Scaffold(
            body: Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Progress could not be loaded. Please restart GlitchQuest.',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }
        if (!snapshot.hasData) return const SplashScreen();
        return HomeScreen(progress: snapshot.requireData);
      },
    );
  }
}

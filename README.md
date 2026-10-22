# GlitchQuest

GlitchQuest is an offline, story-driven mystery puzzle game for Android. Investigate strange digital incidents, inspect evidence, solve puzzles, and uncover the truth behind a corrupted computer system.

## Features

- Three connected mystery cases with distinct stories and endings.
- Three evidence clues and three puzzles in every case.
- Multiple-choice, code-entry, and pattern-recognition challenges.
- Inspectable clues, hints, answer feedback, and score tracking.
- Case unlock progression and gameplay-earned achievements.
- Progress saved locally on the device with `shared_preferences`.
- Dark retro-cyber visual theme with responsive layouts and subtle motion.
- Original scalable GlitchQuest logo in `assets/images/glitchquest_logo.svg`.
- No account, backend, network connection, or paid API required.

## Screenshots

Add screenshots to the `screenshots/` folder and update these paths:

| Screen | Preview |
| --- | --- |
| Home | `screenshots/home.png` |
| Case selection | `screenshots/cases.png` |
| Investigation | `screenshots/investigation.png` |
| Puzzle | `screenshots/puzzle.png` |
| Results | `screenshots/results.png` |
| Achievements | `screenshots/achievements.png` |

## Technologies

- Flutter and Dart
- Material 3
- `shared_preferences` for local progress persistence

## Requirements

- Flutter SDK (stable channel; Flutter 3.47 or later recommended)
- Dart SDK included with Flutter
- Android Studio with Android SDK and an Android emulator, or an Android device with USB debugging enabled
- Visual Studio Code with the Flutter and Dart extensions (recommended)

## Setup and run

1. Open the project folder in Visual Studio Code or a terminal.
2. Check that Flutter and Android tooling are available:

   ```powershell
   flutter doctor
   ```

3. Fetch the project dependencies:

   ```powershell
   flutter pub get
   ```

4. Start an Android emulator from Android Studio's Device Manager, or connect an Android device with USB debugging enabled.
5. Confirm Flutter can see the device:

   ```powershell
   flutter devices
   ```

6. Run the game:

   ```powershell
   flutter run
   ```

For a release APK, use:

```powershell
flutter build apk --release
```

## Gameplay

1. Choose **Start Investigating** or **Case Files** on the home screen.
2. Open an unlocked case. The first case is available immediately; later cases unlock as cases are closed.
3. Tap every evidence card to inspect the clue and add it to your notes.
4. Solve all three puzzles. Use the hint button if you need help.
5. Review the case ending, points, and investigation results. Replay a completed case or return to the case files.

Each puzzle awards its XP only the first time it is solved, including across replays. Hints and incorrect answers do not prevent case completion, but a perfect investigation requires finding all clues and solving the puzzles without hints or incorrect answers. Achievements are awarded when their gameplay conditions are met.

Progress is stored locally on the device. Clearing the app's storage removes that saved progress.

## Project structure

```text
lib/
  assets/
    images/
      glitchquest_logo.svg
  data/
    mystery_cases.dart
  models/
    game_run.dart
    mystery_case.dart
  screens/
    achievements_screen.dart
    case_selection_screen.dart
    home_screen.dart
    investigation_screen.dart
    puzzle_screen.dart
    result_screen.dart
    splash_screen.dart
  services/
    progress_service.dart
  widgets/
    game_widgets.dart
  main.dart
android/
test/
```

## Project objectives

- Practice building a multi-screen Flutter app with reusable UI components.
- Demonstrate simple, testable puzzle logic and an offline game loop.
- Persist meaningful game progress safely on an Android device.
- Present a small mystery game with a consistent visual identity.

## Future improvements

- Add more cases and branching endings.
- Add optional sound effects and haptic feedback.
- Add an in-game evidence board that links discovered clues.
- Add localization and accessibility options.
- Add screenshots and a signed release build.

## Developer

Developer details have not been provided.

## License

No license has been selected for this project. All rights remain with the respective authors; permission for redistribution or reuse is not implied.

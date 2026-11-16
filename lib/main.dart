import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snake_game/progression/player_profile.dart';
import 'package:snake_game/settings/settings_model.dart';
import 'package:snake_game/ui/screens/game_screen.dart';
import 'package:snake_game/ui/screens/home_screen.dart';
import 'package:snake_game/ui/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const SnakeApp());
}

class SnakeApp extends StatelessWidget {
  const SnakeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Snake',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      // Dev/screenshot hook: --dart-define=AUTOSTART=true opens straight
      // into a round-1 arena. Never set in release builds.
      home: const bool.fromEnvironment('AUTOSTART')
          ? const GameScreen(
              profile: PlayerProfile(),
              settings: SettingsModel.defaults(),
            )
          : const HomeScreen(),
    );
  }
}

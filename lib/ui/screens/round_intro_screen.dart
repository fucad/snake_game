import 'package:flutter/material.dart';
import 'package:snake_game/game/logic/round_logic.dart';
import 'package:snake_game/progression/player_profile.dart';
import 'package:snake_game/settings/settings_model.dart';
import 'package:snake_game/ui/screens/game_screen.dart';
import 'package:snake_game/ui/theme/app_animations.dart';
import 'package:snake_game/ui/theme/app_colors.dart';
import 'package:snake_game/ui/theme/app_dimensions.dart';
import 'package:snake_game/ui/theme/app_text_styles.dart';

class RoundIntroScreen extends StatefulWidget {
  final PlayerProfile profile;
  final SettingsModel settings;

  const RoundIntroScreen({
    super.key,
    required this.profile,
    required this.settings,
  });

  @override
  State<RoundIntroScreen> createState() => _RoundIntroScreenState();
}

class _RoundIntroScreenState extends State<RoundIntroScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _countdown = 3;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _startCountdown();
  }

  void _startCountdown() async {
    for (int i = 3; i >= 1; i--) {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;
      setState(() => _countdown = i - 1);
    }
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) =>
            GameScreen(profile: widget.profile, settings: widget.settings),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final round = widget.profile.currentRound;
    final stage = RoundLogic.stageLabel(round);
    final goal = RoundLogic.goalForRound(round);
    final bots = RoundLogic.botCountForRound(round);

    return Scaffold(
      backgroundColor: AppColors.screenBg,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.screenPaddingH,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(stage.toUpperCase(), style: AppTextStyles.stageLabel),
                const SizedBox(height: AppDimensions.spaceSm),
                Text('Round $round', style: AppTextStyles.displayMedium),
                const SizedBox(height: AppDimensions.spaceXl),

                // Stats row
                Row(
                  children: [
                    _StatChip(label: 'GOAL', value: '$goal segs'),
                    const SizedBox(width: AppDimensions.spaceSm),
                    _StatChip(label: 'BOTS', value: '$bots'),
                  ],
                ),

                const SizedBox(height: AppDimensions.spaceXxl),

                // Countdown
                AnimatedSwitcher(
                  duration: AppAnimations.fast,
                  transitionBuilder: (child, anim) =>
                      ScaleTransition(scale: anim, child: child),
                  child: Text(
                    _countdown == 0 ? 'GO!' : '$_countdown',
                    key: ValueKey(_countdown),
                    style: AppTextStyles.displayLarge.copyWith(
                      color: _countdown == 0
                          ? AppColors.secondary
                          : AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  const _StatChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.spaceMd),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
        child: Column(
          children: [
            Text(label, style: AppTextStyles.labelMedium),
            const SizedBox(height: AppDimensions.spaceXs),
            Text(value, style: AppTextStyles.headingMedium),
          ],
        ),
      ),
    );
  }
}

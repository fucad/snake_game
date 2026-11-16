import 'package:flutter/material.dart';
import 'package:snake_game/game/logic/game_event.dart';
import 'package:snake_game/progression/player_profile.dart';
import 'package:snake_game/settings/settings_model.dart';
import 'package:snake_game/ui/screens/round_intro_screen.dart';
import 'package:snake_game/ui/screens/upgrade_screen.dart';
import 'package:snake_game/ui/theme/app_colors.dart';
import 'package:snake_game/ui/theme/app_dimensions.dart';
import 'package:snake_game/ui/theme/app_text_styles.dart';
import 'package:snake_game/ui/widgets/xp_bar_widget.dart';

class GameOverScreen extends StatelessWidget {
  final RoundOverEvent event;
  final int xpEarned;
  final PlayerProfile profile;
  final SettingsModel settings;

  const GameOverScreen({
    super.key,
    required this.event,
    required this.xpEarned,
    required this.profile,
    required this.settings,
  });

  @override
  Widget build(BuildContext context) {
    final goalMet = event.goalWasMet;

    return Scaffold(
      backgroundColor: AppColors.screenBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.screenPaddingH,
            vertical: AppDimensions.screenPaddingV,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),

              // Outcome title
              Text(
                goalMet ? 'GOAL MET!' : 'ROUND OVER',
                style: AppTextStyles.displayMedium.copyWith(
                  color: goalMet ? AppColors.secondary : AppColors.primary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.spaceXl),

              // Stats card
              Container(
                padding: const EdgeInsets.all(AppDimensions.spaceLg),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
                ),
                child: Column(
                  children: [
                    _StatRow(
                      label: 'Length',
                      value: '${event.finalScore} segs',
                    ),
                    const SizedBox(height: AppDimensions.spaceMd),
                    _StatRow(label: 'Kills', value: '${event.killCount}'),
                    const SizedBox(height: AppDimensions.spaceLg),
                    XpBarWidget(currentXp: profile.totalXp, gainedXp: xpEarned),
                  ],
                ),
              ),

              const Spacer(),

              // Upgrade button
              OutlinedButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => UpgradeScreen(profile: profile),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.secondary,
                  side: const BorderSide(color: AppColors.secondary),
                  minimumSize: const Size(
                    double.infinity,
                    AppDimensions.buttonHeightLarge,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                  ),
                ),
                child: const Text('UPGRADE'),
              ),
              const SizedBox(height: AppDimensions.spaceMd),

              // Play again / next round
              ElevatedButton(
                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        RoundIntroScreen(profile: profile, settings: settings),
                  ),
                ),
                child: Text(goalMet ? 'NEXT ROUND' : 'TRY AGAIN'),
              ),
              const SizedBox(height: AppDimensions.spaceMd),

              // Home
              TextButton(
                onPressed: () =>
                    Navigator.popUntil(context, (route) => route.isFirst),
                child: const Text('HOME'),
              ),
              const SizedBox(height: AppDimensions.spaceSm),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;

  const _StatRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.bodyLarge),
        Text(value, style: AppTextStyles.headingSmall),
      ],
    );
  }
}

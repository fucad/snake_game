import 'package:flutter/material.dart';
import 'package:snake_game/game/logic/round_logic.dart';
import 'package:snake_game/progression/persistence_service.dart';
import 'package:snake_game/progression/player_profile.dart';
import 'package:snake_game/settings/settings_model.dart';
import 'package:snake_game/settings/settings_service.dart';
import 'package:snake_game/ui/screens/how_to_play_screen.dart';
import 'package:snake_game/ui/screens/round_intro_screen.dart';
import 'package:snake_game/ui/screens/settings_screen.dart';
import 'package:snake_game/ui/theme/app_colors.dart';
import 'package:snake_game/ui/theme/app_dimensions.dart';
import 'package:snake_game/ui/theme/app_text_styles.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PlayerProfile? _profile;
  SettingsModel? _settings;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final profile = await PersistenceService().load();
    final settings = await SettingsService().load();
    if (mounted) {
      setState(() {
        _profile = profile;
        _settings = settings;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = _profile;
    return Scaffold(
      backgroundColor: AppColors.screenBg,
      body: SafeArea(
        child: profile == null
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              )
            : _Body(
                profile: profile,
                settings: _settings ?? const SettingsModel.defaults(),
                onReload: _load,
              ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final PlayerProfile profile;
  final SettingsModel settings;
  final VoidCallback onReload;

  const _Body({
    required this.profile,
    required this.settings,
    required this.onReload,
  });

  @override
  Widget build(BuildContext context) {
    final round = profile.currentRound;
    final stage = RoundLogic.stageLabel(round);
    final goal = RoundLogic.goalForRound(round);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.screenPaddingH,
        vertical: AppDimensions.screenPaddingV,
      ),
      child: Column(
        children: [
          // Top bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // XP badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spaceMd,
                  vertical: AppDimensions.spaceSm,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      color: AppColors.xpBar,
                      size: AppDimensions.iconSm,
                    ),
                    const SizedBox(width: AppDimensions.spaceXs),
                    Text(
                      '${profile.totalXp} XP',
                      style: AppTextStyles.labelMedium,
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  _IconBtn(
                    icon: Icons.help_outline_rounded,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const HowToPlayScreen(),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spaceSm),
                  _IconBtn(
                    icon: Icons.settings_rounded,
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              SettingsScreen(initialSettings: settings),
                        ),
                      );
                      onReload();
                    },
                  ),
                ],
              ),
            ],
          ),

          const Spacer(),

          // Game title
          const Text('SNAKE', style: AppTextStyles.displayLarge),
          const SizedBox(height: AppDimensions.spaceSm),

          // Stage chip
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spaceMd,
              vertical: AppDimensions.spaceXs,
            ),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
            ),
            child: Text(stage.toUpperCase(), style: AppTextStyles.stageLabel),
          ),

          const SizedBox(height: AppDimensions.spaceXl),

          // Round info card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppDimensions.spaceLg),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
            ),
            child: Column(
              children: [
                Text(
                  'ROUND $round',
                  style: AppTextStyles.headingLarge.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: AppDimensions.spaceXs),
                Text(
                  'Reach $goal segments to advance',
                  style: AppTextStyles.bodyMedium,
                ),
              ],
            ),
          ),

          const SizedBox(height: AppDimensions.spaceXl),

          // Play button
          ElevatedButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      RoundIntroScreen(profile: profile, settings: settings),
                ),
              );
              onReload();
            },
            child: const Text('PLAY'),
          ),

          const Spacer(),

          // High score
          if (profile.highScore > 0)
            Text(
              'Best: ${profile.highScore} segments',
              style: AppTextStyles.bodySmall,
            ),

          const SizedBox(height: AppDimensions.spaceMd),
        ],
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _IconBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
        child: Icon(
          icon,
          color: AppColors.textSecondary,
          size: AppDimensions.iconMd,
        ),
      ),
    );
  }
}

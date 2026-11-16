import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:snake_game/balance/item_config.dart';
import 'package:snake_game/game/logic/game_event.dart';
import 'package:snake_game/game/logic/round_logic.dart';
import 'package:snake_game/game/logic/snake_state.dart';
import 'package:snake_game/game/logic/xp_logic.dart';
import 'package:snake_game/game/snake_game.dart';
import 'package:snake_game/progression/persistence_service.dart';
import 'package:snake_game/progression/player_profile.dart';
import 'package:snake_game/settings/settings_model.dart';
import 'package:snake_game/ui/screens/game_over_screen.dart';
import 'package:snake_game/ui/theme/app_colors.dart';
import 'package:snake_game/ui/theme/app_dimensions.dart';
import 'package:snake_game/ui/theme/app_text_styles.dart';
import 'package:snake_game/ui/widgets/pause_overlay.dart';

// Builds a minimal SnakeState just for XpLogic (only .length is used).
SnakeState _dummySnakeWithLength(int length) => SnakeState(
  id: 'dummy',
  owner: SnakeOwner.player,
  segments: List.generate(length, (_) => Vector2.zero()),
  direction: Vector2(1, 0),
  speed: 0,
);

class GameScreen extends StatefulWidget {
  final PlayerProfile profile;
  final SettingsModel settings;

  const GameScreen({super.key, required this.profile, required this.settings});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late SnakeGame _game;
  bool _paused = false;

  @override
  void initState() {
    super.initState();
    _game = SnakeGame(
      roundNumber: widget.profile.currentRound,
      profile: widget.profile,
      settings: widget.settings,
      onRoundOver: _handleRoundOver,
    );
  }

  Future<void> _handleRoundOver(RoundOverEvent event) async {
    final round = widget.profile.currentRound;
    final goal = RoundLogic.goalForRound(round);

    final xpResult = XpLogic.calculate(
      roundNumber: round,
      playerSnake: _dummySnakeWithLength(event.finalScore),
      killCount: event.killCount,
      roundGoal: goal,
      goalMet: event.goalWasMet,
    );

    // Update profile
    final updatedProfile = widget.profile.copyWith(
      totalXp: widget.profile.totalXp + xpResult.total,
      currentRound: event.goalWasMet
          ? widget.profile.currentRound + 1
          : widget.profile.currentRound,
      highScore: event.finalScore > widget.profile.highScore
          ? event.finalScore
          : widget.profile.highScore,
      totalKills: widget.profile.totalKills + event.killCount,
    );

    await PersistenceService().save(updatedProfile);

    if (!mounted) return;
    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => GameOverScreen(
          event: event,
          xpEarned: xpResult.total,
          profile: updatedProfile,
          settings: widget.settings,
        ),
      ),
    );
  }

  void _togglePause() {
    setState(() => _paused = !_paused);
    if (_paused) {
      _game.pauseEngine();
    } else {
      _game.resumeEngine();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.arenaBg,
      body: Stack(
        children: [
          // Flame game fills the screen
          GameWidget(
            game: _game,
            overlayBuilderMap: {'goalMet': (_, _) => const _GoalMetBanner()},
          ),

          // Flutter HUD on top
          SafeArea(
            child: _Hud(game: _game, onPause: _togglePause),
          ),

          // Pause overlay
          if (_paused)
            PauseOverlay(
              onResume: _togglePause,
              onQuit: () => Navigator.pop(context),
            ),
        ],
      ),
    );
  }
}

// HUD: score, bot count, active item timers, pause button
class _Hud extends StatelessWidget {
  final SnakeGame game;
  final VoidCallback onPause;

  const _Hud({required this.game, required this.onPause});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.hudPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: score + pause
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ValueListenableBuilder<int>(
                valueListenable: game.scoreNotifier,
                builder: (_, score, _) =>
                    Text('$score', style: AppTextStyles.hudScore),
              ),
              GestureDetector(
                onTap: onPause,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.scrim,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                  ),
                  child: const Icon(
                    Icons.pause_rounded,
                    color: AppColors.textPrimary,
                    size: AppDimensions.iconMd,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppDimensions.spaceXs),

          // Bot count
          ValueListenableBuilder<int>(
            valueListenable: game.aliveBotCountNotifier,
            builder: (_, count, _) =>
                Text('$count snakes left', style: AppTextStyles.hudLabel),
          ),

          const Spacer(),

          // Active item timers at bottom-left
          ValueListenableBuilder<double>(
            valueListenable: game.boostTimerNotifier,
            builder: (_, t, _) => t > 0
                ? _ItemTimer(
                    label: 'BOOST',
                    color: AppColors.boostItem,
                    remaining: t,
                    total: ItemConfig.boostDuration,
                  )
                : const SizedBox.shrink(),
          ),
          ValueListenableBuilder<double>(
            valueListenable: game.magnetTimerNotifier,
            builder: (_, t, _) => t > 0
                ? _ItemTimer(
                    label: 'MAGNET',
                    color: AppColors.magnetItem,
                    remaining: t,
                    total: ItemConfig.magnetDuration,
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

class _ItemTimer extends StatelessWidget {
  final String label;
  final Color color;
  final double remaining;
  final double total;

  const _ItemTimer({
    required this.label,
    required this.color,
    required this.remaining,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.spaceXs),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60,
            height: 6,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(3),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: (remaining / total).clamp(0.0, 1.0),
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
          const SizedBox(width: AppDimensions.spaceXs),
          Text(label, style: AppTextStyles.hudLabel.copyWith(color: color)),
        ],
      ),
    );
  }
}

class _GoalMetBanner extends StatelessWidget {
  const _GoalMetBanner();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: 80),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spaceLg,
            vertical: AppDimensions.spaceSm,
          ),
          decoration: BoxDecoration(
            color: AppColors.secondary.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
          ),
          child: Text(
            'GOAL MET!',
            style: AppTextStyles.headingMedium.copyWith(
              color: AppColors.arenaBg,
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:math' as math;
import 'package:snake_game/balance/round_config.dart';
import 'package:snake_game/game/logic/snake_state.dart';

class XpResult {
  final int baseXp;
  final int killXp;
  final int goalBonusXp;
  final int total;

  const XpResult({
    required this.baseXp,
    required this.killXp,
    required this.goalBonusXp,
  }) : total = baseXp + killXp + goalBonusXp;
}

// Pure XP calculation — no rendering or side effects.
class XpLogic {
  XpLogic._();

  static XpResult calculate({
    required int roundNumber,
    required SnakeState playerSnake,
    required int killCount,
    required int roundGoal,
    required bool goalMet,
  }) {
    final multiplier = math
        .pow(RoundConfig.xpGoalScaleFactor, roundNumber - 1)
        .toDouble();

    final baseXp = goalMet
        ? (RoundConfig.baseXpOnGoalMet * multiplier).round()
        : math.max(
            RoundConfig.minPartialXp,
            (RoundConfig.baseXpOnGoalFailed *
                    multiplier *
                    playerSnake.length /
                    roundGoal)
                .round(),
          );

    return XpResult(
      baseXp: baseXp,
      killXp: killCount * RoundConfig.xpPerKill,
      goalBonusXp: 0, // already included in baseXp when goal is met
    );
  }
}

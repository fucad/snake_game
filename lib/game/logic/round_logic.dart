import 'package:snake_game/balance/round_config.dart';
import 'package:snake_game/balance/world_config.dart';
import 'package:snake_game/balance/bot_config.dart';

// Pure functions for querying round parameters.
class RoundLogic {
  RoundLogic._();

  static int goalForRound(int roundNumber) {
    return RoundConfig.baseGoal +
        (roundNumber - 1) * RoundConfig.goalStepPerRound;
  }

  static double arenaSizeForRound(int roundNumber) {
    final size =
        WorldConfig.baseArenaSize +
        (roundNumber - 1) * WorldConfig.sizeStepPerRound;
    return size.clamp(WorldConfig.minArenaSize, WorldConfig.maxArenaSize);
  }

  static int botCountForRound(int roundNumber) {
    final count =
        BotConfig.baseBots +
        ((roundNumber - 1) / BotConfig.botStepRounds).floor();
    return count.clamp(BotConfig.minBots, BotConfig.maxBots);
  }

  // Returns [easy, normal, hard] counts for the given round. [total]
  // overrides the round's bot count (manual setting); the round's mix
  // proportions are kept.
  static List<int> botDifficultyMixForRound(int roundNumber, {int? total}) {
    final index = (roundNumber - 1).clamp(
      0,
      BotConfig.difficultyMix.length - 1,
    );
    final template = BotConfig.difficultyMix[index];
    total ??= botCountForRound(roundNumber);
    final templateTotal = template.reduce((a, b) => a + b);
    if (templateTotal == total) return List.of(template);

    // Scale the last round's mix to match the actual bot count.
    final ratio = total / templateTotal;
    final scaled = template.map((v) => (v * ratio).round()).toList();
    // Correct rounding drift on the last element.
    final diff = total - scaled.reduce((a, b) => a + b);
    scaled[scaled.length - 1] += diff;
    // Drift correction can push the last bucket negative for small totals;
    // take the deficit from the largest bucket instead.
    while (scaled.last < 0) {
      scaled.last++;
      var maxI = 0;
      for (var i = 1; i < scaled.length - 1; i++) {
        if (scaled[i] > scaled[maxI]) maxI = i;
      }
      scaled[maxI]--;
    }
    return scaled;
  }

  static String stageLabel(int roundNumber) {
    for (final stage in RoundConfig.stages) {
      if (roundNumber >= stage.startRound &&
          (stage.endRound == null || roundNumber <= stage.endRound!)) {
        return stage.label;
      }
    }
    return 'Endless';
  }
}

import 'package:vector_math/vector_math.dart' show Vector2;
import 'package:snake_game/balance/world_config.dart';
import 'package:snake_game/game/bot/bot_manager.dart';
import 'package:snake_game/game/logic/arena_state.dart';
import 'package:snake_game/game/logic/round_logic.dart';
import 'package:snake_game/game/logic/snake_state.dart';
import 'package:snake_game/game/logic/spawn_logic.dart';
import 'package:snake_game/progression/player_profile.dart';
import 'package:snake_game/progression/upgrade_logic.dart';
import 'package:snake_game/settings/settings_model.dart';

/// Builds the opening [ArenaState] of a round. Pure Dart, so whole rounds
/// can be simulated headlessly (see test/logic/game_tick_test.dart).
class RoundSetup {
  RoundSetup._();

  /// Food orbs the arena keeps topped up to.
  static int targetFoodCount(double arenaSize) =>
      (arenaSize * arenaSize / WorldConfig.foodAreaPerOrb).round().clamp(
        WorldConfig.minFood,
        WorldConfig.maxFood,
      );

  /// [easy, normal, hard] for a manual difficulty override, or null to keep
  /// the round's own mix.
  static List<int>? manualMix(ManualDifficulty? d, int count) => switch (d) {
    ManualDifficulty.easy => [count, 0, 0],
    ManualDifficulty.normal => [0, count, 0],
    ManualDifficulty.hard => [0, 0, count],
    ManualDifficulty.mixed || null => null,
  };

  /// Player spawns at the arena centre heading right; bots are placed by
  /// [botManager] (which also keeps their AI controllers).
  static ArenaState build({
    required int roundNumber,
    required PlayerProfile profile,
    required SettingsModel settings,
    required BotManager botManager,
  }) {
    final arenaSize = RoundLogic.arenaSizeForRound(roundNumber);
    final center = Vector2(arenaSize / 2, arenaSize / 2);
    final dir = Vector2(1, 0);
    final startingSize = UpgradeLogic.startingSizeFor(profile);

    final player = SnakeState(
      id: 'player',
      owner: SnakeOwner.player,
      segments: List.generate(
        startingSize,
        (i) => center - dir * (i * WorldConfig.segmentSpacing),
      ),
      direction: dir,
      speed: UpgradeLogic.speedFor(profile),
    );

    final count = settings.manualBotCount;
    final bots = botManager.buildBots(
      roundNumber: roundNumber,
      arenaSize: arenaSize,
      playerSpawn: center,
      count: count,
      mix: manualMix(
        settings.manualDifficulty,
        count ?? RoundLogic.botCountForRound(roundNumber),
      ),
    );

    final empty = ArenaState(
      arenaSize: arenaSize,
      snakes: [player, ...bots],
      food: const [],
      particles: const [],
      items: const [],
    );
    return empty.copyWith(
      food: SpawnLogic.refillFood(empty, targetFoodCount(arenaSize)),
    );
  }
}

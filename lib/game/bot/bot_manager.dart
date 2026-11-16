import 'dart:math' as math;
import 'package:vector_math/vector_math.dart' show Vector2;
import 'package:snake_game/balance/bot_config.dart';
import 'package:snake_game/balance/upgrade_config.dart';
import 'package:snake_game/balance/world_config.dart';
import 'package:snake_game/game/bot/bot_controller.dart';
import 'package:snake_game/game/bot/easy_bot.dart';
import 'package:snake_game/game/bot/hard_bot.dart';
import 'package:snake_game/game/bot/normal_bot.dart';
import 'package:snake_game/game/logic/arena_state.dart';
import 'package:snake_game/game/logic/round_logic.dart';
import 'package:snake_game/game/logic/snake_state.dart';

// Manages all bot snakes for a round:
//   - builds initial bot SnakeStates at round start
//   - holds BotController instances keyed by snake ID
//   - computes direction for every living bot each tick
class BotManager {
  final Map<String, BotController> _controllers = {};
  static final _rng = math.Random();
  static int _idCounter = 0;

  // Call once at the start of each round.
  // Returns the list of bot SnakeStates to include in the initial ArenaState.
  // [count] / [mix] ([easy, normal, hard]) override the round defaults
  // (used by the manual bot settings).
  List<SnakeState> buildBots({
    required int roundNumber,
    required double arenaSize,
    required Vector2 playerSpawn,
    int? count,
    List<int>? mix,
  }) {
    _controllers.clear();

    count ??= RoundLogic.botCountForRound(roundNumber);
    mix ??= RoundLogic.botDifficultyMixForRound(roundNumber, total: count);
    // mix = [easyCount, normalCount, hardCount]
    final difficulties = <_Difficulty>[];
    for (var i = 0; i < mix[0]; i++) {
      difficulties.add(_Difficulty.easy);
    }
    for (var i = 0; i < mix[1]; i++) {
      difficulties.add(_Difficulty.normal);
    }
    for (var i = 0; i < mix[2]; i++) {
      difficulties.add(_Difficulty.hard);
    }
    difficulties.shuffle(_rng);

    final bots = <SnakeState>[];
    for (var i = 0; i < count; i++) {
      final id = 'bot_${_idCounter++}';
      final diff = i < difficulties.length ? difficulties[i] : _Difficulty.hard;
      _controllers[id] = _controllerFor(diff);

      final spawn = _randomSpawn(arenaSize, playerSpawn);
      final dir = Vector2(
        _rng.nextDouble() * 2 - 1,
        _rng.nextDouble() * 2 - 1,
      ).normalized();

      final startLength =
          UpgradeConfig.startingSizeValues[0]; // bots start at base
      bots.add(
        SnakeState(
          id: id,
          owner: SnakeOwner.bot,
          segments: List.generate(
            startLength,
            (j) => spawn - dir * (j * WorldConfig.segmentSpacing),
          ),
          direction: dir,
          speed: BotConfig.botBaseSpeed,
          colorIndex:
              i % 12, // index into AppColors.botSnakeColors (12 colours)
        ),
      );
    }
    return bots;
  }

  // Called every tick. Returns map of botId → desired direction.
  Map<String, Vector2> computeDirections(ArenaState state, double dt) {
    final result = <String, Vector2>{};
    for (final snake in state.botSnakes) {
      if (!snake.alive) continue;
      final controller = _controllers[snake.id];
      if (controller == null) continue;
      result[snake.id] = controller.computeDirection(snake, state, dt);
    }
    return result;
  }

  static BotController _controllerFor(_Difficulty d) => switch (d) {
    _Difficulty.easy => EasyBot(),
    _Difficulty.normal => NormalBot(),
    _Difficulty.hard => HardBot(),
  };

  static Vector2 _randomSpawn(double arenaSize, Vector2 playerSpawn) {
    const margin = 200.0;
    Vector2 pos;
    int attempts = 0;
    do {
      pos = Vector2(
        margin + _rng.nextDouble() * (arenaSize - margin * 2),
        margin + _rng.nextDouble() * (arenaSize - margin * 2),
      );
      attempts++;
    } while (pos.distanceTo(playerSpawn) <
            BotConfig.botMinSpawnDistanceFromPlayer &&
        attempts < 30);
    return pos;
  }
}

enum _Difficulty { easy, normal, hard }

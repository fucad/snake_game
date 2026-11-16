import 'package:vector_math/vector_math.dart' show Vector2;
import 'package:snake_game/balance/bot_config.dart';
import 'package:snake_game/balance/world_config.dart';
import 'package:snake_game/game/bot/bot_controller.dart';
import 'package:snake_game/game/logic/arena_state.dart';
import 'package:snake_game/game/logic/snake_state.dart';

// Normal bot: seeks nearest food, avoids other snake bodies within detection radius.
class NormalBot implements BotController {
  @override
  Vector2 computeDirection(SnakeState bot, ArenaState state, double dt) {
    final target = _nearestFood(bot.head, state);
    var dir = target != null ? (target - bot.head).normalized() : bot.direction;
    dir = _avoidBodies(bot, dir, state);
    dir = _avoidWalls(bot.head, dir, state.arenaSize);
    return (dir.length2 == 0) ? bot.direction : dir;
  }

  Vector2? _nearestFood(Vector2 head, ArenaState state) {
    if (state.food.isEmpty) return null;
    return state.food
        .reduce(
          (a, b) =>
              head.distanceTo(a.position) < head.distanceTo(b.position) ? a : b,
        )
        .position;
  }

  Vector2 _avoidBodies(SnakeState bot, Vector2 dir, ArenaState state) {
    var result = dir.clone();
    for (final other in state.snakes) {
      if (!other.alive) continue;
      for (final seg in other.segments.skip(other.id == bot.id ? 5 : 0)) {
        if (bot.head.distanceTo(seg) < BotConfig.normalDetectionRadius) {
          final away = (bot.head - seg).normalized();
          result = (result + away * 0.5).normalized();
        }
      }
    }
    return result;
  }

  Vector2 _avoidWalls(Vector2 head, Vector2 dir, double arenaSize) {
    const margin = WorldConfig.borderThickness + 80;
    final result = dir.clone();
    if (head.x < margin) result.x = result.x.abs();
    if (head.y < margin) result.y = result.y.abs();
    if (head.x > arenaSize - margin) result.x = -result.x.abs();
    if (head.y > arenaSize - margin) result.y = -result.y.abs();
    return (result.length2 == 0) ? dir : result.normalized();
  }
}

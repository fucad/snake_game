import 'package:vector_math/vector_math.dart' show Vector2;
import 'package:snake_game/balance/bot_config.dart';
import 'package:snake_game/balance/world_config.dart';
import 'package:snake_game/game/bot/bot_controller.dart';
import 'package:snake_game/game/logic/arena_state.dart';
import 'package:snake_game/game/logic/snake_state.dart';

// Hard bot: food + death-particle hunting, weighted body avoidance.
class HardBot implements BotController {
  @override
  Vector2 computeDirection(SnakeState bot, ArenaState state, double dt) {
    final target = _bestTarget(bot, state);
    var dir = target != null ? (target - bot.head).normalized() : bot.direction;
    dir = _avoidBodies(bot, dir, state);
    dir = _avoidWalls(bot.head, dir, state.arenaSize);
    return (dir.length2 == 0) ? bot.direction : dir;
  }

  // Prefer nearby death-particle clusters; fall back to nearest food.
  Vector2? _bestTarget(SnakeState bot, ArenaState state) {
    if (state.particles.isNotEmpty) {
      final nearest = state.particles.reduce(
        (a, b) =>
            bot.head.distanceTo(a.position) < bot.head.distanceTo(b.position)
            ? a
            : b,
      );
      if (bot.head.distanceTo(nearest.position) <
          BotConfig.hardDetectionRadius) {
        return nearest.position;
      }
    }
    if (state.food.isEmpty) return null;
    return state.food
        .reduce(
          (a, b) =>
              bot.head.distanceTo(a.position) < bot.head.distanceTo(b.position)
              ? a
              : b,
        )
        .position;
  }

  Vector2 _avoidBodies(SnakeState bot, Vector2 dir, ArenaState state) {
    var result = dir.clone();
    for (final other in state.snakes) {
      if (!other.alive) continue;
      for (final seg in other.segments.skip(other.id == bot.id ? 5 : 0)) {
        final dist = bot.head.distanceTo(seg);
        if (dist < BotConfig.hardDetectionRadius) {
          final weight = 1 - (dist / BotConfig.hardDetectionRadius);
          final away = (bot.head - seg).normalized();
          result = (result + away * weight).normalized();
        }
      }
    }
    return result;
  }

  Vector2 _avoidWalls(Vector2 head, Vector2 dir, double arenaSize) {
    const margin = WorldConfig.borderThickness + 100;
    final result = dir.clone();
    if (head.x < margin) result.x = result.x.abs();
    if (head.y < margin) result.y = result.y.abs();
    if (head.x > arenaSize - margin) result.x = -result.x.abs();
    if (head.y > arenaSize - margin) result.y = -result.y.abs();
    return (result.length2 == 0) ? dir : result.normalized();
  }
}

import 'dart:math' as math;
import 'package:vector_math/vector_math.dart' show Vector2;
import 'package:snake_game/balance/world_config.dart';
import 'package:snake_game/game/bot/bot_controller.dart';
import 'package:snake_game/game/logic/arena_state.dart';
import 'package:snake_game/game/logic/snake_state.dart';

// Easy bot: wanders randomly, turns away from walls only.
class EasyBot implements BotController {
  static final _rng = math.Random();
  Vector2 _wanderDir = Vector2(1, 0);
  double _wanderTimer = 0;

  @override
  Vector2 computeDirection(SnakeState bot, ArenaState state, double dt) {
    _wanderTimer -= dt;
    if (_wanderTimer <= 0) {
      final angle = _rng.nextDouble() * math.pi * 2;
      _wanderDir = Vector2(math.cos(angle), math.sin(angle));
      _wanderTimer = 1 + _rng.nextDouble() * 2;
    }
    return _avoidWalls(bot.head, _wanderDir, state.arenaSize);
  }

  Vector2 _avoidWalls(Vector2 head, Vector2 dir, double arenaSize) {
    const margin = WorldConfig.borderThickness + 60;
    final result = dir.clone();
    if (head.x < margin) result.x = result.x.abs();
    if (head.y < margin) result.y = result.y.abs();
    if (head.x > arenaSize - margin) result.x = -result.x.abs();
    if (head.y > arenaSize - margin) result.y = -result.y.abs();
    return (result.length2 == 0) ? dir : result.normalized();
  }
}

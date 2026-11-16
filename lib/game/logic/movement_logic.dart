import 'dart:math' as math;
import 'package:vector_math/vector_math.dart' show Vector2;
import 'package:snake_game/balance/world_config.dart';
import 'package:snake_game/game/logic/snake_state.dart';

// Pure movement logic — no Flutter/Flame rendering.
class MovementLogic {
  MovementLogic._();

  // Maximum turn rate in radians per second.
  static const double maxTurnRate = 3.5;

  // Steer [snake] toward [targetDirection] and advance by [dt] seconds.
  static SnakeState step(SnakeState snake, Vector2 targetDirection, double dt) {
    if (!snake.alive) return snake;

    final newDirection = _steer(snake.direction, targetDirection, dt);
    final velocity = newDirection * snake.speed * dt;
    final newHead = snake.head + velocity;

    final newSegments = _advanceSegments(snake.segments, newHead);

    return snake.copyWith(
      direction: newDirection,
      segments: newSegments,
      boostTimer: math.max(0, snake.boostTimer - dt),
      magnetTimer: math.max(0, snake.magnetTimer - dt),
      boostActive: snake.boostTimer - dt > 0,
      magnetActive: snake.magnetTimer - dt > 0,
    );
  }

  static Vector2 _steer(Vector2 current, Vector2 target, double dt) {
    if (target.length2 == 0) return current;
    final targetNorm = target.normalized();
    final angle = _signedAngle(current, targetNorm);
    final maxDelta = maxTurnRate * dt;
    final delta = angle.clamp(-maxDelta, maxDelta);
    return Vector2(
      current.x * math.cos(delta) - current.y * math.sin(delta),
      current.x * math.sin(delta) + current.y * math.cos(delta),
    ).normalized();
  }

  static double _signedAngle(Vector2 from, Vector2 to) {
    return math.atan2(
      from.x * to.y - from.y * to.x,
      from.x * to.x + from.y * to.y,
    );
  }

  // Move the head; every following segment is pulled toward the one in
  // front so consecutive segments stay exactly [WorldConfig.segmentSpacing]
  // apart (follow-the-leader). Segment count — the snake's length — never
  // changes here, and the body shape doesn't depend on the frame rate.
  static List<Vector2> _advanceSegments(
    List<Vector2> segments,
    Vector2 newHead,
  ) {
    final result = List<Vector2>.of(segments);
    result[0] = newHead;
    for (var i = 1; i < result.length; i++) {
      final leader = result[i - 1];
      final offset = result[i] - leader;
      final dist = offset.length;
      if (dist > WorldConfig.segmentSpacing) {
        result[i] = leader + offset * (WorldConfig.segmentSpacing / dist);
      }
    }
    return result;
  }

  // Extend the snake by [count] segments, duplicating the tail.
  static SnakeState grow(SnakeState snake, int count) {
    final extra = List<Vector2>.generate(
      count,
      (_) => snake.segments.last.clone(),
    );
    return snake.copyWith(segments: [...snake.segments, ...extra]);
  }
}

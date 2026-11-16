import 'package:vector_math/vector_math.dart' show Vector2;
import 'package:snake_game/game/logic/snake_state.dart';

// All collision detection. Pure Dart — no rendering.
class CollisionLogic {
  CollisionLogic._();

  // Radius used for head-body overlap tests (world units).
  static const double headRadius = 8;
  static const double bodyRadius = 9;
  static const double eatRadius = 12; // slightly larger for food pickup feel

  // Returns the ID of the snake whose body [attacker]'s head hit, or null.
  // Skips the first 5 segments of the attacker's own body (safe zone near head).
  static String? headHitsBody(SnakeState attacker, List<SnakeState> others) {
    for (final other in others) {
      if (!other.alive) continue;
      final startIndex = other.id == attacker.id ? 5 : 0;
      final segments = other.segments.skip(startIndex);
      for (final seg in segments) {
        if (_overlap(attacker.head, headRadius, seg, bodyRadius)) {
          return other.id;
        }
      }
    }
    return null;
  }

  // Head-vs-head: returns the ID of the snake that should die (smaller one).
  // Returns null if no head-to-head collision.
  static String? headToHead(List<SnakeState> aliveSnakes) {
    for (int i = 0; i < aliveSnakes.length; i++) {
      for (int j = i + 1; j < aliveSnakes.length; j++) {
        final a = aliveSnakes[i];
        final b = aliveSnakes[j];
        if (_overlap(a.head, headRadius, b.head, headRadius)) {
          return a.length <= b.length ? a.id : b.id;
        }
      }
    }
    return null;
  }

  // Returns true if [snake]'s head is outside the arena boundary.
  static bool hitsWall(SnakeState snake, double arenaSize) {
    final h = snake.head;
    return h.x < 0 || h.y < 0 || h.x > arenaSize || h.y > arenaSize;
  }

  static bool _overlap(Vector2 a, double ra, Vector2 b, double rb) {
    return a.distanceTo(b) < ra + rb;
  }
}

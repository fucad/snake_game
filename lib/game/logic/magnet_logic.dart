import 'package:vector_math/vector_math.dart' show Vector2;
import 'package:snake_game/balance/item_config.dart';
import 'package:snake_game/game/logic/food_orb.dart';
import 'package:snake_game/game/logic/snake_state.dart';

// Pulls food orbs toward the head of any snake with an active magnet.
// Returns a new food list with updated positions.
class MagnetLogic {
  MagnetLogic._();

  static List<FoodOrb> applyPull(
    List<FoodOrb> food,
    List<SnakeState> snakes,
    double detectionRange,
    double dt,
  ) {
    final magnetSnakes = snakes
        .where((s) => s.alive && s.magnetActive)
        .toList();
    if (magnetSnakes.isEmpty) return food;

    return food
        .map((orb) => _pullOrb(orb, magnetSnakes, detectionRange, dt))
        .toList();
  }

  static FoodOrb _pullOrb(
    FoodOrb orb,
    List<SnakeState> magnetSnakes,
    double detectionRange,
    double dt,
  ) {
    Vector2 totalForce = Vector2.zero();

    for (final snake in magnetSnakes) {
      final toHead = snake.head - orb.position;
      final dist = toHead.length;
      if (dist <= 0 || dist > detectionRange) continue;

      // Force scales inversely with distance — stronger pull when close.
      final strength = (1 - dist / detectionRange) * ItemConfig.magnetPullForce;
      totalForce += toHead.normalized() * strength;
    }

    if (totalForce.length2 == 0) return orb;

    final newPos = orb.position + totalForce * dt;
    return FoodOrb(id: orb.id, position: newPos, value: orb.value);
  }
}

import 'package:snake_game/game/logic/arena_item.dart';
import 'package:snake_game/game/logic/arena_state.dart';
import 'package:snake_game/game/logic/collision_logic.dart';
import 'package:snake_game/game/logic/food_orb.dart';
import 'package:snake_game/game/logic/particle_orb.dart';
import 'package:snake_game/game/logic/snake_state.dart';

class EatResult {
  final List<FoodOrb> eatenFood;
  final List<ParticleOrb> eatenParticles;
  final List<ArenaItem> collectedItems;
  final int segmentsGained;

  const EatResult({
    required this.eatenFood,
    required this.eatenParticles,
    required this.collectedItems,
    required this.segmentsGained,
  });
}

// Determines what [snake] eats this tick from [state].
class EatLogic {
  EatLogic._();

  static EatResult evaluate(SnakeState snake, ArenaState state) {
    if (!snake.alive) {
      return const EatResult(
        eatenFood: [],
        eatenParticles: [],
        collectedItems: [],
        segmentsGained: 0,
      );
    }

    final eatenFood = state.food
        .where(
          (f) => snake.head.distanceTo(f.position) < CollisionLogic.eatRadius,
        )
        .toList();

    final eatenParticles = state.particles
        .where(
          (p) => snake.head.distanceTo(p.position) < CollisionLogic.eatRadius,
        )
        .toList();

    final collectedItems = state.items
        .where(
          (i) =>
              snake.head.distanceTo(i.position) <
              CollisionLogic.eatRadius * 1.5,
        )
        .toList();

    final segmentsGained = eatenFood.fold(0, (sum, f) => sum + f.value);

    return EatResult(
      eatenFood: eatenFood,
      eatenParticles: eatenParticles,
      collectedItems: collectedItems,
      segmentsGained: segmentsGained,
    );
  }
}

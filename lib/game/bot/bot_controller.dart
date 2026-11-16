import 'package:vector_math/vector_math.dart' show Vector2;
import 'package:snake_game/game/logic/arena_state.dart';
import 'package:snake_game/game/logic/snake_state.dart';

// Base interface for all bot AI strategies.
// Receives world state + dt, returns the desired direction vector (normalised).
abstract class BotController {
  Vector2 computeDirection(SnakeState bot, ArenaState state, double dt);
}

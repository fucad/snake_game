import 'package:snake_game/game/logic/arena_item.dart';

// Events emitted by GameTick each frame.
// The rendering layer consumes these to trigger juice effects and UI updates.
// Never put game logic inside event handlers — events are read-only signals.

sealed class GameEvent {
  const GameEvent();
}

// A snake died. killerSnakeId is null if it hit a wall.
class SnakeDiedEvent extends GameEvent {
  final String deadSnakeId;
  final String? killerSnakeId;
  final bool isPlayer;
  const SnakeDiedEvent({
    required this.deadSnakeId,
    this.killerSnakeId,
    required this.isPlayer,
  });
}

// Player killed a bot snake (subset of SnakeDiedEvent, separated for juice).
class PlayerKilledBotEvent extends GameEvent {
  final String botId;
  final int botLength;
  const PlayerKilledBotEvent({required this.botId, required this.botLength});
}

// Any snake ate a food orb.
class FoodEatenEvent extends GameEvent {
  final String snakeId;
  final bool isPlayer;
  const FoodEatenEvent({required this.snakeId, required this.isPlayer});
}

// Any snake ate one or more particle orbs.
class ParticlesEatenEvent extends GameEvent {
  final String snakeId;
  final int count;
  final bool isPlayer;
  const ParticlesEatenEvent({
    required this.snakeId,
    required this.count,
    required this.isPlayer,
  });
}

// A snake collected an item.
class ItemCollectedEvent extends GameEvent {
  final String snakeId;
  final ItemType itemType;
  final bool isPlayer;
  const ItemCollectedEvent({
    required this.snakeId,
    required this.itemType,
    required this.isPlayer,
  });
}

// Player's snake reached the round goal length.
class GoalMetEvent extends GameEvent {
  const GoalMetEvent();
}

// Player's snake died — the round is over.
class RoundOverEvent extends GameEvent {
  final bool goalWasMet;
  final int finalScore;
  final int killCount;
  const RoundOverEvent({
    required this.goalWasMet,
    required this.finalScore,
    required this.killCount,
  });
}

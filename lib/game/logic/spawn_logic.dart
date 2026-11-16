import 'dart:math' as math;
import 'package:vector_math/vector_math.dart' show Vector2;
import 'package:snake_game/balance/item_config.dart';
import 'package:snake_game/balance/world_config.dart';
import 'package:snake_game/game/logic/arena_item.dart';
import 'package:snake_game/game/logic/arena_state.dart';
import 'package:snake_game/game/logic/food_orb.dart';

// Spawning helpers for food and items. Pure Dart.
class SpawnLogic {
  SpawnLogic._();

  static final _rng = math.Random();
  static int _idCounter = 0;

  static String _nextId(String prefix) => '${prefix}_${_idCounter++}';

  // Spawn food orbs until [state] reaches the target count.
  // Avoids spawning on top of existing entities.
  static List<FoodOrb> refillFood(ArenaState state, int targetCount) {
    final existing = List<FoodOrb>.of(state.food);
    final toSpawn = targetCount - existing.length;
    for (int i = 0; i < toSpawn; i++) {
      existing.add(
        FoodOrb(
          id: _nextId('food'),
          position: _randomPosition(state.arenaSize),
        ),
      );
    }
    return existing;
  }

  // Returns a new item of [type] if conditions are met, or null.
  static ArenaItem? trySpawnItem(
    ItemType type,
    ArenaState state,
    Vector2 playerHead,
  ) {
    final count = state.items.where((i) => i.type == type).length;
    final max = type == ItemType.boost
        ? ItemConfig.maxBoostItems
        : ItemConfig.maxMagnetItems;
    if (count >= max) return null;

    Vector2 pos;
    int attempts = 0;
    do {
      pos = _randomPosition(state.arenaSize);
      attempts++;
    } while (pos.distanceTo(playerHead) <
            ItemConfig.minSpawnDistanceFromPlayer &&
        attempts < 20);

    return ArenaItem(
      id: _nextId('item'),
      type: type,
      position: pos,
      lifetime: ItemConfig.itemLifetime,
    );
  }

  static Vector2 _randomPosition(double arenaSize) {
    const margin = WorldConfig.borderThickness + 50;
    return Vector2(
      margin + _rng.nextDouble() * (arenaSize - margin * 2),
      margin + _rng.nextDouble() * (arenaSize - margin * 2),
    );
  }
}

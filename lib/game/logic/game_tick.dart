import 'dart:math' as math;
import 'package:vector_math/vector_math.dart' show Vector2;
import 'package:snake_game/balance/item_config.dart';
import 'package:snake_game/balance/particle_config.dart';
import 'package:snake_game/game/bot/bot_manager.dart';
import 'package:snake_game/game/logic/arena_item.dart';
import 'package:snake_game/game/logic/arena_state.dart';
import 'package:snake_game/game/logic/collision_logic.dart';
import 'package:snake_game/game/logic/death_logic.dart';
import 'package:snake_game/game/logic/game_event.dart';
import 'package:snake_game/game/logic/magnet_logic.dart';
import 'package:snake_game/game/logic/movement_logic.dart';
import 'package:snake_game/game/logic/round_logic.dart';
import 'package:snake_game/game/logic/round_setup.dart';
import 'package:snake_game/game/logic/snake_state.dart';
import 'package:snake_game/game/logic/spawn_logic.dart';

class TickResult {
  final ArenaState state;
  final List<GameEvent> events;
  const TickResult(this.state, this.events);
}

// The central game loop. Advances the world by [dt] seconds.
// All game rules live here or in the logic files it calls.
// The rendering layer calls this every frame and reacts to events.
class GameTick {
  GameTick._();

  static TickResult advance(
    ArenaState state,
    Vector2 playerTargetDirection,
    double dt,
    BotManager botManager,
    int roundNumber,
    double playerDetectionRange,
  ) {
    if (state.roundOver) return TickResult(state, const []);

    final events = <GameEvent>[];

    // ── 1. Collect bot directions ──────────────────────────────────────────
    final botDirections = botManager.computeDirections(state, dt);

    // ── 2. Move all snakes ─────────────────────────────────────────────────
    var snakes = state.snakes.map((snake) {
      if (!snake.alive) return snake;
      final target = snake.owner == SnakeOwner.player
          ? playerTargetDirection
          : (botDirections[snake.id] ?? snake.direction);
      final effectiveSpeed = snake.boostActive
          ? snake.speed * ItemConfig.boostSpeedMultiplier
          : snake.speed;
      return MovementLogic.step(
        snake.copyWith(speed: effectiveSpeed),
        target,
        dt,
      );
    }).toList();

    // ── 3. Apply magnet pull to food ───────────────────────────────────────
    var food = MagnetLogic.applyPull(
      state.food,
      snakes,
      playerDetectionRange,
      dt,
    );

    // ── 4. Check collisions → collect deaths ───────────────────────────────
    final deadIds = <String>{};

    // Wall hits
    for (final snake in snakes) {
      if (!snake.alive) continue;
      if (CollisionLogic.hitsWall(snake, state.arenaSize)) {
        deadIds.add(snake.id);
      }
    }

    // Head-body hits (skip snakes already dead from wall)
    final aliveForCollision = snakes
        .where((s) => s.alive && !deadIds.contains(s.id))
        .toList();
    for (final snake in aliveForCollision) {
      final hitId = CollisionLogic.headHitsBody(snake, aliveForCollision);
      if (hitId != null) deadIds.add(snake.id);
    }

    // Head-to-head (smaller dies)
    final h2hDeadId = CollisionLogic.headToHead(aliveForCollision);
    if (h2hDeadId != null) deadIds.add(h2hDeadId);

    // ── 5. Process deaths ──────────────────────────────────────────────────
    var particles = List.of(state.particles);
    var killCount = state.playerKillCount;
    var playerDied = false;

    for (final id in deadIds) {
      final dead = snakes.firstWhere((s) => s.id == id);
      final newParticles = DeathLogic.toParticles(dead);
      particles.addAll(newParticles);

      final isPlayer = dead.owner == SnakeOwner.player;
      if (isPlayer) playerDied = true;

      // Determine killer (the snake whose body was hit, if any).
      // For simplicity we attribute kills only when a player kills a bot.
      String? killerId;
      if (!isPlayer) {
        // Check if any alive player segment caused the death.
        final player = snakes.firstWhere((s) => s.owner == SnakeOwner.player);
        if (player.alive && !deadIds.contains(player.id)) {
          final hitOnPlayer = CollisionLogic.headHitsBody(dead, [player]);
          if (hitOnPlayer != null) {
            killerId = player.id;
            killCount++;
            events.add(PlayerKilledBotEvent(botId: id, botLength: dead.length));
          }
        }
      }

      events.add(
        SnakeDiedEvent(
          deadSnakeId: id,
          killerSnakeId: killerId,
          isPlayer: isPlayer,
        ),
      );
    }

    // Mark dead snakes
    snakes = snakes
        .map((s) => deadIds.contains(s.id) ? s.copyWith(alive: false) : s)
        .toList();

    // ── 6. Process eating for alive snakes ─────────────────────────────────
    final eatenFoodIds = <String>{};
    final eatenParticleIds = <String>{};
    final eatenItemIds = <String>{};

    snakes = snakes.map((snake) {
      if (!snake.alive) return snake;

      var grown = snake;

      // Food
      final myFood = food.where(
        (f) =>
            !eatenFoodIds.contains(f.id) &&
            snake.head.distanceTo(f.position) < CollisionLogic.eatRadius,
      );
      for (final f in myFood) {
        eatenFoodIds.add(f.id);
        grown = MovementLogic.grow(grown, f.value);
        events.add(
          FoodEatenEvent(
            snakeId: snake.id,
            isPlayer: snake.owner == SnakeOwner.player,
          ),
        );
      }

      // Particles
      final myParticles = particles
          .where(
            (p) =>
                !eatenParticleIds.contains(p.id) &&
                snake.head.distanceTo(p.position) < CollisionLogic.eatRadius,
          )
          .toList();
      if (myParticles.isNotEmpty) {
        for (final p in myParticles) {
          eatenParticleIds.add(p.id);
        }
        final newBuffer = grown.particleBuffer + myParticles.length;
        final gained = newBuffer ~/ ParticleConfig.particlesPerSegmentGain;
        final remainder = newBuffer % ParticleConfig.particlesPerSegmentGain;
        if (gained > 0) grown = MovementLogic.grow(grown, gained);
        grown = grown.copyWith(particleBuffer: remainder);
        events.add(
          ParticlesEatenEvent(
            snakeId: snake.id,
            count: myParticles.length,
            isPlayer: snake.owner == SnakeOwner.player,
          ),
        );
      }

      // Items
      final myItems = state.items.where(
        (i) =>
            !eatenItemIds.contains(i.id) &&
            snake.head.distanceTo(i.position) < CollisionLogic.eatRadius * 1.5,
      );
      for (final item in myItems) {
        eatenItemIds.add(item.id);
        grown = _applyItem(grown, item.type);
        events.add(
          ItemCollectedEvent(
            snakeId: snake.id,
            itemType: item.type,
            isPlayer: snake.owner == SnakeOwner.player,
          ),
        );
      }

      return grown;
    }).toList();

    // ── 7. Tick and clean up particles / items ─────────────────────────────
    particles = particles
        .where((p) => !eatenParticleIds.contains(p.id))
        .map((p) => p.tick(dt))
        .where((p) => !p.expired)
        .toList();

    var items = state.items
        .where((i) => !eatenItemIds.contains(i.id))
        .map((i) => i.tick(dt))
        .where((i) => !i.expired)
        .toList();

    food = food.where((f) => !eatenFoodIds.contains(f.id)).toList();

    // ── 8. Refill food ─────────────────────────────────────────────────────
    final targetFood = _targetFoodCount(state.arenaSize);
    final tempState = state.copyWith(
      food: food,
      particles: particles,
      items: items,
      snakes: snakes,
    );
    food = SpawnLogic.refillFood(tempState, targetFood);

    // ── 9. Try spawn items ─────────────────────────────────────────────────
    var boostTimer = math.max(0.0, state.boostSpawnTimer - dt);
    var magnetTimer = math.max(0.0, state.magnetSpawnTimer - dt);
    final playerHead = snakes.first.head;

    if (boostTimer <= 0) {
      final spawned = SpawnLogic.trySpawnItem(
        ItemType.boost,
        tempState,
        playerHead,
      );
      if (spawned != null) items.add(spawned);
      boostTimer = ItemConfig.boostSpawnInterval;
    }
    if (magnetTimer <= 0) {
      final spawned = SpawnLogic.trySpawnItem(
        ItemType.magnet,
        tempState,
        playerHead,
      );
      if (spawned != null) items.add(spawned);
      magnetTimer = ItemConfig.magnetSpawnInterval;
    }

    // ── 10. Check goal / round over ────────────────────────────────────────
    final player = snakes.first;
    final goal = RoundLogic.goalForRound(roundNumber);
    var goalMet = state.goalMet;

    if (!goalMet && player.alive && player.length >= goal) {
      goalMet = true;
      events.add(const GoalMetEvent());
    }

    var roundOver = state.roundOver;
    if (playerDied) {
      roundOver = true;
      events.add(
        RoundOverEvent(
          goalWasMet: goalMet,
          finalScore: player.length,
          killCount: killCount,
        ),
      );
    }

    // ── 11. Build new state ────────────────────────────────────────────────
    final newState = ArenaState(
      arenaSize: state.arenaSize,
      snakes: snakes,
      food: food,
      particles: particles,
      items: items,
      elapsedSeconds: state.elapsedSeconds + dt,
      roundOver: roundOver,
      goalMet: goalMet,
      playerKillCount: killCount,
      boostSpawnTimer: boostTimer,
      magnetSpawnTimer: magnetTimer,
    );

    return TickResult(newState, events);
  }

  // Apply an item's immediate effect to a snake.
  static SnakeState _applyItem(SnakeState snake, ItemType type) {
    return switch (type) {
      ItemType.boost => snake.copyWith(
        boostActive: true,
        boostTimer: ItemConfig.boostDuration,
      ),
      ItemType.magnet => snake.copyWith(
        magnetActive: true,
        magnetTimer: ItemConfig.magnetDuration,
      ),
    };
  }

  static int _targetFoodCount(double arenaSize) =>
      RoundSetup.targetFoodCount(arenaSize);
}

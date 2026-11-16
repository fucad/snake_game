import 'package:snake_game/balance/item_config.dart';
import 'package:snake_game/game/logic/arena_item.dart';
import 'package:snake_game/game/logic/food_orb.dart';
import 'package:snake_game/game/logic/particle_orb.dart';
import 'package:snake_game/game/logic/snake_state.dart';

class ArenaState {
  final double arenaSize;
  final List<SnakeState> snakes; // index 0 = player
  final List<FoodOrb> food;
  final List<ParticleOrb> particles;
  final List<ArenaItem> items;
  final double elapsedSeconds;
  final bool roundOver;
  final bool goalMet;
  final int playerKillCount;
  // Countdown timers for item spawning. When they hit 0 a new item is attempted.
  final double boostSpawnTimer;
  final double magnetSpawnTimer;

  const ArenaState({
    required this.arenaSize,
    required this.snakes,
    required this.food,
    required this.particles,
    required this.items,
    this.elapsedSeconds = 0,
    this.roundOver = false,
    this.goalMet = false,
    this.playerKillCount = 0,
    this.boostSpawnTimer = ItemConfig.boostSpawnInterval,
    this.magnetSpawnTimer = ItemConfig.magnetSpawnInterval,
  });

  SnakeState get playerSnake => snakes.first;
  List<SnakeState> get botSnakes => snakes.skip(1).toList();
  List<SnakeState> get aliveSnakes => snakes.where((s) => s.alive).toList();
  bool get playerAlive => playerSnake.alive;

  ArenaState copyWith({
    List<SnakeState>? snakes,
    List<FoodOrb>? food,
    List<ParticleOrb>? particles,
    List<ArenaItem>? items,
    double? elapsedSeconds,
    bool? roundOver,
    bool? goalMet,
    int? playerKillCount,
    double? boostSpawnTimer,
    double? magnetSpawnTimer,
  }) {
    return ArenaState(
      arenaSize: arenaSize,
      snakes: snakes ?? this.snakes,
      food: food ?? this.food,
      particles: particles ?? this.particles,
      items: items ?? this.items,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
      roundOver: roundOver ?? this.roundOver,
      goalMet: goalMet ?? this.goalMet,
      playerKillCount: playerKillCount ?? this.playerKillCount,
      boostSpawnTimer: boostSpawnTimer ?? this.boostSpawnTimer,
      magnetSpawnTimer: magnetSpawnTimer ?? this.magnetSpawnTimer,
    );
  }
}

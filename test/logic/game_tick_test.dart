import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:snake_game/game/bot/bot_manager.dart';
import 'package:snake_game/game/logic/arena_state.dart';
import 'package:snake_game/game/logic/game_event.dart';
import 'package:snake_game/game/logic/game_tick.dart';
import 'package:snake_game/game/logic/round_logic.dart';
import 'package:snake_game/game/logic/round_setup.dart';
import 'package:snake_game/game/logic/snake_state.dart';
import 'package:snake_game/progression/player_profile.dart';
import 'package:snake_game/settings/settings_model.dart';
import 'package:vector_math/vector_math.dart' show Vector2;

const dt = 1 / 60;

/// Runs [seconds] of a round headlessly. [steer] maps elapsed time to the
/// player's desired direction. Stops early when the round ends.
({ArenaState state, List<GameEvent> events}) simulate({
  int round = 1,
  double seconds = 30,
  SettingsModel settings = const SettingsModel.defaults(),
  required Vector2 Function(double t) steer,
}) {
  final bots = BotManager();
  var state = RoundSetup.build(
    roundNumber: round,
    profile: const PlayerProfile(),
    settings: settings,
    botManager: bots,
  );
  final events = <GameEvent>[];
  var t = 0.0;
  while (t < seconds && !state.roundOver) {
    final r = GameTick.advance(state, steer(t), dt, bots, round, 100);
    state = r.state;
    events.addAll(r.events);
    t += dt;
  }
  return (state: state, events: events);
}

void main() {
  test('round setup: player centred, bots per round, food topped up', () {
    final state = RoundSetup.build(
      roundNumber: 1,
      profile: const PlayerProfile(),
      settings: const SettingsModel.defaults(),
      botManager: BotManager(),
    );
    final size = RoundLogic.arenaSizeForRound(1);
    expect(state.playerSnake.owner, SnakeOwner.player);
    expect(state.playerSnake.head, Vector2(size / 2, size / 2));
    expect(state.botSnakes.length, RoundLogic.botCountForRound(1));
    expect(state.food.length, RoundSetup.targetFoodCount(size));
  });

  test('manual bot settings override count and difficulty', () {
    final state = RoundSetup.build(
      roundNumber: 1,
      profile: const PlayerProfile(),
      settings: const SettingsModel(
        manualBotCount: 7,
        manualDifficulty: ManualDifficulty.hard,
      ),
      botManager: BotManager(),
    );
    expect(state.botSnakes.length, 7);
    expect(RoundSetup.manualMix(ManualDifficulty.hard, 7), [0, 0, 7]);
    expect(RoundSetup.manualMix(ManualDifficulty.mixed, 7), isNull);
  });

  test('difficulty mix always sums to the bot count, never negative', () {
    for (var round = 1; round <= 30; round++) {
      for (final total in [1, 2, 3, 5, 8, 12]) {
        final mix = RoundLogic.botDifficultyMixForRound(round, total: total);
        expect(mix.reduce((a, b) => a + b), total, reason: 'r$round t$total');
        expect(mix.every((v) => v >= 0), isTrue, reason: 'r$round $mix');
      }
    }
  });

  test('a circling player survives 30s; world stays consistent', () {
    // Gentle circle: radius ~ speed / angularSpeed, well inside the arena.
    final run = simulate(
      steer: (t) => Vector2(math.cos(t * 0.6), math.sin(t * 0.6)),
    );
    final s = run.state;
    expect(s.roundOver, isFalse);
    expect(s.elapsedSeconds, closeTo(30, 0.1));
    for (final snake in s.snakes.where((x) => x.alive)) {
      expect(snake.head.x, inInclusiveRange(0, s.arenaSize));
      expect(snake.head.y, inInclusiveRange(0, s.arenaSize));
    }
    expect(s.food.length, RoundSetup.targetFoodCount(s.arenaSize));
  });

  test('driving straight into the wall ends the round with particles', () {
    final run = simulate(seconds: 120, steer: (_) => Vector2(1, 0));
    expect(run.state.roundOver, isTrue);
    final over = run.events.whereType<RoundOverEvent>().single;
    expect(over.goalWasMet, isFalse);
    expect(over.finalScore, greaterThan(0));
    final died = run.events.whereType<SnakeDiedEvent>().where(
      (e) => e.isPlayer,
    );
    expect(died, hasLength(1));
    expect(run.state.particles, isNotEmpty);
  });

  test('bots move and mostly stay alive for 30s', () {
    final bots = BotManager();
    final start = RoundSetup.build(
      roundNumber: 5,
      profile: const PlayerProfile(),
      settings: const SettingsModel.defaults(),
      botManager: bots,
    );
    var state = start;
    for (var i = 0; i < 30 * 60 && !state.roundOver; i++) {
      final angle = i * dt * 0.6;
      state = GameTick.advance(
        state,
        Vector2(math.cos(angle), math.sin(angle)),
        dt,
        bots,
        5,
        100,
      ).state;
    }
    for (final b in start.botSnakes) {
      final now = state.snakes.firstWhere((s) => s.id == b.id);
      if (now.alive) expect(now.head.distanceTo(b.head), greaterThan(50));
    }
    final alive = state.botSnakes.where((s) => s.alive).length;
    // ignore: avoid_print
    print('round 5: ${start.botSnakes.length} bots → $alive alive after 30s');
    expect(alive, greaterThanOrEqualTo(start.botSnakes.length ~/ 2));
  });

  test('reaching the goal length fires GoalMetEvent once', () {
    final bots = BotManager();
    var state = RoundSetup.build(
      roundNumber: 1,
      profile: const PlayerProfile(),
      settings: const SettingsModel(manualBotCount: 0),
      botManager: bots,
    );
    final goal = RoundLogic.goalForRound(1);
    final p = state.playerSnake;
    final grown = p.copyWith(
      segments: List.generate(goal, (i) => p.head - Vector2(i * 8.0, 0)),
    );
    state = state.copyWith(snakes: [grown, ...state.botSnakes]);
    final events = <GameEvent>[];
    for (var i = 0; i < 10; i++) {
      final r = GameTick.advance(state, Vector2(0, 1), dt, bots, 1, 100);
      state = r.state;
      events.addAll(r.events);
    }
    expect(events.whereType<GoalMetEvent>(), hasLength(1));
    expect(state.goalMet, isTrue);
  });
}

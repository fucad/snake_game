import 'package:flame/components.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snake_game/game/logic/snake_state.dart';
import 'package:snake_game/game/logic/xp_logic.dart';

SnakeState _snake(int length) => SnakeState(
  id: 'p',
  owner: SnakeOwner.player,
  segments: List.generate(length, (_) => Vector2.zero()),
  direction: Vector2(1, 0),
  speed: 120,
);

void main() {
  group('XpLogic.calculate', () {
    test('earns base XP on goal met', () {
      final result = XpLogic.calculate(
        roundNumber: 1,
        playerSnake: _snake(30),
        killCount: 0,
        roundGoal: 20,
        goalMet: true,
      );
      expect(result.total, greaterThan(0));
      expect(result.baseXp, greaterThan(0));
    });

    test('earns partial XP on goal failed', () {
      final result = XpLogic.calculate(
        roundNumber: 1,
        playerSnake: _snake(5),
        killCount: 0,
        roundGoal: 20,
        goalMet: false,
      );
      expect(result.total, greaterThanOrEqualTo(5)); // minPartialXp
    });

    test('kill XP adds on top of base XP', () {
      final noKills = XpLogic.calculate(
        roundNumber: 1,
        playerSnake: _snake(30),
        killCount: 0,
        roundGoal: 20,
        goalMet: true,
      );
      final withKills = XpLogic.calculate(
        roundNumber: 1,
        playerSnake: _snake(30),
        killCount: 3,
        roundGoal: 20,
        goalMet: true,
      );
      expect(withKills.total, greaterThan(noKills.total));
      expect(withKills.killXp, 24); // 3 × 8
    });

    test('XP scales up with round number', () {
      final r1 = XpLogic.calculate(
        roundNumber: 1,
        playerSnake: _snake(30),
        killCount: 0,
        roundGoal: 20,
        goalMet: true,
      );
      final r5 = XpLogic.calculate(
        roundNumber: 5,
        playerSnake: _snake(30),
        killCount: 0,
        roundGoal: 20,
        goalMet: true,
      );
      expect(r5.total, greaterThan(r1.total));
    });
  });
}

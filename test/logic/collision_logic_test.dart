import 'package:flame/components.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snake_game/game/logic/collision_logic.dart';
import 'package:snake_game/game/logic/snake_state.dart';

SnakeState _snake(String id, Vector2 head, {int length = 10}) => SnakeState(
  id: id,
  owner: SnakeOwner.player,
  segments: List.generate(length, (i) => head - Vector2(i * 8.0, 0)),
  direction: Vector2(1, 0),
  speed: 120,
);

void main() {
  group('CollisionLogic.hitsWall', () {
    test('inside arena is safe', () {
      final snake = _snake('p', Vector2(500, 500));
      expect(CollisionLogic.hitsWall(snake, 2000), false);
    });

    test('at x=-1 (past left wall) is a hit', () {
      final snake = _snake('p', Vector2(-1, 500));
      expect(CollisionLogic.hitsWall(snake, 2000), true);
    });

    test('beyond arena width is a hit', () {
      final snake = _snake('p', Vector2(2001, 500));
      expect(CollisionLogic.hitsWall(snake, 2000), true);
    });

    test('at y=-1 (past top wall) is a hit', () {
      final snake = _snake('p', Vector2(500, -1));
      expect(CollisionLogic.hitsWall(snake, 2000), true);
    });
  });

  group('CollisionLogic.headToHead', () {
    test('no collision when snakes are far apart', () {
      final a = _snake('a', Vector2(0, 0));
      final b = _snake('b', Vector2(500, 500));
      expect(CollisionLogic.headToHead([a, b]), null);
    });

    test('shorter snake dies on head collision', () {
      final big = _snake('big', Vector2(0, 0), length: 20);
      final small = _snake('small', Vector2(1, 0), length: 5);
      expect(CollisionLogic.headToHead([big, small]), 'small');
    });

    test('same-length collision kills first listed snake', () {
      final a = _snake('a', Vector2(0, 0), length: 10);
      final b = _snake('b', Vector2(1, 0), length: 10);
      // Smaller or equal → a dies (a.length <= b.length)
      expect(CollisionLogic.headToHead([a, b]), 'a');
    });
  });

  group('CollisionLogic.headHitsBody', () {
    test('no hit when far apart', () {
      final player = _snake('p', Vector2(0, 0));
      final bot = _snake('b', Vector2(500, 0));
      expect(CollisionLogic.headHitsBody(player, [player, bot]), null);
    });

    test('first 5 own segments are safe zone', () {
      // Own head (index 0) should never cause self-death
      final snake = _snake('p', Vector2(100, 100));
      expect(CollisionLogic.headHitsBody(snake, [snake]), null);
    });
  });
}

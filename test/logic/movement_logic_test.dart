import 'package:flame/components.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snake_game/balance/world_config.dart';
import 'package:snake_game/game/logic/collision_logic.dart';
import 'package:snake_game/game/logic/movement_logic.dart';
import 'package:snake_game/game/logic/snake_state.dart';

SnakeState _makeSnake({int length = 5, Vector2? direction}) {
  final dir = direction ?? Vector2(1, 0);
  return SnakeState(
    id: 'test',
    owner: SnakeOwner.player,
    segments: List.generate(length, (i) => Vector2(100.0 - i * 8, 100)),
    direction: dir,
    speed: 120,
  );
}

void main() {
  group('MovementLogic.step', () {
    test('head advances in direction', () {
      final snake = _makeSnake();
      final moved = MovementLogic.step(snake, Vector2(1, 0), 0.1);
      expect(moved.head.x, greaterThan(snake.head.x));
    });

    test('segment count stays the same', () {
      final snake = _makeSnake(length: 10);
      final moved = MovementLogic.step(snake, Vector2(1, 0), 0.016);
      expect(moved.length, snake.length);
    });

    test('dead snake does not move', () {
      final snake = _makeSnake().copyWith(alive: false);
      final moved = MovementLogic.step(snake, Vector2(1, 0), 0.016);
      expect(moved.head, snake.head);
    });

    test('direction stays normalised', () {
      final snake = _makeSnake();
      final moved = MovementLogic.step(snake, Vector2(1, 1), 0.016);
      expect(moved.direction.length, closeTo(1.0, 0.001));
    });

    test('boost timer counts down', () {
      final snake = _makeSnake().copyWith(boostTimer: 2.0, boostActive: true);
      final moved = MovementLogic.step(snake, Vector2(1, 0), 1.0);
      expect(moved.boostTimer, closeTo(1.0, 0.01));
    });

    test('boost becomes inactive at zero', () {
      final snake = _makeSnake().copyWith(boostTimer: 0.5, boostActive: true);
      final moved = MovementLogic.step(snake, Vector2(1, 0), 1.0);
      expect(moved.boostActive, false);
    });
  });

  group('MovementLogic body spacing (regression: instant self-kill)', () {
    test('segments stay segmentSpacing apart after many small steps', () {
      var snake = _makeSnake(length: 12);
      for (var i = 0; i < 300; i++) {
        snake = MovementLogic.step(snake, Vector2(0.3, 1), 1 / 60);
      }
      for (var i = 1; i < snake.length; i++) {
        expect(
          snake.segments[i - 1].distanceTo(snake.segments[i]),
          closeTo(WorldConfig.segmentSpacing, 0.01),
        );
      }
    });

    test('a straight-moving snake never hits its own body', () {
      var snake = _makeSnake(length: 10);
      for (var i = 0; i < 120; i++) {
        snake = MovementLogic.step(snake, Vector2(1, 0), 1 / 60);
        expect(CollisionLogic.headHitsBody(snake, [snake]), isNull);
      }
    });

    test('a hard U-turn at max turn rate does not self-collide', () {
      var snake = _makeSnake(length: 10);
      for (var i = 0; i < 90; i++) {
        snake = MovementLogic.step(snake, Vector2(-1, 0.01), 1 / 60);
        expect(CollisionLogic.headHitsBody(snake, [snake]), isNull);
      }
    });
  });

  group('MovementLogic.grow', () {
    test('adds segments to tail', () {
      final snake = _makeSnake(length: 5);
      final grown = MovementLogic.grow(snake, 3);
      expect(grown.length, 8);
    });

    test('head position unchanged after grow', () {
      final snake = _makeSnake(length: 5);
      final grown = MovementLogic.grow(snake, 2);
      expect(grown.head.x, snake.head.x);
      expect(grown.head.y, snake.head.y);
    });
  });
}

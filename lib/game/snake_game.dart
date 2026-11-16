import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:snake_game/game/bot/bot_manager.dart';
import 'package:snake_game/game/components/arena_component.dart';
import 'package:snake_game/game/components/food_orb_component.dart';
import 'package:snake_game/game/components/item_component.dart';
import 'package:snake_game/game/components/minimap_component.dart';
import 'package:snake_game/game/components/particle_orb_component.dart';
import 'package:snake_game/game/components/snake_component.dart';
import 'package:snake_game/game/logic/arena_state.dart';
import 'package:snake_game/game/logic/game_event.dart';
import 'package:snake_game/game/logic/game_tick.dart';
import 'package:snake_game/game/logic/round_setup.dart';
import 'package:snake_game/progression/player_profile.dart';
import 'package:snake_game/progression/upgrade_logic.dart';
import 'package:snake_game/settings/settings_model.dart';

class SnakeGame extends FlameGame with TapCallbacks, DragCallbacks {
  final int roundNumber;
  final PlayerProfile profile;
  final SettingsModel settings;

  // Called when the player dies and the round is over.
  final void Function(RoundOverEvent event) onRoundOver;

  // ValueNotifiers consumed by the Flutter HUD overlay.
  final ValueNotifier<int> scoreNotifier = ValueNotifier(0);
  final ValueNotifier<int> aliveBotCountNotifier = ValueNotifier(0);
  final ValueNotifier<double> boostTimerNotifier = ValueNotifier(0);
  final ValueNotifier<double> magnetTimerNotifier = ValueNotifier(0);
  final ValueNotifier<bool> goalMetNotifier = ValueNotifier(false);

  SnakeGame({
    required this.roundNumber,
    required this.profile,
    required this.settings,
    required this.onRoundOver,
  });

  late ArenaState _state;
  late BotManager _botManager;
  late double _playerDetectionRange;
  Vector2 _playerTargetDir = Vector2(1, 0);
  bool _roundEnded = false;

  final Map<String, SnakeComponent> _snakeComponents = {};
  final Map<String, FoodOrbComponent> _foodComponents = {};
  final Map<String, ParticleOrbComponent> _particleComponents = {};
  final Map<String, ItemComponent> _itemComponents = {};
  MinimapComponent? _minimap;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    camera.viewfinder.anchor = Anchor.center;
    await _startRound();
  }

  Future<void> _startRound() async {
    _playerDetectionRange = UpgradeLogic.detectionRangeFor(profile);
    _botManager = BotManager();
    _state = RoundSetup.build(
      roundNumber: roundNumber,
      profile: profile,
      settings: settings,
      botManager: _botManager,
    );
    final arenaSize = _state.arenaSize;
    final center = _state.playerSnake.head;
    final playerDir = _state.playerSnake.direction;

    await world.add(ArenaComponent(arenaSize: arenaSize));

    for (final snake in _state.snakes) {
      final comp = SnakeComponent(
        segments: snake.segments,
        bodyColor: SnakeComponent.bodyColorFor(snake),
        headColor: SnakeComponent.headColorFor(snake),
      );
      _snakeComponents[snake.id] = comp;
      world.add(comp);
    }

    for (final orb in _state.food) {
      final comp = FoodOrbComponent(orbId: orb.id, position: orb.position);
      _foodComponents[orb.id] = comp;
      world.add(comp);
    }

    camera.viewfinder.position = center;
    _playerTargetDir = playerDir;

    if (settings.showMinimap) {
      _minimap = MinimapComponent(getState: () => _state);
      await camera.viewport.add(_minimap!);
      _positionMinimap();
    }
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    _positionMinimap();
  }

  void _positionMinimap() {
    const pad = 12.0;
    _minimap?.position = Vector2(size.x - MinimapComponent.s - pad, pad);
  }

  // --- Game loop ---

  @override
  void update(double dt) {
    super.update(dt);
    if (_roundEnded) return;

    final result = GameTick.advance(
      _state,
      _playerTargetDir,
      dt.clamp(0.0, 0.05),
      _botManager,
      roundNumber,
      _playerDetectionRange,
    );

    _state = result.state;
    _handleEvents(result.events);
    _syncVisuals();
  }

  void _handleEvents(List<GameEvent> events) {
    for (final event in events) {
      switch (event) {
        case SnakeDiedEvent(:final deadSnakeId):
          _snakeComponents.remove(deadSnakeId)?.removeFromParent();

        case GoalMetEvent():
          goalMetNotifier.value = true;
          overlays.add('goalMet');

        case RoundOverEvent():
          _roundEnded = true;
          onRoundOver(event);

        default:
          break;
      }
    }

    _syncEntities();
  }

  void _syncEntities() {
    final foodStateIds = _state.food.map((f) => f.id).toSet();
    for (final id in _foodComponents.keys.toList()) {
      if (!foodStateIds.contains(id)) {
        _foodComponents.remove(id)?.removeFromParent();
      }
    }
    for (final orb in _state.food) {
      if (!_foodComponents.containsKey(orb.id)) {
        final comp = FoodOrbComponent(orbId: orb.id, position: orb.position);
        _foodComponents[orb.id] = comp;
        world.add(comp);
      }
    }

    final particleStateIds = _state.particles.map((p) => p.id).toSet();
    for (final id in _particleComponents.keys.toList()) {
      if (!particleStateIds.contains(id)) {
        _particleComponents.remove(id)?.removeFromParent();
      }
    }
    for (final p in _state.particles) {
      if (!_particleComponents.containsKey(p.id)) {
        final comp = ParticleOrbComponent(
          particleId: p.id,
          position: p.position,
        );
        _particleComponents[p.id] = comp;
        world.add(comp);
      }
    }

    final itemStateIds = _state.items.map((i) => i.id).toSet();
    for (final id in _itemComponents.keys.toList()) {
      if (!itemStateIds.contains(id)) {
        _itemComponents.remove(id)?.removeFromParent();
      }
    }
    for (final item in _state.items) {
      if (!_itemComponents.containsKey(item.id)) {
        final comp = ItemComponent(
          itemId: item.id,
          itemType: item.type,
          position: item.position,
        );
        _itemComponents[item.id] = comp;
        world.add(comp);
      }
    }
  }

  void _syncVisuals() {
    if (_state.playerAlive) {
      camera.viewfinder.position = _state.playerSnake.head;
    }

    for (final snake in _state.snakes) {
      if (snake.alive) _snakeComponents[snake.id]?.syncState(snake);
    }

    for (final orb in _state.food) {
      _foodComponents[orb.id]?.syncPosition(orb.position);
    }

    for (final p in _state.particles) {
      _particleComponents[p.id]?.syncState(p.position, p.lifetime);
    }

    final player = _state.playerSnake;
    scoreNotifier.value = player.length;
    aliveBotCountNotifier.value = _state.botSnakes.where((s) => s.alive).length;
    boostTimerNotifier.value = player.boostTimer;
    magnetTimerNotifier.value = player.magnetTimer;
  }

  // --- Input ---

  @override
  void onTapDown(TapDownEvent event) {
    _updateDirection(event.localPosition);
  }

  Vector2 _lastDragPos = Vector2.zero();

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    _lastDragPos = event.localPosition.clone();
    _updateDirection(_lastDragPos);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    _lastDragPos += event.localDelta;
    _updateDirection(_lastDragPos);
  }

  // Screen center = player position (camera follows). Direction is the vector
  // from center to touch point — no world-space conversion needed.
  void _updateDirection(Vector2 screenPos) {
    final dir = screenPos - size / 2;
    if (dir.length2 > 400) {
      _playerTargetDir = dir.normalized();
    }
  }

  @override
  void onRemove() {
    scoreNotifier.dispose();
    aliveBotCountNotifier.dispose();
    boostTimerNotifier.dispose();
    magnetTimerNotifier.dispose();
    goalMetNotifier.dispose();
    super.onRemove();
  }
}

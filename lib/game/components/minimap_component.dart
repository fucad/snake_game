import 'dart:ui';
import 'package:flame/components.dart';
import 'package:snake_game/game/logic/arena_state.dart';
import 'package:snake_game/game/logic/snake_state.dart';
import 'package:snake_game/ui/theme/app_colors.dart';
import 'package:snake_game/ui/theme/app_dimensions.dart';

// Added to camera.viewport — renders in screen (HUD) space.
// SnakeGame positions this after knowing screen size.
class MinimapComponent extends PositionComponent {
  final ArenaState Function() getState;

  static const double s = AppDimensions.minimapSize;

  MinimapComponent({required this.getState}) : super(size: Vector2.all(s));

  @override
  void render(Canvas canvas) {
    final state = getState();

    canvas.save();
    canvas.clipRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(0, 0, s, s),
        const Radius.circular(6),
      ),
    );

    // Background
    canvas.drawRect(
      const Rect.fromLTWH(0, 0, s, s),
      Paint()..color = const Color(0xBB0D1117),
    );

    final scale = s / state.arenaSize;

    // Food dots
    final foodPaint = Paint()..color = AppColors.foodOrb.withValues(alpha: 0.4);
    for (final orb in state.food) {
      final p = orb.position * scale;
      canvas.drawCircle(Offset(p.x, p.y), 1, foodPaint);
    }

    // Snakes
    for (final snake in state.aliveSnakes) {
      final head = snake.head * scale;
      final isPlayer = snake.owner == SnakeOwner.player;
      final color = isPlayer
          ? AppColors.playerSnake
          : AppColors.botSnakeColors[snake.colorIndex.clamp(
              0,
              AppColors.botSnakeColors.length - 1,
            )];

      if (isPlayer) {
        canvas.drawCircle(
          Offset(head.x, head.y),
          5,
          Paint()
            ..color = color.withValues(alpha: 0.4)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
        );
      }
      canvas.drawCircle(
        Offset(head.x, head.y),
        isPlayer ? 3.5 : 2.0,
        Paint()..color = color,
      );
    }

    canvas.restore();

    // Border on top of content
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(0, 0, s, s),
        const Radius.circular(6),
      ),
      Paint()
        ..color = AppColors.border
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
  }
}

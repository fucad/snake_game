import 'dart:ui';
import 'package:flame/components.dart';
import 'package:snake_game/game/logic/snake_state.dart';
import 'package:snake_game/ui/theme/app_colors.dart';
import 'package:snake_game/ui/theme/app_dimensions.dart';

class SnakeComponent extends PositionComponent {
  List<Vector2> _segments;
  final Color _bodyColor;
  final Color _headColor;
  bool _boostActive = false;
  bool _magnetActive = false;

  SnakeComponent({
    required List<Vector2> segments,
    required this._bodyColor,
    required this._headColor,
  }) : _segments = List.of(segments),
       super(position: segments.first.clone());

  void syncState(SnakeState state) {
    _segments = List.of(state.segments);
    position = state.head.clone();
    _boostActive = state.boostActive;
    _magnetActive = state.magnetActive;
  }

  static Color bodyColorFor(SnakeState state) {
    if (state.owner == SnakeOwner.player) return AppColors.playerSnake;
    return AppColors.botSnakeColors[state.colorIndex.clamp(
      0,
      AppColors.botSnakeColors.length - 1,
    )];
  }

  static Color headColorFor(SnakeState state) {
    if (state.owner == SnakeOwner.player) return AppColors.playerSnakeHead;
    return AppColors.botSnakeColors[state.colorIndex.clamp(
      0,
      AppColors.botSnakeColors.length - 1,
    )];
  }

  @override
  void render(Canvas canvas) {
    if (_segments.isEmpty) return;
    final head = _segments.first;

    // Boost trail glow (behind everything)
    if (_boostActive) {
      final trailPaint = Paint()
        ..style = PaintingStyle.fill
        ..color = _headColor.withValues(alpha: 0.15)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 14);
      for (int i = 0; i < _segments.length && i < 8; i++) {
        final local = _segments[i] - head;
        canvas.drawCircle(
          Offset(local.x, local.y),
          AppDimensions.snakeSegmentRadius + 4,
          trailPaint,
        );
      }
    }

    // Magnet aura
    if (_magnetActive) {
      canvas.drawCircle(
        Offset.zero,
        AppDimensions.snakeSegmentRadius + 10,
        Paint()
          ..style = PaintingStyle.fill
          ..color = AppColors.magnetItem.withValues(alpha: 0.22)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 16),
      );
    }

    // Body: tail → head so head renders on top
    for (int i = _segments.length - 1; i >= 0; i--) {
      final local = _segments[i] - head;
      final isHead = i == 0;
      final r = isHead
          ? AppDimensions.snakeSegmentRadius + 2.0
          : AppDimensions.snakeSegmentRadius;
      canvas.drawCircle(
        Offset(local.x, local.y),
        r,
        Paint()
          ..style = PaintingStyle.fill
          ..color = isHead ? _headColor : _bodyColor,
      );
    }

    // Eyes on head
    _drawEyes(canvas);
  }

  void _drawEyes(Canvas canvas) {
    final white = Paint()
      ..color = const Color(0xFFFFFFFF)
      ..style = PaintingStyle.fill;
    final dark = Paint()
      ..color = const Color(0xFF0A0D14)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(const Offset(-4, -4), 2.8, white);
    canvas.drawCircle(const Offset(4, -4), 2.8, white);
    canvas.drawCircle(const Offset(-3.5, -3.5), 1.5, dark);
    canvas.drawCircle(const Offset(4.5, -3.5), 1.5, dark);
  }
}

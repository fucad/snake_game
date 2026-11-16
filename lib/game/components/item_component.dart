import 'dart:math' as math;
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:snake_game/game/logic/arena_item.dart';
import 'package:snake_game/ui/theme/app_colors.dart';
import 'package:snake_game/ui/theme/app_dimensions.dart';

class ItemComponent extends PositionComponent {
  final String itemId;
  final ItemType itemType;
  double _time = 0;

  ItemComponent({
    required this.itemId,
    required this.itemType,
    required Vector2 position,
  }) : super(position: position.clone());

  Color get _color =>
      itemType == ItemType.boost ? AppColors.boostItem : AppColors.magnetItem;

  @override
  void update(double dt) {
    _time += dt;
  }

  @override
  void render(Canvas canvas) {
    final pulse = 1.0 + 0.1 * math.sin(_time * 2.2);
    final r = AppDimensions.itemRadius * pulse;

    // Outer aura
    canvas.drawCircle(
      Offset.zero,
      r * 2.6,
      Paint()
        ..color = _color.withValues(alpha: 0.18)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18),
    );

    // Mid glow ring
    canvas.drawCircle(
      Offset.zero,
      r * 1.5,
      Paint()
        ..color = _color.withValues(alpha: 0.25)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );

    // Main filled circle
    canvas.drawCircle(Offset.zero, r, Paint()..color = _color);

    if (itemType == ItemType.boost) {
      _drawBolt(canvas, r);
    } else {
      _drawMagnetArc(canvas, r);
    }
  }

  void _drawBolt(Canvas canvas, double r) {
    final path = Path()
      ..moveTo(2, -r * 0.55)
      ..lineTo(-3, 0)
      ..lineTo(1, 0)
      ..lineTo(-2, r * 0.55)
      ..lineTo(3, -0.1)
      ..lineTo(-1, -0.1)
      ..close();
    canvas.drawPath(path, Paint()..color = const Color(0xCCFFFFFF));
  }

  void _drawMagnetArc(Canvas canvas, double r) {
    final paint = Paint()
      ..color = const Color(0xCCFFFFFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: Offset.zero, radius: r * 0.45),
      math.pi,
      math.pi,
      false,
      paint,
    );
    canvas.drawLine(Offset(-r * 0.45, 0), Offset(-r * 0.45, r * 0.28), paint);
    canvas.drawLine(Offset(r * 0.45, 0), Offset(r * 0.45, r * 0.28), paint);
  }
}

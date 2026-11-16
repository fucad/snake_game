import 'dart:ui';
import 'package:flame/components.dart';
import 'package:snake_game/ui/theme/app_colors.dart';

class ArenaComponent extends PositionComponent {
  final double arenaSize;

  ArenaComponent({required this.arenaSize}) : super(position: Vector2.zero());

  @override
  void render(Canvas canvas) {
    // Background fill
    canvas.drawRect(
      Rect.fromLTWH(0, 0, arenaSize, arenaSize),
      Paint()..color = AppColors.arenaBg,
    );

    // Subtle grid every 200 world units
    final gridPaint = Paint()
      ..color = const Color(0xFF141921)
      ..strokeWidth = 1;
    for (double x = 0; x <= arenaSize; x += 200) {
      canvas.drawLine(Offset(x, 0), Offset(x, arenaSize), gridPaint);
    }
    for (double y = 0; y <= arenaSize; y += 200) {
      canvas.drawLine(Offset(0, y), Offset(arenaSize, y), gridPaint);
    }

    // Thick outer border band
    canvas.drawRect(
      Rect.fromLTWH(0, 0, arenaSize, arenaSize),
      Paint()
        ..color = const Color(0xFF0A0D14)
        ..strokeWidth = 40
        ..style = PaintingStyle.stroke,
    );

    // Soft coral inner-edge glow
    canvas.drawRect(
      Rect.fromLTWH(2, 2, arenaSize - 4, arenaSize - 4),
      Paint()
        ..color = AppColors.primary.withValues(alpha: 0.18)
        ..strokeWidth = 4
        ..style = PaintingStyle.stroke
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
    );

    // Hard border line
    canvas.drawRect(
      Rect.fromLTWH(0, 0, arenaSize, arenaSize),
      Paint()
        ..color = AppColors.arenaBorder
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke,
    );
  }
}

import 'dart:math' as math;
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:snake_game/ui/theme/app_colors.dart';
import 'package:snake_game/ui/theme/app_dimensions.dart';

class FoodOrbComponent extends PositionComponent {
  final String orbId;
  double _time = 0;

  FoodOrbComponent({required this.orbId, required Vector2 position})
    : super(position: position.clone());

  void syncPosition(Vector2 pos) {
    position = pos.clone();
  }

  @override
  void update(double dt) {
    _time += dt;
  }

  @override
  void render(Canvas canvas) {
    final pulse = 1.0 + 0.15 * math.sin(_time * 2.8);
    final r = AppDimensions.foodOrbRadius * pulse;

    // Glow halo
    canvas.drawCircle(
      Offset.zero,
      r * 2.4,
      Paint()
        ..color = AppColors.foodOrb.withValues(alpha: 0.22)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );

    // Core orb
    canvas.drawCircle(Offset.zero, r, Paint()..color = AppColors.foodOrb);

    // Specular highlight
    canvas.drawCircle(
      Offset(-r * 0.3, -r * 0.3),
      r * 0.3,
      Paint()..color = const Color(0x55FFFFFF),
    );
  }
}

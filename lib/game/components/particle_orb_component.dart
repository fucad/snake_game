import 'dart:ui';
import 'package:flame/components.dart';
import 'package:snake_game/balance/particle_config.dart';
import 'package:snake_game/ui/theme/app_colors.dart';
import 'package:snake_game/ui/theme/app_dimensions.dart';

class ParticleOrbComponent extends PositionComponent {
  final String particleId;
  double _lifetimeFraction = 1.0;

  ParticleOrbComponent({required this.particleId, required Vector2 position})
    : super(position: position.clone());

  void syncState(Vector2 newPosition, double remainingLifetime) {
    position = newPosition.clone();
    _lifetimeFraction = (remainingLifetime / ParticleConfig.particleLifetime)
        .clamp(0.0, 1.0);
  }

  @override
  void render(Canvas canvas) {
    final alpha = (_lifetimeFraction * 0.88).clamp(0.0, 1.0);

    // Glow
    canvas.drawCircle(
      Offset.zero,
      AppDimensions.particleOrbRadius * 2.2,
      Paint()
        ..color = AppColors.deathParticle.withValues(alpha: alpha * 0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
    );

    // Core
    canvas.drawCircle(
      Offset.zero,
      AppDimensions.particleOrbRadius,
      Paint()..color = AppColors.deathParticle.withValues(alpha: alpha),
    );
  }
}

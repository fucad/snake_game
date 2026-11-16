import 'dart:math' as math;
import 'package:vector_math/vector_math.dart' show Vector2;
import 'package:snake_game/balance/particle_config.dart';
import 'package:snake_game/game/logic/particle_orb.dart';
import 'package:snake_game/game/logic/snake_state.dart';

// Handles snake death and converting the body to particles.
class DeathLogic {
  DeathLogic._();

  static final _rng = math.Random();

  // Converts [snake]'s body into a list of ParticleOrbs.
  static List<ParticleOrb> toParticles(SnakeState snake) {
    final particles = <ParticleOrb>[];
    for (int i = 0; i < snake.segments.length; i++) {
      final segment = snake.segments[i];
      for (int p = 0; p < ParticleConfig.particlesPerSegment; p++) {
        final angle = _rng.nextDouble() * math.pi * 2;
        final speed = _rng.nextDouble() * ParticleConfig.particleDriftSpeed;
        particles.add(
          ParticleOrb(
            id: '${snake.id}_p${i}_$p',
            position: _scatter(segment),
            velocity: Vector2(math.cos(angle) * speed, math.sin(angle) * speed),
            lifetime: ParticleConfig.particleLifetime,
          ),
        );
      }
    }
    return particles;
  }

  static Vector2 _scatter(Vector2 origin) {
    final r = _rng.nextDouble() * ParticleConfig.particleScatterRadius;
    final a = _rng.nextDouble() * math.pi * 2;
    return origin + Vector2(math.cos(a) * r, math.sin(a) * r);
  }
}

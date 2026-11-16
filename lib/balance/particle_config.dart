// Controls death particle behaviour.
// Particles are the orbs left behind when a snake dies.
class ParticleConfig {
  ParticleConfig._();

  // How many particles spawn per body segment on death
  static const int particlesPerSegment = 1;

  // How many particles must be eaten to gain 1 snake segment
  static const int particlesPerSegmentGain = 3;

  // How long particles persist before fading out (seconds)
  static const double particleLifetime = 25;

  // Random scatter applied to each particle on spawn (world units)
  static const double particleScatterRadius = 50;

  // Particle drift speed after spawn (slow float)
  static const double particleDriftSpeed = 8;
}

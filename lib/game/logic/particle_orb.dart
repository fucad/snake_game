import 'package:vector_math/vector_math.dart' show Vector2;

class ParticleOrb {
  final String id;
  final Vector2 position;
  final Vector2 velocity;
  final double lifetime; // remaining seconds
  final int value; // segments gained (requires N to gain 1)

  const ParticleOrb({
    required this.id,
    required this.position,
    required this.velocity,
    required this.lifetime,
    this.value = 1,
  });

  ParticleOrb tick(double dt) => ParticleOrb(
    id: id,
    position: position + velocity * dt,
    velocity: velocity,
    lifetime: lifetime - dt,
    value: value,
  );

  bool get expired => lifetime <= 0;
}

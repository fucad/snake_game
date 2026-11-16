import 'package:vector_math/vector_math.dart' show Vector2;

enum SnakeOwner { player, bot }

class SnakeState {
  final String id;
  final SnakeOwner owner;
  final List<Vector2> segments; // index 0 = head
  final Vector2 direction; // normalised
  final double speed;
  final bool alive;
  final bool boostActive;
  final bool magnetActive;
  final double boostTimer;
  final double magnetTimer;
  final int score;
  // Tracks partial particle gains. When this reaches ParticleConfig.particlesPerSegmentGain
  // the snake gains 1 segment and the buffer decrements by the threshold.
  final int particleBuffer;
  // Index into AppColors.botSnakeColors; 0 for the player snake.
  final int colorIndex;

  const SnakeState({
    required this.id,
    required this.owner,
    required this.segments,
    required this.direction,
    required this.speed,
    this.alive = true,
    this.boostActive = false,
    this.magnetActive = false,
    this.boostTimer = 0,
    this.magnetTimer = 0,
    this.score = 0,
    this.particleBuffer = 0,
    this.colorIndex = 0,
  });

  int get length => segments.length;
  Vector2 get head => segments.first;

  SnakeState copyWith({
    List<Vector2>? segments,
    Vector2? direction,
    double? speed,
    bool? alive,
    bool? boostActive,
    bool? magnetActive,
    double? boostTimer,
    double? magnetTimer,
    int? score,
    int? particleBuffer,
    int? colorIndex,
  }) {
    return SnakeState(
      id: id,
      owner: owner,
      segments: segments ?? this.segments,
      direction: direction ?? this.direction,
      speed: speed ?? this.speed,
      alive: alive ?? this.alive,
      boostActive: boostActive ?? this.boostActive,
      magnetActive: magnetActive ?? this.magnetActive,
      boostTimer: boostTimer ?? this.boostTimer,
      magnetTimer: magnetTimer ?? this.magnetTimer,
      score: score ?? this.score,
      particleBuffer: particleBuffer ?? this.particleBuffer,
      colorIndex: colorIndex ?? this.colorIndex,
    );
  }
}

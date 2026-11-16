import 'package:vector_math/vector_math.dart' show Vector2;

enum ItemType { boost, magnet }

class ArenaItem {
  final String id;
  final ItemType type;
  final Vector2 position;
  final double lifetime; // remaining seconds before auto-despawn

  const ArenaItem({
    required this.id,
    required this.type,
    required this.position,
    required this.lifetime,
  });

  ArenaItem tick(double dt) => ArenaItem(
    id: id,
    type: type,
    position: position,
    lifetime: lifetime - dt,
  );

  bool get expired => lifetime <= 0;
}

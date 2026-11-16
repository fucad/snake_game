import 'package:vector_math/vector_math.dart' show Vector2;

class FoodOrb {
  final String id;
  final Vector2 position;
  final int value; // segments gained when eaten

  const FoodOrb({required this.id, required this.position, this.value = 1});
}

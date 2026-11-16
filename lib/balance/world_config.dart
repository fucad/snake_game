// Controls arena size and food density.
// Edit these values to tune how the world feels — no game logic changes needed.
class WorldConfig {
  WorldConfig._();

  // Arena dimensions (square). Units are game-world units, not pixels.
  static const double baseArenaSize = 2000;
  static const double sizeStepPerRound = 150;
  static const double minArenaSize = 2000;
  static const double maxArenaSize = 5000;

  // Food orbs
  static const double foodAreaPerOrb = 200000; // 1 orb per N square units
  static const int minFood = 20;
  static const int maxFood = 80;

  // Distance between consecutive body segments (world units). Movement
  // keeps this spacing exactly, so snake length is frame-rate independent.
  static const double segmentSpacing = 8;

  // Arena border padding — snakes cannot pass within this distance of the edge
  static const double borderThickness = 40;
}

// Controls item spawn rates and effect durations.
// Items (Boost, Magnet) do not scale with rounds — they remain constant.
class ItemConfig {
  ItemConfig._();

  // Spawn intervals in seconds (timer resets after pickup or expiry)
  static const double boostSpawnInterval = 18;
  static const double magnetSpawnInterval = 24;

  // Maximum simultaneous items of each type on the field
  static const int maxBoostItems = 1;
  static const int maxMagnetItems = 1;

  // How long an uncollected item stays on the field before despawning
  static const double itemLifetime = 20;

  // Minimum distance from the player snake head when spawning an item
  static const double minSpawnDistanceFromPlayer = 300;

  // Effect durations in seconds
  static const double boostDuration = 5;
  static const double magnetDuration = 7;

  // Boost speed multiplier (applied on top of player's current upgrade speed)
  static const double boostSpeedMultiplier = 1.8;

  // Magnet pull force in world units per second²
  static const double magnetPullForce = 400;
}

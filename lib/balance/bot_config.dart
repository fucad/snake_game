// Controls bot count and difficulty mix per round.
// Edit these values to tune AI opponent pressure.
class BotConfig {
  BotConfig._();

  static const int baseBots = 3;
  static const int botStepRounds = 2; // +1 bot every N rounds
  static const int minBots = 3;
  static const int maxBots = 12;

  // Base speed of bot snakes in game-world units per second.
  // Bots do not scale in speed — only count and difficulty changes.
  static const double botBaseSpeed = 110;

  // Difficulty mix per round — [easy, normal, hard] counts.
  // Index = round number - 1. Rounds beyond this list use the last entry.
  static const List<List<int>> difficultyMix = [
    [3, 0, 0], // round 1
    [3, 0, 0], // round 2
    [3, 1, 0], // round 3
    [2, 2, 0], // round 4
    [1, 3, 1], // round 5
    [1, 2, 2], // round 6
    [0, 4, 2], // round 7
    [0, 3, 3], // round 8
    [0, 2, 5], // round 9
    [0, 1, 6], // round 10
    [0, 0, 8], // round 11
    [0, 0, 8], // round 12 (all hard from here)
  ];

  // Bot AI detection radius in world units
  static const double easyDetectionRadius = 0; // no awareness
  static const double normalDetectionRadius = 200;
  static const double hardDetectionRadius = 350;

  // Minimum gap between a bot spawn point and the player
  static const double botMinSpawnDistanceFromPlayer = 400;
}

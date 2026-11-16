// Controls round goals, XP rewards, and stage labels.
// Edit goal/XP values to rebalance progression difficulty.
class RoundConfig {
  RoundConfig._();

  // Round goal: target snake length in segments
  static const int baseGoal = 20;
  static const int goalStepPerRound = 18;

  // XP rewards
  static const int baseXpOnGoalMet = 25;
  static const double xpGoalScaleFactor = 1.2; // multiplied each round
  static const int baseXpOnGoalFailed = 10;
  static const double xpFailedScaleFactor = 1.2;
  static const int xpPerKill = 8;
  static const int minPartialXp = 5; // minimum XP even on very bad run

  // Endless scaling (rounds beyond the defined list)
  static const double endlessXpMultiplierPerRound = 1.2;
  static const int endlessGoalStep = 18; // same as base — linear forever

  // Stage definitions — [startRound, endRound, label, description]
  static const List<StageDefinition> stages = [
    StageDefinition(1, 3, 'Hatchling', 'Gentle introduction'),
    StageDefinition(4, 7, 'Crawler', 'First real opponents'),
    StageDefinition(8, 12, 'Predator', 'Hard bots enter the arena'),
    StageDefinition(13, 20, 'Apex', 'Full pressure — arena at max'),
    StageDefinition(21, null, 'Endless', 'Survive as long as you can'),
  ];
}

/// One progression stage: rounds [startRound, endRound] share a label.
class StageDefinition {
  final int startRound;
  final int? endRound; // null = open-ended
  final String label;
  final String description;

  const StageDefinition(
    this.startRound,
    this.endRound,
    this.label,
    this.description,
  );
}

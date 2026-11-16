// Controls upgrade tiers, XP costs, and stat values.
// Edit tier values to rebalance progression feel.
// Each upgrade has exactly 5 tiers beyond the base (index 0 = base, no cost).
class UpgradeConfig {
  UpgradeConfig._();

  // Speed upgrade — in game-world units per second
  static const List<double> speedValues = [120, 132, 148, 166, 186, 204];
  static const List<int> speedCosts = [
    0,
    20,
    35,
    55,
    80,
    110,
  ]; // index 0 = base (free)

  // Detection range upgrade — radius in world units
  // Affects: magnet pull distance, proximity warning UI
  static const List<double> detectionRangeValues = [
    100,
    130,
    165,
    205,
    250,
    300,
  ];
  static const List<int> detectionRangeCosts = [0, 20, 35, 55, 80, 110];

  // Starting size upgrade — snake segments at round start
  static const List<int> startingSizeValues = [10, 14, 19, 25, 31, 38];
  static const List<int> startingSizeCosts = [0, 25, 40, 65, 95, 130];

  static const int maxTier = 5;
}

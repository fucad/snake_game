import 'package:snake_game/balance/upgrade_config.dart';
import 'package:snake_game/progression/player_profile.dart';
import 'package:snake_game/progression/upgrade_type.dart';

class UpgradeLogic {
  UpgradeLogic._();

  static bool canUpgrade(PlayerProfile profile, UpgradeType type) {
    final tier = profile.tierFor(type);
    if (tier >= UpgradeConfig.maxTier) return false;
    final cost = _costFor(type, tier + 1);
    return profile.totalXp >= cost;
  }

  static PlayerProfile applyUpgrade(PlayerProfile profile, UpgradeType type) {
    assert(canUpgrade(profile, type));
    final tier = profile.tierFor(type);
    final cost = _costFor(type, tier + 1);
    final newTiers = Map<UpgradeType, int>.of(profile.upgradeTiers);
    newTiers[type] = tier + 1;
    return profile.copyWith(
      totalXp: profile.totalXp - cost,
      upgradeTiers: newTiers,
    );
  }

  static double speedFor(PlayerProfile profile) {
    final tier = profile.tierFor(UpgradeType.speed);
    return UpgradeConfig.speedValues[tier];
  }

  static double detectionRangeFor(PlayerProfile profile) {
    final tier = profile.tierFor(UpgradeType.detectionRange);
    return UpgradeConfig.detectionRangeValues[tier];
  }

  static int startingSizeFor(PlayerProfile profile) {
    final tier = profile.tierFor(UpgradeType.startingSize);
    return UpgradeConfig.startingSizeValues[tier];
  }

  static int _costFor(UpgradeType type, int targetTier) => switch (type) {
    UpgradeType.speed => UpgradeConfig.speedCosts[targetTier],
    UpgradeType.detectionRange => UpgradeConfig.detectionRangeCosts[targetTier],
    UpgradeType.startingSize => UpgradeConfig.startingSizeCosts[targetTier],
  };
}

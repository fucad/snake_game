import 'package:snake_game/progression/upgrade_type.dart';

class PlayerProfile {
  final int currentRound;
  final int totalXp;
  final Map<UpgradeType, int>
  upgradeTiers; // 0 = base, max = UpgradeConfig.maxTier
  final int highScore; // best single-round length achieved
  final int totalKills;

  const PlayerProfile({
    this.currentRound = 1,
    this.totalXp = 0,
    this.upgradeTiers = const {
      UpgradeType.speed: 0,
      UpgradeType.detectionRange: 0,
      UpgradeType.startingSize: 0,
    },
    this.highScore = 0,
    this.totalKills = 0,
  });

  int tierFor(UpgradeType type) => upgradeTiers[type] ?? 0;

  PlayerProfile copyWith({
    int? currentRound,
    int? totalXp,
    Map<UpgradeType, int>? upgradeTiers,
    int? highScore,
    int? totalKills,
  }) {
    return PlayerProfile(
      currentRound: currentRound ?? this.currentRound,
      totalXp: totalXp ?? this.totalXp,
      upgradeTiers: upgradeTiers ?? this.upgradeTiers,
      highScore: highScore ?? this.highScore,
      totalKills: totalKills ?? this.totalKills,
    );
  }
}

import 'package:flutter_test/flutter_test.dart';
import 'package:snake_game/balance/upgrade_config.dart';
import 'package:snake_game/progression/player_profile.dart';
import 'package:snake_game/progression/upgrade_logic.dart';
import 'package:snake_game/progression/upgrade_type.dart';

PlayerProfile _profile({int xp = 200, int speedTier = 0}) {
  return PlayerProfile(
    totalXp: xp,
    upgradeTiers: {
      UpgradeType.speed: speedTier,
      UpgradeType.detectionRange: 0,
      UpgradeType.startingSize: 0,
    },
  );
}

void main() {
  group('UpgradeLogic.canUpgrade', () {
    test('can upgrade when affordable', () {
      final p = _profile(xp: 200);
      expect(UpgradeLogic.canUpgrade(p, UpgradeType.speed), true);
    });

    test('cannot upgrade when too expensive', () {
      final p = _profile(xp: 5);
      expect(UpgradeLogic.canUpgrade(p, UpgradeType.speed), false);
    });

    test('cannot upgrade at max tier', () {
      final p = _profile(xp: 9999, speedTier: UpgradeConfig.maxTier);
      expect(UpgradeLogic.canUpgrade(p, UpgradeType.speed), false);
    });
  });

  group('UpgradeLogic.applyUpgrade', () {
    test('tier increments after upgrade', () {
      final p = _profile(xp: 200);
      final upgraded = UpgradeLogic.applyUpgrade(p, UpgradeType.speed);
      expect(upgraded.tierFor(UpgradeType.speed), 1);
    });

    test('XP is deducted', () {
      final p = _profile(xp: 200);
      final upgraded = UpgradeLogic.applyUpgrade(p, UpgradeType.speed);
      expect(upgraded.totalXp, lessThan(200));
    });

    test('other tiers are unchanged', () {
      final p = _profile(xp: 200);
      final upgraded = UpgradeLogic.applyUpgrade(p, UpgradeType.speed);
      expect(upgraded.tierFor(UpgradeType.detectionRange), 0);
      expect(upgraded.tierFor(UpgradeType.startingSize), 0);
    });
  });

  group('UpgradeLogic stat values', () {
    test('speedFor returns tier 0 base value', () {
      expect(
        UpgradeLogic.speedFor(_profile(speedTier: 0)),
        UpgradeConfig.speedValues[0],
      );
    });

    test('startingSizeFor returns tier 0 base', () {
      expect(
        UpgradeLogic.startingSizeFor(_profile()),
        UpgradeConfig.startingSizeValues[0],
      );
    });
  });
}

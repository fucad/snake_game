import 'package:flutter/material.dart';
import 'package:snake_game/balance/upgrade_config.dart';
import 'package:snake_game/progression/persistence_service.dart';
import 'package:snake_game/progression/player_profile.dart';
import 'package:snake_game/progression/upgrade_logic.dart';
import 'package:snake_game/progression/upgrade_type.dart';
import 'package:snake_game/ui/theme/app_colors.dart';
import 'package:snake_game/ui/theme/app_dimensions.dart';
import 'package:snake_game/ui/theme/app_text_styles.dart';
import 'package:snake_game/ui/widgets/upgrade_card_widget.dart';

class UpgradeScreen extends StatefulWidget {
  final PlayerProfile profile;

  const UpgradeScreen({super.key, required this.profile});

  @override
  State<UpgradeScreen> createState() => _UpgradeScreenState();
}

class _UpgradeScreenState extends State<UpgradeScreen> {
  late PlayerProfile _profile;

  @override
  void initState() {
    super.initState();
    _profile = widget.profile;
  }

  Future<void> _upgrade(UpgradeType type) async {
    if (!UpgradeLogic.canUpgrade(_profile, type)) return;
    setState(() {
      _profile = UpgradeLogic.applyUpgrade(_profile, type);
    });
    await PersistenceService().save(_profile);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBg,
      appBar: AppBar(
        title: const Text('UPGRADES'),
        backgroundColor: AppColors.screenBg,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.screenPaddingH,
            vertical: AppDimensions.screenPaddingV,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // XP balance
              Container(
                padding: const EdgeInsets.all(AppDimensions.spaceMd),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      color: AppColors.xpBar,
                      size: AppDimensions.iconMd,
                    ),
                    const SizedBox(width: AppDimensions.spaceSm),
                    Text(
                      '${_profile.totalXp} XP available',
                      style: AppTextStyles.headingSmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppDimensions.spaceLg),

              // Upgrade cards
              for (final type in UpgradeType.values) ...[
                UpgradeCardWidget(
                  type: type,
                  currentTier: _profile.tierFor(type),
                  xpCost: _nextCostFor(type),
                  canAfford: UpgradeLogic.canUpgrade(_profile, type),
                  onUpgrade: () => _upgrade(type),
                ),
                const SizedBox(height: AppDimensions.spaceMd),
              ],
            ],
          ),
        ),
      ),
    );
  }

  int _nextCostFor(UpgradeType type) {
    final tier = _profile.tierFor(type);
    if (tier >= UpgradeConfig.maxTier) return 0;
    return switch (type) {
      UpgradeType.speed => UpgradeConfig.speedCosts[tier + 1],
      UpgradeType.detectionRange => UpgradeConfig.detectionRangeCosts[tier + 1],
      UpgradeType.startingSize => UpgradeConfig.startingSizeCosts[tier + 1],
    };
  }
}

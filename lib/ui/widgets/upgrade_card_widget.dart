import 'package:flutter/material.dart';
import 'package:snake_game/balance/upgrade_config.dart';
import 'package:snake_game/progression/upgrade_type.dart';
import 'package:snake_game/ui/theme/app_colors.dart';
import 'package:snake_game/ui/theme/app_dimensions.dart';
import 'package:snake_game/ui/theme/app_text_styles.dart';

class UpgradeCardWidget extends StatelessWidget {
  final UpgradeType type;
  final int currentTier;
  final int xpCost;
  final bool canAfford;
  final VoidCallback? onUpgrade;

  const UpgradeCardWidget({
    super.key,
    required this.type,
    required this.currentTier,
    required this.xpCost,
    required this.canAfford,
    this.onUpgrade,
  });

  bool get _maxed => currentTier >= UpgradeConfig.maxTier;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.cardPaddingH,
        vertical: AppDimensions.cardPaddingV,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(type.displayName, style: AppTextStyles.headingSmall),
                const SizedBox(height: AppDimensions.spaceXs),
                Text(type.description, style: AppTextStyles.bodySmall),
                const SizedBox(height: AppDimensions.spaceSm),
                _TierDots(
                  currentTier: currentTier,
                  maxTier: UpgradeConfig.maxTier,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppDimensions.spaceMd),
          // Upgrade button
          if (_maxed)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.spaceMd,
                vertical: AppDimensions.spaceSm,
              ),
              decoration: BoxDecoration(
                color: AppColors.secondary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
              ),
              child: Text(
                'MAX',
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.secondary,
                ),
              ),
            )
          else
            _UpgradeButton(
              xpCost: xpCost,
              canAfford: canAfford,
              onTap: onUpgrade,
            ),
        ],
      ),
    );
  }
}

class _TierDots extends StatelessWidget {
  final int currentTier;
  final int maxTier;

  const _TierDots({required this.currentTier, required this.maxTier});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(maxTier, (i) {
        final filled = i < currentTier;
        return Padding(
          padding: const EdgeInsets.only(right: 4),
          child: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: filled ? AppColors.primary : AppColors.border,
              shape: BoxShape.circle,
            ),
          ),
        );
      }),
    );
  }
}

class _UpgradeButton extends StatelessWidget {
  final int xpCost;
  final bool canAfford;
  final VoidCallback? onTap;

  const _UpgradeButton({
    required this.xpCost,
    required this.canAfford,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: canAfford ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spaceMd,
          vertical: AppDimensions.spaceSm,
        ),
        decoration: BoxDecoration(
          color: canAfford ? AppColors.primary : AppColors.border,
          borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        ),
        child: Column(
          children: [
            Text(
              'UPGRADE',
              style: AppTextStyles.labelMedium.copyWith(
                color: canAfford
                    ? AppColors.textPrimary
                    : AppColors.textDisabled,
              ),
            ),
            Text(
              '$xpCost XP',
              style: AppTextStyles.bodySmall.copyWith(
                color: canAfford
                    ? AppColors.textPrimary.withValues(alpha: 0.8)
                    : AppColors.textDisabled,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:snake_game/ui/theme/app_animations.dart';
import 'package:snake_game/ui/theme/app_colors.dart';
import 'package:snake_game/ui/theme/app_dimensions.dart';
import 'package:snake_game/ui/theme/app_text_styles.dart';

class XpBarWidget extends StatelessWidget {
  final int currentXp;
  final int gainedXp;

  const XpBarWidget({
    super.key,
    required this.currentXp,
    required this.gainedXp,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('TOTAL XP', style: AppTextStyles.labelMedium),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '$currentXp',
                    style: AppTextStyles.headingSmall,
                  ),
                  if (gainedXp > 0)
                    TextSpan(
                      text: '  +$gainedXp',
                      style: AppTextStyles.headingSmall.copyWith(
                        color: AppColors.secondary,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.spaceXs),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppDimensions.xpBarRadius),
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: gainedXp.toDouble()),
            duration: AppAnimations.xpBarFill,
            curve: AppAnimations.decelerate,
            builder: (context, animated, _) {
              final maxDisplay = (currentXp + gainedXp).toDouble().clamp(
                1,
                double.infinity,
              );
              final fillFraction =
                  ((currentXp - gainedXp + animated) / maxDisplay).clamp(
                    0.0,
                    1.0,
                  );
              return Stack(
                children: [
                  Container(
                    height: AppDimensions.xpBarHeight,
                    color: AppColors.xpBarBg,
                  ),
                  FractionallySizedBox(
                    widthFactor: fillFraction,
                    child: Container(
                      height: AppDimensions.xpBarHeight,
                      decoration: const BoxDecoration(color: AppColors.xpBar),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:snake_game/ui/theme/app_colors.dart';
import 'package:snake_game/ui/theme/app_dimensions.dart';
import 'package:snake_game/ui/theme/app_text_styles.dart';

class PauseOverlay extends StatelessWidget {
  final VoidCallback onResume;
  final VoidCallback onQuit;

  const PauseOverlay({super.key, required this.onResume, required this.onQuit});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.scrim,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.screenPaddingH * 1.5,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('PAUSED', style: AppTextStyles.headingLarge),
              const SizedBox(height: AppDimensions.spaceXl),
              ElevatedButton(onPressed: onResume, child: const Text('RESUME')),
              const SizedBox(height: AppDimensions.spaceMd),
              OutlinedButton(
                onPressed: onQuit,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textSecondary,
                  side: const BorderSide(color: AppColors.border),
                  minimumSize: const Size(
                    double.infinity,
                    AppDimensions.buttonHeightLarge,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                  ),
                ),
                child: const Text('QUIT'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

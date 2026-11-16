import 'package:flutter/material.dart';
import 'package:snake_game/ui/theme/app_colors.dart';
import 'package:snake_game/ui/theme/app_dimensions.dart';
import 'package:snake_game/ui/theme/app_text_styles.dart';

class HowToPlayScreen extends StatelessWidget {
  const HowToPlayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBg,
      appBar: AppBar(
        title: const Text('HOW TO PLAY'),
        backgroundColor: AppColors.screenBg,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.screenPaddingH,
            vertical: AppDimensions.screenPaddingV,
          ),
          children: const [
            _Rule(
              emoji: '👆',
              title: 'Controls',
              body:
                  'Touch and drag anywhere on screen. Your snake steers toward your finger.',
            ),
            _Rule(
              emoji: '🟡',
              title: 'Food Orbs',
              body:
                  'Collect yellow orbs to grow. Reach the segment goal to complete the round.',
            ),
            _Rule(
              emoji: '💀',
              title: 'Death',
              body:
                  'Your head cannot hit another snake\'s body. In a head-on collision, the shorter snake dies.',
            ),
            _Rule(
              emoji: '🔵',
              title: 'Boost',
              body:
                  'Pick up the blue Boost item to sprint at 1.8× speed for 5 seconds.',
            ),
            _Rule(
              emoji: '🟣',
              title: 'Magnet',
              body:
                  'Pick up the purple Magnet item to attract nearby food orbs for 7 seconds.',
            ),
            _Rule(
              emoji: '💥',
              title: 'Death Particles',
              body:
                  'When a snake dies it leaves orange particles. Collect 3 particles to gain 1 segment.',
            ),
            _Rule(
              emoji: '⭐',
              title: 'XP & Upgrades',
              body:
                  'Earn XP each round. Spend it on Speed, Detection, or Starting Size upgrades between rounds.',
            ),
          ],
        ),
      ),
    );
  }
}

class _Rule extends StatelessWidget {
  final String emoji;
  final String title;
  final String body;

  const _Rule({required this.emoji, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.spaceLg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(width: AppDimensions.spaceMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.headingSmall),
                const SizedBox(height: AppDimensions.spaceXs),
                Text(body, style: AppTextStyles.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

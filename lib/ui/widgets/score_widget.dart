import 'package:flutter/material.dart';
import 'package:snake_game/ui/theme/app_text_styles.dart';

// Minimal in-game score display.
class ScoreWidget extends StatelessWidget {
  final int score;
  const ScoreWidget({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    return Text('$score', style: AppTextStyles.hudScore);
  }
}

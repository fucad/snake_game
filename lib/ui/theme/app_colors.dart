import 'package:flutter/material.dart';

// Dunk Shot-inspired palette: dark arena, soft surfaces, rounded feel.
// One warm accent (coral) + one cool accent (mint) for contrast.
class AppColors {
  AppColors._();

  // --- Backgrounds ---
  static const Color arenaBg = Color(0xFF0D1117); // near-black, game field
  static const Color screenBg = Color(0xFF13151F); // slightly lighter, menu bg
  static const Color surface = Color(0xFF1E2130); // cards, panels
  static const Color surfaceElevated = Color(
    0xFF262A3D,
  ); // elevated cards, dialogs

  // --- Borders & dividers ---
  static const Color border = Color(0xFF2E3347);
  static const Color divider = Color(0xFF1E2130);

  // --- Accent ---
  static const Color primary = Color(0xFFFF6B6B); // coral — CTAs, highlights
  static const Color primaryLight = Color(0xFFFF8E8E);
  static const Color secondary = Color(0xFF64FFDA); // mint — secondary actions

  // --- Text ---
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF9BA3B8);
  static const Color textDisabled = Color(0xFF4A5068);

  // --- Game entities ---
  static const Color playerSnake = Color(0xFF6BFF8A); // vibrant green
  static const Color playerSnakeHead = Color(0xFF00E676);
  static const Color foodOrb = Color(0xFFFFD166); // warm yellow
  static const Color deathParticle = Color(0xFFFF9800); // orange — death glow
  static const Color boostItem = Color(0xFF4FC3F7); // electric blue
  static const Color magnetItem = Color(0xFFCE93D8); // soft purple
  static const Color arenaBorder = Color(0xFF2E3347);

  // Bot snake colours — distinct from player and each other
  static const List<Color> botSnakeColors = [
    Color(0xFFFF5252), // red
    Color(0xFFFFAB40), // amber
    Color(0xFF69F0AE), // light green
    Color(0xFF40C4FF), // light blue
    Color(0xFFEA80FC), // purple
    Color(0xFFFF6D00), // deep orange
    Color(0xFF1DE9B6), // teal
    Color(0xFFF06292), // pink
    Color(0xFFB2FF59), // lime
    Color(0xFF80D8FF), // sky blue
    Color(0xFFFFFF00), // yellow
    Color(0xFFE040FB), // violet
  ];

  // --- UI feedback ---
  static const Color success = Color(0xFF6BFF8A);
  static const Color warning = Color(0xFFFFD166);
  static const Color error = Color(0xFFFF6B6B);

  // --- XP / progression ---
  static const Color xpBar = Color(0xFF6C63FF); // purple XP fill
  static const Color xpBarBg = Color(0xFF2E3347);

  // --- Overlay ---
  static const Color scrim = Color(0xCC0D1117); // 80% opacity dark scrim
}

// Spacing, sizing, and border radius constants.
// Based on an 8px grid — all values are multiples of 4 or 8.
class AppDimensions {
  AppDimensions._();

  // --- Spacing ---
  static const double spaceXs = 4;
  static const double spaceSm = 8;
  static const double spaceMd = 16;
  static const double spaceLg = 24;
  static const double spaceXl = 32;
  static const double spaceXxl = 48;

  // --- Border radius ---
  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 20;
  static const double radiusXl = 28;
  static const double radiusFull = 999; // pill shape

  // --- Button sizes ---
  static const double buttonHeightLarge = 56;
  static const double buttonHeightMedium = 48;
  static const double buttonHeightSmall = 36;

  // --- Card / panel ---
  static const double cardPaddingH = 20;
  static const double cardPaddingV = 16;
  static const double cardElevation = 0; // flat design — no Material elevation

  // --- Icon sizes ---
  static const double iconSm = 16;
  static const double iconMd = 24;
  static const double iconLg = 32;

  // --- Screen padding ---
  static const double screenPaddingH = 24;
  static const double screenPaddingV = 20;

  // --- HUD ---
  static const double hudPadding = 12;
  static const double minimapSize = 100;
  static const double minimapPadding = 12;

  // --- Upgrade card ---
  static const double upgradeCardWidth = double.infinity;
  static const double upgradeCardHeight = 80;

  // --- XP bar ---
  static const double xpBarHeight = 8;
  static const double xpBarRadius = 4;

  // --- Game world entities (visual sizes, not logic) ---
  static const double snakeSegmentRadius = 10;
  static const double foodOrbRadius = 6;
  static const double particleOrbRadius = 4;
  static const double itemRadius = 14;
}

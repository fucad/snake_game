import 'package:flutter/material.dart';

// Animation durations and curves.
// Dunk Shot feel: smooth, not snappy. Ease in-out for most things.
class AppAnimations {
  AppAnimations._();

  // --- Durations ---
  static const Duration micro = Duration(milliseconds: 120); // instant feedback
  static const Duration fast = Duration(milliseconds: 200); // button press, tap
  static const Duration normal = Duration(milliseconds: 300); // state changes
  static const Duration slow = Duration(
    milliseconds: 450,
  ); // screen transitions
  static const Duration crawl = Duration(milliseconds: 600); // intro reveals

  // --- Curves ---
  static const Curve standard = Curves.easeInOutCubic;
  static const Curve enter = Curves.easeOutCubic; // things coming in
  static const Curve exit = Curves.easeInCubic; // things going out
  static const Curve spring = Curves.elasticOut; // juicy bounces (score pop)
  static const Curve decelerate = Curves.decelerate;

  // --- Screen transitions ---
  static const Duration screenTransition = slow;
  static const Curve screenTransitionCurve = standard;

  // --- Game juice ---
  static const Duration screenShake = Duration(milliseconds: 350);
  static const Duration eatFlash = Duration(milliseconds: 150);
  static const Duration itemPickupGlow = Duration(milliseconds: 400);
  static const Duration deathExplosion = Duration(milliseconds: 600);
  static const Duration xpBarFill = Duration(milliseconds: 800);
  static const Duration scoreCountUp = Duration(milliseconds: 1200);
}

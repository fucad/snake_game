enum UpgradeType {
  speed,
  detectionRange,
  startingSize;

  String get displayName => switch (this) {
    UpgradeType.speed => 'Speed',
    UpgradeType.detectionRange => 'Detection',
    UpgradeType.startingSize => 'Starting Size',
  };

  String get description => switch (this) {
    UpgradeType.speed => 'Move faster across the arena',
    UpgradeType.detectionRange => 'Extend magnet reach and awareness radius',
    UpgradeType.startingSize => 'Begin each round with a longer snake',
  };
}

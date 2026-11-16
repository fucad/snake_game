// All user-configurable settings.
// Pure Dart — no Flutter or Flame imports.
class SettingsModel {
  final bool soundEnabled;
  final bool musicEnabled;
  final bool hapticsEnabled;
  final bool showMinimap;
  final ControlStyle controlStyle;
  // When non-null, override the round-based bot count and difficulty.
  final int? manualBotCount;
  final ManualDifficulty? manualDifficulty;

  const SettingsModel({
    this.soundEnabled = true,
    this.musicEnabled = false,
    this.hapticsEnabled = true,
    this.showMinimap = true,
    this.controlStyle = ControlStyle.followFinger,
    this.manualBotCount,
    this.manualDifficulty,
  });

  const SettingsModel.defaults() : this();

  SettingsModel copyWith({
    bool? soundEnabled,
    bool? musicEnabled,
    bool? hapticsEnabled,
    bool? showMinimap,
    ControlStyle? controlStyle,
    // Pass SettingsModel.noOverride to clear manual overrides
    Object? manualBotCount = _keep,
    Object? manualDifficulty = _keep,
  }) {
    return SettingsModel(
      soundEnabled: soundEnabled ?? this.soundEnabled,
      musicEnabled: musicEnabled ?? this.musicEnabled,
      hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
      showMinimap: showMinimap ?? this.showMinimap,
      controlStyle: controlStyle ?? this.controlStyle,
      manualBotCount: manualBotCount == _keep
          ? this.manualBotCount
          : manualBotCount as int?,
      manualDifficulty: manualDifficulty == _keep
          ? this.manualDifficulty
          : manualDifficulty as ManualDifficulty?,
    );
  }

  static const _keep = Object();
}

enum ControlStyle {
  followFinger,
  joystick;

  String get displayName => switch (this) {
    ControlStyle.followFinger => 'Follow Finger',
    ControlStyle.joystick => 'Joystick',
  };
}

enum ManualDifficulty {
  easy,
  normal,
  hard,
  mixed;

  String get displayName => switch (this) {
    ManualDifficulty.easy => 'Easy',
    ManualDifficulty.normal => 'Normal',
    ManualDifficulty.hard => 'Hard',
    ManualDifficulty.mixed => 'Mixed (default)',
  };
}

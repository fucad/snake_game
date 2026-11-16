import 'package:shared_preferences/shared_preferences.dart';
import 'package:snake_game/settings/settings_model.dart';

// Loads and saves SettingsModel to local storage.
// No network, no accounts, no tracking.
class SettingsService {
  static const _sound = 'sound_enabled';
  static const _music = 'music_enabled';
  static const _haptics = 'haptics_enabled';
  static const _minimap = 'show_minimap';
  static const _control = 'control_style';
  static const _botCount = 'manual_bot_count';
  static const _difficulty = 'manual_difficulty';

  Future<SettingsModel> load() async {
    final p = await SharedPreferences.getInstance();
    return SettingsModel(
      soundEnabled: p.getBool(_sound) ?? true,
      musicEnabled: p.getBool(_music) ?? false,
      hapticsEnabled: p.getBool(_haptics) ?? true,
      showMinimap: p.getBool(_minimap) ?? true,
      controlStyle: _decodeControl(p.getString(_control)),
      manualBotCount: p.getInt(_botCount),
      manualDifficulty: _decodeDifficulty(p.getString(_difficulty)),
    );
  }

  Future<void> save(SettingsModel s) async {
    final p = await SharedPreferences.getInstance();
    await Future.wait([
      p.setBool(_sound, s.soundEnabled),
      p.setBool(_music, s.musicEnabled),
      p.setBool(_haptics, s.hapticsEnabled),
      p.setBool(_minimap, s.showMinimap),
      p.setString(_control, s.controlStyle.name),
      if (s.manualBotCount != null)
        p.setInt(_botCount, s.manualBotCount!)
      else
        p.remove(_botCount),
      if (s.manualDifficulty != null)
        p.setString(_difficulty, s.manualDifficulty!.name)
      else
        p.remove(_difficulty),
    ]);
  }

  static ControlStyle _decodeControl(String? raw) {
    if (raw == null) return ControlStyle.followFinger;
    return ControlStyle.values.firstWhere(
      (e) => e.name == raw,
      orElse: () => ControlStyle.followFinger,
    );
  }

  static ManualDifficulty? _decodeDifficulty(String? raw) {
    if (raw == null) return null;
    return ManualDifficulty.values.firstWhere(
      (e) => e.name == raw,
      orElse: () => ManualDifficulty.mixed,
    );
  }
}

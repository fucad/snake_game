import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snake_game/progression/player_profile.dart';
import 'package:snake_game/progression/upgrade_type.dart';

// Saves and loads PlayerProfile from local storage.
// No network calls, no accounts, no tracking.
class PersistenceService {
  static const _key = 'player_profile_v1';

  Future<PlayerProfile> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return const PlayerProfile();
    try {
      return _decode(json.decode(raw) as Map<String, dynamic>);
    } catch (_) {
      return const PlayerProfile();
    }
  }

  Future<void> save(PlayerProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, json.encode(_encode(profile)));
  }

  static Map<String, dynamic> _encode(PlayerProfile p) => {
    'round': p.currentRound,
    'xp': p.totalXp,
    'tiers': {for (final e in p.upgradeTiers.entries) e.key.name: e.value},
    'highScore': p.highScore,
    'kills': p.totalKills,
  };

  static PlayerProfile _decode(Map<String, dynamic> m) {
    final tiersRaw = m['tiers'] as Map<String, dynamic>? ?? {};
    final tiers = {
      for (final type in UpgradeType.values)
        type: (tiersRaw[type.name] as int?) ?? 0,
    };
    return PlayerProfile(
      currentRound: (m['round'] as int?) ?? 1,
      totalXp: (m['xp'] as int?) ?? 0,
      upgradeTiers: tiers,
      highScore: (m['highScore'] as int?) ?? 0,
      totalKills: (m['kills'] as int?) ?? 0,
    );
  }
}

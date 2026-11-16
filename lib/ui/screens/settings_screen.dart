import 'package:flutter/material.dart';
import 'package:snake_game/settings/settings_model.dart';
import 'package:snake_game/settings/settings_service.dart';
import 'package:snake_game/ui/theme/app_colors.dart';
import 'package:snake_game/ui/theme/app_dimensions.dart';
import 'package:snake_game/ui/theme/app_text_styles.dart';

class SettingsScreen extends StatefulWidget {
  final SettingsModel initialSettings;

  const SettingsScreen({super.key, required this.initialSettings});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late SettingsModel _settings;
  final _service = SettingsService();

  @override
  void initState() {
    super.initState();
    _settings = widget.initialSettings;
  }

  Future<void> _update(SettingsModel updated) async {
    setState(() => _settings = updated);
    await _service.save(updated);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBg,
      appBar: AppBar(
        title: const Text('SETTINGS'),
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
          children: [
            const _SectionLabel('Audio'),
            _ToggleTile(
              title: 'Sound Effects',
              value: _settings.soundEnabled,
              onChanged: (v) => _update(_settings.copyWith(soundEnabled: v)),
            ),
            _ToggleTile(
              title: 'Music',
              value: _settings.musicEnabled,
              onChanged: (v) => _update(_settings.copyWith(musicEnabled: v)),
            ),

            const SizedBox(height: AppDimensions.spaceLg),
            const _SectionLabel('Controls'),
            _ToggleTile(
              title: 'Haptic Feedback',
              value: _settings.hapticsEnabled,
              onChanged: (v) => _update(_settings.copyWith(hapticsEnabled: v)),
            ),
            _DropdownTile<ControlStyle>(
              title: 'Control Style',
              value: _settings.controlStyle,
              items: ControlStyle.values,
              labelOf: (e) => e.displayName,
              onChanged: (v) => v != null
                  ? _update(_settings.copyWith(controlStyle: v))
                  : null,
            ),

            const SizedBox(height: AppDimensions.spaceLg),
            const _SectionLabel('Display'),
            _ToggleTile(
              title: 'Show Minimap',
              value: _settings.showMinimap,
              onChanged: (v) => _update(_settings.copyWith(showMinimap: v)),
            ),

            const SizedBox(height: AppDimensions.spaceLg),
            const _SectionLabel('Bots (optional overrides)'),
            _DropdownTile<ManualDifficulty?>(
              title: 'Difficulty',
              value: _settings.manualDifficulty,
              items: [null, ...ManualDifficulty.values],
              labelOf: (e) => e?.displayName ?? 'Auto (by round)',
              onChanged: (v) =>
                  _update(_settings.copyWith(manualDifficulty: v)),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: AppDimensions.spaceSm),
    child: Text(text, style: AppTextStyles.stageLabel),
  );
}

class _ToggleTile extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleTile({
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.spaceSm),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.cardPaddingH,
        vertical: AppDimensions.spaceSm,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppTextStyles.bodyLarge),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}

class _DropdownTile<T> extends StatelessWidget {
  final String title;
  final T value;
  final List<T> items;
  final String Function(T) labelOf;
  final ValueChanged<T?> onChanged;

  const _DropdownTile({
    required this.title,
    required this.value,
    required this.items,
    required this.labelOf,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.spaceSm),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.cardPaddingH,
        vertical: AppDimensions.spaceSm,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppTextStyles.bodyLarge),
          DropdownButton<T>(
            value: value,
            dropdownColor: AppColors.surfaceElevated,
            underline: const SizedBox.shrink(),
            style: AppTextStyles.bodyMedium,
            items: items
                .map(
                  (e) => DropdownMenuItem<T>(value: e, child: Text(labelOf(e))),
                )
                .toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

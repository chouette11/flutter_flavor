import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../util/providers/shared_preferences_provider.dart';

/// SharedPreferences で使用するテーマ保存用のキー
const _themePrefsKey = 'selectedThemeKey';

final themeSelectorProvider = StateNotifierProvider<ThemeSelector, ThemeMode>(
  ThemeSelector.new,
);

class ThemeSelector extends StateNotifier<ThemeMode> {
  ThemeSelector(this._ref) : super(ThemeMode.system) {
    /// `SharedPreferences` を使用して、記憶しているテーマがあれば取得して反映する。
    final themeIndex = _prefs.getInt(_themePrefsKey);
    if (themeIndex == null) {
      return;
    }
    final themeMode = ThemeMode.values.firstWhere(
      (e) => e.index == themeIndex,
      orElse: () => ThemeMode.system,
    );
    state = themeMode;
  }

  final Ref _ref;

  /// 選択したテーマを保存するためのローカル保存領域
  late final _prefs = _ref.read(sharedPreferencesProvider);

  /// テーマの変更と保存を行う
  Future<void> changeAndSave(ThemeMode theme) async {
    await _prefs.setInt(_themePrefsKey, theme.index);
    state = theme;
  }
}

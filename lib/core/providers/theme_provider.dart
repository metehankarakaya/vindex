import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vindex/core/providers/shared_preferences_provider.dart';

class ThemeNotifier extends Notifier<ThemeMode> {
  static const _key = 'theme_mode_key';

  @override
  ThemeMode build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final savedModeName = prefs.getString(_key);

    return ThemeMode.values.firstWhere(
          (mode) => mode.name == savedModeName,
      orElse: () => ThemeMode.system,
    );
  }
  Future<void> setTheme(ThemeMode mode) async {
    state = mode;
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(_key, mode.name);
  }

}

final themeModeProvider = NotifierProvider<ThemeNotifier, ThemeMode>(ThemeNotifier.new);

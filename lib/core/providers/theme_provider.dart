import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vindex/core/providers/shared_preferences_provider.dart';

class ThemeNotifier extends Notifier<ThemeMode> {
  static const _key = 'theme_mode';

  @override
  ThemeMode build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final isDark = prefs.getBool(_key) ?? false;
    return isDark ? ThemeMode.dark : ThemeMode.light;
  }

  void toggle() async {
    final prefs = ref.read(sharedPreferencesProvider);
    state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    await prefs.setBool(_key, state == ThemeMode.dark);
  }
}

final themeModeProvider = NotifierProvider<ThemeNotifier, ThemeMode>(ThemeNotifier.new);

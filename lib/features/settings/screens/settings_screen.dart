import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vindex/core/constants/app_strings.dart';
import 'package:vindex/core/widgets/language_selector.dart';
import 'package:vindex/core/widgets/theme_selector.dart';

import '../../../core/providers/theme_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.settings.tr()),
      ),
      body: Center(
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.palette_outlined),
              title: Text(AppStrings.theme.tr()),
              subtitle: Text(
                switch (themeMode) {
                  ThemeMode.light => AppStrings.lightMode.tr(),
                  ThemeMode.dark => AppStrings.darkMode.tr(),
                  ThemeMode.system => AppStrings.systemMode.tr(),
                },
              ),
              onTap: () => ThemeSelector.show(context),
            ),
            ListTile(
              leading: const Icon(Icons.language),
              title: Text(AppStrings.changeLanguage.tr()),
              onTap: () => LanguageSelector.show(context),
            ),
          ],
        ),
      )
    );
  }
}

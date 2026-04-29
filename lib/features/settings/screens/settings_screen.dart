import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vindex/core/widgets/theme_selector.dart';

import '../../../core/providers/theme_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Center(
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.palette_outlined),
              title: Text("Tema"),
              subtitle: Text(
                switch (themeMode) {
                  ThemeMode.light => "Açık",
                  ThemeMode.dark => "Koyu",
                  ThemeMode.system => "Sistem Varsayılanı",
                },
              ),
              onTap: () => ThemeSelector.show(context),
            )
          ],
        ),
      )
    );
  }
}

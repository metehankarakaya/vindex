import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/theme_provider.dart';

class ThemeSelector {
  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => Consumer(
        builder: (context, ref, child) {
          final currentMode = ref.watch(themeModeProvider);

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 36,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 24),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.outlineVariant,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  _ThemeOption(
                    title: "Açık Tema",
                    icon: Icons.light_mode_outlined,
                    mode: ThemeMode.light,
                    current: currentMode,
                    ref: ref,
                  ),
                  _ThemeOption(
                    title: "Koyu Tema",
                    icon: Icons.dark_mode_outlined,
                    mode: ThemeMode.dark,
                    current: currentMode,
                    ref: ref,
                  ),
                  _ThemeOption(
                    title: "Sistem Varsayılanı",
                    icon: Icons.brightness_auto_outlined,
                    mode: ThemeMode.system,
                    current: currentMode,
                    ref: ref,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final String title;
  final IconData icon;
  final ThemeMode mode;
  final ThemeMode current;
  final WidgetRef ref;

  const _ThemeOption({
    required this.title,
    required this.icon,
    required this.mode,
    required this.current,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = mode == current;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: ListTile(
        tileColor: isSelected ? colorScheme.primary.withValues(alpha: 0.1) : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: isSelected
            ? BorderSide(color: colorScheme.primary.withValues(alpha: 0.2))
            : BorderSide.none,
        ),
        leading: Icon(
          icon,
          color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? colorScheme.primary : colorScheme.onSurface,
          ),
        ),
        trailing: isSelected
          ? Icon(Icons.check_circle_rounded, color: colorScheme.primary, size: 22)
          : null,
        onTap: () async {
          Navigator.pop(context);
          await Future.delayed(const Duration(milliseconds: 150));
          if (context.mounted) {
            ref.read(themeModeProvider.notifier).setTheme(mode);
          }
        },
      ),
    );
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vindex/core/constants/app_strings.dart';
import 'package:vindex/features/settings/widgets/sliver_section_header.dart';

import '../../../core/providers/theme_provider.dart';
import '../../../core/widgets/language_selector.dart';
import '../../../core/widgets/theme_selector.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120.0,
            pinned: true,
            stretch: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                AppStrings.settings.tr(),
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)
              ),
              titlePadding: const EdgeInsetsDirectional.only(start: 16, bottom: 16),
              centerTitle: false,
            ),
          ),
          SliverSectionHeader(title: AppStrings.theme.tr().toUpperCase(),),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(
              child: Card(
                elevation: 0,
                color: colorScheme.surfaceContainerLow,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                      trailing: const Icon(Icons.expand_more, size: 20),
                      onTap: () => ThemeSelector.show(context),
                    ),
                    Divider(height: 1, indent: 56, endIndent: 16, color: colorScheme.outlineVariant),
                    ListTile(
                      leading: const Icon(Icons.language),
                      title: Text(AppStrings.changeLanguage.tr()),
                      trailing: const Icon(Icons.expand_more, size: 20),
                      onTap: () => LanguageSelector.show(context),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 12)),
          SliverSectionHeader(title: AppStrings.dataManagementTitle.tr().toUpperCase(),),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(
              child: Card(
                elevation: 0,
                color: colorScheme.surfaceContainerLow,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: ListTile(
                  leading: const Icon(Icons.storage_rounded),
                  title: Text(AppStrings.dataManagementTitle.tr()),
                  subtitle: Text(AppStrings.dataManagementSubtitle.tr()),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push("/settings/data-management"),
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }
}

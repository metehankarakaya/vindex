import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vindex/core/constants/app_strings.dart';
import 'package:vindex/core/providers/package_info_provider.dart';
import 'package:vindex/features/settings/widgets/sliver_section_header.dart';

import '../../../core/providers/theme_provider.dart';
import '../../../core/widgets/language_selector.dart';
import '../../../core/widgets/theme_selector.dart';
import '../widgets/settings_list_item.dart';

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
            expandedHeight: 100.0,
            pinned: true,
            stretch: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(AppStrings.settings.tr(), style: theme.textTheme.titleMedium),
              titlePadding: const EdgeInsetsDirectional.only(start: 16, bottom: 16),
              centerTitle: false,
            ),
          ),
          SliverSectionHeader(title: AppStrings.theme.tr().toUpperCase()),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(
              child: Card(
                elevation: 0,
                color: colorScheme.surfaceContainerLow,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Column(
                  children: [
                    SettingsListItem(
                      leadingIcon: Icons.palette_outlined,
                      title: AppStrings.theme.tr(),
                      subtitle: switch (themeMode) {
                        ThemeMode.light => AppStrings.lightTheme.tr(),
                        ThemeMode.dark => AppStrings.darkTheme.tr(),
                        ThemeMode.system => AppStrings.systemTheme.tr(),
                      },
                      onTap: () => ThemeSelector.show(context),
                      showDivider: true,
                    ),
                    SettingsListItem(
                      leadingIcon: Icons.language,
                      title: AppStrings.changeLanguage.tr(),
                      onTap: () => LanguageSelector.show(context),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 12)),
          SliverSectionHeader(title: AppStrings.dataManagementTitle.tr().toUpperCase()),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(
              child: Card(
                elevation: 0,
                color: colorScheme.surfaceContainerLow,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: SettingsListItem(
                  leadingIcon: Icons.storage_rounded,
                  title: AppStrings.dataManagementTitle.tr(),
                  subtitle: AppStrings.dataManagementSubtitle.tr(),
                  trailing: const Icon(Icons.chevron_right, size: 20),
                  onTap: () => context.push("/settings/data-management"),
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ref.watch(packageInfoProvider).when(
                data: (info) => Column(
                  mainAxisAlignment: .end,
                  children: [
                    Icon(
                      Icons.account_balance_wallet_outlined,
                      size: 24,
                      color: colorScheme.primary.withValues(alpha: 0.2),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Vindex v${info.version} (${info.buildNumber})",
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ],
                ),
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const Text("v1.0.0"),
              ),
            ),
          )
        ],
      ),
    );
  }
}

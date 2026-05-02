import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vindex/features/security/widgets/secuirt_list_item.dart';

import '../../../core/constants/app_strings.dart';
import '../providers/security_provider.dart';

class SecurityScreen extends ConsumerWidget {
  const SecurityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final hasPinSetup = ref.watch(securityProvider).value?.hasPinSetup ?? false;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.securityTitle.tr()),
        centerTitle: false,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                elevation: 0,
                clipBehavior: Clip.antiAlias,
                color: colorScheme.surfaceContainerLow,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Column(
                  children: [
                    SecurityListItem(
                      title: AppStrings.pinAdd.tr(),
                      icon: Icons.lock_outline_rounded,
                      enabled: !hasPinSetup,
                      onTap: () => context.push("/settings/security/pin-setup"),
                    ),
                    SecurityListItem(
                      title: AppStrings.pinChange.tr(),
                      icon: Icons.password_rounded,
                      enabled: hasPinSetup,
                      onTap: () => context.push("/settings/security/pin-change"),
                    ),
                    SecurityListItem(
                      title: AppStrings.pinRemove.tr(),
                      icon: Icons.lock_open_rounded,
                      showDivider: false,
                      enabled: hasPinSetup,
                      onTap: () => context.push("/settings/security/pin-disable"),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverFillRemaining(
              hasScrollBody: false,
              child: Align(
                alignment: .bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Card(
                    elevation: 0,
                    color: colorScheme.surfaceContainerLow,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Text(
                        AppStrings.pinForgotWarning.tr(),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant.withOpacity(0.7),
                        ),
                        textAlign: .center,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      )
    );
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vindex/core/constants/app_strings.dart';
import 'package:vindex/features/dashboard/screens/dashboard_screen.dart';
import 'package:vindex/features/security/screens/pin_change.dart';
import 'package:vindex/features/security/screens/pin_setup.dart';
import 'package:vindex/features/security/screens/security_screen.dart';
import 'package:vindex/features/stats/screens/stats_screen.dart';

import '../features/recurrings/screens/recurring_screen.dart';
import '../features/security/providers/security_provider.dart';
import '../features/security/screens/pin_disable.dart';
import '../features/security/screens/pin_verify.dart';
import '../features/settings/screens/data_management_screen.dart';
import '../features/settings/screens/settings_screen.dart';
import '../features/transactions/screens/transactions_screen.dart';

GoRouter buildRouter(WidgetRef ref) {
  return GoRouter(
    initialLocation: "/dashboard",
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: Theme.of(context).colorScheme.error),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => context.go('/dashboard'),
              child: Text(AppStrings.dashboard.tr()),
            ),
          ],
        ),
      ),
    ),
    refreshListenable: _SecurityStateNotifier(ref),
    redirect: (context, state) {
      final securityAsync = ref.read(securityProvider);

      if (securityAsync.isLoading || securityAsync.hasError) return null;

      final security = securityAsync.value!;
      final isOnPinVerify = state.matchedLocation == "/pin-verify";

      if (security.hasPinSetup && !security.isUnlocked && !isOnPinVerify) {
        return "/pin-verify";
      }
      if (!security.hasPinSetup && isOnPinVerify) {
        return "/dashboard";
      }
      if (security.isUnlocked && isOnPinVerify) {
        return "/dashboard";
      }

      return null;
    },
    routes: [
      GoRoute(
        path: "/pin-verify",
        builder: (context, state) => const PinVerify(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithBottomNav(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: "/dashboard",
                builder: (context, state) => const DashboardScreen()
              )
            ]
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: "/transactions",
                builder: (context, state) => const TransactionsScreen()
              )
            ]
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: "/recurring",
                builder: (context, state) => const RecurringScreen()
              )
            ]
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: "/settings",
                builder: (context, state) => const SettingsScreen(),
                routes: [
                  GoRoute(
                    path: "stats",
                    builder: (context, state) => const StatsScreen(),
                  ),
                  GoRoute(
                    path: "security",
                    builder: (context, state) => const SecurityScreen(),
                    routes: [
                      GoRoute(
                        path: "pin-setup",
                        builder: (context, state) => const PinSetup(),
                      ),
                      GoRoute(
                        path: "pin-change",
                        builder: (context, state) => const PinChange(),
                      ),
                      GoRoute(
                        path: "pin-disable",
                        builder: (context, state) => const PinDisable(),
                      ),
                    ]
                  ),
                  GoRoute(
                    path: "data-management",
                    builder: (context, state) => const DataManagementScreen(),
                  ),
                ]
              )
            ]
          ),
        ]
      )
    ]
  );
}

class _SecurityStateNotifier extends ChangeNotifier {
  _SecurityStateNotifier(WidgetRef ref) {
    ref.listen(securityProvider, (_, __) => notifyListeners());
  }
}

class ScaffoldWithBottomNav extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const ScaffoldWithBottomNav({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    context.locale;
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex
          );
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.dashboard_outlined),
            selectedIcon: const Icon(Icons.dashboard),
            label: AppStrings.dashboard.tr(),
          ),
          NavigationDestination(
            icon: const Icon(Icons.receipt_long_outlined),
            selectedIcon: const Icon(Icons.receipt_long),
            label: AppStrings.transactions.tr(),
          ),
          NavigationDestination(
            icon: const Icon(Icons.repeat_outlined),
            selectedIcon: const Icon(Icons.repeat),
            label: AppStrings.recurring.tr(),
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings),
            label: AppStrings.settings.tr(),
          ),
        ],
      ),
    );
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vindex/core/constants/app_strings.dart';
import 'package:vindex/features/dashboard/screens/dashboard_screen.dart';

import '../features/recurrings/screens/recurring_screen.dart';
import '../features/settings/screens/data_management_screen.dart';
import '../features/settings/screens/settings_screen.dart';
import '../features/transactions/screens/transactions_screen.dart';

final appRouter = GoRouter(
  initialLocation: "/dashboard",
  routes: [
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

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vindex/features/dashboard/screens/dashboard_screen.dart';

import '../features/recurrings/screens/recurring_screen.dart';
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
              builder: (context, state) => const SettingsScreen()
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
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'Transactions',
          ),
          NavigationDestination(
            icon: Icon(Icons.repeat_outlined),
            selectedIcon: Icon(Icons.repeat),
            label: 'Recurring',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

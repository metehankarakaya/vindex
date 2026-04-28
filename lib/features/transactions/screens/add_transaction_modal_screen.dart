import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:vindex/core/constants/app_strings.dart';
import 'package:vindex/features/recurrings/screens/add_recurring_transaction_screen.dart';
import 'package:vindex/features/transactions/screens/add_transaction_screen.dart';

class AddTransactionModalScreen extends StatelessWidget {
  const AddTransactionModalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return DefaultTabController(
      length: 2,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            const SizedBox(height: 16),
            TabBar(
              tabs: [
                Tab(text: AppStrings.instant.tr()),
                Tab(text: AppStrings.recurring.tr()),
              ],
            ),
            Expanded(
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  AddTransactionScreen(),
                  AddRecurringTransactionScreen()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

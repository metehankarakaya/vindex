import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vindex/core/constants/app_strings.dart';

import '../../../core/providers/currency_formatter_provider.dart';
import '../providers/stats_provider.dart';

class StatsSummaryCard extends ConsumerWidget {
  const StatsSummaryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final formatter = ref.watch(currencyFormatterProvider);
    final incomeStats = ref.watch(statsIncomeProvider);
    final expenseStats = ref.watch(statsExpenseProvider);
    final totalBalance = incomeStats - expenseStats;

    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              AppStrings.netBalance.tr(),
              style: TextStyle(color: colorScheme.outline, fontSize: 13, fontWeight: FontWeight.w600)
            ),
            const SizedBox(height: 8),
            Text(
              formatter.format(totalBalance / 100),
              style: TextStyle(fontSize: 34, fontWeight: FontWeight.w900, letterSpacing: -1),
            ),
            const SizedBox(height: 24),
            const Divider(height: 1),
            const SizedBox(height: 24),
            Row(
              children: [
                MiniStat(label: AppStrings.totalIncome.tr(), value: formatter.format(incomeStats / 100), color: Colors.green),
                MiniStat(label: AppStrings.totalExpense.tr(), value: formatter.format(expenseStats / 100), color: colorScheme.error),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const MiniStat({super.key, required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}

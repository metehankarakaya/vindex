import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vindex/core/constants/app_colors.dart';
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
        borderRadius: BorderRadius.circular(28),
        side: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              AppStrings.netBalance.tr().toUpperCase(),
              style: TextStyle(
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
              )
            ),
            const SizedBox(height: 10),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                formatter.format(totalBalance / 100),
                style: TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1.5,
                  color: totalBalance < 0 ? colorScheme.error : colorScheme.onSurface,
                ),
              ),
            ),
            const SizedBox(height: 28),
            Divider(height: 1, color: colorScheme.outlineVariant.withValues(alpha: 0.4)),
            const SizedBox(height: 28),
            Row(
              children: [
                MiniStat(
                  label: AppStrings.totalIncome.tr(),
                  value: formatter.format(incomeStats / 100),
                  color: AppColors.income,
                ),
                Container(
                  width: 1,
                  height: 30,
                  color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                ),
                MiniStat(
                  label: AppStrings.totalExpense.tr(),
                  value: formatter.format(expenseStats / 100),
                  color: colorScheme.error,
                ),
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
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            )
          ),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: color,
                letterSpacing: -0.5,
              )
            ),
          ),
        ],
      ),
    );
  }
}

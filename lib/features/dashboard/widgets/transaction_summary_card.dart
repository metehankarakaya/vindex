import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vindex/features/dashboard/provider/dashboard_provider.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/models/transactions_table.dart';

class TransactionSummaryCard extends ConsumerWidget {
  final TransactionType type;
  const TransactionSummaryCard({super.key, required this.type});

  static final formatter = NumberFormat.currency(locale: 'tr_TR', symbol: '₺');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isHide = ref.watch(toggleProvider);
    final isIncome = type == TransactionType.income;

    final amount = isIncome ? ref.watch(totalIncomeProvider) : ref.watch(totalExpenseProvider);
    final formattedAmount = formatter.format(amount / 100);

    final icon = isIncome
      ? Icons.arrow_upward_outlined
      : Icons.arrow_downward_outlined;

    final title = isIncome
      ? AppStrings.transactionIncome.tr()
      : AppStrings.transactionExpense.tr();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(icon, size: 32),
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.labelMedium),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  isHide ? "₺******" : formattedAmount,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

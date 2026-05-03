import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/models/transactions_table.dart';
import '../../../core/providers/currency_formatter_provider.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/widgets/category_icon_widget.dart';
import '../../../database/app_database.dart';

class TransactionListItem extends ConsumerWidget {
  final Transaction transaction;
  const TransactionListItem({super.key, required this.transaction});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formatter = ref.watch(currencyFormatterProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final formattedAmount = formatter.format(transaction.amountCents / 100);

    final bool isExpense = transaction.type == TransactionType.expense;

    final Color amountColor = isExpense
      ? colorScheme.error
      : AppColors.income;

    return ListTile(
      leading: CategoryIconWidget(category: transaction.category),
      trailing: SizedBox(
        width: 100,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerRight,
          child: Text(
            "${isExpense ? "-" : "+"}$formattedAmount",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: amountColor,
            ),
          ),
        ),
      ),
      title: Text(
        transaction.title.trim().isEmpty ? transaction.category.tr() : transaction.title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
      ),
      subtitle: Text(
        DateFormatter.formatTransactionDate(transaction.createdAt, context.locale),
        style: TextStyle(
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
        ),
      ),
    );
  }
}

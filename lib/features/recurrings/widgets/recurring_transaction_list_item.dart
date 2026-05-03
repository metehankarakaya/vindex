import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vindex/core/constants/app_colors.dart';
import 'package:vindex/database/app_database.dart';

import '../../../core/models/transactions_table.dart';
import '../../../core/providers/currency_formatter_provider.dart';
import '../../../core/utils/category_utils.dart';
import '../../../core/utils/date_formatter.dart';

class RecurringTransactionListItem extends ConsumerWidget {
  final RecurringTransaction recurringTransaction;
  final VoidCallback? onLongPress;
  const RecurringTransactionListItem({super.key, required this.recurringTransaction, this.onLongPress});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formatter = ref.watch(currencyFormatterProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final formattedAmount = formatter.format(recurringTransaction.amountCents / 100);

    final bool isExpense = recurringTransaction.type == TransactionType.expense;
    final categoryColor = colorForCategory(recurringTransaction.category);

    String formatDateRange(DateTime startDate, DateTime? endDate) {
      final start = DateFormatter.formatFullDate(startDate, context.locale);
      if (endDate == null) return "$start - ∞";
      return "$start - ${DateFormatter.formatFullDate(endDate, context.locale)}";
    }

    final Color amountColor = isExpense
      ? colorScheme.error
      : AppColors.income;

    return Opacity(
      opacity: recurringTransaction.isActive ? 1.0 : 0.6,
      child: ListTile(
        onLongPress: onLongPress,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: categoryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            iconForCategory(recurringTransaction.category),
            color: categoryColor,
            size: 24,
          ),
        ),
        title: Row(
          children: [
            Flexible(
              child: Text(
                recurringTransaction.title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: colorScheme.secondaryContainer.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                recurringTransaction.frequency.name.tr(),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSecondaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        subtitle: Text(
          formatDateRange(recurringTransaction.startDate, recurringTransaction.endDate),
          style: TextStyle(
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
          ),
        ),
        trailing: SizedBox(
          width: 100,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerRight,
            child: Text(
              "${isExpense ? "-" : "+"}$formattedAmount",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: amountColor,
                decoration: recurringTransaction.isActive ? null : TextDecoration.lineThrough,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

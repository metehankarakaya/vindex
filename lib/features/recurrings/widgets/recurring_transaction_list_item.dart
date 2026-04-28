import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vindex/database/app_database.dart';

import '../../../core/models/transactions_table.dart';
import '../../../core/utils/category_utils.dart';

class RecurringTransactionListItem extends ConsumerWidget {
  final RecurringTransaction recurringTransaction;
  final VoidCallback? onLongPress;
  const RecurringTransactionListItem({super.key, required this.recurringTransaction, this.onLongPress});

  static final formatter = NumberFormat.currency(locale: 'tr_TR', symbol: '₺');

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    String formatDateRange(DateTime startDate, DateTime? endDate) {
      final dateFormat = DateFormat('dd MMMM yyyy', context.locale.toString());
      final start = dateFormat.format(startDate);
      if (endDate == null) {
        return "$start - ∞";
      }
      return "$start - ${dateFormat.format(endDate)}";
    }

    final colorScheme = Theme.of(context).colorScheme;
    final formattedAmount = formatter.format(recurringTransaction.amountCents / 100);

    final bool isExpense = recurringTransaction.type == TransactionType.expense;
    final categoryColor = colorForCategory(recurringTransaction.category);

    final Color amountColor = isExpense
      ? Colors.redAccent.shade400
      : const Color(0xFF10B981);

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
        title: Text(
          "${recurringTransaction.title} (${recurringTransaction.frequency.name.tr()})",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        subtitle: Text(
          formatDateRange(recurringTransaction.startDate, recurringTransaction.endDate),
          style: TextStyle(
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
          ),
        ),
        trailing: Text(
          "${isExpense ? "-" : "+"}$formattedAmount",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: amountColor,
            decoration: recurringTransaction.isActive ? null : TextDecoration.lineThrough,
          ),
        ),
      ),
    );
  }
}

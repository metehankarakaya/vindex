import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/transactions_table.dart';
import '../../../core/providers/currency_formatter_provider.dart';
import '../../../core/utils/category_utils.dart';
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
    final categoryColor = colorForCategory(transaction.category);

    String formatDate(BuildContext context, DateTime date) {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final transactionDay = DateTime(date.year, date.month, date.day);

      final diff = today.difference(transactionDay).inDays;

      if (diff == 0) {
        return DateFormat.Hm(context.locale.toString()).format(date);
      } else if (diff < 7) {
        return DateFormat("EEEE HH:mm", context.locale.toString()).format(date);
      } else {
        return DateFormat("d MMM HH:mm", context.locale.toString()).format(date);
      }
    }

    final Color amountColor = isExpense
      ? colorScheme.error
      : const Color(0xFF10B981);

    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: categoryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          iconForCategory(transaction.category),
          color: categoryColor,
          size: 24,
        ),
      ),
      trailing: Text(
        "${isExpense ? "-" : "+"}$formattedAmount",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: amountColor,
        ),
      ),
      title: Text(
        transaction.title.trim().isEmpty ? transaction.category : transaction.title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
      ),
      subtitle: Text(
        formatDate(context, transaction.createdAt),
        style: TextStyle(
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
        ),
      ),
    );
  }
}

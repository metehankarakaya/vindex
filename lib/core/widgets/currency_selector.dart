import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vindex/core/constants/app_strings.dart';
import 'package:vindex/core/models/currency_option.dart';
import 'package:vindex/core/providers/currency_provider.dart';

import '../../features/recurrings/providers/recurring_transaction_provider.dart';
import '../../features/transactions/providers/transaction_provider.dart';

class CurrencySelector {
  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => Consumer(
        builder: (context, ref, child) {
          final selectedCurrency = ref.watch(currencyProvider);
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 36,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 24),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.outlineVariant,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  ...supportedCurrencies.map((currency) => _CurrencyOptionTile(
                    option: currency,
                    isSelected: currency.code == selectedCurrency.code,
                  )),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CurrencyOptionTile extends ConsumerWidget {
  final CurrencyOption option;
  final bool isSelected;

  const _CurrencyOptionTile({
    required this.option,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: ListTile(
        tileColor: isSelected ? colorScheme.primary.withValues(alpha: 0.1) : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: isSelected
            ? BorderSide(color: colorScheme.primary.withValues(alpha: 0.2))
            : BorderSide.none,
        ),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isSelected ? colorScheme.primary : colorScheme.surfaceContainerHigh,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              option.symbol,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
              ),
            ),
          ),
        ),
        title: Text(
          option.name,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? colorScheme.primary : colorScheme.onSurface,
          ),
        ),
        trailing: isSelected
          ? Icon(Icons.check_circle_rounded, color: colorScheme.primary, size: 22)
          : Text(
          option.code,
          style: TextStyle(
            color: colorScheme.outline,
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: () async {
          if (!isSelected) {
            if (context.mounted) {
              final confirm = await showDialog<bool>(
                context: context,
                barrierDismissible: false,
                builder: (context) => AlertDialog(
                  title: Row(
                    children: [
                      Icon(Icons.warning_amber_rounded, color: colorScheme.error),
                      const SizedBox(width: 12),
                      Text(AppStrings.currencyChangeTitle.tr()),
                    ],
                  ),
                  content: Text(
                    AppStrings.currencyChangeMessage.tr(
                      namedArgs: {'currency': "${option.name} (${option.symbol})"}
                    ),
                    style: const TextStyle(fontSize: 16),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text(AppStrings.cancel.tr(), style: TextStyle(color: colorScheme.outline)),
                    ),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: colorScheme.error,
                        foregroundColor: colorScheme.onError,
                      ),
                      onPressed: () => Navigator.pop(context, true),
                      child: Text(AppStrings.resetAndChange.tr()),
                    ),
                  ],
                ),
              );
              if (confirm == true && context.mounted) {
                await ref.read(transactionDaoProvider).deleteAllTransactions();
                await ref.read(recurringTransactionDaoProvider).deleteAllRecurringTransactions();
                ref.read(currencyProvider.notifier).setCurrency(option);
                if (context.mounted) Navigator.pop(context);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(AppStrings.currencyUpdated.tr(namedArgs: {'code': option.code})),
                      behavior: SnackBarBehavior.floating,
                      margin: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  );
                }
              }
            }
          }
        },
      ),
    );
  }
}

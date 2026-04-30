import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/currency_formatter_provider.dart';

class CategoryStats extends ConsumerWidget {
  final String category;
  final int amountCents;
  final int totalExpenseCents;
  const CategoryStats({super.key, required this.category, required this.amountCents, required this.totalExpenseCents});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final formatter = ref.watch(currencyFormatterProvider);
    final percentage = totalExpenseCents > 0 ? amountCents / totalExpenseCents : 0.0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                category.tr(),
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              Text(
                formatter.format(amountCents / 100),
                style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: percentage,
              minHeight: 16,
              backgroundColor: colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
            ),
          )
        ],
      ),
    );
  }
}

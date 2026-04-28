import 'package:flutter/material.dart';
import 'package:vindex/core/constants/app_strings.dart';

import '../models/transactions_table.dart';

class TransactionTypeSelector extends StatelessWidget {
  final TransactionType selectedType;
  final Function(TransactionType) onTypeSelected;
  const TransactionTypeSelector({super.key, required this.selectedType, required this.onTypeSelected,});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SizedBox(
      width: double.infinity,
      child: SegmentedButton<TransactionType>(
        segments: const [
          ButtonSegment(
            value: TransactionType.expense,
            label: Text(AppStrings.expense),
            icon: Icon(Icons.arrow_downward, size: 18),
          ),
          ButtonSegment(
            value: TransactionType.income,
            label: Text(AppStrings.income),
            icon: Icon(Icons.arrow_upward, size: 18),
          ),
        ],
        selected: {selectedType},
        onSelectionChanged: (newSelection) => onTypeSelected(newSelection.first),
        style: SegmentedButton.styleFrom(
          side: BorderSide(color: colorScheme.outlineVariant),
          selectedBackgroundColor: selectedType == TransactionType.expense
            ? Colors.red.withValues(alpha: 0.1)
            : Colors.green.withValues(alpha: 0.1),
          selectedForegroundColor: selectedType == TransactionType.expense
            ? Colors.red
            : Colors.green,
        ),
      ),
    );
  }
}

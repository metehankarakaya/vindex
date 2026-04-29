import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../models/recurring_transaction_table.dart';

class FrequencySelector extends StatelessWidget {
  final RecurringFrequency? selectedFrequency;
  final Function(RecurringFrequency?) onFrequencySelected;

  FrequencySelector({super.key, required this.selectedFrequency, required this.onFrequencySelected,});

  final List<RecurringFrequency> _frequencies = [
    RecurringFrequency.daily,
    RecurringFrequency.weekly,
    RecurringFrequency.monthly,
    RecurringFrequency.yearly,
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 0.0,
        childAspectRatio: 2.1,
      ),
      itemCount: _frequencies.length,
      itemBuilder: (context, index) {
        final frequency = _frequencies[index];
        final isSelected = selectedFrequency == frequency;

        return GestureDetector(
          onTap: () => onFrequencySelected(frequency),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isSelected
                ? colorScheme.primary
                : colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
              border: isSelected
                ? null
                : Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.2)),),
            child: Center(
              child: Text(
                frequency.name.tr(),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected
                    ? colorScheme.onPrimary
                    : colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vindex/features/dashboard/provider/dashboard_provider.dart';

import '../../../core/providers/currency_formatter_provider.dart';

class BalanceCard extends ConsumerWidget {
  const BalanceCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formatter = ref.watch(currencyFormatterProvider);
    final totalBalance = ref.watch(totalBalanceProvider);
    final formattedAmount = formatter.format(totalBalance / 100);
    final isHide = ref.watch(toggleProvider);

    return Row(
      children: [
        Expanded(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              isHide ? "${formatter.currencySymbol}******" : formattedAmount,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: -1,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16,),
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: IconButton(
            onPressed: () => ref.read(toggleProvider.notifier).update((state) => !state),
            icon: Icon(isHide ? Icons.visibility_off : Icons.visibility),
            visualDensity: VisualDensity.compact,
          ),
        )
      ],
    );
  }
}

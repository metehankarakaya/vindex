import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vindex/core/constants/app_strings.dart';
import 'package:vindex/core/widgets/empty_holder.dart';
import 'package:vindex/features/recurrings/providers/recurring_transaction_provider.dart';
import 'package:vindex/features/recurrings/widgets/recurring_transaction_list_item.dart';

class RecurringScreen extends ConsumerWidget {
  const RecurringScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recurringTransactionAsync = ref.watch(recurringTransactionStreamProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text(AppStrings.recurring.tr()),
            floating: true,
            snap: true,
          ),
          recurringTransactionAsync.when(
            data: (recurringTransactions) => recurringTransactions.isNotEmpty
              ? SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                sliver: SliverList.builder(
                  itemCount: recurringTransactions.length,
                  itemBuilder: (context, index) => Dismissible(
                    key: Key(recurringTransactions[index].id),
                    direction: DismissDirection.endToStart,
                    onDismissed: (_) => ref.read(recurringTransactionDaoProvider).deleteRecurringTransaction(recurringTransactions[index].id),
                    child: Card(
                      child: RecurringTransactionListItem(recurringTransaction: recurringTransactions[index]),
                    ),
                  ),
                ),
              ) : SliverFillRemaining(
                hasScrollBody: false,
                child: EmptyHolder(
                  iconData: Icons.receipt_long_outlined,
                  title: AppStrings.noTransactionsYet.tr(),
                ),
              ),
            loading: () => SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
            error: (err, stackTrace) => SliverToBoxAdapter(
              child: Center(
                child: Text("Hata: $err"),
              ),
            ),
          )
        ],
      ),
    );
  }
}

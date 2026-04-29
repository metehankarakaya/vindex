import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vindex/core/constants/app_strings.dart';
import 'package:vindex/core/widgets/empty_holder.dart';
import 'package:vindex/features/transactions/providers/transaction_provider.dart';
import 'package:vindex/features/transactions/widgets/transaction_list_item.dart';

class TransactionsScreen extends ConsumerWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final transactionAsync = ref.watch(transactionStreamProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120.0,
            pinned: true,
            stretch: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(AppStrings.transactions.tr(), style: theme.textTheme.titleLarge),
              titlePadding: const EdgeInsetsDirectional.only(start: 16, bottom: 16),
              centerTitle: false,
            ),
          ),
          transactionAsync.when(
            data: (transactions) => transactions.isNotEmpty
              ? SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              sliver: SliverList.separated(
                separatorBuilder: (context, index) => Divider(
                  height: 1,
                  indent: 56,
                  color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                ),
                itemCount: transactions.length,
                itemBuilder: (context, index) => Dismissible(
                  key: Key(transactions[index].id),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) => ref.read(transactionDaoProvider).deleteTransaction(transactions[index].id),
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    decoration: BoxDecoration(
                      color: colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.delete_outline, color: colorScheme.error),
                  ),
                  child: TransactionListItem(transaction: transactions[index]),
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
            error: (err, stack) => SliverToBoxAdapter(
              child: Center(
                child: Text("Hata: $err"),
              ),
            )
          )
        ],
      ),
    );
  }
}

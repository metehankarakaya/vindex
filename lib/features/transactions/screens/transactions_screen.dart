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
    final transactionAsync = ref.watch(transactionStreamProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text(AppStrings.transactions.tr()),
            floating: true,
            snap: true,
          ),
          transactionAsync.when(
            data: (transactions) => transactions.isNotEmpty
              ? SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              sliver: SliverList.builder(
                itemCount: transactions.length,
                itemBuilder: (context, index) => Card(
                  child: TransactionListItem(transaction: transactions[index])
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

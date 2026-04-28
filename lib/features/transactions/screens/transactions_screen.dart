import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vindex/core/constants/app_strings.dart';
import 'package:vindex/core/widgets/empty_holder.dart';
import 'package:vindex/features/transactions/providers/transaction_provider.dart';

class TransactionsScreen extends ConsumerWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionAsync = ref.watch(transactionStreamProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            title: Text(AppStrings.transactions),
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
                  child: ListTile(
                    title: Text(
                      transactions[index].title.isNotEmpty ? transactions[index].title : transactions[index].category
                    ),
                  ),
                ),
              ),
            ) : SliverFillRemaining(
              hasScrollBody: false,
              child: EmptyHolder(
                iconData: Icons.receipt_long_outlined,
                title: AppStrings.noTransactionsYes,
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

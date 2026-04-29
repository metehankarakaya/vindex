import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vindex/features/dashboard/widgets/balance_card.dart';
import 'package:vindex/features/dashboard/widgets/total_balance_title.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/models/transactions_table.dart';
import '../../transactions/screens/add_transaction_modal.dart';
import '../../transactions/widgets/transaction_list_item.dart';
import '../provider/dashboard_provider.dart';
import '../widgets/transaction_summary_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentTransactions = ref.watch(recentTransactionsProvider);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: Text("Vindex"),
            ),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 8.0, 0.0, 8.0),
                    child: TotalBalanceTitle(),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 8.0, 0.0, 8.0),
                    child: BalanceCard(),
                  ),
                  Row(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16.0, 8.0, 8.0, 16.0),
                        child: TransactionSummaryCard(type: TransactionType.income),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8.0, 8.0, 16.0, 16.0),
                        child: TransactionSummaryCard(type: TransactionType.expense),
                      )
                    ],
                  ),
                  Text(AppStrings.recentTransactions.tr(), style: Theme.of(context).textTheme.headlineSmall,),
                ],
              ),
            ),
            SliverList.builder(
              itemCount: recentTransactions.length,
              itemBuilder: (context, index) => TransactionListItem(
                transaction: recentTransactions[index],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => AddTransactionModal.show(context),
        child: Icon(Icons.add),
      ),
    );
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vindex/features/dashboard/widgets/balance_card.dart';
import 'package:vindex/features/dashboard/widgets/total_balance_title.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/models/transactions_table.dart';
import '../../../core/widgets/empty_holder.dart';
import '../../transactions/screens/add_transaction_modal.dart';
import '../../transactions/widgets/transaction_list_item.dart';
import '../provider/dashboard_provider.dart';
import '../widgets/transaction_summary_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final recentTransactions = ref.watch(recentTransactionsProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120.0,
            pinned: true,
            stretch: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: false,
              stretchModes: const [StretchMode.zoomBackground],
              titlePadding: const EdgeInsetsDirectional.only(start: 16, bottom: 16),
              title: Text(
                "Vindex",
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      colorScheme.primary.withValues(alpha: 0.03),
                      theme.scaffoldBackgroundColor,
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 8.0, 0.0, 2.0),
                  child: TotalBalanceTitle(),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 2.0, 0.0, 8.0),
                  child: BalanceCard(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16.0, 8.0, 4.0, 16.0),
                        child: TransactionSummaryCard(type: TransactionType.income),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(4.0, 8.0, 16.0, 16.0),
                        child: TransactionSummaryCard(type: TransactionType.expense),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            sliver: SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0, top: 16.0),
                child: Text(
                  AppStrings.recentTransactions.tr(),
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          recentTransactions.isNotEmpty
          ? SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            sliver: SliverList.separated(
              separatorBuilder: (context, index) => Divider(
                height: 1,
                indent: 70,
                color: colorScheme.outlineVariant.withValues(alpha: 0.3),
              ),
              itemCount: recentTransactions.length,
              itemBuilder: (context, index) => TransactionListItem(
                transaction: recentTransactions[index],
              ),
            ),
          ) : SliverFillRemaining(
            hasScrollBody: false,
            child: EmptyHolder(
              iconData: Icons.receipt_long_outlined,
              title: AppStrings.noTransactionsYet.tr(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => AddTransactionModal.show(context),
        child: Icon(Icons.add),
      ),
    );
  }
}

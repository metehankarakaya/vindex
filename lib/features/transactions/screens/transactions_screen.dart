import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vindex/core/constants/app_strings.dart';
import 'package:vindex/core/widgets/empty_holder.dart';
import 'package:vindex/features/transactions/providers/transaction_provider.dart';
import 'package:vindex/features/transactions/widgets/transaction_list_item.dart';

class TransactionsScreen extends ConsumerStatefulWidget {
  const TransactionsScreen({super.key});

  @override
  TransactionsScreenState createState() => TransactionsScreenState();
}

class TransactionsScreenState extends ConsumerState<TransactionsScreen> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
    super.dispose();
  }

  bool _showBackToTop = false;

  void _onScroll() {
    if (_scrollController.offset > 300 && !_showBackToTop) {
      setState(() => _showBackToTop = true);
    } else if (_scrollController.offset <= 300 && _showBackToTop) {
      setState(() => _showBackToTop = false);
    }
    final asyncTransactions = ref.read(transactionStreamProvider);

    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      if (!asyncTransactions.isLoading && !asyncTransactions.isRefreshing) {
        ref.read(transactionPageProvider.notifier).update((state) => state + 1);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final transactionAsync = ref.watch(transactionStreamProvider);

    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            expandedHeight: 100.0,
            pinned: true,
            stretch: true,
            backgroundColor: theme.scaffoldBackgroundColor,
            surfaceTintColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(AppStrings.transactions.tr(), style: theme.textTheme.titleMedium),
              titlePadding: const EdgeInsetsDirectional.only(start: 16, bottom: 16),
              centerTitle: false,
            ),
          ),
          transactionAsync.when(
            skipLoadingOnReload: true,
            data: (transactions) =>
            transactions.isNotEmpty
            ? SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            sliver: SliverList.separated(
              separatorBuilder: (context, index) => Divider(
                height: 1,
                indent: 56,
                color: colorScheme.outlineVariant.withValues(alpha: 0.3),
              ),
              itemCount: transactions.length,
              itemBuilder: (context, index) =>
                Dismissible(
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
                    child: Icon(
                      Icons.delete_outline, color: colorScheme.error),
                  ),
                  child: TransactionListItem(transaction: transactions[index]),),
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
      floatingActionButton: _showBackToTop
      ? FloatingActionButton(
        onPressed: () {
          _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        },
        child: Icon(Icons.arrow_upward_outlined),
      ) : null,
    );
  }
}

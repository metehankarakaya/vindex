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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final recurringTransactionAsync = ref.watch(recurringTransactionStreamProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 100.0,
            pinned: true,
            stretch: true,
            backgroundColor: theme.scaffoldBackgroundColor,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(AppStrings.recurring.tr(), style: theme.textTheme.titleMedium),
              titlePadding: const EdgeInsetsDirectional.only(start: 16, bottom: 16),
              centerTitle: false,
            ),
          ),
          recurringTransactionAsync.when(
            data: (recurringTransactions) => recurringTransactions.isNotEmpty
              ? SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              sliver: SliverList.separated(
                separatorBuilder: (context, index) => Divider(
                  height: 1,
                  indent: 56,
                  color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                ),
                itemCount: recurringTransactions.length,
                itemBuilder: (context, index) => Dismissible(
                  key: Key(recurringTransactions[index].id),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) => ref.read(recurringTransactionDaoProvider).deleteRecurringTransaction(recurringTransactions[index].id),
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    decoration: BoxDecoration(
                      color: colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.delete_outline, color: colorScheme.error),
                  ),
                  child: RecurringTransactionListItem(recurringTransaction: recurringTransactions[index]),
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
                child: CircularProgressIndicator(
                  semanticsLabel: AppStrings.loading.tr(),
                ),
              ),
            ),
            error: (err, stackTrace) => SliverToBoxAdapter(
              child: Center(
                child: Text(AppStrings.loadError.tr(namedArgs: {'error': err.toString()})),
              ),
            ),
          )
        ],
      ),
    );
  }
}

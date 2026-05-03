import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vindex/core/constants/app_strings.dart';
import 'package:vindex/features/stats/providers/stats_provider.dart';
import 'package:vindex/features/stats/widgets/category_stats.dart';
import 'package:vindex/features/stats/widgets/stats_summary_card.dart';
import 'package:vindex/features/stats/widgets/transactions_summary_card.dart';

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final selectedPeriod = ref.watch(selectedPeriodProvider);
    final categoryMap = ref.watch(categoryBreakdownProvider);
    final totalExpense = ref.watch(statsExpenseProvider);

    final sortedEntries = categoryMap.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 100.0,
            pinned: true,
            stretch: true,
            backgroundColor: theme.scaffoldBackgroundColor,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(AppStrings.stats.tr(), style: theme.textTheme.titleMedium),
              titlePadding: const EdgeInsetsDirectional.only(start: 56, bottom: 16),
              centerTitle: false,
              background: Container(color: theme.scaffoldBackgroundColor),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              child: SegmentedButton<StatsPeriod>(
                selected: {selectedPeriod},
                segments: [
                  ButtonSegment(value: StatsPeriod.week, label: Text(AppStrings.weekly.tr())),
                  ButtonSegment(value: StatsPeriod.month, label: Text(AppStrings.monthly.tr())),
                  ButtonSegment(value: StatsPeriod.year, label: Text(AppStrings.yearly.tr())),
                ],
                onSelectionChanged: (newSelection) {
                  ref.read(selectedPeriodProvider.notifier).state = newSelection.first;
                },
                showSelectedIcon: false,
                style: SegmentedButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: StatsSummaryCard(),
            ),
          ),
          categoryMap.isNotEmpty
          ? SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
            sliver: SliverToBoxAdapter(
              child: Text(
                AppStrings.categoryDistribution.tr().toUpperCase(),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                  color: colorScheme.primary.withValues(alpha: 0.8),
                ),
              ),
            ),
          ) : SliverToBoxAdapter(child: const SizedBox(),),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final entry = sortedEntries[index];
                  return CategoryStats(
                    category: entry.key,
                    amountCents: entry.value,
                    totalExpenseCents: totalExpense,
                  );
                },
                childCount: sortedEntries.length,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 40),
            sliver: SliverToBoxAdapter(
              child: TransactionsSummaryCard(),
            ),
          ),
        ],
      ),
    );
  }
}

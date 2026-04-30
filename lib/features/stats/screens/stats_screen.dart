import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vindex/core/constants/app_strings.dart';
import 'package:vindex/features/stats/providers/stats_provider.dart';
import 'package:vindex/features/stats/widgets/category_stats.dart';
import 'package:vindex/features/stats/widgets/stats_summary_card.dart';

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final selectedPeriod = ref.watch(selectedPeriodProvider);
    final category = ref.watch(categoryBreakdownProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 100.0,
            pinned: true,
            stretch: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(AppStrings.stats.tr(), style: theme.textTheme.titleMedium),
              titlePadding: const EdgeInsetsDirectional.only(start: 16, bottom: 16),
              centerTitle: false,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              child: SegmentedButton<StatsPeriod>(
                selected: {selectedPeriod},
                segments: [
                  ButtonSegment(value: StatsPeriod.week, label: Text(AppStrings.weekly)),
                  ButtonSegment(value: StatsPeriod.month, label: Text(AppStrings.monthly)),
                  ButtonSegment(value: StatsPeriod.year, label: Text(AppStrings.yearly)),
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
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: StatsSummaryCard()
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
            sliver: SliverToBoxAdapter(
              child: Text(
                AppStrings.categoryDistribution.tr().toUpperCase(),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.5,
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.7),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                category.entries.map((entry) => CategoryStats(
                  category: entry.key,
                  amountCents: entry.value,
                  totalExpenseCents: ref.watch(statsExpenseProvider),
                )).toList(),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }
}

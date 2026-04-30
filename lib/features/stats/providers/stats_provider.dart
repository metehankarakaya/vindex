import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/transactions_table.dart';
import '../../../database/app_database.dart';
import '../../recurrings/providers/recurring_transaction_provider.dart';
import '../../transactions/providers/transaction_provider.dart';

enum StatsPeriod { week, month, year }

final selectedPeriodProvider = StateProvider<StatsPeriod>((ref) => StatsPeriod.month);

final filteredTransactionsProvider = Provider<List<Transaction>>((ref) {
  final transactionsAsync = ref.watch(transactionStreamProvider);
  final period = ref.watch(selectedPeriodProvider);

  return transactionsAsync.when(
    data: (transactions) {
      final now = DateTime.now();
      final start = switch (period) {
        StatsPeriod.week => now.subtract(const Duration(days: 7)),
        StatsPeriod.month => DateTime(now.year, now.month, 1),
        StatsPeriod.year => DateTime(now.year, 1, 1),
      };
      return transactions.where((t) => t.createdAt.isAfter(start)).toList();
    },
    loading: () => [],
    error: (_, __) => [],
  );
});

final statsIncomeProvider = Provider<int>((ref) {
  final transactions = ref.watch(filteredTransactionsProvider);
  return transactions
    .where((t) => t.type == TransactionType.income)
    .fold(0, (sum, t) => sum + t.amountCents);
});

final statsExpenseProvider = Provider<int>((ref) {
  final transactions = ref.watch(filteredTransactionsProvider);
  return transactions
    .where((t) => t.type == TransactionType.expense)
    .fold(0, (sum, t) => sum + t.amountCents);
});

final categoryBreakdownProvider = Provider<Map<String, int>>((ref) {
  final transactions = ref.watch(filteredTransactionsProvider);
  final Map<String, int> breakdown = {};
  for (final t in transactions.where((t) => t.type == TransactionType.expense)) {
    breakdown[t.category] = (breakdown[t.category] ?? 0) + t.amountCents;
  }
  return breakdown;
});

final instantTransactionCountProvider = StreamProvider<int>((ref) {
  return ref.watch(transactionDaoProvider).watchTransactionCount();
});

final recurringTransactionCountProvider = Provider<int>((ref) {
  return ref.watch(recurringTransactionStreamProvider).valueOrNull?.length ?? 0;
});

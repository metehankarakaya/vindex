import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/transactions_table.dart';
import '../../../database/app_database.dart';
import '../../transactions/providers/transaction_provider.dart';

final totalBalanceProvider = Provider<int>((ref) {
  final transactionsAsync = ref.watch(transactionStreamProvider);
  return transactionsAsync.when(
    data: (transactions) {
      final income = transactions
          .where((t) => t.type == TransactionType.income)
          .fold(0, (sum, t) => sum + t.amountCents);
      final expense = transactions
          .where((t) => t.type == TransactionType.expense)
          .fold(0, (sum, t) => sum + t.amountCents);
      return income - expense;
    },
    loading: () => 0,
    error: (_, __) => 0,
  );
});

final totalIncomeProvider = Provider<int>((ref) {
  final transactionsAsync = ref.watch(transactionStreamProvider);
  return transactionsAsync.when(
    data: (transactions) {
      final income = transactions
          .where((t) => t.type == TransactionType.income)
          .fold(0, (sum, t) => sum + t.amountCents);
      return income;
    },
    loading: () => 0,
    error: (_, __) => 0,
  );
});

final totalExpenseProvider = Provider<int>((ref) {
  final transactionsAsync = ref.watch(transactionStreamProvider);
  return transactionsAsync.when(
    data: (transactions) {
      final expense = transactions
          .where((t) => t.type == TransactionType.expense)
          .fold(0, (sum, t) => sum + t.amountCents);
      return expense;
    },
    loading: () => 0,
    error: (_, __) => 0,
  );
});

final recentTransactionsProvider = Provider<List<Transaction>>((ref) {
  final transactionsAsync = ref.watch(transactionStreamProvider);
  return transactionsAsync.when(
    data: (transactions) => transactions.take(10).toList(),
    loading: () => [],
    error: (_, __) => [],
  );
});


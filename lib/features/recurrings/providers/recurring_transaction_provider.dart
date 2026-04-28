import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/database_provider.dart';
import '../../../database/app_database.dart';
import '../../../database/daos/recurring_transactions_dao.dart';

final recurringTransactionDaoProvider = Provider<RecurringTransactionsDao>((ref) {
  return ref.watch(databaseProvider).recurringTransactionsDao;
});

final recurringTransactionStreamProvider = StreamProvider<List<RecurringTransaction>>((ref) {
  return ref.watch(recurringTransactionDaoProvider).getAllRecurringTransactions();
});

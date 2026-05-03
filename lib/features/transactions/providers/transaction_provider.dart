import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/database_provider.dart';
import '../../../database/app_database.dart';
import '../../../database/daos/transactions_dao.dart';

final transactionDaoProvider = Provider<TransactionsDao>((ref) {
  return ref.watch(databaseProvider).transactionsDao;
});

final transactionStreamProvider = StreamProvider<List<Transaction>>((ref) {
  final page = ref.watch(transactionPageProvider);
  return ref.watch(transactionDaoProvider).getAllTransactions(limit: page * 20);
});

final transactionPageProvider = StateProvider.autoDispose<int>((ref) => 1);

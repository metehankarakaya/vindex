import 'package:drift/drift.dart';
import 'package:vindex/database/app_database.dart';

import '../../core/models/transactions_table.dart';

part 'transactions_dao.g.dart';

@DriftAccessor(tables: [Transactions])
class TransactionsDao extends DatabaseAccessor<AppDatabase> with _$TransactionsDaoMixin {
  TransactionsDao(super.db);

  Stream<List<Transaction>> getTransactionsByDateRange(DateTime start) {
    return (select(transactions)
      ..where((t) => t.createdAt.isBiggerOrEqualValue(start))
      ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
    ).watch();
  }

  Stream<int> watchTransactionCount() {
    return (selectOnly(transactions)..addColumns([countAll()]))
        .map((row) => row.read(countAll())!)
        .watchSingle();
  }

  Stream<List<Transaction>> getAllTransactions({int? limit}) {
    final query = select(transactions)
    ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]);

    if (limit != null) query.limit(limit);

    return query.watch();
  }

  Future<int> insertTransaction(TransactionsCompanion entry) {
    return into(transactions).insert(entry);
  }

  Future<bool> updateTransaction(TransactionsCompanion entry) {
    return update(transactions).replace(entry);
  }

  Future<int> deleteTransaction(String id) {
    return (delete(transactions)..where((t) => t.id.equals(id))).go();
  }

  Future<void> deleteAllTransactions() {
    return delete(transactions).go();
  }

}

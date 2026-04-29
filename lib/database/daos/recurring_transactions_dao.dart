import 'package:drift/drift.dart';
import 'package:vindex/database/app_database.dart';

import '../../core/models/recurring_transaction_table.dart';

part 'recurring_transactions_dao.g.dart';

@DriftAccessor(tables: [RecurringTransactions])
class RecurringTransactionsDao extends DatabaseAccessor<AppDatabase> with _$RecurringTransactionsDaoMixin {
  RecurringTransactionsDao(super.db);

  Stream<List<RecurringTransaction>> getAllRecurringTransactions() {
    return (select(recurringTransactions)..orderBy([(r) => OrderingTerm.desc(r.startDate)])).watch();
  }

  Future<int> insertRecurringTransactions(RecurringTransactionsCompanion entry) {
    return into(recurringTransactions).insert(entry);
  }

  Future<bool> updateRecurringTransaction(RecurringTransactionsCompanion entry) {
    return update(recurringTransactions).replace(entry);
  }

  Future<int> deleteRecurringTransaction(String id) {
    return (delete(recurringTransactions)..where((r) => r.id.equals(id))).go();
  }

}

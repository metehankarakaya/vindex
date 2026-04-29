import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import 'package:vindex/database/app_database.dart';

import '../../core/models/recurring_transaction_table.dart';
import '../../core/models/transactions_table.dart';

part 'recurring_transactions_dao.g.dart';

@DriftAccessor(tables: [RecurringTransactions, Transactions])
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

  Future<void> deleteAllRecurringTransactions() {
    return delete(recurringTransactions).go();
  }

  Future<void> processRecurringTransactions() async {
    final now = DateTime.now();

    final actives = await (select(recurringTransactions)
    ..where((r) => r.isActive.equals(true))).get();

    for (final recurring in actives) {
      int periodsElapsed = 0;
      final lastProcess = recurring.lastProcessDate ?? recurring.startDate;
      final daysDiff = now.difference(lastProcess).inDays;
      if (recurring.endDate != null && now.isAfter(recurring.endDate!)) {
        continue;
      }
      switch (recurring.frequency) {
        case RecurringFrequency.daily:
          periodsElapsed = daysDiff;
          break;
        case RecurringFrequency.weekly:
          periodsElapsed = daysDiff ~/ 7;
          break;
        case RecurringFrequency.monthly:
          periodsElapsed = (now.year - lastProcess.year) * 12 + (now.month - lastProcess.month);
          break;
        case RecurringFrequency.yearly:
          periodsElapsed = now.year - lastProcess.year;
          break;
      }
      if (periodsElapsed > 0) {
        for (int i = 0; i < periodsElapsed; i++) {
          await into(transactions).insert(
            TransactionsCompanion(
              id: Value(const Uuid().v4()),
              title: Value(recurring.title),
              amountCents: Value(recurring.amountCents),
              category: Value(recurring.category),
              type: Value(recurring.type),
              createdAt: Value(now),
            )
          );
        }
        await (update(recurringTransactions)
        ..where((r) => r.id.equals(recurring.id)))
        .write(RecurringTransactionsCompanion(
          lastProcessDate: Value(now)
        ));
      }

    }

  }

}

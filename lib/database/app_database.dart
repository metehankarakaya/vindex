import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:vindex/database/daos/recurring_transactions_dao.dart';
import 'package:vindex/database/daos/transactions_dao.dart';

import '../core/models/recurring_transaction_table.dart';
import '../core/models/transactions_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Transactions, RecurringTransactions])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'vindex_db'));

  @override
  int get schemaVersion => 1;

  late final transactionsDao = TransactionsDao(this);
  late final recurringTransactionsDao = RecurringTransactionsDao(this);

}

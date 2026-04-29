// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recurring_transactions_dao.dart';

// ignore_for_file: type=lint
mixin _$RecurringTransactionsDaoMixin on DatabaseAccessor<AppDatabase> {
  $RecurringTransactionsTable get recurringTransactions =>
      attachedDatabase.recurringTransactions;
  $TransactionsTable get transactions => attachedDatabase.transactions;
  RecurringTransactionsDaoManager get managers =>
      RecurringTransactionsDaoManager(this);
}

class RecurringTransactionsDaoManager {
  final _$RecurringTransactionsDaoMixin _db;
  RecurringTransactionsDaoManager(this._db);
  $$RecurringTransactionsTableTableManager get recurringTransactions =>
      $$RecurringTransactionsTableTableManager(
        _db.attachedDatabase,
        _db.recurringTransactions,
      );
  $$TransactionsTableTableManager get transactions =>
      $$TransactionsTableTableManager(_db.attachedDatabase, _db.transactions);
}

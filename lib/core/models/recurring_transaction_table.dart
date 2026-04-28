import 'package:drift/drift.dart';
import 'package:vindex/core/models/transactions_table.dart';

enum RecurringFrequency { daily, weekly, monthly, yearly }

class RecurringTransactions extends Table {
  TextColumn get id => text()();
  TextColumn get title => text().withLength(min: 0, max: 50)();
  IntColumn get amountCents => integer()();
  TextColumn get category => text().withDefault(const Constant('General'))();
  DateTimeColumn get lastProcessDate => dateTime().nullable()();
  DateTimeColumn get startDate => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get endDate => dateTime().nullable()();
  IntColumn get frequency => intEnum<RecurringFrequency>()();
  IntColumn get type => intEnum<TransactionType>()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}

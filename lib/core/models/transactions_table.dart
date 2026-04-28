import 'package:drift/drift.dart';

enum TransactionType { income, expense }

class Transactions extends Table {
  TextColumn get id => text()();
  TextColumn get title => text().withLength(min: 0, max: 50)();
  IntColumn get amountCents => integer()();
  TextColumn get category => text().withDefault(const Constant('General'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  IntColumn get type => intEnum<TransactionType>()();

  @override
  Set<Column> get primaryKey => {id};
}

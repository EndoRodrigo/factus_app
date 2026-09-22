import 'package:drift/drift.dart';

@DataClassName('ProductTableData')
class Products extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  TextColumn get code => text()();

  RealColumn get price => real()();

  RealColumn get taxRate => real().withDefault(const Constant(0))();

  TextColumn get description => text().nullable()();

  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();
}

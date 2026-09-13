import 'package:drift/drift.dart';

@DataClassName('EstablishmentTableData')
class Establishments extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  TextColumn get nit => text()();

  TextColumn get email => text()();

  TextColumn get phone => text()();

  TextColumn get address => text()();

  TextColumn get municipalityCode => text().nullable()();

  TextColumn get municipalityName => text().nullable()();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime).nullable()();

  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime).nullable()();
}
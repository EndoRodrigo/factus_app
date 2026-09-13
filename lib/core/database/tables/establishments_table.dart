import 'package:drift/drift.dart';

@DataClassName('EstablishmentTableData')
class Establishments extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  TextColumn get nit => text()();

  TextColumn get email => text()();

  TextColumn get phone => text()();

  TextColumn get address => text()();

  IntColumn get municipalityId => integer()();

  TextColumn get municipalityName => text()();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();
}
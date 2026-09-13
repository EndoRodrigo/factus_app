import 'package:drift/drift.dart';

import 'tables/establishments_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Establishments,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

QueryExecutor _openConnection() {
  throw UnimplementedError();
}
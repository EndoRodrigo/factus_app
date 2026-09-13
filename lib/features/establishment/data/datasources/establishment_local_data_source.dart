import '../../../../core/database/app_database.dart';

class EstablishmentLocalDataSource {
  final AppDatabase database;

  EstablishmentLocalDataSource(this.database);

  Future<List<EstablishmentTableData>> getEstablishments() {
    return database.select(database.establishments).get();
  }

  Future<EstablishmentTableData?> getEstablishment() async {
    final establishments = await database.select(
      database.establishments,
    ).get();

    if (establishments.isEmpty) {
      return null;
    }

    return establishments.first;
  }

  Future<int> createEstablishment(
      EstablishmentsCompanion establishment,
      ) {
    return database.into(database.establishments).insert(establishment);
  }

  Future<bool> updateEstablishment(
      EstablishmentTableData establishment,
      ) {
    return database.update(database.establishments).replace(establishment);
  }

  Future<int> deleteEstablishment(int id) {
    return (database.delete(
      database.establishments,
    )..where((table) => table.id.equals(id))).go();
  }
}

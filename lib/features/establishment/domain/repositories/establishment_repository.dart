import '../../../../core/database/app_database.dart';

abstract class EstablishmentRepository {
  Future<Establishment?> getEstablishment();

  Future<void> createEstablishment(Establishment establishment);

  Future<void> updateEstablishment(Establishment establishment);

  Future<void> deleteEstablishment(int id);
}
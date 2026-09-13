
import '../../../../core/database/app_database.dart';
import '../../domain/repositories/establishment_repository.dart';
import '../datasources/establishment_local_data_source.dart';
import '../models/establishment_model.dart';

class EstablishmentRepositoryImpl implements EstablishmentRepository {
  final EstablishmentLocalDataSource localDataSource;

  EstablishmentRepositoryImpl(this.localDataSource);

  @override
  Future<Establishment?> getEstablishment() async {
    final result = await localDataSource.getEstablishment();

    if (result == null) {
      return null;
    }

    return EstablishmentModel.fromDrift(result).toEntity();
  }

  @override
  Future<void> createEstablishment(
      Establishment establishment,
      ) async {
    final companion = EstablishmentsCompanion.insert(
      name: establishment.name,
      nit: establishment.nit,
      email: establishment.email,
      phone: establishment.phone,
      address: establishment.address,
      municipalityId: establishment.municipalityId,
      municipalityName: establishment.municipalityName,
    );

    await localDataSource.createEstablishment(companion);
  }

  @override
  Future<void> updateEstablishment(
      Establishment establishment,
      ) async {
    if (establishment.id == null) {
      throw ArgumentError(
        'No se puede actualizar un establecimiento sin id',
      );
    }

    final companion = EstablishmentData(
      id: establishment.id!,
      name: establishment.name,
      nit: establishment.nit,
      email: establishment.email,
      phone: establishment.phone,
      address: establishment.address,
      municipalityId: establishment.municipalityId,
      municipalityName: establishment.municipalityName,
      createdAt: establishment.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await localDataSource.updateEstablishment(companion);
  }

  @override
  Future<void> deleteEstablishment(int id) async {
    await localDataSource.deleteEstablishment(id);
  }
}
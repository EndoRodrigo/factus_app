import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart';
import '../../domain/entities/establishment.dart';
import '../../domain/repositories/establishment_repository.dart';
import '../datasources/establishment_local_data_source.dart';
import '../mappers/establishment_mapper.dart';

class EstablishmentRepositoryImpl implements EstablishmentRepository {
  final EstablishmentLocalDataSource localDataSource;

  EstablishmentRepositoryImpl(this.localDataSource);

  @override
  Future<Establishment?> getEstablishment() async {
    final result = await localDataSource.getEstablishment();
    if (result == null) return null;
    return EstablishmentMapper.toEntity(result);
  }

  @override
  Future<void> createEstablishment(Establishment establishment) async {
    final companion = EstablishmentsCompanion.insert(
      name: establishment.name,
      nit: establishment.nit,
      email: establishment.email,
      phone: establishment.phone,
      address: establishment.address,
      municipalityCode: Value(establishment.municipalityCode),
      municipalityName: Value(establishment.municipalityName),
    );

    await localDataSource.createEstablishment(companion);
  }

  @override
  Future<void> updateEstablishment(Establishment establishment) async {
    final id = establishment.id;
    if (id == null) {
      throw ArgumentError('No se puede actualizar un establecimiento sin id');
    }

    final data = EstablishmentTableData(
      id: id,
      name: establishment.name,
      nit: establishment.nit,
      email: establishment.email,
      phone: establishment.phone,
      address: establishment.address,
      municipalityCode: establishment.municipalityCode,
      municipalityName: establishment.municipalityName,
      createdAt: establishment.createdAt,
      updatedAt: DateTime.now(),
    );

    await localDataSource.updateEstablishment(data);
  }

  @override
  Future<void> deleteEstablishment(int id) async {
    await localDataSource.deleteEstablishment(id);
  }
}

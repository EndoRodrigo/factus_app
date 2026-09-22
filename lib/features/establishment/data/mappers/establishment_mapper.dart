import '../../../../core/database/app_database.dart';
import '../../domain/entities/establishment.dart';

class EstablishmentMapper {
  static Establishment toEntity(EstablishmentTableData data) {
    return Establishment(
      id: data.id,
      name: data.name,
      nit: data.nit,
      email: data.email,
      phone: data.phone,
      address: data.address,
      municipalityCode: data.municipalityCode ?? '',
      municipalityName: data.municipalityName ?? '',
      createdAt: data.createdAt,
      updatedAt: data.updatedAt,
    );
  }
}

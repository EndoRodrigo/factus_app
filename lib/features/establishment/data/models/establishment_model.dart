import '../../../../core/database/app_database.dart';
import '../../domain/entities/establishment.dart';

class EstablishmentModel {
  final int id;
  final String name;
  final String nit;
  final String email;
  final String phone;
  final String address;
  final String municipalityCode;
  final String municipalityName;
  final DateTime createdAt;
  final DateTime updatedAt;

  const EstablishmentModel({
    required this.id,
    required this.name,
    required this.nit,
    required this.email,
    required this.phone,
    required this.address,
    required this.municipalityCode,
    required this.municipalityName,
    required this.createdAt,
    required this.updatedAt,
  });

  factory EstablishmentModel.fromDrift(EstablishmentTableData data) {
    return EstablishmentModel(
      id: data.id,
      name: data.name,
      nit: data.nit,
      email: data.email,
      phone: data.phone,
      address: data.address,
      municipalityCode: data.municipalityCode ?? '',
      municipalityName: data.municipalityName ?? '',
      createdAt: data.createdAt ?? DateTime.now(),
      updatedAt: data.updatedAt ?? DateTime.now(),
    );
  }

  Establishment toEntity() {
    return Establishment(
      id: id,
      name: name,
      nit: nit,
      email: email,
      phone: phone,
      address: address,
      municipalityCode: municipalityCode,
      municipalityName: municipalityName,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

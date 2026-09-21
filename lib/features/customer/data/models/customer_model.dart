import '../../domain/entities/customer.dart';

class CustomerModel {
  final int? id;
  final String identification;
  final String identificationType;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String municipalityCode;
  final String municipalityName;

  const CustomerModel({
    this.id,
    required this.identification,
    required this.identificationType,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.municipalityCode,
    required this.municipalityName,
  });

  Customer toEntity() {
    return Customer(
      id: id,
      identification: identification,
      identificationType: identificationType,
      name: name,
      email: email,
      phone: phone,
      address: address,
      municipalityCode: municipalityCode,
      municipalityName: municipalityName,
    );
  }
}
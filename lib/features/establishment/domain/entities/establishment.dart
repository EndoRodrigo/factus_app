class Establishment {
  final int? id;
  final String name;
  final String nit;
  final String email;
  final String phone;
  final String address;
  final int municipalityId;
  final String municipalityName;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Establishment({
    this.id,
    required this.name,
    required this.nit,
    required this.email,
    required this.phone,
    required this.address,
    required this.municipalityId,
    required this.municipalityName,
    this.createdAt,
    this.updatedAt,
  });
}
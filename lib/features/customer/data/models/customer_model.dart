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

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['id'] as int?,
      identification: json['identification']?.toString() ?? '',
      identificationType: json['identification_document_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      municipalityCode: json['municipality_code']?.toString() ?? '',
      municipalityName: json['municipality']?.toString() ?? '',
    );
  }
}

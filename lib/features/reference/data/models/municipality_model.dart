import '../../domain/entities/municipality.dart';

class MunicipalityModel {
  final String code;
  final String name;
  final String departmentCode;
  final String departmentName;

  const MunicipalityModel({
    required this.code,
    required this.name,
    required this.departmentCode,
    required this.departmentName,
  });

  factory MunicipalityModel.fromJson(Map<String, dynamic> json) {
    String depCode = '';
    String depName = '';

    final department = json['department'];
    if (department is Map<String, dynamic>) {
      depCode = department['code']?.toString() ?? '';
      depName = department['name']?.toString() ?? '';
    } else if (department is String) {
      depName = department;
    }

    return MunicipalityModel(
      code: json['code']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      departmentCode: depCode,
      departmentName: depName,
    );
  }

  Municipality toEntity() {
    return Municipality(
      code: code,
      name: name,
      departmentCode: departmentCode,
      departmentName: departmentName,
    );
  }
}

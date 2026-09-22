import '../../domain/entities/customer.dart';
import '../models/customer_model.dart';

class CustomerMapper {
  static Customer toEntity(CustomerModel model) {
    return Customer(
      id: model.id,
      identification: model.identification,
      identificationType: model.identificationType,
      name: model.name,
      email: model.email,
      phone: model.phone,
      address: model.address,
      municipalityCode: model.municipalityCode,
      municipalityName: model.municipalityName,
    );
  }
}

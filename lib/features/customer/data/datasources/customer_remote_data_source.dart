import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../models/customer_model.dart';

class CustomerRemoteDataSource {
  final Dio dio;

  CustomerRemoteDataSource(this.dio);

  Future<CustomerModel> getCustomer({
    required String identificationDocumentCode,
    required String identificationNumber,
  }) async {
    final response = await dio.get(
      ApiConstants.acquirerEndpoint,
      queryParameters: {
        'identification_document_id': identificationDocumentCode,
        'identification_number': identificationNumber,
      },
    );

    final data = response.data['data'];
    
    if (data == null || data is! Map) {
      throw Exception('Cliente no encontrado');
    }

    return CustomerModel(
      identification: identificationNumber,
      identificationType: identificationDocumentCode,
      name: data['name']?.toString() ?? 'Sin nombre',
      email: data['email']?.toString() ?? 'Sin email',
      phone: '',
      address: '',
      municipalityCode: '',
      municipalityName: '',
    );
  }
}
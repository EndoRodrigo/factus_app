import 'package:dio/dio.dart';
import '../../../../core/exceptions/app_exception.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/customer_model.dart';

class CustomerRemoteDataSource {
  final Dio dio;

  CustomerRemoteDataSource(this.dio);

  Future<CustomerModel> getCustomer({
    required String identificationDocumentCode,
    required String identificationNumber,
  }) async {
    try {
      final response = await dio.get(
        ApiConstants.acquirerEndpoint,
        queryParameters: {
          'identification_document_id': identificationDocumentCode,
          'identification_number': identificationNumber,
        },
      );

      final data = response.data['data'];
      if (data == null || data is! Map) {
        throw AppException(message: 'Cliente no encontrado');
      }

      return CustomerModel.fromJson(Map<String, dynamic>.from(data));
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    }
  }
}

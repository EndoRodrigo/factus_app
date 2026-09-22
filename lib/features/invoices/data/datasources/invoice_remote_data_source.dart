import 'package:dio/dio.dart';
import '../../../../core/exceptions/app_exception.dart';

import '../../../../core/constants/api_constants.dart';
import '../models/create_invoice_request.dart';
import '../models/invoice_pagination_model.dart';

class InvoiceRemoteDataSource {
  final Dio dio;

  InvoiceRemoteDataSource(this.dio);

  Future<InvoicePaginationModel> getInvoices({int page = 1}) async {
    try {
      final response = await dio.get(
        ApiConstants.billsEndpoint,
        queryParameters: {'page': page},
      );

      return InvoicePaginationModel.fromJson(
        response.data['data'] as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    }
  }

  Future<Map<String, dynamic>> validateInvoice(
    CreateInvoiceRequest request,
  ) async {
    try {
      final response = await dio.post(
        ApiConstants.validateBillEndpoint,
        data: request.toJson(),
      );

      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    }
  }
}

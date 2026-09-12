import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../models/invoice_pagination_model.dart';

class InvoiceRemoteDataSource {
  final Dio dio;

  InvoiceRemoteDataSource(this.dio);

  Future<InvoicePaginationModel> getInvoices({int page = 1}) async {
    final response = await dio.get(
      ApiConstants.billsEndpoint,
      queryParameters: {'page': page},
    );

    return InvoicePaginationModel.fromJson(
      response.data['data'] as Map<String, dynamic>,
    );
  }
}

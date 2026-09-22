import '../../domain/entities/invoice_pagination.dart';
import '../../domain/repositories/invoice_repository.dart';
import '../datasources/invoice_remote_data_source.dart';
import '../mappers/invoice_mapper.dart';
import '../models/create_invoice_request.dart';

class InvoiceRepositoryImpl implements InvoiceRepository {
  final InvoiceRemoteDataSource remoteDataSource;

  InvoiceRepositoryImpl(this.remoteDataSource);

  @override
  Future<InvoicePagination> getInvoices({int page = 1}) async {
    final result = await remoteDataSource.getInvoices(page: page);
    return InvoiceMapper.toPaginationEntity(result);
  }

  @override
  Future<Map<String, dynamic>> validateInvoice(CreateInvoiceRequest request) {
    return remoteDataSource.validateInvoice(request);
  }
}

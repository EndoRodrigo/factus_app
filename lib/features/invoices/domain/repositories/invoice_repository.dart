import '../../data/models/create_invoice_request.dart';
import '../entities/invoice_pagination.dart';

abstract class InvoiceRepository {
  Future<InvoicePagination> getInvoices({int page = 1});

  Future<Map<String, dynamic>> validateInvoice(CreateInvoiceRequest request);
}

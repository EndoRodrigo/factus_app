import '../entities/invoice_pagination.dart';

abstract class InvoiceRepository {
  Future<InvoicePagination> getInvoices({int page = 1});
}

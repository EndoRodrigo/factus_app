import '../entities/invoice_pagination.dart';
import '../repositories/invoice_repository.dart';

class GetInvoicesUseCase {
  final InvoiceRepository repository;

  GetInvoicesUseCase(this.repository);

  Future<InvoicePagination> call({int page = 1}) {
    return repository.getInvoices(page: page);
  }
}

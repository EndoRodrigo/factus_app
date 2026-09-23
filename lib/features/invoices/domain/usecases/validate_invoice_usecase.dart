import '../../data/models/create_invoice_request.dart';
import '../repositories/invoice_repository.dart';

class ValidateInvoiceUseCase {
  final InvoiceRepository repository;

  ValidateInvoiceUseCase(this.repository);

  Future<Map<String, dynamic>> call(CreateInvoiceRequest request) {
    return repository.validateInvoice(request);
  }
}

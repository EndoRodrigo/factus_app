import '../entities/customer.dart';
import '../repositories/customer_repository.dart';

class GetCustomerUseCase {
  final CustomerRepository repository;

  GetCustomerUseCase(this.repository);

  Future<Customer> call({
    required String identificationDocumentCode,
    required String identificationNumber,
  }) {
    return repository.getCustomer(
      identificationDocumentCode: identificationDocumentCode,
      identificationNumber: identificationNumber,
    );
  }
}

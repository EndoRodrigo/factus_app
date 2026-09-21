import '../entities/customer.dart';

abstract class CustomerRepository {
  Future<Customer> getCustomer({
    required String identificationDocumentCode,
    required String identificationNumber,
  });
}

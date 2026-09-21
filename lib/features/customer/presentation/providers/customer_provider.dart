import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/datasources/customer_remote_data_source.dart';
import '../../data/repositories/customer_repository_impl.dart';
import '../../domain/entities/customer.dart';
import '../../domain/repositories/customer_repository.dart';

final customerRemoteDataSourceProvider = Provider<CustomerRemoteDataSource>((
  ref,
) {
  final apiClient = ref.watch(apiClientProvider);

  return CustomerRemoteDataSource(apiClient.dio);
});

final customerRepositoryProvider = Provider<CustomerRepository>((ref) {
  final remoteDataSource = ref.watch(customerRemoteDataSourceProvider);

  return CustomerRepositoryImpl(remoteDataSource);
});

final customerProvider = FutureProvider.family<Customer, CustomerQuery>((
  ref,
  query,
) async {
  final repository = ref.watch(customerRepositoryProvider);

  return repository.getCustomer(
    identificationDocumentCode: query.identificationDocumentCode,
    identificationNumber: query.identificationNumber,
  );
});

class CustomerQuery {
  final String identificationDocumentCode;
  final String identificationNumber;

  const CustomerQuery({
    required this.identificationDocumentCode,
    required this.identificationNumber,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomerQuery &&
          runtimeType == other.runtimeType &&
          identificationDocumentCode == other.identificationDocumentCode &&
          identificationNumber == other.identificationNumber;

  @override
  int get hashCode =>
      identificationDocumentCode.hashCode ^ identificationNumber.hashCode;
}

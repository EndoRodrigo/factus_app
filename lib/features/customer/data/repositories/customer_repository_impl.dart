import '../../domain/entities/customer.dart';
import '../../domain/repositories/customer_repository.dart';
import '../datasources/customer_remote_data_source.dart';
import '../mappers/customer_mapper.dart';

class CustomerRepositoryImpl implements CustomerRepository {
  final CustomerRemoteDataSource remoteDataSource;

  CustomerRepositoryImpl(this.remoteDataSource);

  @override
  Future<Customer> getCustomer({
    required String identificationDocumentCode,
    required String identificationNumber,
  }) async {
    final model = await remoteDataSource.getCustomer(
      identificationDocumentCode: identificationDocumentCode,
      identificationNumber: identificationNumber,
    );

    return CustomerMapper.toEntity(model);
  }
}

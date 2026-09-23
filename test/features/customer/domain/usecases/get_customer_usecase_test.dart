import 'package:factus_app/features/customer/domain/entities/customer.dart';
import 'package:factus_app/features/customer/domain/repositories/customer_repository.dart';
import 'package:factus_app/features/customer/domain/usecases/get_customer_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCustomerRepository extends Mock implements CustomerRepository {}

void main() {
  late MockCustomerRepository mockRepository;
  late GetCustomerUseCase getCustomerUseCase;

  setUp(() {
    mockRepository = MockCustomerRepository();
    getCustomerUseCase = GetCustomerUseCase(mockRepository);
  });

  group('GetCustomerUseCase Tests', () {
    const tCustomer = Customer(
      identification: '123456789',
      identificationType: '6',
      name: 'Empresa Test S.A.S.',
      email: 'test@factus.com',
      phone: '3001234567',
      address: 'Calle 100 # 15-20',
      municipalityCode: '11001',
      municipalityName: 'Bogotá',
    );

    test('should call repository.getCustomer with correct arguments', () async {
      when(() => mockRepository.getCustomer(
            identificationDocumentCode: '6',
            identificationNumber: '123456789',
          )).thenAnswer((_) async => tCustomer);

      final result = await getCustomerUseCase(
        identificationDocumentCode: '6',
        identificationNumber: '123456789',
      );

      expect(result, equals(tCustomer));
      verify(() => mockRepository.getCustomer(
            identificationDocumentCode: '6',
            identificationNumber: '123456789',
          )).called(1);
    });
  });
}

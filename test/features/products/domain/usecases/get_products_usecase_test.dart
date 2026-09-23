import 'package:factus_app/features/products/domain/entities/product.dart';
import 'package:factus_app/features/products/domain/repositories/product_repository.dart';
import 'package:factus_app/features/products/domain/usecases/get_products_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockProductRepository extends Mock implements ProductRepository {}

void main() {
  late MockProductRepository mockRepository;
  late GetProductsUseCase getProductsUseCase;

  setUp(() {
    mockRepository = MockProductRepository();
    getProductsUseCase = GetProductsUseCase(mockRepository);
  });

  group('GetProductsUseCase Tests', () {
    final tProducts = [
      const Product(
        id: 1,
        code: 'PROD01',
        name: 'Producto Test',
        price: 50000.0,
        taxRate: 19.0,
        unitMeasureCode: '70',
        standardCode: '999',
        isActive: true,
      ),
    ];

    test('should return list of products from repository', () async {
      when(() => mockRepository.getProducts())
          .thenAnswer((_) async => tProducts);

      final result = await getProductsUseCase();

      expect(result, equals(tProducts));
      verify(() => mockRepository.getProducts()).called(1);
    });
  });
}

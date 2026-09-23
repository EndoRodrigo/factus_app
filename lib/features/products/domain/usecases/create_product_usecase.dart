import '../repositories/product_repository.dart';

class CreateProductUseCase {
  final ProductRepository repository;

  CreateProductUseCase(this.repository);

  Future<int> call({
    required String name,
    required String code,
    required double price,
    required double taxRate,
    String? description,
    required String unitMeasureCode,
    required String standardCode,
  }) {
    return repository.createProduct(
      name: name,
      code: code,
      price: price,
      taxRate: taxRate,
      description: description,
      unitMeasureCode: unitMeasureCode,
      standardCode: standardCode,
    );
  }
}

import '../repositories/product_repository.dart';

class UpdateProductUseCase {
  final ProductRepository repository;

  UpdateProductUseCase(this.repository);

  Future<bool> call({
    required int id,
    required String name,
    required String code,
    required double price,
    required double taxRate,
    String? description,
    required String unitMeasureCode,
    required String standardCode,
    required bool isActive,
  }) {
    return repository.updateProduct(
      id: id,
      name: name,
      code: code,
      price: price,
      taxRate: taxRate,
      description: description,
      unitMeasureCode: unitMeasureCode,
      standardCode: standardCode,
      isActive: isActive,
    );
  }
}

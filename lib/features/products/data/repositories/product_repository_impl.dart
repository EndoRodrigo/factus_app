import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_local_data_source.dart';
import '../mappers/product_mapper.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductLocalDataSource localDataSource;

  ProductRepositoryImpl(this.localDataSource);

  @override
  Future<List<Product>> getProducts() async {
    final products = await localDataSource.getProducts();
    return products.map(ProductMapper.toEntity).toList();
  }

  @override
  Future<Product?> getProductById(int id) async {
    final product = await localDataSource.getProductById(id);
    if (product == null) return null;
    return ProductMapper.toEntity(product);
  }

  @override
  Future<int> createProduct({
    required String name,
    required String code,
    required double price,
    required double taxRate,
    String? description,
    required String unitMeasureCode,
    required String standardCode,
  }) {
    return localDataSource.createProduct(
      name: name,
      code: code,
      price: price,
      taxRate: taxRate,
      description: description,
      unitMeasureCode: unitMeasureCode,
      standardCode: standardCode,
    );
  }

  @override
  Future<bool> updateProduct({
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
    return localDataSource.updateProduct(
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

  @override
  Future<bool> deleteProduct(int id) {
    return localDataSource.deleteProduct(id);
  }
}

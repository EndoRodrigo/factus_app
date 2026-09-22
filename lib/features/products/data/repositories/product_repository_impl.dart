import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_local_data_source.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductLocalDataSource localDataSource;

  ProductRepositoryImpl(this.localDataSource);

  @override
  Future<List<Product>> getProducts() async {
    final products = await localDataSource.getProducts();

    return products
        .map(
          (product) => Product(
            id: product.id,
            name: product.name,
            code: product.code,
            price: product.price,
            taxRate: product.taxRate,
            description: product.description,
            isActive: product.isActive,
            createdAt: product.createdAt,
            updatedAt: product.updatedAt,
          ),
        )
        .toList();
  }

  @override
  Future<Product?> getProductById(int id) async {
    final product = await localDataSource.getProductById(id);

    if (product == null) {
      return null;
    }

    return Product(
      id: product.id,
      name: product.name,
      code: product.code,
      price: product.price,
      taxRate: product.taxRate,
      description: product.description,
      isActive: product.isActive,
      createdAt: product.createdAt,
      updatedAt: product.updatedAt,
    );
  }

  @override
  Future<int> createProduct({
    required String name,
    required String code,
    required double price,
    required double taxRate,
    String? description,
  }) {
    return localDataSource.createProduct(
      name: name,
      code: code,
      price: price,
      taxRate: taxRate,
      description: description,
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
    required bool isActive,
  }) {
    return localDataSource.updateProduct(
      id: id,
      name: name,
      code: code,
      price: price,
      taxRate: taxRate,
      description: description,
      isActive: isActive,
    );
  }

  @override
  Future<bool> deleteProduct(int id) {
    return localDataSource.deleteProduct(id);
  }
}

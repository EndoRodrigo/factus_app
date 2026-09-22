import '../entities/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts();

  Future<Product?> getProductById(int id);

  Future<int> createProduct({
    required String name,
    required String code,
    required double price,
    required double taxRate,
    String? description,
  });

  Future<bool> updateProduct({
    required int id,
    required String name,
    required String code,
    required double price,
    required double taxRate,
    String? description,
    required bool isActive,
  });

  Future<bool> deleteProduct(int id);
}

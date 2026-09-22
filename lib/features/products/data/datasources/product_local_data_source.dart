import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';

class ProductLocalDataSource {
  final AppDatabase database;

  ProductLocalDataSource(this.database);

  Future<List<ProductTableData>> getProducts() {
    return (database.select(database.products)
          ..where((product) => product.isActive.equals(true)))
        .get();
  }

  Future<ProductTableData?> getProductById(int id) {
    return (database.select(database.products)
          ..where((product) => product.id.equals(id)))
        .getSingleOrNull();
  }

  Future<int> createProduct({
    required String name,
    required String code,
    required double price,
    required double taxRate,
    String? description,
  }) {
    final now = DateTime.now();

    return database.into(database.products).insert(
          ProductsCompanion.insert(
            name: name,
            code: code,
            price: price,
            taxRate: Value(taxRate),
            description: Value(description),
            createdAt: now,
            updatedAt: now,
          ),
        );
  }

  Future<bool> updateProduct({
    required int id,
    required String name,
    required String code,
    required double price,
    required double taxRate,
    String? description,
    required bool isActive,
  }) {
    return (database.update(database.products)
          ..where((product) => product.id.equals(id)))
        .write(
          ProductsCompanion(
            name: Value(name),
            code: Value(code),
            price: Value(price),
            taxRate: Value(taxRate),
            description: Value(description),
            isActive: Value(isActive),
            updatedAt: Value(DateTime.now()),
          ),
        )
        .then((rows) => rows > 0);
  }

  Future<bool> deleteProduct(int id) {
    return (database.update(database.products)
          ..where((product) => product.id.equals(id)))
        .write(
          ProductsCompanion(
            isActive: const Value(false),
            updatedAt: Value(DateTime.now()),
          ),
        )
        .then((rows) => rows > 0);
  }
}

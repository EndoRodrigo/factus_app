import 'package:flutter_riverpod/legacy.dart';

import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import 'product_providers.dart';

class ProductState {
  final bool isLoading;
  final List<Product> products;
  final Product? selectedProduct;
  final String? error;

  const ProductState({
    this.isLoading = false,
    this.products = const [],
    this.selectedProduct,
    this.error,
  });

  ProductState copyWith({
    bool? isLoading,
    List<Product>? products,
    Product? selectedProduct,
    String? error,
    bool clearSelectedProduct = false,
  }) {
    return ProductState(
      isLoading: isLoading ?? this.isLoading,
      products: products ?? this.products,
      selectedProduct: clearSelectedProduct
          ? null
          : selectedProduct ?? this.selectedProduct,
      error: error,
    );
  }
}

class ProductNotifier extends StateNotifier<ProductState> {
  final ProductRepository repository;

  ProductNotifier(this.repository) : super(const ProductState());

  Future<void> loadProducts() async {
    state = state.copyWith(
      isLoading: true,
      error: null,
    );

    try {
      final products = await repository.getProducts();

      state = state.copyWith(
        isLoading: false,
        products: products,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<Product?> getProductById(int id) async {
    try {
      final product = await repository.getProductById(id);

      state = state.copyWith(
        selectedProduct: product,
        error: null,
      );

      return product;
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
      );

      return null;
    }
  }

  Future<bool> createProduct({
    required String name,
    required String code,
    required double price,
    required double taxRate,
    String? description,
    required String unitMeasureCode,
    required String standardCode,
  }) async {
    state = state.copyWith(
      isLoading: true,
      error: null,
    );

    try {
      await repository.createProduct(
        name: name,
        code: code,
        price: price,
        taxRate: taxRate,
        description: description,
        unitMeasureCode: unitMeasureCode,
        standardCode: standardCode,
      );

      await loadProducts();

      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );

      return false;
    }
  }

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
  }) async {
    state = state.copyWith(
      isLoading: true,
      error: null,
    );

    try {
      final updated = await repository.updateProduct(
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

      if (updated) {
        await loadProducts();
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'No se pudo actualizar el producto.',
        );
      }

      return updated;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );

      return false;
    }
  }

  Future<bool> deleteProduct(int id) async {
    state = state.copyWith(
      isLoading: true,
      error: null,
    );

    try {
      final deleted = await repository.deleteProduct(id);

      if (deleted) {
        await loadProducts();
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'No se pudo desactivar el producto.',
        );
      }

      return deleted;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );

      return false;
    }
  }

  void clearSelectedProduct() {
    state = state.copyWith(
      clearSelectedProduct: true,
      error: null,
    );
  }

  void clearError() {
    state = state.copyWith(
      error: null,
    );
  }
}

final productNotifierProvider =
    StateNotifierProvider<ProductNotifier, ProductState>((ref) {
  final repository = ref.watch(productRepositoryProvider);

  return ProductNotifier(repository);
});

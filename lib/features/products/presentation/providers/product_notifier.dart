import 'package:flutter_riverpod/flutter_riverpod.dart';
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
      selectedProduct: clearSelectedProduct ? null : selectedProduct ?? this.selectedProduct,
      error: error,
    );
  }
}

class ProductNotifier extends Notifier<ProductState> {
  late final ProductRepository _repository;

  @override
  ProductState build() {
    _repository = ref.watch(productRepositoryProvider);
    return const ProductState();
  }

  Future<void> loadProducts() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final products = await _repository.getProducts();
      state = state.copyWith(isLoading: false, products: products);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<Product?> getProductById(int id) async {
    try {
      final product = await _repository.getProductById(id);
      state = state.copyWith(selectedProduct: product);
      return product;
    } catch (e) {
      state = state.copyWith(error: e.toString());
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
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _repository.createProduct(
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
      state = state.copyWith(isLoading: false, error: e.toString());
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
    state = state.copyWith(isLoading: true, error: null);

    try {
      final updated = await _repository.updateProduct(
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
      if (updated) await loadProducts();
      return updated;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> deleteProduct(int id) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final deleted = await _repository.deleteProduct(id);
      if (deleted) await loadProducts();
      return deleted;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  void clearSelectedProduct() => state = state.copyWith(clearSelectedProduct: true);
  void clearError() => state = state.copyWith(error: null);
}

final productNotifierProvider = NotifierProvider<ProductNotifier, ProductState>(() {
  return ProductNotifier();
});

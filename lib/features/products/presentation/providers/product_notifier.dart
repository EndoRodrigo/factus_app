import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/exceptions/app_exception.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/create_product_usecase.dart';
import '../../domain/usecases/delete_product_usecase.dart';
import '../../domain/usecases/get_product_by_id_usecase.dart';
import '../../domain/usecases/get_products_usecase.dart';
import '../../domain/usecases/update_product_usecase.dart';
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
  late final GetProductsUseCase _getProductsUseCase;
  late final GetProductByIdUseCase _getProductByIdUseCase;
  late final CreateProductUseCase _createProductUseCase;
  late final UpdateProductUseCase _updateProductUseCase;
  late final DeleteProductUseCase _deleteProductUseCase;

  @override
  ProductState build() {
    _getProductsUseCase = ref.watch(getProductsUseCaseProvider);
    _getProductByIdUseCase = ref.watch(getProductByIdUseCaseProvider);
    _createProductUseCase = ref.watch(createProductUseCaseProvider);
    _updateProductUseCase = ref.watch(updateProductUseCaseProvider);
    _deleteProductUseCase = ref.watch(deleteProductUseCaseProvider);
    return const ProductState();
  }

  Future<void> loadProducts() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final products = await _getProductsUseCase();
      state = state.copyWith(isLoading: false, products: products);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e is AppException ? e.message : e.toString(),
      );
    }
  }

  Future<Product?> getProductById(int id) async {
    try {
      final product = await _getProductByIdUseCase(id);
      state = state.copyWith(selectedProduct: product);
      return product;
    } catch (e) {
      state = state.copyWith(
        error: e is AppException ? e.message : e.toString(),
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
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _createProductUseCase(
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
        error: e is AppException ? e.message : e.toString(),
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
    state = state.copyWith(isLoading: true, error: null);

    try {
      final updated = await _updateProductUseCase(
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
      state = state.copyWith(
        isLoading: false,
        error: e is AppException ? e.message : e.toString(),
      );
      return false;
    }
  }

  Future<bool> deleteProduct(int id) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final deleted = await _deleteProductUseCase(id);
      if (deleted) await loadProducts();
      return deleted;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e is AppException ? e.message : e.toString(),
      );
      return false;
    }
  }

  void clearSelectedProduct() => state = state.copyWith(clearSelectedProduct: true);
  void clearError() => state = state.copyWith(error: null);
}

final productNotifierProvider = NotifierProvider<ProductNotifier, ProductState>(() {
  return ProductNotifier();
});

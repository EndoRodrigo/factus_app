import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/app_database.dart';
import '../../data/datasources/product_local_data_source.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../domain/repositories/product_repository.dart';
import '../../domain/usecases/create_product_usecase.dart';
import '../../domain/usecases/delete_product_usecase.dart';
import '../../domain/usecases/get_product_by_id_usecase.dart';
import '../../domain/usecases/get_products_usecase.dart';
import '../../domain/usecases/update_product_usecase.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

final productLocalDataSourceProvider =
Provider<ProductLocalDataSource>((ref) {
  final database = ref.watch(databaseProvider);

  return ProductLocalDataSource(database);
});

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final dataSource = ref.watch(productLocalDataSourceProvider);

  return ProductRepositoryImpl(dataSource);
});

final getProductsUseCaseProvider = Provider<GetProductsUseCase>((ref) {
  final repository = ref.watch(productRepositoryProvider);

  return GetProductsUseCase(repository);
});

final getProductByIdUseCaseProvider = Provider<GetProductByIdUseCase>((ref) {
  final repository = ref.watch(productRepositoryProvider);

  return GetProductByIdUseCase(repository);
});

final createProductUseCaseProvider = Provider<CreateProductUseCase>((ref) {
  final repository = ref.watch(productRepositoryProvider);

  return CreateProductUseCase(repository);
});

final updateProductUseCaseProvider = Provider<UpdateProductUseCase>((ref) {
  final repository = ref.watch(productRepositoryProvider);

  return UpdateProductUseCase(repository);
});

final deleteProductUseCaseProvider = Provider<DeleteProductUseCase>((ref) {
  final repository = ref.watch(productRepositoryProvider);

  return DeleteProductUseCase(repository);
});
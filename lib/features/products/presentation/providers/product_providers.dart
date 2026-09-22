import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/app_database.dart';
import '../../data/datasources/product_local_data_source.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../domain/repositories/product_repository.dart';

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
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/app_database.dart';
import '../../data/datasources/establishment_local_data_source.dart';
import '../../data/repositories/establishment_repository_impl.dart';
import '../../domain/repositories/establishment_repository.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();

  ref.onDispose(database.close);

  return database;
});

final establishmentLocalDataSourceProvider =
    Provider<EstablishmentLocalDataSource>((ref) {
      final database = ref.watch(databaseProvider);

      return EstablishmentLocalDataSource(database);
    });

final establishmentRepositoryProvider = Provider<EstablishmentRepository>((
  ref,
) {
  final dataSource = ref.watch(establishmentLocalDataSourceProvider);

  return EstablishmentRepositoryImpl(dataSource);
});

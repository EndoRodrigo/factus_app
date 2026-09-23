import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/datasources/reference_remote_data_source.dart';
import '../../data/repositories/reference_repository_impl.dart';
import '../../domain/entities/municipality.dart';
import '../../domain/repositories/reference_repository.dart';
import '../../domain/usecases/get_municipalities_usecase.dart';

final referenceRemoteDataSourceProvider = Provider<ReferenceRemoteDataSource>((
  ref,
) {
  final apiClient = ref.watch(apiClientProvider);

  return ReferenceRemoteDataSource(apiClient.dio);
});

final referenceRepositoryProvider = Provider<ReferenceRepository>((ref) {
  final dataSource = ref.watch(referenceRemoteDataSourceProvider);

  return ReferenceRepositoryImpl(dataSource);
});

final getMunicipalitiesUseCaseProvider = Provider<GetMunicipalitiesUseCase>((ref) {
  final repository = ref.watch(referenceRepositoryProvider);

  return GetMunicipalitiesUseCase(repository);
});

final municipalitiesProvider = FutureProvider<List<Municipality>>((ref) async {
  final getMunicipalitiesUseCase = ref.watch(getMunicipalitiesUseCaseProvider);

  return getMunicipalitiesUseCase();
});

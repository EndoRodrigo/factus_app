import '../../domain/entities/municipality.dart';
import '../../domain/repositories/reference_repository.dart';
import '../datasources/reference_remote_data_source.dart';

class ReferenceRepositoryImpl implements ReferenceRepository {
  final ReferenceRemoteDataSource remoteDataSource;

  ReferenceRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Municipality>> getMunicipalities() async {
    final municipalities = await remoteDataSource.getMunicipalities();

    return municipalities
        .map((municipality) => municipality.toEntity())
        .toList();
  }
}

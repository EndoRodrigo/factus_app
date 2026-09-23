import '../entities/municipality.dart';
import '../repositories/reference_repository.dart';

class GetMunicipalitiesUseCase {
  final ReferenceRepository repository;

  GetMunicipalitiesUseCase(this.repository);

  Future<List<Municipality>> call() {
    return repository.getMunicipalities();
  }
}

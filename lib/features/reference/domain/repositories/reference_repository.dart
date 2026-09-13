import '../entities/municipality.dart';

abstract class ReferenceRepository {
  Future<List<Municipality>> getMunicipalities();
}

import '../entities/establishment.dart';
import '../repositories/establishment_repository.dart';

class GetEstablishmentUseCase {
  final EstablishmentRepository repository;

  GetEstablishmentUseCase(this.repository);

  Future<Establishment?> call() {
    return repository.getEstablishment();
  }
}

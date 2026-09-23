import '../entities/establishment.dart';
import '../repositories/establishment_repository.dart';

class SaveEstablishmentUseCase {
  final EstablishmentRepository repository;

  SaveEstablishmentUseCase(this.repository);

  Future<void> create(Establishment establishment) {
    return repository.createEstablishment(establishment);
  }

  Future<void> update(Establishment establishment) {
    return repository.updateEstablishment(establishment);
  }
}

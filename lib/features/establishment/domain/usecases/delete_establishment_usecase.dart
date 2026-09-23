import '../repositories/establishment_repository.dart';

class DeleteEstablishmentUseCase {
  final EstablishmentRepository repository;

  DeleteEstablishmentUseCase(this.repository);

  Future<void> call(int id) {
    return repository.deleteEstablishment(id);
  }
}

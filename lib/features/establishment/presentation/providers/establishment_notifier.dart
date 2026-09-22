import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/establishment.dart';
import '../../domain/repositories/establishment_repository.dart';
import 'establishment_provider.dart';

class EstablishmentState {
  final bool isLoading;
  final Establishment? establishment;
  final String? error;

  const EstablishmentState({
    this.isLoading = false,
    this.establishment,
    this.error,
  });

  EstablishmentState copyWith({
    bool? isLoading,
    Establishment? establishment,
    String? error,
    bool clearEstablishment = false,
  }) {
    return EstablishmentState(
      isLoading: isLoading ?? this.isLoading,
      establishment: clearEstablishment ? null : establishment ?? this.establishment,
      error: error,
    );
  }
}

class EstablishmentNotifier extends Notifier<EstablishmentState> {
  late final EstablishmentRepository _repository;

  @override
  EstablishmentState build() {
    _repository = ref.watch(establishmentRepositoryProvider);
    return const EstablishmentState();
  }

  Future<void> load() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final establishment = await _repository.getEstablishment();
      state = state.copyWith(isLoading: false, establishment: establishment);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> create(Establishment establishment) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _repository.createEstablishment(establishment);
      await load();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> update(Establishment establishment) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _repository.updateEstablishment(establishment);
      await load();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> delete() async {
    final establishment = state.establishment;
    if (establishment?.id == null) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      await _repository.deleteEstablishment(establishment!.id!);
      state = state.copyWith(isLoading: false, clearEstablishment: true);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final establishmentNotifierProvider = NotifierProvider<EstablishmentNotifier, EstablishmentState>(() {
  return EstablishmentNotifier();
});

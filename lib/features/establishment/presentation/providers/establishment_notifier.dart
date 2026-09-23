import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/exceptions/app_exception.dart';
import '../../domain/entities/establishment.dart';
import '../../domain/usecases/delete_establishment_usecase.dart';
import '../../domain/usecases/get_establishment_usecase.dart';
import '../../domain/usecases/save_establishment_usecase.dart';
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
  late final GetEstablishmentUseCase _getEstablishmentUseCase;
  late final SaveEstablishmentUseCase _saveEstablishmentUseCase;
  late final DeleteEstablishmentUseCase _deleteEstablishmentUseCase;

  @override
  EstablishmentState build() {
    _getEstablishmentUseCase = ref.watch(getEstablishmentUseCaseProvider);
    _saveEstablishmentUseCase = ref.watch(saveEstablishmentUseCaseProvider);
    _deleteEstablishmentUseCase = ref.watch(deleteEstablishmentUseCaseProvider);
    return const EstablishmentState();
  }

  Future<void> load() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final establishment = await _getEstablishmentUseCase();
      state = state.copyWith(isLoading: false, establishment: establishment);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e is AppException ? e.message : e.toString(),
      );
    }
  }

  Future<void> create(Establishment establishment) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _saveEstablishmentUseCase.create(establishment);
      await load();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e is AppException ? e.message : e.toString(),
      );
    }
  }

  Future<void> update(Establishment establishment) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _saveEstablishmentUseCase.update(establishment);
      await load();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e is AppException ? e.message : e.toString(),
      );
    }
  }

  Future<void> delete() async {
    final establishment = state.establishment;
    if (establishment?.id == null) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      await _deleteEstablishmentUseCase(establishment!.id!);
      state = state.copyWith(isLoading: false, clearEstablishment: true);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e is AppException ? e.message : e.toString(),
      );
    }
  }
}

final establishmentNotifierProvider = NotifierProvider<EstablishmentNotifier, EstablishmentState>(() {
  return EstablishmentNotifier();
});

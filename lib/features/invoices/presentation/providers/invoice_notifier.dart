import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/exceptions/app_exception.dart';
import '../../data/models/create_invoice_request.dart';
import '../../domain/entities/invoice.dart';
import '../../domain/usecases/get_invoices_usecase.dart';
import '../../domain/usecases/validate_invoice_usecase.dart';
import 'invoice_provider.dart';

class InvoiceState {
  final bool isLoading;
  final List<Invoice> invoices;
  final int total;
  final int currentPage;
  final int lastPage;
  final String? error;
  final Map<String, dynamic>? lastResponse;

  const InvoiceState({
    this.isLoading = false,
    this.invoices = const [],
    this.total = 0,
    this.currentPage = 1,
    this.lastPage = 1,
    this.error,
    this.lastResponse,
  });

  bool get hasNextPage => currentPage < lastPage;

  InvoiceState copyWith({
    bool? isLoading,
    List<Invoice>? invoices,
    int? total,
    int? currentPage,
    int? lastPage,
    String? error,
    Map<String, dynamic>? lastResponse,
    bool clearLastResponse = false,
  }) {
    return InvoiceState(
      isLoading: isLoading ?? this.isLoading,
      invoices: invoices ?? this.invoices,
      total: total ?? this.total,
      currentPage: currentPage ?? this.currentPage,
      lastPage: lastPage ?? this.lastPage,
      error: error,
      lastResponse: clearLastResponse ? null : lastResponse ?? this.lastResponse,
    );
  }
}

class InvoiceNotifier extends Notifier<InvoiceState> {
  late final GetInvoicesUseCase _getInvoicesUseCase;
  late final ValidateInvoiceUseCase _validateInvoiceUseCase;

  @override
  InvoiceState build() {
    _getInvoicesUseCase = ref.watch(getInvoicesUseCaseProvider);
    _validateInvoiceUseCase = ref.watch(validateInvoiceUseCaseProvider);
    return const InvoiceState();
  }

  Future<void> loadInvoices() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await _getInvoicesUseCase(page: 1);
      state = state.copyWith(
        isLoading: false,
        invoices: result.invoices,
        total: result.total,
        currentPage: result.currentPage,
        lastPage: result.lastPage,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e is AppException ? e.message : e.toString(),
      );
    }
  }

  Future<void> loadNextPage() async {
    if (state.isLoading || !state.hasNextPage) return;

    try {
      state = state.copyWith(isLoading: true, error: null);
      final nextPage = state.currentPage + 1;
      final result = await _getInvoicesUseCase(page: nextPage);

      state = state.copyWith(
        isLoading: false,
        invoices: [...state.invoices, ...result.invoices],
        total: result.total,
        currentPage: result.currentPage,
        lastPage: result.lastPage,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e is AppException ? e.message : e.toString(),
      );
    }
  }

  Future<bool> validateInvoice(CreateInvoiceRequest request) async {
    state = state.copyWith(isLoading: true, error: null, clearLastResponse: true);

    try {
      final response = await _validateInvoiceUseCase(request);
      state = state.copyWith(isLoading: false, lastResponse: response);
      await loadInvoices();
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e is AppException ? e.message : e.toString(),
      );
      return false;
    }
  }

  void clearError() => state = state.copyWith(error: null);
}

final invoiceNotifierProvider = NotifierProvider<InvoiceNotifier, InvoiceState>(() {
  return InvoiceNotifier();
});

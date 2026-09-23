import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/exceptions/app_exception.dart';
import '../../domain/entities/customer.dart';
import '../../domain/usecases/get_customer_usecase.dart';
import 'customer_provider.dart';

class CustomerState {
  final bool isLoading;
  final Customer? customer;
  final String? error;

  const CustomerState({this.isLoading = false, this.customer, this.error});

  CustomerState copyWith({bool? isLoading, Customer? customer, String? error}) {
    return CustomerState(
      isLoading: isLoading ?? this.isLoading,
      customer: customer ?? this.customer,
      error: error,
    );
  }
}

class CustomerNotifier extends Notifier<CustomerState> {
  late final GetCustomerUseCase _getCustomerUseCase;

  @override
  CustomerState build() {
    _getCustomerUseCase = ref.watch(getCustomerUseCaseProvider);
    return const CustomerState();
  }

  Future<void> searchCustomer({
    required String identificationDocumentCode,
    required String identificationNumber,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final customer = await _getCustomerUseCase(
        identificationDocumentCode: identificationDocumentCode,
        identificationNumber: identificationNumber,
      );

      state = state.copyWith(isLoading: false, customer: customer, error: null);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e is AppException ? e.message : e.toString(),
      );
    }
  }

  void clearCustomer() => state = const CustomerState();
}

final customerNotifierProvider = NotifierProvider<CustomerNotifier, CustomerState>(() {
  return CustomerNotifier();
});

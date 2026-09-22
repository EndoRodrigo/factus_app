import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/customer.dart';
import '../../domain/repositories/customer_repository.dart';
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
  late final CustomerRepository _repository;

  @override
  CustomerState build() {
    _repository = ref.watch(customerRepositoryProvider);
    return const CustomerState();
  }

  Future<void> searchCustomer({
    required String identificationDocumentCode,
    required String identificationNumber,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final customer = await _repository.getCustomer(
        identificationDocumentCode: identificationDocumentCode,
        identificationNumber: identificationNumber,
      );

      state = state.copyWith(isLoading: false, customer: customer, error: null);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void clearCustomer() => state = const CustomerState();
}

final customerNotifierProvider = NotifierProvider<CustomerNotifier, CustomerState>(() {
  return CustomerNotifier();
});

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/datasources/invoice_remote_data_source.dart';
import '../../data/repositories/invoice_repository_impl.dart';
import '../../domain/repositories/invoice_repository.dart';
import '../../domain/usecases/get_invoices_usecase.dart';
import '../../domain/usecases/validate_invoice_usecase.dart';

final invoiceRemoteDataSourceProvider = Provider<InvoiceRemoteDataSource>((
  ref,
) {
  final apiClient = ref.watch(apiClientProvider);

  return InvoiceRemoteDataSource(apiClient.dio);
});

final invoiceRepositoryProvider = Provider<InvoiceRepository>((ref) {
  final remoteDataSource = ref.watch(invoiceRemoteDataSourceProvider);

  return InvoiceRepositoryImpl(remoteDataSource);
});

final getInvoicesUseCaseProvider = Provider<GetInvoicesUseCase>((ref) {
  final repository = ref.watch(invoiceRepositoryProvider);

  return GetInvoicesUseCase(repository);
});

final validateInvoiceUseCaseProvider = Provider<ValidateInvoiceUseCase>((ref) {
  final repository = ref.watch(invoiceRepositoryProvider);

  return ValidateInvoiceUseCase(repository);
});

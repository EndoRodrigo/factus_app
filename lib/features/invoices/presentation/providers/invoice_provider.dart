import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/datasources/invoice_remote_data_source.dart';
import '../../data/repositories/invoice_repository_impl.dart';
import '../../domain/repositories/invoice_repository.dart';

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

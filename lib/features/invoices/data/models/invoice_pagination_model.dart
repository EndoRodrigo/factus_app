import '../../domain/entities/invoice_pagination.dart';
import 'invoice_model.dart';

class InvoicePaginationModel {
  final List<InvoiceModel> invoices;
  final int total;
  final int perPage;
  final int currentPage;
  final int lastPage;
  final int from;
  final int to;

  const InvoicePaginationModel({
    required this.invoices,
    required this.total,
    required this.perPage,
    required this.currentPage,
    required this.lastPage,
    required this.from,
    required this.to,
  });

  factory InvoicePaginationModel.fromJson(Map<String, dynamic> json) {
    final invoicesData = json['data'] as List? ?? [];

    final pagination = json['pagination'] as Map<String, dynamic>? ?? {};

    return InvoicePaginationModel(
      invoices: invoicesData
          .map(
            (invoice) => InvoiceModel.fromJson(invoice as Map<String, dynamic>),
          )
          .toList(),
      total: pagination['total'] as int? ?? 0,
      perPage: pagination['per_page'] as int? ?? 0,
      currentPage: pagination['current_page'] as int? ?? 1,
      lastPage: pagination['last_page'] as int? ?? 1,
      from: pagination['from'] as int? ?? 0,
      to: pagination['to'] as int? ?? 0,
    );
  }

  InvoicePagination toEntity() {
    return InvoicePagination(
      invoices: invoices.map((invoice) => invoice.toEntity()).toList(),
      total: total,
      perPage: perPage,
      currentPage: currentPage,
      lastPage: lastPage,
      from: from,
      to: to,
    );
  }
}

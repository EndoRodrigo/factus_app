import 'invoice.dart';

class InvoicePagination {
  final List<Invoice> invoices;
  final int total;
  final int perPage;
  final int currentPage;
  final int lastPage;
  final int from;
  final int to;

  const InvoicePagination({
    required this.invoices,
    required this.total,
    required this.perPage,
    required this.currentPage,
    required this.lastPage,
    required this.from,
    required this.to,
  });

  bool get hasNextPage => currentPage < lastPage;

  bool get hasPreviousPage => currentPage > 1;
}
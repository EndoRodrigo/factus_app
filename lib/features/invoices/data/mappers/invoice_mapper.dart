import '../../domain/entities/invoice.dart';
import '../../domain/entities/invoice_pagination.dart';
import '../models/invoice_model.dart';
import '../models/invoice_pagination_model.dart';

class InvoiceMapper {
  static Invoice toEntity(InvoiceModel model) {
    return Invoice(
      id: model.id,
      documentName: model.documentName,
      operationTypeName: model.operationTypeName,
      number: model.number,
      referenceCode: model.referenceCode,
      identification: model.identification,
      customerName: model.customerName,
      total: model.total,
      status: model.status,
      errors: model.errors,
      paymentFormName: model.paymentFormName,
      createdAt: model.createdAt,
    );
  }

  static InvoicePagination toPaginationEntity(InvoicePaginationModel model) {
    return InvoicePagination(
      invoices: model.invoices.map(toEntity).toList(),
      total: model.total,
      perPage: model.perPage,
      currentPage: model.currentPage,
      lastPage: model.lastPage,
      from: model.from,
      to: model.to,
    );
  }
}

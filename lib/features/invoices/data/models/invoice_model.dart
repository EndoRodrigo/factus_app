import '../../domain/entities/invoice.dart';

class InvoiceModel {
  final int id;
  final String documentName;
  final String operationTypeName;
  final String number;
  final String referenceCode;
  final String identification;
  final String customerName;
  final double total;
  final int status;
  final Map<String, dynamic> errors;
  final String paymentFormName;
  final String createdAt;

  const InvoiceModel({
    required this.id,
    required this.documentName,
    required this.operationTypeName,
    required this.number,
    required this.referenceCode,
    required this.identification,
    required this.customerName,
    required this.total,
    required this.status,
    required this.errors,
    required this.paymentFormName,
    required this.createdAt,
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    return InvoiceModel(
      id: json['id'] as int? ?? 0,
      documentName: json['document']?['name']?.toString() ?? '',
      operationTypeName:
      json['operation_type']?['name']?.toString() ?? '',
      number: json['number']?.toString() ?? '',
      referenceCode: json['reference_code']?.toString() ?? '',
      identification: json['identification']?.toString() ?? '',
      customerName: json['names']?.toString() ?? '',
      total: double.tryParse(
        json['total']?.toString() ?? '0',
      ) ??
          0,
      status: json['status'] as int? ?? 0,
      errors: Map<String, dynamic>.from(
        json['errors'] ?? {},
      ),
      paymentFormName:
      json['payment_form']?['name']?.toString() ?? '',
      createdAt: json['created_at']?.toString() ?? '',
    );
  }

  Invoice toEntity() {
    return Invoice(
      id: id,
      documentName: documentName,
      operationTypeName: operationTypeName,
      number: number,
      referenceCode: referenceCode,
      identification: identification,
      customerName: customerName,
      total: total,
      status: status,
      errors: errors,
      paymentFormName: paymentFormName,
      createdAt: createdAt,
    );
  }
}
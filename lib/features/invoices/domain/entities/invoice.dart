class Invoice {
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

  const Invoice({
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
}
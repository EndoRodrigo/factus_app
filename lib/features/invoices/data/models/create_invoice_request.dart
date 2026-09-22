class CreateInvoiceRequest {
  final String referenceCode;
  final CustomerRequest customer;
  final List<InvoiceItemRequest> items;
  final PaymentDetailsRequest paymentDetails;

  const CreateInvoiceRequest({
    required this.referenceCode,
    required this.customer,
    required this.items,
    required this.paymentDetails,
  });

  Map<String, dynamic> toJson() {
    return {
      'reference_code': referenceCode,
      'customer': customer.toJson(),
      'items': items.map((item) => item.toJson()).toList(),
      'payment_details': paymentDetails.toJson(),
    };
  }
}

class CustomerRequest {
  final String identification;
  final int identificationDocumentId;
  final String names;
  final String email;
  final String phone;
  final String address;
  final String municipalityCode;

  const CustomerRequest({
    required this.identification,
    required this.identificationDocumentId,
    required this.names,
    required this.email,
    required this.phone,
    required this.address,
    required this.municipalityCode,
  });

  Map<String, dynamic> toJson() {
    return {
      'identification': identification,
      'identification_document_id': identificationDocumentId,
      'names': names,
      'email': email,
      'phone': phone,
      'address': address,
      'municipality_code': municipalityCode,
    };
  }
}

class InvoiceItemRequest {
  final String codeReference;
  final String name;
  final double quantity;
  final double price;
  final double taxRate;
  final double discountRate;
  final int unitMeasureId;
  final int standardCodeId;
  final int isExcluded;
  final int tributeId;
  final List<InvoiceTaxRequest> taxes;

  const InvoiceItemRequest({
    required this.codeReference,
    required this.name,
    required this.quantity,
    required this.price,
    required this.taxRate,
    required this.discountRate,
    required this.unitMeasureId,
    required this.standardCodeId,
    required this.isExcluded,
    required this.tributeId,
    required this.taxes,
  });

  Map<String, dynamic> toJson() {
    return {
      'code_reference': codeReference,
      'name': name,
      'quantity': quantity,
      'price': price,
      'tax_rate': taxRate,
      'discount_rate': discountRate,
      'unit_measure_id': unitMeasureId,
      'standard_code_id': standardCodeId,
      'is_excluded': isExcluded,
      'tribute_id': tributeId,
      // 'taxes': taxes.map((tax) => tax.toJson()).toList(), // V1 might not use this list if tax_rate is direct
    };
  }
}

class InvoiceTaxRequest {
  final String tax;
  final double taxRate;

  const InvoiceTaxRequest({
    required this.tax,
    required this.taxRate,
  });

  Map<String, dynamic> toJson() {
    return {
      'tax': tax,
      'tax_rate': taxRate,
    };
  }
}

class PaymentDetailsRequest {
  final String paymentForm;
  final String paymentMethodCode;

  const PaymentDetailsRequest({
    required this.paymentForm,
    required this.paymentMethodCode,
  });

  Map<String, dynamic> toJson() {
    return {
      'payment_form': paymentForm,
      'payment_method_code': paymentMethodCode,
    };
  }
}

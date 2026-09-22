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
  final int identification;
  final String identificationType;
  final String names;
  final String email;
  final String phone;
  final String address;
  final String municipalityCode;

  const CustomerRequest({
    required this.identification,
    required this.identificationType,
    required this.names,
    required this.email,
    required this.phone,
    required this.address,
    required this.municipalityCode,
  });

  Map<String, dynamic> toJson() {
    return {
      'identification': identification,
      'identification_type': identificationType,
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
  final String unitMeasureCode;
  final String standardCode;
  final List<InvoiceTaxRequest> taxes;

  const InvoiceItemRequest({
    required this.codeReference,
    required this.name,
    required this.quantity,
    required this.price,
    required this.unitMeasureCode,
    required this.standardCode,
    required this.taxes,
  });

  Map<String, dynamic> toJson() {
    return {
      'code_reference': codeReference,
      'name': name,
      'quantity': quantity,
      'price': price,
      'unit_measure_code': unitMeasureCode,
      'standard_code': standardCode,
      'taxes': taxes.map((tax) => tax.toJson()).toList(),
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
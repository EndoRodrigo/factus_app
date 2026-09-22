import 'package:flutter_riverpod/legacy.dart';

import '../../../customer/domain/entities/customer.dart';
import '../../../products/domain/entities/product.dart';
import '../../data/models/create_invoice_request.dart';


class InvoiceDraft {
  final Customer? customer;
  final List<InvoiceItemDraft> items;
  final String paymentForm; // '1' para Contado, '2' para Crédito
  final String paymentMethodCode; // '10' para Efectivo, etc.

  const InvoiceDraft({
    this.customer,
    this.items = const [],
    this.paymentForm = '1',
    this.paymentMethodCode = '10',
  });

  double get subtotal => items.fold(0, (sum, item) => sum + item.total);
  double get totalTax => items.fold(0, (sum, item) => sum + item.taxAmount);
  double get total => subtotal + totalTax;

  InvoiceDraft copyWith({
    Customer? customer,
    List<InvoiceItemDraft>? items,
    String? paymentForm,
    String? paymentMethodCode,
  }) {
    return InvoiceDraft(
      customer: customer ?? this.customer,
      items: items ?? this.items,
      paymentForm: paymentForm ?? this.paymentForm,
      paymentMethodCode: paymentMethodCode ?? this.paymentMethodCode,
    );
  }

  CreateInvoiceRequest? toRequest(String referenceCode) {
    if (customer == null || items.isEmpty) return null;

    return CreateInvoiceRequest(
      referenceCode: referenceCode,
      customer: CustomerRequest(
        identification: int.tryParse(customer!.identification) ?? 0,
        identificationType: customer!.identificationType,
        names: customer!.name,
        email: customer!.email,
        phone: customer!.phone,
        address: customer!.address,
        municipalityCode: customer!.municipalityCode,
      ),
      items: items.map((item) => item.toRequest()).toList(),
      paymentDetails: PaymentDetailsRequest(
        paymentForm: paymentForm,
        paymentMethodCode: paymentMethodCode,
      ),
    );
  }
}

class InvoiceItemDraft {
  final Product product;
  final double quantity;

  const InvoiceItemDraft({
    required this.product,
    this.quantity = 1,
  });

  double get total => product.price * quantity;
  double get taxAmount => total * (product.taxRate / 100);

  InvoiceItemDraft copyWith({
    Product? product,
    double? quantity,
  }) {
    return InvoiceItemDraft(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }

  InvoiceItemRequest toRequest() {
    return InvoiceItemRequest(
      codeReference: product.code,
      name: product.name,
      quantity: quantity,
      price: product.price,
      unitMeasureCode: product.unitMeasureCode,
      standardCode: product.standardCode,
      taxes: [
        InvoiceTaxRequest(
          tax: '01', // IVA
          taxRate: product.taxRate,
        ),
      ],
    );
  }
}

class InvoiceDraftNotifier extends StateNotifier<InvoiceDraft> {
  InvoiceDraftNotifier() : super(const InvoiceDraft());

  void setCustomer(Customer customer) {
    state = state.copyWith(customer: customer);
  }

  void addProduct(Product product, {double quantity = 1}) {
    final existingIndex = state.items.indexWhere((item) => item.product.id == product.id);
    
    if (existingIndex != -1) {
      final updatedItems = List<InvoiceItemDraft>.from(state.items);
      updatedItems[existingIndex] = updatedItems[existingIndex].copyWith(
        quantity: updatedItems[existingIndex].quantity + quantity,
      );
      state = state.copyWith(items: updatedItems);
    } else {
      state = state.copyWith(
        items: [...state.items, InvoiceItemDraft(product: product, quantity: quantity)],
      );
    }
  }

  void removeProduct(int productId) {
    state = state.copyWith(
      items: state.items.where((item) => item.product.id != productId).toList(),
    );
  }

  void updateQuantity(int productId, double quantity) {
    if (quantity <= 0) {
      removeProduct(productId);
      return;
    }

    state = state.copyWith(
      items: state.items.map((item) {
        if (item.product.id == productId) {
          return item.copyWith(quantity: quantity);
        }
        return item;
      }).toList(),
    );
  }

  void setPaymentDetails({String? form, String? method}) {
    state = state.copyWith(
      paymentForm: form,
      paymentMethodCode: method,
    );
  }

  void reset() {
    state = const InvoiceDraft();
  }
}

final invoiceDraftProvider = StateNotifierProvider<InvoiceDraftNotifier, InvoiceDraft>((ref) {
  return InvoiceDraftNotifier();
});

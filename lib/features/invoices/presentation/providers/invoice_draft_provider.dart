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
        identification: customer!.identification,
        // En V1, los IDs suelen ser enteros. Mapeamos los códigos conocidos.
        identificationDocumentId: _mapDocTypeToV1Id(customer!.identificationType),
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

  int _mapDocTypeToV1Id(String type) {
    switch (type) {
      case '13': return 1; // Cédula
      case '31': return 3; // NIT
      case '22': return 2; // Extranjería
      case '41': return 4; // Pasaporte
      default: return int.tryParse(type) ?? 1;
    }
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
      taxRate: product.taxRate,
      discountRate: 0,
      // Mapeo de IDs comunes para Factus V1
      // Unidad (94 en V2) suele ser 70 en V1
      unitMeasureId: _mapUnitMeasure(product.unitMeasureCode),
      // Estándar de adopción del contribuyente (999 en V2) suele ser 1 en V1
      standardCodeId: _mapStandardCode(product.standardCode),
      isExcluded: 0,
      tributeId: 1, // 1 = IVA
      taxes: [
        InvoiceTaxRequest(
          tax: '01',
          taxRate: product.taxRate,
        ),
      ],
    );
  }

  int _mapUnitMeasure(String code) {
    if (code == '94') return 70; // Unidad
    return int.tryParse(code) ?? 70;
  }

  int _mapStandardCode(String code) {
    if (code == '999') return 1; // Estándar de adopción del contribuyente
    return int.tryParse(code) ?? 1;
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

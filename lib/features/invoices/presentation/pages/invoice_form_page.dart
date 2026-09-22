import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/presentation/utils/ui_utils.dart';
import '../../../customer/domain/entities/customer.dart';
import '../../../customer/presentation/providers/customer_notifier.dart';
import '../../../products/presentation/providers/product_notifier.dart';
import '../providers/invoice_draft_provider.dart';
import '../providers/invoice_notifier.dart';

class InvoiceFormPage extends ConsumerStatefulWidget {
  const InvoiceFormPage({super.key});

  @override
  ConsumerState<InvoiceFormPage> createState() => _InvoiceFormPageState();
}

class _InvoiceFormPageState extends ConsumerState<InvoiceFormPage> {
  @override
  Widget build(BuildContext context) {
    final draft = ref.watch(invoiceDraftProvider);
    final invoiceState = ref.watch(invoiceNotifierProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionHeader(
                    title: 'Cliente',
                    trailing: TextButton.icon(
                      onPressed: _showCustomerSelector,
                      icon: const Icon(Icons.search),
                      label: Text(
                          draft.customer == null ? 'Seleccionar' : 'Cambiar'),
                    ),
                  ),
                  if (draft.customer != null)
                    _CustomerCard(customer: draft.customer!)
                  else
                    const _EmptyCard(text: 'No se ha seleccionado un cliente'),
                  const SizedBox(height: 24),
                  _SectionHeader(
                    title: 'Productos',
                    trailing: IconButton(
                      onPressed: _showProductSelector,
                      icon: const Icon(Icons.add_circle_outline),
                    ),
                  ),
                  if (draft.items.isEmpty)
                    const _EmptyCard(text: 'Agrega productos a la factura')
                  else
                    ...draft.items.map((item) => _ProductItemRow(item: item)),
                  const SizedBox(height: 24),
                  const _SectionHeader(title: 'Resumen'),
                  _SummaryCard(draft: draft),
                  const SizedBox(height: 32),
                  FilledButton.icon(
                    onPressed: (draft.customer == null ||
                            draft.items.isEmpty ||
                            invoiceState.isLoading)
                        ? null
                        : _createInvoice,
                    icon: invoiceState.isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white))
                        : const Icon(Icons.send),
                    label: const Text('Crear Factura Electrónica'),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(double.infinity, 54),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCustomerSelector() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const _CustomerSearchSheet(),
    );
  }

  void _showProductSelector() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const _ProductSearchSheet(),
    );
  }

  Future<void> _createInvoice() async {
    final draft = ref.read(invoiceDraftProvider);
    final referenceCode = const Uuid().v4().substring(0, 8).toUpperCase();

    final request = draft.toRequest(referenceCode);

    if (request != null) {
      final success = await ref
          .read(invoiceNotifierProvider.notifier)
          .validateInvoice(request);

      if (!mounted) return;

      if (success) {
        ref.read(invoiceDraftProvider.notifier).reset();
        UIUtils.showSuccessSnackBar(context, 'Factura creada exitosamente');
      } else {
        final error = ref.read(invoiceNotifierProvider).error;
        UIUtils.showErrorSnackBar(
            context, error ?? 'Ocurrió un error al crear la factura');
      }
    }
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final Widget? trailing;

  const _SectionHeader({required this.title, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}

class _CustomerCard extends StatelessWidget {
  final Customer customer;

  const _CustomerCard({required this.customer});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.person)),
        title: Text(customer.name),
        subtitle: Text(
            '${customer.identificationType}: ${customer.identification}\n${customer.email}'),
        isThreeLine: true,
      ),
    );
  }
}

class _ProductItemRow extends ConsumerWidget {
  final InvoiceItemDraft item;

  const _ProductItemRow({required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.product.name,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text('Ref: ${item.product.code}',
                          style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ),
                Text('\$${item.total.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: () => ref
                          .read(invoiceDraftProvider.notifier)
                          .updateQuantity(item.product.id!, item.quantity - 1),
                    ),
                    Text(item.quantity.toStringAsFixed(0),
                        style: const TextStyle(fontSize: 16)),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: () => ref
                          .read(invoiceDraftProvider.notifier)
                          .updateQuantity(item.product.id!, item.quantity + 1),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => ref
                      .read(invoiceDraftProvider.notifier)
                      .removeProduct(item.product.id!),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final InvoiceDraft draft;

  const _SummaryCard({required this.draft});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _SummaryRow(label: 'Subtotal', value: draft.subtotal),
            _SummaryRow(label: 'IVA', value: draft.totalTax),
            const Divider(),
            _SummaryRow(
              label: 'Total',
              value: draft.total,
              isBold: true,
              color: Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final double value;
  final bool isBold;
  final Color? color;

  const _SummaryRow(
      {required this.label, required this.value, this.isBold = false, this.color});

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      fontSize: isBold ? 18 : 14,
      color: color,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text('\$${value.toStringAsFixed(2)}', style: style),
        ],
      ),
    );
  }
}

class _EmptyCard extends StatelessWidget {
  final String text;

  const _EmptyCard({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey.withAlpha(20),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withAlpha(50)),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.grey),
      ),
    );
  }
}

class _CustomerSearchSheet extends ConsumerStatefulWidget {
  const _CustomerSearchSheet();

  @override
  ConsumerState<_CustomerSearchSheet> createState() =>
      __CustomerSearchSheetState();
}

class __CustomerSearchSheetState extends ConsumerState<_CustomerSearchSheet> {
  final _controller = TextEditingController();
  String _docType = '1'; // Usamos los IDs reales de Factus V1

  @override
  Widget build(BuildContext context) {
    final customerState = ref.watch(customerNotifierProvider);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20,
        right: 20,
        top: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Buscar Cliente', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: _docType,
            items: const [
              DropdownMenuItem(value: '1', child: Text('Cédula de ciudadanía')),
              DropdownMenuItem(value: '3', child: Text('NIT')),
            ],
            onChanged: (v) => setState(() => _docType = v!),
            decoration: const InputDecoration(
                border: OutlineInputBorder(), labelText: 'Tipo'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Número de documento',
              suffixIcon: Icon(Icons.search),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          if (customerState.isLoading)
            const CircularProgressIndicator()
          else
            FilledButton(
              onPressed: () async {
                await ref
                    .read(customerNotifierProvider.notifier)
                    .searchCustomer(
                      identificationDocumentCode: _docType,
                      identificationNumber: _controller.text.trim(),
                    );

                if (!context.mounted) return;

                final found = ref.read(customerNotifierProvider).customer;
                if (found != null) {
                  ref.read(invoiceDraftProvider.notifier).setCustomer(found);
                  Navigator.pop(context);
                } else if (ref.read(customerNotifierProvider).error != null) {
                  UIUtils.showErrorSnackBar(
                      context, ref.read(customerNotifierProvider).error!);
                }
              },
              child: const Text('Buscar y Seleccionar'),
            ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _ProductSearchSheet extends ConsumerStatefulWidget {
  const _ProductSearchSheet();

  @override
  ConsumerState<_ProductSearchSheet> createState() =>
      _ProductSearchSheetState();
}

class _ProductSearchSheetState extends ConsumerState<_ProductSearchSheet> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(productNotifierProvider.notifier).loadProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final productState = ref.watch(productNotifierProvider);

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text('Catálogo de Productos',
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          Expanded(
            child: productState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: productState.products.length,
                    itemBuilder: (context, index) {
                      final product = productState.products[index];
                      return ListTile(
                        title: Text(product.name),
                        subtitle:
                            Text('Ref: ${product.code} - \$${product.price}'),
                        trailing: const Icon(Icons.add_circle_outline),
                        onTap: () {
                          ref
                              .read(invoiceDraftProvider.notifier)
                              .addProduct(product);
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

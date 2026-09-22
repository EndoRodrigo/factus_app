import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/product_notifier.dart';
import '../widgets/product_card.dart';
import 'product_form_page.dart';

class ProductsPage extends ConsumerStatefulWidget {
  const ProductsPage({super.key});

  @override
  ConsumerState<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends ConsumerState<ProductsPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(productNotifierProvider.notifier).loadProducts();
    });
  }

  Future<void> _openCreateProduct() async {
    final created = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => const ProductFormPage(),
      ),
    );

    if (created == true && mounted) {
      ref.read(productNotifierProvider.notifier).loadProducts();
    }
  }

  Future<void> _openEditProduct(int productId) async {
    final updated = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => ProductFormPage(
          productId: productId,
        ),
      ),
    );

    if (updated == true && mounted) {
      ref.read(productNotifierProvider.notifier).loadProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(productNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Productos',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: _buildBody(state),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openCreateProduct,
        icon: const Icon(Icons.add),
        label: const Text('Nuevo producto'),
      ),
    );
  }

  Widget _buildBody(ProductState state) {
    if (state.isLoading && state.products.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state.error != null && state.products.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                size: 48,
              ),
              const SizedBox(height: 16),
              Text(
                state.error!,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref
                      .read(productNotifierProvider.notifier)
                      .loadProducts();
                },
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    if (state.products.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.inventory_2_outlined,
                size: 64,
              ),
              SizedBox(height: 16),
              Text(
                'No hay productos registrados',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Crea tu primer producto para comenzar.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () {
        return ref
            .read(productNotifierProvider.notifier)
            .loadProducts();
      },
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(
          16,
          16,
          16,
          100,
        ),
        itemCount: state.products.length,
        itemBuilder: (context, index) {
          final product = state.products[index];

          return ProductCard(
            product: product,
            onEdit: () => _openEditProduct(product.id!),
            onDelete: () => _confirmDelete(product.id!),
          );
        },
      ),
    );
  }

  Future<void> _confirmDelete(int productId) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Desactivar producto'),
          content: const Text(
            '¿Deseas desactivar este producto? '
                'No aparecerá como producto activo, pero se conservará '
                'en la base de datos.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Desactivar'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true || !mounted) {
      return;
    }

    await ref
        .read(productNotifierProvider.notifier)
        .deleteProduct(productId);
  }
}
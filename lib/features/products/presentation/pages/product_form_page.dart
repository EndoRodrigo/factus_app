import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/product.dart';
import '../providers/product_notifier.dart';

class ProductFormPage extends ConsumerStatefulWidget {
  final int? productId;

  const ProductFormPage({
    super.key,
    this.productId,
  });

  bool get isEditing => productId != null;

  @override
  ConsumerState<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends ConsumerState<ProductFormPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _codeController = TextEditingController();
  final _priceController = TextEditingController();
  final _taxRateController = TextEditingController();
  final _descriptionController = TextEditingController();

  bool _isActive = true;
  bool _loadingProduct = false;

  @override
  void initState() {
    super.initState();

    _taxRateController.text = '19';

    if (widget.isEditing) {
      _loadProduct();
    }
  }

  Future<void> _loadProduct() async {
    setState(() {
      _loadingProduct = true;
    });

    final product = await ref
        .read(productNotifierProvider.notifier)
        .getProductById(widget.productId!);

    if (!mounted) {
      return;
    }

    if (product != null) {
      _fillForm(product);
    }

    setState(() {
      _loadingProduct = false;
    });
  }

  void _fillForm(Product product) {
    _nameController.text = product.name;
    _codeController.text = product.code;
    _priceController.text = product.price.toStringAsFixed(2);
    _taxRateController.text = product.taxRate.toStringAsFixed(0);
    _descriptionController.text = product.description ?? '';
    _isActive = product.isActive;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _priceController.dispose();
    _taxRateController.dispose();
    _descriptionController.dispose();

    super.dispose();
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final name = _nameController.text.trim();
    final code = _codeController.text.trim();
    final price = double.parse(_priceController.text);
    final taxRate = double.parse(_taxRateController.text);
    final description = _descriptionController.text.trim();

    final notifier = ref.read(productNotifierProvider.notifier);

    bool success;

    if (widget.isEditing) {
      success = await notifier.updateProduct(
        id: widget.productId!,
        name: name,
        code: code,
        price: price,
        taxRate: taxRate,
        description: description.isEmpty ? null : description,
        isActive: _isActive,
      );
    } else {
      success = await notifier.createProduct(
        name: name,
        code: code,
        price: price,
        taxRate: taxRate,
        description: description.isEmpty ? null : description,
      );
    }

    if (!mounted) {
      return;
    }

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.isEditing
                ? 'Producto actualizado correctamente'
                : 'Producto creado correctamente',
          ),
        ),
      );

      Navigator.pop(context, true);
    } else {
      final error = ref.read(productNotifierProvider).error;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error ?? 'No se pudo guardar el producto',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(productNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isEditing ? 'Editar producto' : 'Nuevo producto',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: _loadingProduct
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  TextFormField(
                    controller: _nameController,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      labelText: 'Nombre del producto',
                      hintText: 'Ej. Camiseta básica',
                      prefixIcon: Icon(Icons.inventory_2_outlined),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Ingresa el nombre del producto';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _codeController,
                    textCapitalization: TextCapitalization.characters,
                    decoration: const InputDecoration(
                      labelText: 'Código',
                      hintText: 'Ej. CAM-001',
                      prefixIcon: Icon(Icons.qr_code_2_outlined),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Ingresa el código del producto';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _priceController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Precio',
                      hintText: 'Ej. 50000',
                      prefixIcon: Icon(Icons.attach_money),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Ingresa el precio';
                      }

                      final price = double.tryParse(value);

                      if (price == null || price <= 0) {
                        return 'Ingresa un precio válido';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _taxRateController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'IVA (%)',
                      hintText: 'Ej. 19',
                      prefixIcon: Icon(Icons.percent),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Ingresa el IVA';
                      }

                      final taxRate = double.tryParse(value);

                      if (taxRate == null || taxRate < 0 || taxRate > 100) {
                        return 'Ingresa un IVA entre 0 y 100';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 3,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      labelText: 'Descripción',
                      hintText: 'Descripción opcional del producto',
                      prefixIcon: Icon(Icons.description_outlined),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  if (widget.isEditing) ...[
                    const SizedBox(height: 8),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text(
                        'Producto activo',
                      ),
                      subtitle: const Text(
                        'Los productos inactivos no se '
                        'mostrarán para nuevas facturas.',
                      ),
                      value: _isActive,
                      onChanged: (value) {
                        setState(() {
                          _isActive = value;
                        });
                      },
                    ),
                  ],
                  const SizedBox(height: 32),
                  SizedBox(
                    height: 52,
                    child: FilledButton.icon(
                      onPressed: state.isLoading ? null : _saveProduct,
                      icon: state.isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(Icons.save_outlined),
                      label: Text(
                        widget.isEditing ? 'Guardar cambios' : 'Crear producto',
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

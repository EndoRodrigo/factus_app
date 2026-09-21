import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/customer_notifier.dart';

class CustomerTestPage extends ConsumerStatefulWidget {
  const CustomerTestPage({super.key});

  @override
  ConsumerState<CustomerTestPage> createState() => _CustomerTestPageState();
}

class _CustomerTestPageState extends ConsumerState<CustomerTestPage> {
  final identificationNumberController = TextEditingController();

  String identificationDocumentCode = '3';

  @override
  void dispose() {
    identificationNumberController.dispose();
    super.dispose();
  }

  void searchCustomer() {
    final identificationNumber = identificationNumberController.text.trim();

    if (identificationNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa el número de identificación')),
      );
      return;
    }

    ref
        .read(customerNotifierProvider.notifier)
        .searchCustomer(
          identificationDocumentCode: identificationDocumentCode,
          identificationNumber: identificationNumber,
        );
  }

  @override
  Widget build(BuildContext context) {
    final customerState = ref.watch(customerNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Consultar cliente')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              initialValue: identificationDocumentCode,
              decoration: const InputDecoration(
                labelText: 'Tipo de documento',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: '3',
                  child: Text('Cédula de ciudadanía'),
                ),
                DropdownMenuItem(value: '6d', child: Text('NIT')),
                DropdownMenuItem(
                  value: '2',
                  child: Text('Cédula de extranjería'),
                ),
                DropdownMenuItem(value: '7', child: Text('Pasaporte')),
              ],
              onChanged: (value) {
                if (value == null) return;

                setState(() {
                  identificationDocumentCode = value;
                });
              },
            ),

            const SizedBox(height: 16),

            TextField(
              controller: identificationNumberController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Número de identificación',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: customerState.isLoading ? null : searchCustomer,
                child: customerState.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Consultar'),
              ),
            ),

            const SizedBox(height: 24),

            if (customerState.error != null)
              Center(
                child: Text(
                  'Error: ${customerState.error}',
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              )
            else if (customerState.customer != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              customerState.customer!.name,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                          const Icon(Icons.person, color: Colors.blue),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _InfoRow(
                        label: 'Documento',
                        value: customerState.customer!.identification,
                      ),
                      _InfoRow(
                        label: 'Tipo',
                        value: _getDocName(
                          customerState.customer!.identificationType,
                        ),
                      ),
                      _InfoRow(
                        label: 'Correo',
                        value: customerState.customer!.email,
                      ),
                    ],
                  ),
                ),
              )
            else
              const Center(child: Text('Ingresa un documento para consultar.')),
          ],
        ),
      ),
    );
  }

  String _getDocName(String code) {
    switch (code) {
      case '13':
        return 'Cédula de ciudadanía';
      case '31':
        return 'NIT';
      case '22':
        return 'Cédula de extranjería';
      case '41':
        return 'Pasaporte';
      default:
        return code;
    }
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

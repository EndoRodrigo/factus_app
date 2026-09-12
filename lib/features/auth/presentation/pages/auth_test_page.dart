import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../invoices/presentation/pages/invoices_page.dart';
import '../providers/auth_notifier.dart';
import '../providers/auth_providers.dart';

class AuthTestPage extends ConsumerWidget {
  const AuthTestPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final token = ref.read(tokenStorageProvider).getAccessToken();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Prueba Factus'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (authState.isLoading)
                const CircularProgressIndicator()
              else
                ElevatedButton(
                  onPressed: () {
                    ref
                        .read(authNotifierProvider.notifier)
                        .login();
                  },
                  child: const Text('Iniciar sesión'),
                ),

              const SizedBox(height: 24),

              if (authState.auth != null) ...[
                const Text(
                  'Autenticación exitosa',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Tipo: ${authState.auth!.tokenType}',
                ),
                Text(
                  'Expira en: ${authState.auth!.expiresIn} segundos',
                ),
                Text(
                  'Token almacenado: ${token.toString()}',
                ),

                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const InvoicesPage(),
                      ),
                    );
                  },
                  child: const Text('Ver mis facturas'),
                ),

              ],

              if (authState.error != null) ...[
                const SizedBox(height: 20),
                Text(
                  authState.error!,
                  style: const TextStyle(
                    color: Colors.red,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
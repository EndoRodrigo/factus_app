import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_notifier.dart';

class AuthTestPage extends ConsumerWidget {
  const AuthTestPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);

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
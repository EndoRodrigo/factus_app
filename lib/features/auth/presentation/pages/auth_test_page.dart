import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/presentation/utils/ui_utils.dart';
import '../../../home/presentation/page/home_page.dart';
import '../providers/auth_notifier.dart';

class AuthTestPage extends ConsumerWidget {
  const AuthTestPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);

    ref.listen<AuthState>(
      authNotifierProvider,
      (previous, next) {
        // Autenticación exitosa
        if (previous?.auth == null && next.auth != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ),
          );
        }

        // Error de autenticación
        if (next.error != null && previous?.error != next.error) {
          UIUtils.showErrorSnackBar(context, next.error!);
        }
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Factus',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/capi-factus.png',
                width: 300,
                height: 300,
                alignment: Alignment.topCenter,
              ),
              const SizedBox(height: 24),
              if (authState.isLoading)
                const CircularProgressIndicator()
              else
                ElevatedButton(
                  onPressed: () {
                    ref.read(authNotifierProvider.notifier).login();
                  },
                  child: const Text(
                    'Iniciar sesión',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

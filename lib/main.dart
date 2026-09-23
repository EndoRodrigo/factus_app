import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/pages/login_page.dart';

void main() {
  runApp(const ProviderScope(child: FactusApp()));
}

class FactusApp extends StatelessWidget {
  const FactusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Factus App',
      theme: AppTheme.lightTheme,
      home: const LoginPage(),
    );
  }
}

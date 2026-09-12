import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'features/auth/presentation/pages/auth_test_page.dart';

void main() {
  runApp(ProviderScope(child: const FactusApp()));
}

class FactusApp extends StatelessWidget {
  const FactusApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Factus',
      home: AuthTestPage(),
    );
  }
}


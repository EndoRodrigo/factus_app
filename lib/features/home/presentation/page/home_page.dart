import 'package:factus_app/features/products/presentation/pages/products_page.dart';
import 'package:flutter/material.dart';

import '../../../customer/presentation/pages/customer_test_page.dart';
import '../../../establishment/presentation/pages/profile_page.dart';
import '../../../invoices/presentation/pages/invoice_form_page.dart';
import '../../../invoices/presentation/pages/invoices_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  late final List<Widget> _pages = [
    _HomeDashboard(
      onNavigate: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
    ),
    const InvoicesPage(),
    const InvoiceFormPage(),
  ];

  final List<String> _titles = const [
    'Factus',
    'Mis facturas',
    'Crear factura',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle_outlined),
            tooltip: 'Mi perfil',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
          ),
        ],
      ),

      drawer: Drawer(
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.receipt_long, size: 45),
                    SizedBox(height: 12),
                    Text(
                      'Factus',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text('Gestión de facturación'),
                  ],
                ),
              ),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  'CONSULTAS',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),

              ListTile(
                leading: const Icon(Icons.receipt_long_outlined),
                title: const Text('Consultar facturas'),
                onTap: () {
                  Navigator.pop(context);

                  setState(() {
                    _currentIndex = 1;
                  });
                },
              ),

              ListTile(
                leading: const Icon(Icons.people_outline),
                title: const Text('Consultar clientes'),
                onTap: () {
                  Navigator.pop(context);

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CustomerTestPage()),
                  );
                },
              ),

              const Divider(),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  'CATÁLOGOS',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),

              ListTile(
                leading: const Icon(Icons.inventory_2_outlined),
                title: const Text('Productos'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const ProductsPage()));
                },
              ),
            ],
          ),
        ),
      ),

      body: _pages[_currentIndex],

      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'Facturas',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_circle_outline),
            selectedIcon: Icon(Icons.add_circle),
            label: 'Crear',
          ),
        ],
      ),
    );
  }
}

class _HomeDashboard extends StatelessWidget {
  final ValueChanged<int> onNavigate;

  const _HomeDashboard({required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),

          const Text(
            'Hola 👋',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          Text(
            'Bienvenido a Factus',
            style: TextStyle(fontSize: 17, color: Colors.grey.shade600),
          ),

          const SizedBox(height: 30),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.receipt_long,
                  size: 45,
                  color: Theme.of(context).colorScheme.primary,
                ),

                const SizedBox(height: 16),

                const Text(
                  'Gestiona tu facturación',
                  style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 8),

                Text(
                  'Consulta tus facturas y crea nuevas facturas '
                  'desde un solo lugar.',
                  style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          const Text(
            'Acciones rápidas',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _ActionCard(
                  icon: Icons.receipt_long,
                  title: 'Consultar',
                  subtitle: 'Mis facturas',
                  onTap: () {
                    onNavigate(1);
                  },
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: _ActionCard(
                  icon: Icons.add_circle,
                  title: 'Crear',
                  subtitle: 'Nueva factura',
                  onTap: () {
                    onNavigate(2);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              Icon(
                icon,
                size: 38,
                color: Theme.of(context).colorScheme.primary,
              ),

              const SizedBox(height: 12),

              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

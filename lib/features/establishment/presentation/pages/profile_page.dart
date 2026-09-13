import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/establishment_notifier.dart';
import 'establishment_form_page.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(establishmentNotifierProvider.notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(establishmentNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi perfil'),
      ),
      body: _buildBody(state),
    );
  }

  Widget _buildBody(EstablishmentState state) {
    if (state.isLoading && state.establishment == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state.error != null && state.establishment == null) {
      return _buildError(state.error!);
    }

    if (state.establishment == null) {
      return _buildEmptyState();
    }

    return _buildProfile(state);
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.business_outlined,
              size: 80,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text(
              'Configura tu establecimiento',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Registra los datos de tu establecimiento '
                  'para utilizarlos al crear tus facturas.',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: _openForm,
              icon: const Icon(Icons.add_business),
              label: const Text('Configurar establecimiento'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfile(EstablishmentState state) {
    final establishment = state.establishment!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildHeader(establishment),
          const SizedBox(height: 24),
          _buildInfoCard(establishment),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _openForm,
              icon: const Icon(Icons.edit),
              label: const Text('Editar establecimiento'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(dynamic establishment) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor:
          Theme.of(context).colorScheme.primaryContainer,
          child: Icon(
            Icons.business,
            size: 48,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          establishment.name,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          'NIT ${establishment.nit}',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }

  Widget _buildInfoCard(dynamic establishment) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildInfoRow(
              Icons.location_on_outlined,
              'Dirección',
              establishment.address,
            ),
            const Divider(height: 28),
            _buildInfoRow(
              Icons.phone_outlined,
              'Teléfono',
              establishment.phone,
            ),
            const Divider(height: 28),
            _buildInfoRow(
              Icons.email_outlined,
              'Correo electrónico',
              establishment.email,
            ),
            const Divider(height: 28),
            _buildInfoRow(
              Icons.location_city_outlined,
              'Municipio',
              establishment.municipalityName,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
      IconData icon,
      String label,
      String value,
      ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildError(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            const Text(
              'No pudimos cargar tu establecimiento',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () {
                ref
                    .read(establishmentNotifierProvider.notifier)
                    .load();
              },
              child: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openForm() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EstablishmentFormPage(),
      ),
    );

    if (!mounted) return;

    ref.read(establishmentNotifierProvider.notifier).load();
  }
}
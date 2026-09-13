import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/app_database.dart';
import '../providers/establishment_notifier.dart';

class EstablishmentFormPage extends ConsumerStatefulWidget {
  const EstablishmentFormPage({super.key});

  @override
  ConsumerState<EstablishmentFormPage> createState() =>
      _EstablishmentFormPageState();
}

class _EstablishmentFormPageState extends ConsumerState<EstablishmentFormPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _nitController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _municipalityIdController = TextEditingController();
  final _municipalityNameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _nitController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _municipalityIdController.dispose();
    _municipalityNameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(establishmentNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          state.establishment == null
              ? 'Configurar establecimiento'
              : 'Editar establecimiento',
        ),
      ),
      body: _buildForm(state),
    );
  }

  Widget _buildForm(EstablishmentState state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.business_outlined, size: 64),

            const SizedBox(height: 24),

            _buildTextField(
              controller: _nameController,
              label: 'Nombre del establecimiento',
              icon: Icons.business,
            ),

            const SizedBox(height: 16),

            _buildTextField(
              controller: _nitController,
              label: 'NIT',
              icon: Icons.badge_outlined,
            ),

            const SizedBox(height: 16),

            _buildTextField(
              controller: _emailController,
              label: 'Correo electrónico',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
            ),

            const SizedBox(height: 16),

            _buildTextField(
              controller: _phoneController,
              label: 'Teléfono',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
            ),

            const SizedBox(height: 16),

            _buildTextField(
              controller: _addressController,
              label: 'Dirección',
              icon: Icons.location_on_outlined,
            ),

            const SizedBox(height: 16),

            _buildTextField(
              controller: _municipalityIdController,
              label: 'ID del municipio',
              icon: Icons.numbers,
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 16),

            _buildTextField(
              controller: _municipalityNameController,
              label: 'Nombre del municipio',
              icon: Icons.location_city_outlined,
            ),

            const SizedBox(height: 32),

            FilledButton.icon(
              onPressed: state.isLoading ? null : _save,
              icon: state.isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save),
              label: Text(
                state.isLoading ? 'Guardando...' : 'Guardar establecimiento',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Este campo es obligatorio';
        }

        return null;
      },
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final currentEstablishment = ref
        .read(establishmentNotifierProvider)
        .establishment;

    final establishment = Establishment(
      id: currentEstablishment!.id,
      name: _nameController.text.trim(),
      nit: _nitController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      address: _addressController.text.trim(),
      municipalityId: int.parse(_municipalityIdController.text.trim()),
      municipalityName: _municipalityNameController.text.trim(),
      createdAt: currentEstablishment?.createdAt,
      updatedAt: currentEstablishment?.updatedAt,
    );

    final notifier = ref.read(establishmentNotifierProvider.notifier);

    if (currentEstablishment == null) {
      await notifier.create(establishment);
    } else {
      await notifier.update(establishment);
    }

    if (!mounted) return;

    final state = ref.read(establishmentNotifierProvider);

    if (state.error != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(state.error!)));
      return;
    }

    Navigator.pop(context);
  }
}

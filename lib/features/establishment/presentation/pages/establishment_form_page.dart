import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/establishment.dart';
import '../../../reference/domain/entities/municipality.dart';
import '../../../reference/presentation/providers/municipality_provider.dart';
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
  final _municipalityCodeController = TextEditingController();
  final _municipalityNameController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _loadExistingData();
  }

  void _loadExistingData() {
    final establishment = ref.read(establishmentNotifierProvider).establishment;

    if (establishment == null) {
      return;
    }

    _nameController.text = establishment.name;
    _nitController.text = establishment.nit;
    _emailController.text = establishment.email;
    _phoneController.text = establishment.phone;
    _addressController.text = establishment.address;
    _municipalityCodeController.text = establishment.municipalityCode;
    _municipalityNameController.text = establishment.municipalityName;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nitController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _municipalityCodeController.dispose();
    _municipalityNameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(establishmentNotifierProvider);

    final isEditing = state.establishment != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? 'Editar establecimiento' : 'Configurar establecimiento',
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
              keyboardType: TextInputType.number,
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

            _buildMunicipalityField(),

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
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      onTap: onTap,
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

  Widget _buildMunicipalityField() {
    return _buildTextField(
      controller: _municipalityNameController,
      label: 'Municipio',
      icon: Icons.location_city_outlined,
      readOnly: true,
      onTap: _showMunicipalitySelector,
    );
  }

  void _showMunicipalitySelector() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const _MunicipalitySelector(),
    ).then((municipality) {
      if (municipality != null && municipality is Municipality) {
        setState(() {
          _municipalityCodeController.text = municipality.code;
          _municipalityNameController.text = municipality.name;
        });
      }
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final currentEstablishment = ref
        .read(establishmentNotifierProvider)
        .establishment;

    final establishment = Establishment(
      id: currentEstablishment?.id,
      name: _nameController.text.trim(),
      nit: _nitController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      address: _addressController.text.trim(),
      municipalityCode: _municipalityCodeController.text.trim(),
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

class _MunicipalitySelector extends ConsumerStatefulWidget {
  const _MunicipalitySelector();

  @override
  ConsumerState<_MunicipalitySelector> createState() =>
      __MunicipalitySelectorState();
}

class __MunicipalitySelectorState extends ConsumerState<_MunicipalitySelector> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final municipalitiesAsync = ref.watch(municipalitiesProvider);

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Buscar municipio...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _query = value.toLowerCase();
                });
              },
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: municipalitiesAsync.when(
              data: (municipalities) {
                final filtered = municipalities
                    .where((m) =>
                        m.name.toLowerCase().contains(_query) ||
                        m.departmentName.toLowerCase().contains(_query))
                    .toList();

                if (filtered.isEmpty) {
                  return const Center(child: Text('No se encontraron resultados'));
                }

                return ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final municipality = filtered[index];
                    return ListTile(
                      title: Text(municipality.name),
                      subtitle: Text(municipality.departmentName),
                      onTap: () => Navigator.pop(context, municipality),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
          ),
        ],
      ),
    );
  }
}

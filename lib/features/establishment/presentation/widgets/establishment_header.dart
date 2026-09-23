import 'package:flutter/material.dart';
import '../../domain/entities/establishment.dart';

class EstablishmentHeader extends StatelessWidget {
  final Establishment establishment;

  const EstablishmentHeader({
    super.key,
    required this.establishment,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
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
}

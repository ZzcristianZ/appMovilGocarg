import 'package:flutter/material.dart';

import 'package:gocarg/presentation/widgets/proximamente_view.dart';

/// Historial de solicitudes/viajes del cliente.
/// Contenido real se construye en la Fase 3 del plan de diseño.
class ClienteHistorialScreen extends StatelessWidget {
  const ClienteHistorialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProximamenteView(
      icon: Icons.history_rounded,
      mensaje: 'Aquí verás tus solicitudes y viajes pasados.',
    );
  }
}

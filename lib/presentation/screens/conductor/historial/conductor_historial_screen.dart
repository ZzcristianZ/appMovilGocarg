import 'package:flutter/material.dart';

import '../../../widgets/widgets.dart';


/// Historial de servicios realizados por el conductor.
/// Contenido real se construye en la Fase 5.
class ConductorHistorialScreen extends StatelessWidget {
  const ConductorHistorialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProximamenteView(
      icon: Icons.history_rounded,
      mensaje: 'Aquí verás los servicios que ya realizaste.',
    );
  }
}

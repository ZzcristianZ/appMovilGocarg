import 'package:flutter/material.dart';

import '../../../widgets/widgets.dart';

/// Perfil del conductor: datos personales, vehículo(s) y documentos de
/// verificación. Es una pantalla distinta a la del cliente porque necesita
/// estos campos adicionales. Contenido real se construye en la Fase 5.
class PerfilConductorScreen extends StatelessWidget {
  const PerfilConductorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProximamenteView(
      icon: Icons.badge_outlined,
      mensaje: 'Aquí gestionarás tu perfil, tu vehículo y tus documentos.',
    );
  }
}

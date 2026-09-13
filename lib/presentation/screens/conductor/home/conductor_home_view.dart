import 'package:flutter/material.dart';

import '../../../widgets/widgets.dart';
/// Dashboard del conductor: toggle disponible/no disponible + resumen del
/// día. Contenido real se construye en la Fase 4.
class ConductorHomeView extends StatelessWidget {
  const ConductorHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProximamenteView(
      icon: Icons.local_shipping_rounded,
      mensaje: 'Aquí controlarás tu disponibilidad y verás tu resumen del día.',
    );
  }
}

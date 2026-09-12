import 'package:flutter/material.dart';

import 'package:gocarg/presentation/widgets/proximamente_view.dart';

/// Formulario para publicar una solicitud de flete (origen, destino, tipo
/// de carga/vehículo, fecha). Contenido real se construye en la Fase 2.
class NuevaSolicitudScreen extends StatelessWidget {
  const NuevaSolicitudScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nueva solicitud')),
      body: const ProximamenteView(
        icon: Icons.local_shipping_outlined,
        mensaje: 'Aquí vas a publicar tu solicitud de flete.',
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/router/routing.dart';
import '../../../widgets/widgets.dart';

/// Seguimiento en tiempo real del servicio (mapa + estado del viaje).
/// Contenido real se construye en la Fase 3.
class SeguimientoScreen extends StatelessWidget {
  const SeguimientoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tu solicitud'),
        automaticallyImplyLeading: false,
      ),
      body: const ProximamenteView(
        icon: Icons.route_rounded,
        mensaje: 'Aquí verás el seguimiento en tiempo real de tu servicio.',
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => context.go(AppRoutes.clienteHome),
              child: const Text('Volver al inicio'),
            ),
          ),
        ),
      ),
    );
  }
}

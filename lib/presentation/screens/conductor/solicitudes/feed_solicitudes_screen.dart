import 'package:flutter/material.dart';

import 'package:gocarg/presentation/widgets/proximamente_view.dart';

/// Feed de solicitudes de flete disponibles cerca del conductor.
/// Contenido real se construye en la Fase 4.
class FeedSolicitudesScreen extends StatelessWidget {
  const FeedSolicitudesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProximamenteView(
      icon: Icons.list_alt_rounded,
      mensaje: 'Aquí verás las solicitudes de flete disponibles cerca de ti.',
    );
  }
}

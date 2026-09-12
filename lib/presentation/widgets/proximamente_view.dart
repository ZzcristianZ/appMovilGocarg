import 'package:flutter/material.dart';

/// Placeholder visual para pantallas cuyo diseño definitivo llega en una
/// fase posterior del plan. Mantiene la app navegable mientras se construye
/// cada apartado, sin bloquear el flujo de rutas.
class ProximamenteView extends StatelessWidget {
  final IconData icon;
  final String mensaje;

  const ProximamenteView({
    super.key,
    required this.icon,
    required this.mensaje,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: colors.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 32, color: colors.onSurfaceVariant),
            ),
            const SizedBox(height: 16),
            Text(
              'Próximamente',
              style: textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              mensaje,
              style: textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

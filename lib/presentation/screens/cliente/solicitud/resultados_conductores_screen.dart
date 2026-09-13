import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/router/routing.dart';
import '../../../../config/theme/theme.dart';
import '../../../providers/providers.dart';
import '../../../widgets/widgets.dart';
import '../cliente.dart';

/// Resultados de conductores/vehículos disponibles cerca, tras publicar
/// la solicitud. Datos de muestra — se conecta al backend real más
/// adelante.
class ResultadosConductoresScreen extends ConsumerWidget {
  const ResultadosConductoresScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final conductores = conductoresDisponiblesMock;
    final solicitud = ref.watch(solicitudEnProgresoProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Conductores disponibles')),
      body: Column(
        children: [
          SizedBox(
            height: 180,
            child: MockMapBackground(
              pines: const [
                Alignment(-0.5, -0.2),
                Alignment(0.3, 0.4),
                Alignment(0.6, -0.4),
              ],
            ),
          ),
          if (solicitud != null)
            Container(
              width: double.infinity,
              color: colors.surfaceContainerHighest,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  Icon(Icons.route_rounded, size: 16, color: colors.onSurfaceVariant),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      '${solicitud.origen} → ${solicitud.destino}',
                      style: textTheme.bodyMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              children: [
                Text(
                  '${conductores.length} conductores cerca de ti',
                  style: textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  'Ordenados por cercanía',
                  style: textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
                ),
                const SizedBox(height: 16),
                for (final conductor in conductores) ...[
                  _ConductorCard(
                    conductor: conductor,
                    onTap: () => context.push(
                      AppRoutes.clienteDetalleConductor,
                      extra: conductor,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ConductorCard extends StatelessWidget {
  final ConductorDisponible conductor;
  final VoidCallback onTap;

  const _ConductorCard({required this.conductor, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            border: Border.all(color: colors.outline),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.cargaSuave,
                child: Text(
                  conductor.iniciales,
                  style: const TextStyle(color: AppColors.rutaOscuro, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(conductor.nombre, style: textTheme.titleMedium),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, size: 15, color: AppColors.carga),
                        const SizedBox(width: 2),
                        Text(
                          '${conductor.calificacion}',
                          style: AppTypography.dato(fontSize: 12),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '· ${conductor.vehiculo} · ${conductor.placa}',
                          style: textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${conductor.distanciaKm} km · ${conductor.etaMinutos} min',
                      style: AppTypography.dato(fontSize: 12, color: colors.onSurfaceVariant, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${conductor.tarifa}',
                    style: AppTypography.dato(fontSize: 16, color: AppColors.rutaOscuro),
                  ),
                  const SizedBox(height: 4),
                  Icon(Icons.chevron_right_rounded, color: colors.outline),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:gocarg/config/router/app_routes.dart';
import 'package:gocarg/config/theme/theme.dart';
import 'package:gocarg/presentation/widgets/widgets.dart';

import 'viaje_historial.dart';

/// Detalle de un viaje ya finalizado, abierto desde el Historial.
class DetalleViajeScreen extends StatelessWidget {
  const DetalleViajeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viaje = GoRouterState.of(context).extra as ViajeHistorial?;
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (viaje == null) {
      return const Scaffold(body: Center(child: Text('No se encontró el viaje')));
    }

    final completado = viaje.estado == EstadoViaje.completado;

    return Scaffold(
      appBar: AppBar(title: const Text('Detalle del viaje')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          RouteTicketCard(
            origen: viaje.origen,
            destino: viaje.destino,
            chips: [
              Chip(label: Text(viaje.tipo.nombre), side: BorderSide(color: colors.outline)),
              Chip(
                label: Text(completado ? 'Completado' : 'Cancelado'),
                side: BorderSide(color: colors.outline),
                backgroundColor: completado ? AppColors.rutaVerdeSuave : AppColors.errorSuave,
                labelStyle: TextStyle(color: completado ? AppColors.rutaVerde : AppColors.error),
              ),
            ],
            pie: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.cargaSuave,
                  child: Text(
                    viaje.conductorIniciales,
                    style: const TextStyle(color: AppColors.rutaOscuro, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(viaje.conductorNombre, style: textTheme.bodyLarge),
                      Text(
                        _formatearFecha(viaje.fecha),
                        style: textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
                if (completado && viaje.tarifaFinal != null)
                  Text('\$${viaje.tarifaFinal}', style: AppTypography.dato(fontSize: 16, color: colors.onSurface)),
              ],
            ),
          ),

          const SizedBox(height: 24),

          if (completado && viaje.calificacionDada != null) ...[
            Text('Tu calificación', style: textTheme.titleMedium),
            const SizedBox(height: 10),
            Row(
              children: List.generate(5, (i) {
                final lleno = i < viaje.calificacionDada!.round();
                return Icon(
                  lleno ? Icons.star_rounded : Icons.star_border_rounded,
                  color: AppColors.carga,
                  size: 26,
                );
              }),
            ),
          ] else if (completado) ...[
            Text('¿Cómo estuvo tu viaje?', style: textTheme.titleMedium),
            const SizedBox(height: 6),
            Text(
              'Aún no has calificado este viaje.',
              style: textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => context.push(
                  AppRoutes.clienteCalificar,
                  extra: (nombre: viaje.conductorNombre, iniciales: viaje.conductorIniciales),
                ),
                icon: const Icon(Icons.star_outline_rounded),
                label: const Text('Calificar este viaje'),
              ),
            ),
          ] else ...[
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.errorSuave,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded, color: AppColors.error, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Esta solicitud fue cancelada y no se cobró ningún valor.',
                      style: textTheme.bodyMedium?.copyWith(color: AppColors.error),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => context.push(AppRoutes.clienteDisponibilidad, extra: viaje.tipo),
              child: const Text('Solicitar de nuevo'),
            ),
          ),
        ],
      ),
    );
  }

  String _formatearFecha(DateTime fecha) {
    const meses = [
      'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
      'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre',
    ];
    return '${fecha.day} de ${meses[fecha.month - 1]} · ${fecha.hour.toString().padLeft(2, '0')}:${fecha.minute.toString().padLeft(2, '0')}';
  }
}

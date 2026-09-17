import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:gocarg/config/router/app_routes.dart';
import 'package:gocarg/config/theme/theme.dart';
import 'package:gocarg/presentation/widgets/widgets.dart';

import 'viaje_historial.dart';

/// Historial de solicitudes/viajes del cliente. Datos de muestra — se
/// reemplaza por el historial real cuando exista backend.
class ClienteHistorialScreen extends StatelessWidget {
  const ClienteHistorialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (historialMock.isEmpty) {
      return const ProximamenteView(
        icon: Icons.history_rounded,
        mensaje: 'Aquí verás tus solicitudes y viajes pasados.',
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      itemCount: historialMock.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final viaje = historialMock[index];
        return _ViajeCard(
          viaje: viaje,
          onTap: () => context.push(AppRoutes.clienteHistorialDetalle, extra: viaje),
        );
      },
    );
  }
}

class _ViajeCard extends StatelessWidget {
  final ViajeHistorial viaje;
  final VoidCallback onTap;

  const _ViajeCard({required this.viaje, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final completado = viaje.estado == EstadoViaje.completado;

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
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: colors.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(viaje.tipo.icono, color: colors.onSurfaceVariant),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${viaje.origen} → ${viaje.destino}',
                      style: textTheme.bodyLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      _formatearFecha(viaje.fecha),
                      style: textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _EstadoChip(completado: completado),
                        if (completado && viaje.tarifaFinal != null) ...[
                          const SizedBox(width: 8),
                          Text(
                            '\$${viaje.tarifaFinal}',
                            style: AppTypography.dato(fontSize: 13, color: colors.onSurface),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: colors.outline),
            ],
          ),
        ),
      ),
    );
  }

  String _formatearFecha(DateTime fecha) {
    const meses = [
      'ene', 'feb', 'mar', 'abr', 'may', 'jun',
      'jul', 'ago', 'sep', 'oct', 'nov', 'dic',
    ];
    return '${fecha.day} ${meses[fecha.month - 1]} · ${fecha.hour.toString().padLeft(2, '0')}:${fecha.minute.toString().padLeft(2, '0')}';
  }
}

class _EstadoChip extends StatelessWidget {
  final bool completado;
  const _EstadoChip({required this.completado});

  @override
  Widget build(BuildContext context) {
    final color = completado ? AppColors.rutaVerde : AppColors.error;
    final colorSuave = completado ? AppColors.rutaVerdeSuave : AppColors.errorSuave;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: colorSuave, borderRadius: BorderRadius.circular(20)),
      child: Text(
        completado ? 'Completado' : 'Cancelado',
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:gocarg/config/router/app_routes.dart';
import 'package:gocarg/config/theme/app_colors.dart';
import 'package:gocarg/config/theme/app_typography.dart';
import 'package:gocarg/presentation/screens/cliente/solicitud/conductor_disponible.dart';

/// Detalle del conductor/vehículo elegido en Disponibilidad. Al confirmar,
/// se pasa a crear la solicitud (origen, destino, carga) con este
/// conductor ya asignado.
class DetalleConductorScreen extends StatelessWidget {
  const DetalleConductorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final conductor = GoRouterState.of(context).extra as ConductorDisponible?;
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (conductor == null) {
      return const Scaffold(body: Center(child: Text('No se encontró el conductor')));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Detalle del conductor')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: AppColors.cargaSuave,
                child: Text(
                  conductor.iniciales,
                  style: const TextStyle(color: AppColors.rutaOscuro, fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(conductor.nombre, style: textTheme.titleLarge),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, size: 16, color: AppColors.carga),
                        const SizedBox(width: 2),
                        Text('${conductor.calificacion}', style: AppTypography.dato(fontSize: 13, color: colors.onSurface)),
                        const SizedBox(width: 6),
                        Text(
                          '· ${conductor.viajesRealizados} viajes',
                          style: textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          Text('Vehículo', style: textTheme.titleMedium),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              border: Border.all(color: colors.outline),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Icon(conductor.tipo.icono, color: colors.onSurfaceVariant),
                const SizedBox(width: 12),
                Expanded(child: Text(conductor.tipo.nombre, style: textTheme.bodyLarge)),
                Text(conductor.placa, style: AppTypography.dato(fontSize: 14, color: colors.onSurface)),
              ],
            ),
          ),

          const SizedBox(height: 24),
          Text('Tarifa', style: textTheme.titleMedium),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: colors.outline),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Icon(Icons.handshake_outlined, color: colors.onSurfaceVariant),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'El precio se acuerda con el conductor después de enviar la solicitud.',
                    style: textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => context.push(AppRoutes.clienteNuevaSolicitud, extra: conductor),
              child: const Text('Elegir este conductor y continuar'),
            ),
          ),
        ],
      ),
    );
  }
}

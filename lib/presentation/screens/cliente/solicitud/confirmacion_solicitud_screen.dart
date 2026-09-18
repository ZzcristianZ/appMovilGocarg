import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:gocarg/config/router/app_routes.dart';
import 'package:gocarg/config/theme/app_colors.dart';
import 'package:gocarg/presentation/providers/solicitud_provider.dart';
import 'package:gocarg/presentation/widgets/route_ticket_card.dart';

/// Último paso antes de enviar la solicitud: resumen de ruta + conductor
/// elegido + tarifa. Al confirmar, limpia la solicitud en progreso y
/// entra a Seguimiento (contenido real en la Fase 3).
class ConfirmacionSolicitudScreen extends ConsumerWidget {
  const ConfirmacionSolicitudScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final solicitud = ref.watch(solicitudEnProgresoProvider);
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (solicitud == null) {
      return const Scaffold(body: Center(child: Text('Falta información de la solicitud')));
    }

    final conductor = solicitud.conductor;

    return Scaffold(
      appBar: AppBar(title: const Text('Confirmar solicitud')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          Text('Revisa antes de enviar', style: textTheme.titleLarge),
          const SizedBox(height: 4),
          Text(
            'Una vez confirmes, le llegará la solicitud a este conductor.',
            style: textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
          ),
          const SizedBox(height: 20),
          RouteTicketCard(
            origen: solicitud.origen,
            destino: solicitud.destino,
            chips: [
              Chip(label: Text(conductor.tipo.nombre), side: BorderSide(color: colors.outline)),
              if (solicitud.peso.isNotEmpty)
                Chip(label: Text('${solicitud.peso} kg'), side: BorderSide(color: colors.outline)),
            ],
            pie: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.cargaSuave,
                  child: Text(
                    conductor.iniciales,
                    style: const TextStyle(color: AppColors.rutaOscuro, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(conductor.nombre, style: textTheme.bodyLarge),
                      Text(
                        '${conductor.tipo.nombre} · ${conductor.placa}',
                        style: textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.handshake_outlined, size: 18, color: colors.onSurfaceVariant),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'El precio se acuerda con el conductor después de enviar la solicitud.',
                  style: textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
                ),
              ),
            ],
          ),
          if (solicitud.fecha != null || solicitud.hora != null) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.schedule_rounded, size: 18, color: colors.onSurfaceVariant),
                const SizedBox(width: 8),
                Text(
                  [
                    if (solicitud.fecha != null)
                      '${solicitud.fecha!.day}/${solicitud.fecha!.month}/${solicitud.fecha!.year}',
                    if (solicitud.hora != null) solicitud.hora!.format(context),
                  ].join(' · '),
                  style: textTheme.bodyMedium,
                ),
              ],
            ),
          ],
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                ref.read(solicitudEnProgresoProvider.notifier).limpiar();
                ref.read(viajeActivoProvider.notifier).iniciar(solicitud);
                context.go(AppRoutes.clienteSeguimiento);
              },
              child: const Text('Confirmar solicitud'),
            ),
          ),
        ],
      ),
    );
  }
}

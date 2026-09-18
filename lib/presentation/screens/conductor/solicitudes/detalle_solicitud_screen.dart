import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

import 'package:gocarg/config/router/app_routes.dart';
import 'package:gocarg/config/theme/theme.dart';
import 'package:gocarg/presentation/providers/providers.dart';
import 'package:gocarg/presentation/widgets/widgets.dart';

import 'solicitud_entrante.dart';

/// Detalle de una solicitud del feed, antes de aceptarla o rechazarla.
/// Al aceptar, pasa a ser el viaje en curso del conductor.
class DetalleSolicitudScreen extends ConsumerWidget {
  const DetalleSolicitudScreen({super.key});

  Future<void> _rechazar(BuildContext context, WidgetRef ref, SolicitudEntrante solicitud) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Rechazar solicitud?'),
        content: const Text('No podrás volver a verla en tu feed.'),
        actions: [
          TextButton(onPressed: () => context.pop(false), child: const Text('No')),
          TextButton(onPressed: () => context.pop(true), child: const Text('Sí, rechazar')),
        ],
      ),
    );
    if (confirmar == true && context.mounted) {
      ref.read(feedSolicitudesProvider.notifier).quitar(solicitud.id);
      context.pop();
    }
  }

  void _aceptar(BuildContext context, WidgetRef ref, SolicitudEntrante solicitud) {
    ref.read(feedSolicitudesProvider.notifier).quitar(solicitud.id);
    ref.read(viajeConductorProvider.notifier).aceptar(solicitud);
    context.go(AppRoutes.conductorViajeEnCurso);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final solicitud = GoRouterState.of(context).extra as SolicitudEntrante?;
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (solicitud == null) {
      return const Scaffold(body: Center(child: Text('No se encontró la solicitud')));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de la solicitud')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              height: 160,
              child: GoCargMap(
                interactivo: false,
                centroInicial: LatLng(solicitud.origenLat, solicitud.origenLng),
                marcadores: [
                  Marker(
                    point: LatLng(solicitud.origenLat, solicitud.origenLng),
                    width: 36,
                    height: 36,
                    child: const Icon(Icons.location_on_rounded, color: AppColors.rutaVerde, size: 32),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),
          Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: AppColors.rutaVerdeSuave,
                child: Text(
                  solicitud.clienteIniciales,
                  style: const TextStyle(color: Color(0xFF163A2B), fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(solicitud.clienteNombre, style: textTheme.titleMedium),
                    Text(
                      solicitud.haceTiempo,
                      style: textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),
          RouteTicketCard(
            origen: solicitud.origen,
            destino: solicitud.destino,
            chips: [
              Chip(label: Text(solicitud.tipo.nombre), side: BorderSide(color: colors.outline)),
              Chip(label: Text(solicitud.peso), side: BorderSide(color: colors.outline)),
            ],
          ),

          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: colors.outline),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Icon(Icons.social_distance_rounded, size: 18, color: colors.onSurfaceVariant),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'A ${solicitud.distanciaKm} km de ti · ${solicitud.etaMinutos} min hasta el punto de recogida',
                    style: textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.handshake_outlined, size: 18, color: colors.onSurfaceVariant),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Al aceptar, coordinas la recogida y la tarifa directamente con el cliente.',
                  style: textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _rechazar(context, ref, solicitud),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: colors.error,
                    side: BorderSide(color: colors.error.withValues(alpha: 0.4)),
                  ),
                  child: const Text('Rechazar'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _aceptar(context, ref, solicitud),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.rutaVerde,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Aceptar'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

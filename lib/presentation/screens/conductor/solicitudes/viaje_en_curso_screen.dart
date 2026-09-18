import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

import 'package:gocarg/config/router/app_routes.dart';
import 'package:gocarg/config/theme/theme.dart';
import 'package:gocarg/presentation/providers/providers.dart';
import 'package:gocarg/presentation/widgets/widgets.dart';

extension on EstadoViajeConductor {
  String get titulo => switch (this) {
        EstadoViajeConductor.hacialRecogida => 'Yendo al punto de recogida',
        EstadoViajeConductor.cargaRecogida => 'Carga recogida',
        EstadoViajeConductor.enRuta => 'En ruta al destino',
        EstadoViajeConductor.entregado => 'Carga entregada',
      };

  IconData get icono => switch (this) {
        EstadoViajeConductor.hacialRecogida => Icons.local_shipping_rounded,
        EstadoViajeConductor.cargaRecogida => Icons.inventory_2_rounded,
        EstadoViajeConductor.enRuta => Icons.alt_route_rounded,
        EstadoViajeConductor.entregado => Icons.check_circle_rounded,
      };

  String get accion => switch (this) {
        EstadoViajeConductor.hacialRecogida => 'Marcar carga recogida',
        EstadoViajeConductor.cargaRecogida => 'Iniciar ruta al destino',
        EstadoViajeConductor.enRuta => 'Marcar como entregado',
        EstadoViajeConductor.entregado => 'Finalizar viaje',
      };
}

/// Viaje que el conductor ya aceptó y tiene en curso: a diferencia del
/// Seguimiento del cliente (que avanza solo), aquí el propio conductor
/// marca cada paso con el botón de acción, porque es quien de verdad sabe
/// si ya recogió o entregó la carga.
class ViajeEnCursoScreen extends ConsumerWidget {
  const ViajeEnCursoScreen({super.key});

  Future<void> _cancelar(BuildContext context, WidgetRef ref) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Cancelar viaje?'),
        content: const Text('El cliente ya fue notificado de que aceptaste. ¿Seguro que quieres cancelar?'),
        actions: [
          TextButton(onPressed: () => context.pop(false), child: const Text('No')),
          TextButton(onPressed: () => context.pop(true), child: const Text('Sí, cancelar')),
        ],
      ),
    );
    if (confirmar == true && context.mounted) {
      ref.read(viajeConductorProvider.notifier).finalizar();
      context.go(AppRoutes.conductorHome);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viaje = ref.watch(viajeConductorProvider);
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (viaje == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Viaje en curso'),
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => context.go(AppRoutes.conductorHome),
          ),
        ),
        body: const ProximamenteView(
          icon: Icons.local_shipping_rounded,
          mensaje: 'Aquí verás el viaje que tengas en curso.',
        ),
      );
    }

    final solicitud = viaje.solicitud;
    final estado = viaje.estado;
    final entregado = estado == EstadoViajeConductor.entregado;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Viaje en curso'),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          tooltip: 'Ir a Inicio (el viaje sigue en curso)',
          onPressed: () => context.go(AppRoutes.conductorHome),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              height: 180,
              child: GoCargMap(
                interactivo: false,
                centroInicial: entregado
                    ? LatLng(solicitud.destinoLat, solicitud.destinoLng)
                    : LatLng(solicitud.origenLat, solicitud.origenLng),
                marcadores: [
                  Marker(
                    point: entregado
                        ? LatLng(solicitud.destinoLat, solicitud.destinoLng)
                        : LatLng(solicitud.origenLat, solicitud.origenLng),
                    width: 36,
                    height: 36,
                    child: const Icon(Icons.location_on_rounded, color: AppColors.rutaVerde, size: 32),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: entregado ? AppColors.rutaVerdeSuave : colors.secondaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Icon(estado.icono, color: entregado ? AppColors.rutaVerde : colors.onSecondaryContainer),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    estado.titulo,
                    style: textTheme.titleMedium?.copyWith(
                      color: entregado ? const Color(0xFF163A2B) : colors.onSecondaryContainer,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          RouteTicketCard(
            origen: solicitud.origen,
            destino: solicitud.destino,
            pie: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.rutaVerdeSuave,
                  child: Text(
                    solicitud.clienteIniciales,
                    style: const TextStyle(color: Color(0xFF163A2B), fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(solicitud.clienteNombre, style: textTheme.bodyLarge),
                      Text(
                        '${solicitud.tipo.nombre} · ${solicitud.peso}',
                        style: textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Contactar cliente',
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('El chat con el cliente estará disponible en la siguiente fase.')),
                    );
                  },
                  icon: Icon(Icons.chat_bubble_outline_rounded, color: colors.primary),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (entregado) {
                  ref.read(viajeConductorProvider.notifier).finalizar();
                  context.go(AppRoutes.conductorHome);
                } else {
                  ref.read(viajeConductorProvider.notifier).avanzar();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.rutaVerde,
                foregroundColor: Colors.white,
              ),
              child: Text(estado.accion),
            ),
          ),
          if (!entregado) ...[
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => _cancelar(context, ref),
                child: const Text('Cancelar viaje'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

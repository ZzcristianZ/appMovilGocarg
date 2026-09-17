import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

import 'package:gocarg/config/router/app_routes.dart';
import 'package:gocarg/config/theme/theme.dart';
import 'package:gocarg/presentation/widgets/widgets.dart';

import 'solicitud_flete.dart';

enum _EstadoViaje { confirmada, conductorEnCamino, cargaRecogida, enRuta, entregado }

extension on _EstadoViaje {
  String get titulo => switch (this) {
        _EstadoViaje.confirmada => 'Solicitud confirmada',
        _EstadoViaje.conductorEnCamino => 'El conductor va en camino',
        _EstadoViaje.cargaRecogida => 'Tu carga fue recogida',
        _EstadoViaje.enRuta => 'En camino al destino',
        _EstadoViaje.entregado => 'Carga entregada',
      };

  IconData get icono => switch (this) {
        _EstadoViaje.confirmada => Icons.task_alt_rounded,
        _EstadoViaje.conductorEnCamino => Icons.local_shipping_rounded,
        _EstadoViaje.cargaRecogida => Icons.inventory_2_rounded,
        _EstadoViaje.enRuta => Icons.alt_route_rounded,
        _EstadoViaje.entregado => Icons.check_circle_rounded,
      };
}

/// Seguimiento del servicio en curso: estado del viaje, mapa del conductor
/// y acceso al chat. Sin backend todavía — el avance de estados es
/// simulado localmente para poder mostrar el flujo completo.
class SeguimientoScreen extends StatefulWidget {
  const SeguimientoScreen({super.key});

  @override
  State<SeguimientoScreen> createState() => _SeguimientoScreenState();
}

class _SeguimientoScreenState extends State<SeguimientoScreen> {
  _EstadoViaje _estado = _EstadoViaje.confirmada;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      final siguiente = _estado.index + 1;
      if (siguiente >= _EstadoViaje.values.length) {
        timer.cancel();
        return;
      }
      setState(() => _estado = _EstadoViaje.values[siguiente]);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _cancelar() async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Cancelar solicitud?'),
        content: const Text('El conductor ya fue notificado. ¿Seguro que quieres cancelarla?'),
        actions: [
          TextButton(onPressed: () => context.pop(false), child: const Text('No')),
          TextButton(onPressed: () => context.pop(true), child: const Text('Sí, cancelar')),
        ],
      ),
    );
    if (confirmar == true && mounted) {
      context.go(AppRoutes.clienteHome);
    }
  }

  @override
  Widget build(BuildContext context) {
    final solicitud = GoRouterState.of(context).extra as SolicitudFlete?;
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final entregado = _estado == _EstadoViaje.entregado;

    if (solicitud == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Tu solicitud'), automaticallyImplyLeading: false),
        body: const ProximamenteView(
          icon: Icons.route_rounded,
          mensaje: 'Aquí verás el seguimiento en tiempo real de tu servicio.',
        ),
      );
    }

    final conductor = solicitud.conductor;

    return Scaffold(
      appBar: AppBar(title: const Text('Tu solicitud'), automaticallyImplyLeading: false),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              height: 180,
              child: GoCargMap(
                interactivo: false,
                centroInicial: LatLng(conductor.lat, conductor.lng),
                marcadores: [
                  Marker(
                    point: LatLng(conductor.lat, conductor.lng),
                    width: 36,
                    height: 36,
                    child: Icon(conductor.tipo.icono, color: AppColors.rutaVerde, size: 30),
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
                Icon(_estado.icono, color: entregado ? AppColors.rutaVerde : AppColors.rutaOscuro),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _estado.titulo,
                    style: textTheme.titleMedium?.copyWith(
                      color: entregado ? const Color(0xFF163A2B) : AppColors.rutaOscuro,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          _LineaDeTiempo(estadoActual: _estado),

          const SizedBox(height: 24),
          RouteTicketCard(
            origen: solicitud.origen,
            destino: solicitud.destino,
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
                IconButton(
                  onPressed: () => context.push(AppRoutes.clienteChat, extra: conductor),
                  icon: Icon(Icons.chat_bubble_outline_rounded, color: colors.primary),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: colors.outline),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Icon(Icons.handshake_outlined, size: 18, color: colors.onSurfaceVariant),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Tarifa: acuérdala con el conductor por el chat.',
                    style: textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),
          if (entregado) ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => context.push(
                  AppRoutes.clienteCalificar,
                  extra: (nombre: conductor.nombre, iniciales: conductor.iniciales),
                ),
                icon: const Icon(Icons.star_outline_rounded),
                label: const Text('Calificar viaje'),
              ),
            ),
            const SizedBox(height: 8),
          ],
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: entregado ? () => context.go(AppRoutes.clienteHome) : _cancelar,
              child: Text(entregado ? 'Volver al inicio' : 'Cancelar solicitud'),
            ),
          ),
        ],
      ),
    );
  }
}

class _LineaDeTiempo extends StatelessWidget {
  final _EstadoViaje estadoActual;
  const _LineaDeTiempo({required this.estadoActual});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      children: _EstadoViaje.values.map((estado) {
        final completado = estado.index <= estadoActual.index;
        final esUltimo = estado == _EstadoViaje.values.last;

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Icon(
                    completado ? Icons.check_circle_rounded : Icons.circle_outlined,
                    size: 18,
                    color: completado ? AppColors.rutaVerde : colors.outline,
                  ),
                  if (!esUltimo)
                    Expanded(
                      child: Container(
                        width: 2,
                        margin: const EdgeInsets.symmetric(vertical: 2),
                        color: completado ? AppColors.rutaVerde : colors.outlineVariant,
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 12),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  estado.titulo,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: completado ? FontWeight.w600 : FontWeight.normal,
                    color: completado ? colors.onSurface : colors.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

import 'package:gocarg/config/router/app_routes.dart';
import 'package:gocarg/config/theme/app_colors.dart';
import 'package:gocarg/config/theme/app_typography.dart';
import 'package:gocarg/presentation/screens/cliente/solicitud/conductor_disponible.dart';
import 'package:gocarg/presentation/screens/cliente/solicitud/tipo_vehiculo.dart';
import 'package:gocarg/presentation/widgets/gocarg_map.dart';

/// Ver disponibilidad de conductores/vehículos por tipo, ANTES de crear la
/// solicitud. Al elegir un conductor recién se llena el formulario con
/// origen/destino — no al revés. Datos de muestra — se conecta al backend
/// (con ubicación en vivo) más adelante.
class DisponibilidadScreen extends StatelessWidget {
  const DisponibilidadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tipo = GoRouterState.of(context).extra as TipoVehiculo?;
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final conductores = tipo == null
        ? conductoresDisponiblesMock
        : conductoresDisponiblesMock.where((c) => c.tipo == tipo).toList();

    return Scaffold(
      appBar: AppBar(title: Text(tipo?.nombre ?? 'Disponibilidad')),
      body: Column(
        children: [
          SizedBox(
            height: 200,
            child: GoCargMap(
              interactivo: false,
              marcadores: [
                for (final c in conductores)
                  Marker(
                    point: LatLng(c.lat, c.lng),
                    width: 36,
                    height: 36,
                    child: Icon(c.tipo.icono, color: AppColors.rutaVerde, size: 30),
                  ),
              ],
            ),
          ),
          Expanded(
            child: conductores.isEmpty
                ? Center(
                    child: Text(
                      'No hay conductores disponibles de este tipo ahora mismo',
                      style: textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                    children: [
                      Text('${conductores.length} disponibles cerca de ti', style: textTheme.titleMedium),
                      const SizedBox(height: 4),
                      Text(
                        'Elige un conductor para crear tu solicitud',
                        style: textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
                      ),
                      const SizedBox(height: 16),
                      for (final conductor in conductores) ...[
                        _ConductorCard(
                          conductor: conductor,
                          onTap: () => context.push(AppRoutes.clienteNuevaSolicitud, extra: conductor),
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
                        Text('${conductor.calificacion}', style: AppTypography.dato(fontSize: 12, color: colors.onSurface)),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            '· ${conductor.tipo.nombre} · ${conductor.placa}',
                            style: textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
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
              Icon(Icons.chevron_right_rounded, color: colors.outline),
            ],
          ),
        ),
      ),
    );
  }
}

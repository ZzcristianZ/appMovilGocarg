import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:gocarg/config/router/app_routes.dart';
import 'package:gocarg/config/theme/theme.dart';
import 'package:gocarg/presentation/providers/providers.dart';

import 'solicitud_entrante.dart';

/// Feed de solicitudes de flete disponibles cerca del conductor. Solo se ve
/// si está disponible y no tiene ya un viaje en curso (Fase 4).
class FeedSolicitudesScreen extends ConsumerWidget {
  const FeedSolicitudesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final disponible = ref.watch(disponibilidadConductorProvider);
    final viaje = ref.watch(viajeConductorProvider);
    final solicitudes = ref.watch(feedSolicitudesProvider);
    final colors = Theme.of(context).colorScheme;

    if (viaje != null) {
      return _MensajeCentral(
        icon: Icons.local_shipping_rounded,
        titulo: 'Tienes un viaje en curso',
        mensaje: 'Termina o cancela tu viaje actual antes de ver nuevas solicitudes.',
        accion: 'Ver viaje en curso',
        onAccion: () => context.push(AppRoutes.conductorViajeEnCurso),
      );
    }

    if (!disponible) {
      return _MensajeCentral(
        icon: Icons.pause_circle_outline_rounded,
        titulo: 'No estás disponible',
        mensaje: 'Actívate en Inicio para empezar a ver solicitudes de flete cerca de ti.',
        accion: 'Ir a Inicio',
        onAccion: () => context.go(AppRoutes.conductorHome),
      );
    }

    if (solicitudes.isEmpty) {
      return const _MensajeCentral(
        icon: Icons.inbox_outlined,
        titulo: 'Sin solicitudes por ahora',
        mensaje: 'En cuanto un cliente cerca de ti pida un flete, aparecerá aquí.',
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      itemCount: solicitudes.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final solicitud = solicitudes[index];
        return _SolicitudCard(
          solicitud: solicitud,
          colors: colors,
          onTap: () => context.push(AppRoutes.conductorDetalleSolicitud, extra: solicitud),
        );
      },
    );
  }
}

class _SolicitudCard extends StatelessWidget {
  final SolicitudEntrante solicitud;
  final ColorScheme colors;
  final VoidCallback onTap;

  const _SolicitudCard({required this.solicitud, required this.colors, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: colors.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.rutaVerdeSuave,
                child: Text(
                  solicitud.clienteIniciales,
                  style: const TextStyle(color: Color(0xFF163A2B), fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(child: Text(solicitud.clienteNombre, style: textTheme.titleSmall)),
                        Text(
                          solicitud.haceTiempo,
                          style: textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.circle, size: 8, color: colors.primary),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            solicitud.origen,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Icon(Icons.location_on_rounded, size: 12, color: colors.tertiary),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            solicitud.destino,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        _Etiqueta(icon: solicitud.tipo.icono, texto: solicitud.tipo.nombre, colors: colors),
                        _Etiqueta(icon: Icons.scale_outlined, texto: solicitud.peso, colors: colors),
                        _Etiqueta(
                          icon: Icons.social_distance_rounded,
                          texto: '${solicitud.distanciaKm} km · ${solicitud.etaMinutos} min',
                          colors: colors,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Etiqueta extends StatelessWidget {
  final IconData icon;
  final String texto;
  final ColorScheme colors;

  const _Etiqueta({required this.icon, required this.texto, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: colors.onSurfaceVariant),
          const SizedBox(width: 4),
          Text(texto, style: TextStyle(fontSize: 11, color: colors.onSurfaceVariant)),
        ],
      ),
    );
  }
}

class _MensajeCentral extends StatelessWidget {
  final IconData icon;
  final String titulo;
  final String mensaje;
  final String? accion;
  final VoidCallback? onAccion;

  const _MensajeCentral({
    required this.icon,
    required this.titulo,
    required this.mensaje,
    this.accion,
    this.onAccion,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: colors.onSurfaceVariant),
            const SizedBox(height: 16),
            Text(titulo, style: textTheme.titleMedium, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(
              mensaje,
              style: textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
            if (accion != null) ...[
              const SizedBox(height: 20),
              OutlinedButton(onPressed: onAccion, child: Text(accion!)),
            ],
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gocarg/config/router/app_routes.dart';
import 'package:gocarg/config/theme/theme.dart';
import 'package:gocarg/presentation/providers/providers.dart';
import 'package:gocarg/presentation/screens/cliente/solicitud/solicitud.dart';

import '../historial/viaje_historial.dart';

/// Si ya hay un viaje en curso, no tiene sentido abrir una segunda
/// solicitud (reemplazaría en silencio el viaje activo) — se lleva al
/// cliente a Seguimiento en su lugar.
void _irASolicitar(BuildContext context, ViajeActivo? viajeActivo, {TipoVehiculo? tipo}) {
  if (viajeActivo != null) {
    context.push(AppRoutes.clienteSeguimiento);
  } else {
    context.push(AppRoutes.clienteDisponibilidad, extra: tipo);
  }
}

class ClienteHomeView extends ConsumerWidget {
  const ClienteHomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final viajeActivo = ref.watch(viajeActivoProvider);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Hero Header ───────────────────────────────────────────
          _HeroHeader(colors: colors, viajeActivo: viajeActivo),

          // ── Contenido ─────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionTitle(title: '¿Qué necesitas mover?'),
                const SizedBox(height: 14),
                _ServicesRow(colors: colors, viajeActivo: viajeActivo),

                const SizedBox(height: 28),

                _SectionTitle(title: 'Disponible ahora en Ocaña'),
                const SizedBox(height: 14),
                _StatsGrid(colors: colors),

                const SizedBox(height: 28),

                _SectionTitle(title: 'Actividad reciente'),
                const SizedBox(height: 14),
                _RecentActivity(colors: colors),

                const SizedBox(height: 28),

                _PromoBanner(colors: colors, viajeActivo: viajeActivo),

                const SizedBox(height: 28),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Hero Header ───────────────────────────────────────────────────────────────

class _HeroHeader extends StatelessWidget {
  final ColorScheme colors;
  final ViajeActivo? viajeActivo;
  const _HeroHeader({required this.colors, required this.viajeActivo});

  @override
  Widget build(BuildContext context) {
    final activo = viajeActivo != null;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colors.primary, colors.tertiary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -30,
            right: -20,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
          ),
          Positioned(
            bottom: -40,
            right: 70,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.04),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Badge de estado — solo dice "activo" cuando de verdad hay
                // un viaje en curso, y en ese caso lleva a Seguimiento.
                _BadgeEstado(activo: activo),
                const SizedBox(height: 14),
                const Text(
                  'Hola, Cristian 👋',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '¿Qué vas a transportar hoy?',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.75),
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 20),
                // CTA de búsqueda
                Material(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(16),
                  clipBehavior: Clip.antiAlias,
                  elevation: 8,
                  shadowColor: Colors.black.withValues(alpha: 0.12),
                  child: InkWell(
                    onTap: () => _irASolicitar(context, viajeActivo),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      child: Row(
                        children: [
                          Icon(Icons.location_on_rounded, color: colors.primary, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              '¿A dónde va tu carga?',
                              style: TextStyle(color: colors.onSurfaceVariant, fontSize: 14),
                            ),
                          ),
                          FilledButton(
                            onPressed: () => _irASolicitar(context, viajeActivo),
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              visualDensity: VisualDensity.compact,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Solicitar',
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BadgeEstado extends StatelessWidget {
  final bool activo;
  const _BadgeEstado({required this.activo});

  @override
  Widget build(BuildContext context) {
    final contenido = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: activo ? const Color(0xFF4ADE80) : Colors.white.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            activo ? 'Servicio activo · toca para verlo' : 'Sin servicio activo',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );

    if (!activo) {
      return contenido;
    }

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push(AppRoutes.clienteSeguimiento),
        child: contenido,
      ),
    );
  }
}

// ── Section Title ─────────────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: -0.3,
          ),
    );
  }
}

// ── Services Row ──────────────────────────────────────────────────────────────

class _ServicesRow extends StatelessWidget {
  final ColorScheme colors;
  final ViajeActivo? viajeActivo;
  const _ServicesRow({required this.colors, required this.viajeActivo});

  @override
  Widget build(BuildContext context) {
    final services = [
      (
        Icons.airport_shuttle_rounded,
        'Camión\nde carga',
        'Hasta 5 ton',
        colors.primaryContainer,
        colors.onPrimaryContainer,
        TipoVehiculo.camion,
      ),
      (
        Icons.motorcycle_rounded,
        'Moto\ncarga',
        'Hasta 200 kg',
        colors.secondaryContainer,
        colors.onSecondaryContainer,
        TipoVehiculo.moto,
      ),
    ];

    return Row(
      children: services.map((s) {
        final (icon, label, sub, bg, fg, tipo) = s;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: _ServiceTile(
              icon: icon,
              label: label,
              subtitle: sub,
              bg: bg,
              fg: fg,
              onTap: () => _irASolicitar(context, viajeActivo, tipo: tipo),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _ServiceTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color bg;
  final Color fg;
  final VoidCallback onTap;

  const _ServiceTile({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.bg,
    required this.fg,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: fg.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: fg, size: 22),
              ),
              const SizedBox(height: 12),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: fg,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 11,
                  color: fg.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Stats Grid ────────────────────────────────────────────────────────────────
//
// Datos derivados de los conductores/viajes de muestra (Ocaña) — antes esta
// sección mostraba métricas de flota genéricas ("12 Vehículos", "7 Activos")
// que no aplican a un cliente que solo solicita un flete ocasional.

class _StatsGrid extends StatelessWidget {
  final ColorScheme colors;
  const _StatsGrid({required this.colors});

  @override
  Widget build(BuildContext context) {
    final camiones =
        conductoresDisponiblesMock.where((c) => c.tipo == TipoVehiculo.camion).length;
    final motos = conductoresDisponiblesMock.where((c) => c.tipo == TipoVehiculo.moto).length;
    final calificacionProm = conductoresDisponiblesMock.isEmpty
        ? 0.0
        : conductoresDisponiblesMock.map((c) => c.calificacion).reduce((a, b) => a + b) /
            conductoresDisponiblesMock.length;
    final viajesCompletados =
        historialMock.where((v) => v.estado == EstadoViaje.completado).length;

    final stats = [
      (Icons.airport_shuttle_rounded, '$camiones', 'Camiones libres', colors.primary),
      (Icons.motorcycle_rounded, '$motos', 'Motos libres', colors.secondary),
      (Icons.star_rounded, calificacionProm.toStringAsFixed(1), 'Calif. conductores', const Color(0xFFFBBF24)),
      (Icons.check_circle_rounded, '$viajesCompletados', 'Tus viajes', const Color(0xFF4ADE80)),
    ];

    return Row(
      children: stats.asMap().entries.map((entry) {
        final i = entry.key;
        final (icon, val, label, color) = entry.value;
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: i < stats.length - 1 ? 10 : 0),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
            decoration: BoxDecoration(
              color: colors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: colors.outlineVariant.withValues(alpha: 0.4),
              ),
            ),
            child: Column(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(height: 6),
                Text(
                  val,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: colors.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: TextStyle(fontSize: 10, color: colors.onSurfaceVariant),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ── Recent Activity ───────────────────────────────────────────────────────────
//
// Ahora es la actividad real del cliente (del historial de muestra en
// Ocaña) — antes mostraba viajes de una flota ajena en barrios de Bogotá.

class _RecentActivity extends StatelessWidget {
  final ColorScheme colors;
  const _RecentActivity({required this.colors});

  @override
  Widget build(BuildContext context) {
    final recientes = historialMock.take(3).toList();

    if (recientes.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          'Todavía no tienes viajes. Cuando solicites uno, aquí verás su estado.',
          style: TextStyle(fontSize: 13, color: colors.onSurfaceVariant),
        ),
      );
    }

    return Column(
      children: recientes.map((viaje) {
        final completado = viaje.estado == EstadoViaje.completado;
        final color = completado ? AppColors.rutaVerde : AppColors.error;
        final icon = completado ? Icons.check_circle_rounded : Icons.cancel_rounded;
        final titulo = completado ? 'Viaje completado' : 'Solicitud cancelada';

        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: colors.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(titulo,
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 13, color: colors.onSurface)),
                    const SizedBox(height: 2),
                    Text(
                      '${viaje.tipo.nombre} · ${viaje.origen} → ${viaje.destino}',
                      style: TextStyle(fontSize: 11, color: colors.onSurfaceVariant),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(_formatearFecha(viaje.fecha),
                  style: TextStyle(fontSize: 10, color: colors.onSurfaceVariant)),
            ],
          ),
        );
      }).toList(),
    );
  }

  String _formatearFecha(DateTime fecha) {
    const meses = [
      'ene', 'feb', 'mar', 'abr', 'may', 'jun',
      'jul', 'ago', 'sep', 'oct', 'nov', 'dic',
    ];
    return '${fecha.day} ${meses[fecha.month - 1]}';
  }
}

// ── Promo Banner ──────────────────────────────────────────────────────────────
//
// Antes anunciaba "PRÓXIMAMENTE: Seguimiento en tiempo real" — pero ese
// seguimiento ya existe (Fase 3), así que mantener el rótulo era falso.
// Ahora: si hay un viaje activo, lleva directo a Seguimiento; si no, muestra
// una propuesta de valor real de la app (tarifa negociada por chat).

class _PromoBanner extends StatelessWidget {
  final ColorScheme colors;
  final ViajeActivo? viajeActivo;
  const _PromoBanner({required this.colors, required this.viajeActivo});

  @override
  Widget build(BuildContext context) {
    final activo = viajeActivo != null;

    final contenido = Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colors.primary, colors.tertiary],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    activo ? 'EN CURSO' : 'CÓMO FUNCIONA',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  activo ? 'Tu carga va\nen camino' : 'Tarifa justa,\nacordada contigo',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  activo
                      ? 'Toca para ver el seguimiento en vivo'
                      : 'Habla directo con el conductor y define el precio por chat',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(activo ? Icons.map_rounded : Icons.handshake_rounded,
                color: Colors.white, size: 36),
          ),
        ],
      ),
    );

    if (!activo) {
      return contenido;
    }

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push(AppRoutes.clienteSeguimiento),
        child: contenido,
      ),
    );
  }
}

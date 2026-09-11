import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gocarg/config/router/app_routes.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Hero Header ───────────────────────────────────────────
          _HeroHeader(colors: colors),

          // ── Contenido ─────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionTitle(title: '¿Qué necesitas mover?'),
                const SizedBox(height: 14),
                _ServicesRow(colors: colors),

                const SizedBox(height: 28),

                _SectionTitle(title: 'En tiempo real'),
                const SizedBox(height: 14),
                _StatsGrid(colors: colors),

                const SizedBox(height: 28),

                _SectionTitle(title: 'Actividad reciente'),
                const SizedBox(height: 14),
                _RecentActivity(colors: colors),

                const SizedBox(height: 28),

                _PromoBanner(colors: colors),

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
  const _HeroHeader({required this.colors});

  @override
  Widget build(BuildContext context) {
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
                // Badge activo
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
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
                        decoration: const BoxDecoration(
                          color: Color(0xFF4ADE80),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Servicio activo',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
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
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.location_on_rounded,
                          color: colors.primary, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          '¿A dónde va tu carga?',
                          style: TextStyle(
                              color: colors.outline, fontSize: 14),
                        ),
                      ),
                      FilledButton(
                        onPressed: () {},
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          visualDensity: VisualDensity.compact,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Solicitar',
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
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
  const _ServicesRow({required this.colors});

  @override
  Widget build(BuildContext context) {
    final services = [
      (
        Icons.airport_shuttle_rounded,
        'Camión\nde carga',
        'Hasta 5 ton',
        colors.primaryContainer,
        colors.onPrimaryContainer,
        AppRoutes.cars,
      ),
      (
        Icons.motorcycle_rounded,
        'Moto\ncarga',
        'Hasta 200 kg',
        colors.secondaryContainer,
        colors.onSecondaryContainer,
        AppRoutes.motocars,
      ),
    ];

    return Row(
      children: services.map((s) {
        final (icon, label, sub, bg, fg, route) = s;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: _ServiceTile(
              icon: icon,
              label: label,
              subtitle: sub,
              bg: bg,
              fg: fg,
              onTap: () => context.go(route),
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

class _StatsGrid extends StatelessWidget {
  final ColorScheme colors;
  const _StatsGrid({required this.colors});

  @override
  Widget build(BuildContext context) {
    final stats = [
      (Icons.directions_car_filled_rounded, '12', 'Vehículos', colors.primary),
      (Icons.motorcycle_rounded, '8', 'Motos', colors.secondary),
      (Icons.check_circle_rounded, '7', 'Activos', const Color(0xFF4ADE80)),
      (Icons.pending_rounded, '5', 'En ruta', const Color(0xFFFBBF24)),
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
                  style: TextStyle(fontSize: 10, color: colors.outline),
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

class _RecentActivity extends StatelessWidget {
  final ColorScheme colors;
  const _RecentActivity({required this.colors});

  @override
  Widget build(BuildContext context) {
    final activity = [
      (
        Icons.check_circle_rounded,
        'Entrega completada',
        'Camión #3 · Cra 7 → Suba',
        'Hace 2h',
        const Color(0xFF4ADE80),
      ),
      (
        Icons.local_shipping_rounded,
        'Servicio en curso',
        'Moto #2 · Kennedy → Chapinero',
        'En progreso',
        const Color(0xFFFBBF24),
      ),
      (
        Icons.schedule_rounded,
        'Solicitud pendiente',
        'Camión #5 · Usaquén → Soacha',
        'Hace 45 min',
        colors.outline,
      ),
    ];

    return Column(
      children: activity.map((a) {
        final (icon, title, subtitle, time, color) = a;
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
                    Text(title,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 13)),
                    const SizedBox(height: 2),
                    Text(subtitle,
                        style: TextStyle(
                            fontSize: 11, color: colors.outline)),
                  ],
                ),
              ),
              Text(time,
                  style: TextStyle(fontSize: 10, color: colors.outline)),
            ],
          ),
        );
      }).toList(),
    );
  }
}

// ── Promo Banner ──────────────────────────────────────────────────────────────

class _PromoBanner extends StatelessWidget {
  final ColorScheme colors;
  const _PromoBanner({required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'PRÓXIMAMENTE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Seguimiento\nen tiempo real',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Rastrea tu carga en el mapa',
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
            child: const Icon(Icons.map_rounded,
                color: Colors.white, size: 36),
          ),
        ],
      ),
    );
  }
}
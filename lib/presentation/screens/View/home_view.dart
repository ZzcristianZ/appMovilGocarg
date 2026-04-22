import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gocarg/config/router/app_routes.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Banner de bienvenida ──────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [colors.primary, colors.secondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.local_shipping_rounded,
                    size: 40,
                    color: colors.onPrimary,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '¡Bienvenido a Gocarg!',
                    style: textTheme.headlineSmall?.copyWith(
                      color: colors.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Tu solución de carga y transporte',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colors.onPrimary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            Text(
              'Nuestros Servicios',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Cards de servicios
            Row(
              children: [
                Expanded(
                  child: _ServiceCard(
                    icon: Icons.airport_shuttle_outlined,
                    title: 'Carros\nde Carga',
                    subtitle: 'Flota disponible',
                    color: colors.primaryContainer,
                    iconColor: colors.primary,
                    onTap: () => context.go(AppRoutes.cars),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _ServiceCard(
                    icon: Icons.motorcycle_sharp,
                    title: 'Moto\nCargas',
                    subtitle: 'Entregas rápidas',
                    color: colors.secondaryContainer,
                    iconColor: colors.secondary,
                    onTap: () => context.go(AppRoutes.motocars),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            Text(
              'Resumen',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            _StatRow(
              items: [
                _StatItem(
                  label: 'Vehículos',
                  value: '12',
                  icon: Icons.directions_car,
                ),
                _StatItem(label: 'Motos', value: '8', icon: Icons.motorcycle),
                _StatItem(
                  label: 'Activos',
                  value: '7',
                  icon: Icons.check_circle_outline,
                ),
              ],
            ),

            const SizedBox(height: 28),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colors.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: colors.primary, size: 28),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      'Estamos construyendo algo increíble. Más funciones próximamente.',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: size.height * 0.02),
          ],
        ),
      ),
    );
  }
}


class _ServiceCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final Color iconColor;
  final VoidCallback onTap;

  const _ServiceCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 36, color: iconColor),
            const SizedBox(height: 12),
            Text(
              title,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: textTheme.bodySmall?.copyWith(color: iconColor),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final List<_StatItem> items;
  const _StatRow({required this.items});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: items
          .map((item) => Expanded(child: _StatCard(item: item)))
          .toList(),
    );
  }
}

class _StatItem {
  final String label;
  final String value;
  final IconData icon;
  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
  });
}

class _StatCard extends StatelessWidget {
  final _StatItem item;
  const _StatCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 0,
      color: colors.surfaceContainerLow,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Column(
          children: [
            Icon(item.icon, color: colors.primary, size: 22),
            const SizedBox(height: 6),
            Text(
              item.value,
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              item.label,
              style: textTheme.labelSmall?.copyWith(color: colors.outline),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

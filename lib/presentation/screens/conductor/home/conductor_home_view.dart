import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:gocarg/config/router/app_routes.dart';
import 'package:gocarg/config/theme/theme.dart';
import 'package:gocarg/presentation/providers/providers.dart';

/// Dashboard del conductor: toggle disponible/no disponible y acceso al
/// viaje en curso o al feed de solicitudes, según corresponda (Fase 4).
class ConductorHomeView extends ConsumerWidget {
  const ConductorHomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final disponible = ref.watch(disponibilidadConductorProvider);
    final viaje = ref.watch(viajeConductorProvider);
    final solicitudesCerca = ref.watch(feedSolicitudesProvider).length;
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      children: [
        if (viaje != null) ...[
          _ViajeEnCursoBanner(onTap: () => context.push(AppRoutes.conductorViajeEnCurso)),
          const SizedBox(height: 20),
        ],

        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: disponible ? AppColors.rutaVerdeSuave : colors.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: disponible ? AppColors.rutaVerde : colors.onSurfaceVariant.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  disponible ? Icons.local_shipping_rounded : Icons.local_shipping_outlined,
                  color: disponible ? Colors.white : colors.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      disponible ? 'Estás disponible' : 'No estás disponible',
                      style: textTheme.titleMedium?.copyWith(
                        color: disponible ? const Color(0xFF163A2B) : colors.onSurface,
                      ),
                    ),
                    Text(
                      disponible
                          ? 'Puedes recibir solicitudes de flete cerca de ti.'
                          : 'Actívate para empezar a recibir solicitudes.',
                      style: textTheme.bodyMedium?.copyWith(
                        color: disponible ? const Color(0xFF163A2B) : colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: disponible,
                activeThumbColor: AppColors.rutaVerde,
                onChanged: (_) => ref.read(disponibilidadConductorProvider.notifier).toggle(),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        if (disponible && viaje == null) ...[
          _AccesoCard(
            icon: Icons.list_alt_rounded,
            titulo: 'Solicitudes cerca de ti',
            valor: '$solicitudesCerca',
            descripcion: solicitudesCerca == 1
                ? 'Hay 1 solicitud esperando respuesta.'
                : 'Hay $solicitudesCerca solicitudes esperando respuesta.',
            onTap: () => context.go(AppRoutes.conductorSolicitudes),
          ),
        ] else if (!disponible) ...[
          Text(
            'Cuando actives tu disponibilidad, aquí verás cuántas solicitudes hay cerca de ti.',
            style: textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
          ),
        ],
      ],
    );
  }
}

class _ViajeEnCursoBanner extends StatelessWidget {
  final VoidCallback onTap;
  const _ViajeEnCursoBanner({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.rutaVerde,
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: const Padding(
          padding: EdgeInsets.all(18),
          child: Row(
            children: [
              Icon(Icons.local_shipping_rounded, color: Colors.white),
              SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Viaje en curso',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      'Toca para ver el estado y continuar',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _AccesoCard extends StatelessWidget {
  final IconData icon;
  final String titulo;
  final String valor;
  final String descripcion;
  final VoidCallback onTap;

  const _AccesoCard({
    required this.icon,
    required this.titulo,
    required this.valor,
    required this.descripcion,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: colors.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Icon(icon, color: AppColors.rutaVerde, size: 28),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(titulo, style: textTheme.titleMedium),
                        const SizedBox(width: 8),
                        Text(
                          valor,
                          style: textTheme.titleMedium?.copyWith(color: AppColors.rutaVerde, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Text(
                      descripcion,
                      style: textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios_rounded, size: 14, color: colors.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}

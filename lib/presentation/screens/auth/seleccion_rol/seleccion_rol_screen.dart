import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:gocarg/config/router/app_routes.dart';

import '../../../../config/theme/theme.dart';
import '../../../providers/providers.dart';


/// Bifurca hacia el flujo Cliente o el flujo Conductor. Es la puerta única
/// antes de Login — Login ya sabe con qué acento y hacia dónde entrar.
class SeleccionRolScreen extends ConsumerWidget {
  const SeleccionRolScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    void elegir(GoCargRole rol) {
      ref.read(selectedRoleProvider.notifier).seleccionar(rol);
      context.go(AppRoutes.login);
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              Text('¿Cómo quieres usar GoCarg?', style: textTheme.displaySmall),
              const SizedBox(height: 8),
              Text(
                'Elige un rol para continuar. Vas a iniciar sesión según lo que necesites hacer.',
                style: textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
              ),
              const SizedBox(height: 32),
              _RoleCard(
                icon: Icons.inventory_2_outlined,
                titulo: 'Soy Cliente',
                subtitulo: 'Necesito transportar una carga',
                rol: GoCargRole.cliente,
                onTap: () => elegir(GoCargRole.cliente),
              ),
              const SizedBox(height: 16),
              _RoleCard(
                icon: Icons.local_shipping_outlined,
                titulo: 'Soy Conductor',
                subtitulo: 'Tengo un vehículo y ofrezco el servicio',
                rol: GoCargRole.conductor,
                onTap: () => elegir(GoCargRole.conductor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final IconData icon;
  final String titulo;
  final String subtitulo;
  final GoCargRole rol;
  final VoidCallback onTap;

  const _RoleCard({
    required this.icon,
    required this.titulo,
    required this.subtitulo,
    required this.rol,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: colors.outline),
            borderRadius: BorderRadius.circular(18),
          ),
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: rol.acentoSuave,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: rol.acento, size: 26),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(titulo, style: textTheme.titleMedium),
                    const SizedBox(height: 2),
                    Text(
                      subtitulo,
                      style: textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
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
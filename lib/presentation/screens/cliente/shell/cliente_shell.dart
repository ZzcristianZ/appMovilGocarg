import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import 'package:gocarg/config/router/app_routes.dart';
import 'package:gocarg/config/theme/app_colors.dart';
import 'package:gocarg/presentation/widgets/gocarg_app_bar.dart';
import 'package:gocarg/presentation/widgets/gocarg_bottom_nav.dart';

/// Shell del flujo Cliente: Inicio, Historial y Perfil.
/// "Solicitar" no es una pestaña — vive dentro de Inicio como la acción
/// principal, igual que en apps de viajes por demanda.
class ClienteShell extends StatelessWidget {
  final Widget child;

  const ClienteShell({super.key, required this.child});

  static const _titulos = ['Inicio', 'Historial', 'Perfil'];

  static const _items = [
    GoCargNavItem(activo: Icons.home_rounded, inactivo: Icons.home_outlined, label: 'Inicio'),
    GoCargNavItem(activo: Icons.history_rounded, inactivo: Icons.history_outlined, label: 'Historial'),
    GoCargNavItem(activo: Icons.person_rounded, inactivo: Icons.person_outline_rounded, label: 'Perfil'),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final location = GoRouterState.of(context).uri.path;

    int currentIndex = 0;
    if (location == AppRoutes.clienteHistorial) {
      currentIndex = 1;
    } else if (location == AppRoutes.clientePerfil) {
      currentIndex = 2;
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: colors.surface,
      ),
      child: Scaffold(
        backgroundColor: colors.surface,
        appBar: GoCargAppBar(
          title: _titulos[currentIndex],
          acento: AppColors.carga,
        ),
        body: child,
        bottomNavigationBar: GoCargBottomNav(
          items: _items,
          currentIndex: currentIndex,
          acento: AppColors.carga,
          onTap: (index) {
            switch (index) {
              case 0: context.go(AppRoutes.clienteHome); break;
              case 1: context.go(AppRoutes.clienteHistorial); break;
              case 2: context.go(AppRoutes.clientePerfil); break;
            }
          },
        ),
      ),
    );
  }
}
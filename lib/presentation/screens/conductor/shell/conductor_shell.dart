import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:gocarg/config/router/app_routes.dart';
import 'package:gocarg/config/theme/theme.dart';

import 'package:gocarg/presentation/widgets/widgets.dart';




/// Shell del flujo Conductor: Inicio, Solicitudes, Historial y Perfil.
/// A diferencia del cliente, el conductor sí necesita "Solicitudes" como
/// pestaña propia: es lo primero que revisa al abrir la app.
class ConductorShell extends StatelessWidget {
  final Widget child;

  const ConductorShell({super.key, required this.child});

  static const _titulos = ['Inicio', 'Solicitudes', 'Historial', 'Perfil'];

  static const _items = [
    GoCargNavItem(activo: Icons.home_rounded, inactivo: Icons.home_outlined, label: 'Inicio'),
    GoCargNavItem(activo: Icons.list_alt_rounded, inactivo: Icons.list_alt_outlined, label: 'Solicitudes'),
    GoCargNavItem(activo: Icons.history_rounded, inactivo: Icons.history_outlined, label: 'Historial'),
    GoCargNavItem(activo: Icons.person_rounded, inactivo: Icons.person_outline_rounded, label: 'Perfil'),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final location = GoRouterState.of(context).uri.path;

    int currentIndex = 0;
    if (location == AppRoutes.conductorSolicitudes) {
      currentIndex = 1;
    } else if (location == AppRoutes.conductorHistorial) {
      currentIndex = 2;
    } else if (location == AppRoutes.conductorPerfil) {
      currentIndex = 3;
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
          acento: AppColors.rutaVerde,
        ),
        body: child,
        bottomNavigationBar: GoCargBottomNav(
          items: _items,
          currentIndex: currentIndex,
          acento: AppColors.rutaVerde,
          onTap: (index) {
            switch (index) {
              case 0: context.go(AppRoutes.conductorHome); break;
              case 1: context.go(AppRoutes.conductorSolicitudes); break;
              case 2: context.go(AppRoutes.conductorHistorial); break;
              case 3: context.go(AppRoutes.conductorPerfil); break;
            }
          },
        ),
      ),
    );
  }
}
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'package:gocarg/config/router/app_routes.dart';
import 'package:gocarg/presentation/screens/auth/auth.dart';
import 'package:gocarg/presentation/screens/cliente/cliente.dart';
import 'package:gocarg/presentation/screens/conductor/conductor.dart';







CustomTransitionPage _fade(Widget child) => CustomTransitionPage(
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      child: child,
    );

// NOTA: initialLocation apunta al splash. De ahí se pasa a selección de
// rol y login antes de entrar a cualquiera de los dos shells.
final appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      pageBuilder: (context, state) => _fade(const SplashScreen()),
    ),
    GoRoute(
      path: AppRoutes.seleccionRol,
      pageBuilder: (context, state) => _fade(const SeleccionRolScreen()),
    ),
    GoRoute(
      path: AppRoutes.login,
      pageBuilder: (context, state) => _fade(const LoginScreen()),
    ),

    // ── Flujo Cliente ────────────────────────────────────────────────────
    ShellRoute(
      builder: (context, state, child) => ClienteShell(key: state.pageKey, child: child),
      routes: [
        GoRoute(
          path: AppRoutes.clienteHome,
          pageBuilder: (context, state) => _fade(const ClienteHomeView()),
        ),
        GoRoute(
          path: AppRoutes.clienteHistorial,
          pageBuilder: (context, state) => _fade(const ClienteHistorialScreen()),
        ),
        GoRoute(
          path: AppRoutes.clientePerfil,
          pageBuilder: (context, state) => _fade(const PerfilClienteScreen()),
        ),
      ],
    ),
    GoRoute(
      path: AppRoutes.clienteNuevaSolicitud,
      pageBuilder: (context, state) => _fade(const NuevaSolicitudScreen()),
    ),
    GoRoute(
      path: AppRoutes.clienteSelectorUbicacion,
      pageBuilder: (context, state) => _fade(const SelectorUbicacionScreen()),
    ),
    GoRoute(
      path: AppRoutes.clienteDisponibilidad,
      pageBuilder: (context, state) => _fade(const DisponibilidadScreen()),
    ),
    GoRoute(
      path: AppRoutes.clienteDetalleConductor,
      pageBuilder: (context, state) => _fade(const DetalleConductorScreen()),
    ),
    GoRoute(
      path: AppRoutes.clienteConfirmacion,
      pageBuilder: (context, state) => _fade(const ConfirmacionSolicitudScreen()),
    ),
    GoRoute(
      path: AppRoutes.clienteSeguimiento,
      pageBuilder: (context, state) => _fade(const SeguimientoScreen()),
    ),

    // ── Flujo Conductor ──────────────────────────────────────────────────
    ShellRoute(
      builder: (context, state, child) => ConductorShell(key: state.pageKey, child: child),
      routes: [
        GoRoute(
          path: AppRoutes.conductorHome,
          pageBuilder: (context, state) => _fade(const ConductorHomeView()),
        ),
        GoRoute(
          path: AppRoutes.conductorSolicitudes,
          pageBuilder: (context, state) => _fade(const FeedSolicitudesScreen()),
        ),
        GoRoute(
          path: AppRoutes.conductorHistorial,
          pageBuilder: (context, state) => _fade(const ConductorHistorialScreen()),
        ),
        GoRoute(
          path: AppRoutes.conductorPerfil,
          pageBuilder: (context, state) => _fade(const PerfilConductorScreen()),
        ),
      ],
    ),
  ],
);

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:gocarg/config/router/app_routes.dart';
import 'package:gocarg/presentation/screens/cliente/shell/cliente_shell.dart';
import 'package:gocarg/presentation/screens/cliente/home/cliente_home_view.dart';
import 'package:gocarg/presentation/screens/cliente/historial/cliente_historial_screen.dart';
import 'package:gocarg/presentation/screens/cliente/perfil/perfil_cliente_screen.dart';
import 'package:gocarg/presentation/screens/cliente/solicitud/nueva_solicitud_screen.dart';
import 'package:gocarg/presentation/screens/conductor/shell/conductor_shell.dart';
import 'package:gocarg/presentation/screens/conductor/home/conductor_home_view.dart';
import 'package:gocarg/presentation/screens/conductor/solicitudes/feed_solicitudes_screen.dart';
import 'package:gocarg/presentation/screens/conductor/historial/conductor_historial_screen.dart';
import 'package:gocarg/presentation/screens/conductor/perfil/perfil_conductor_screen.dart';

CustomTransitionPage _fade(Widget child) => CustomTransitionPage(
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      child: child,
    );

// NOTA: initialLocation apunta directo a '/cliente' de forma temporal.
// La Fase 1 (splash + selección de rol + login) es la que decide a dónde
// entra realmente cada usuario.
final appRouter = GoRouter(
  initialLocation: AppRoutes.clienteHome,
  routes: [
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

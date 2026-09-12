class AppRoutes {
  AppRoutes._();

  // Auth compartido
  static const splash = '/splash';
  static const seleccionRol = '/seleccion-rol';
  static const login = '/login';

  // Cliente
  static const clienteHome = '/cliente';
  static const clienteHistorial = '/cliente/historial';
  static const clientePerfil = '/cliente/perfil';
  static const clienteNuevaSolicitud = '/cliente/solicitud/nueva';

  // Conductor
  static const conductorHome = '/conductor';
  static const conductorSolicitudes = '/conductor/solicitudes';
  static const conductorHistorial = '/conductor/historial';
  static const conductorPerfil = '/conductor/perfil';
}

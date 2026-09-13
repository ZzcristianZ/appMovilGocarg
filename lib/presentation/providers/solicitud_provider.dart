import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../screens/cliente/solicitud/solicitud.dart';



class SolicitudNotifier extends Notifier<SolicitudFlete?> {
  @override
  SolicitudFlete? build() => null;

  void guardar(SolicitudFlete solicitud) => state = solicitud;

  void limpiar() => state = null;
}

final solicitudEnProgresoProvider =
    NotifierProvider<SolicitudNotifier, SolicitudFlete?>(SolicitudNotifier.new);

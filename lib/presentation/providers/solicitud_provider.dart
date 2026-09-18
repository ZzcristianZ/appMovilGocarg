import 'dart:async';

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

/// Estados del viaje ya confirmado, en el orden en que ocurren.
enum EstadoSeguimiento { confirmada, conductorEnCamino, cargaRecogida, enRuta, entregado }

/// El viaje confirmado y su avance en vivo, mientras está activo.
class ViajeActivo {
  final SolicitudFlete solicitud;
  final EstadoSeguimiento estado;

  const ViajeActivo({required this.solicitud, required this.estado});

  ViajeActivo copyWith({EstadoSeguimiento? estado}) =>
      ViajeActivo(solicitud: solicitud, estado: estado ?? this.estado);
}

/// El viaje ya confirmado y en curso (si hay uno), junto con su progreso.
/// A diferencia de [solicitudEnProgresoProvider] (que se limpia apenas se
/// confirma), este vive mientras el servicio está activo, para que
/// Seguimiento se pueda retomar desde Inicio aunque el cliente navegue a
/// otra pestaña — el avance de estados vive aquí (no en el State de la
/// pantalla) para que no se reinicie cada vez que Seguimiento se vuelve a
/// abrir.
class ViajeActivoNotifier extends Notifier<ViajeActivo?> {
  Timer? _timer;

  @override
  ViajeActivo? build() {
    ref.onDispose(() => _timer?.cancel());
    return null;
  }

  void iniciar(SolicitudFlete solicitud) {
    _timer?.cancel();
    state = ViajeActivo(solicitud: solicitud, estado: EstadoSeguimiento.confirmada);
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      final actual = state;
      if (actual == null) {
        timer.cancel();
        return;
      }
      final siguiente = actual.estado.index + 1;
      if (siguiente >= EstadoSeguimiento.values.length) {
        timer.cancel();
        return;
      }
      state = actual.copyWith(estado: EstadoSeguimiento.values[siguiente]);
    });
  }

  void finalizar() {
    _timer?.cancel();
    _timer = null;
    state = null;
  }
}

final viajeActivoProvider =
    NotifierProvider<ViajeActivoNotifier, ViajeActivo?>(ViajeActivoNotifier.new);

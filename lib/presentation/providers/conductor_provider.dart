import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../screens/conductor/solicitudes/solicitud_entrante.dart';

/// Si el conductor está aceptando solicitudes en este momento. Mientras
/// esté en falso, el feed de solicitudes no se muestra (Dashboard, Fase 4).
class DisponibilidadNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void toggle() => state = !state;
}

final disponibilidadConductorProvider =
    NotifierProvider<DisponibilidadNotifier, bool>(DisponibilidadNotifier.new);

/// Solicitudes visibles en el feed del conductor. Se le quita una tanto al
/// aceptarla (pasa a [viajeConductorProvider]) como al rechazarla, para que
/// no se pueda volver a elegir en este mismo recorrido de prueba.
class FeedSolicitudesNotifier extends Notifier<List<SolicitudEntrante>> {
  @override
  List<SolicitudEntrante> build() => List.of(solicitudesEntrantesMock);

  void quitar(String id) => state = state.where((s) => s.id != id).toList();
}

final feedSolicitudesProvider =
    NotifierProvider<FeedSolicitudesNotifier, List<SolicitudEntrante>>(FeedSolicitudesNotifier.new);

/// Estados del viaje ya aceptado por el conductor, en el orden en que
/// ocurren. A diferencia del seguimiento del cliente (que avanza solo, vía
/// Timer, para poder demostrarlo sin backend), aquí el propio conductor
/// marca cada paso — es quien de verdad sabe si ya recogió o entregó la
/// carga.
enum EstadoViajeConductor { hacialRecogida, cargaRecogida, enRuta, entregado }

/// El viaje aceptado por el conductor y su avance.
class ViajeConductor {
  final SolicitudEntrante solicitud;
  final EstadoViajeConductor estado;

  const ViajeConductor({required this.solicitud, required this.estado});

  ViajeConductor copyWith({EstadoViajeConductor? estado}) =>
      ViajeConductor(solicitud: solicitud, estado: estado ?? this.estado);
}

/// El viaje que el conductor tiene en curso (si hay uno). Vive aquí (no en
/// el State de la pantalla) por la misma razón que [ViajeActivo] del
/// cliente: para que Viaje en curso se pueda retomar desde Inicio o desde
/// Solicitudes sin perder el avance.
class ViajeConductorNotifier extends Notifier<ViajeConductor?> {
  @override
  ViajeConductor? build() => null;

  void aceptar(SolicitudEntrante solicitud) {
    state = ViajeConductor(solicitud: solicitud, estado: EstadoViajeConductor.hacialRecogida);
  }

  void avanzar() {
    final actual = state;
    if (actual == null) {
      return;
    }
    final siguiente = actual.estado.index + 1;
    if (siguiente >= EstadoViajeConductor.values.length) {
      return;
    }
    state = actual.copyWith(estado: EstadoViajeConductor.values[siguiente]);
  }

  void finalizar() => state = null;
}

final viajeConductorProvider =
    NotifierProvider<ViajeConductorNotifier, ViajeConductor?>(ViajeConductorNotifier.new);

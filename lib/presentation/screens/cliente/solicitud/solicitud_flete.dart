import 'package:flutter/material.dart';

import 'package:gocarg/presentation/screens/cliente/solicitud/conductor_disponible.dart';

/// Datos de la solicitud mientras el cliente la arma, ya con el conductor
/// elegido desde Disponibilidad. Vive en [solicitudEnProgresoProvider];
/// cuando exista backend esto se envía como el payload real.
class SolicitudFlete {
  final ConductorDisponible conductor;
  final String origen;
  final String destino;
  final String peso;
  final DateTime? fecha;
  final TimeOfDay? hora;

  const SolicitudFlete({
    required this.conductor,
    required this.origen,
    required this.destino,
    this.peso = '',
    this.fecha,
    this.hora,
  });
}

import 'package:flutter/material.dart';

/// Datos del formulario de "Nueva solicitud" mientras el cliente avanza
/// por el flujo (Resultados → Detalle → Confirmación). Vive en
/// [solicitudEnProgresoProvider]; cuando exista backend esto se envía
/// como el payload real.
class SolicitudFlete {
  final String origen;
  final String destino;
  final String tipoVehiculo;
  final String tipoCarga;
  final String peso;
  final DateTime? fecha;
  final TimeOfDay? hora;

  const SolicitudFlete({
    required this.origen,
    required this.destino,
    required this.tipoVehiculo,
    required this.tipoCarga,
    this.peso = '',
    this.fecha,
    this.hora,
  });
}

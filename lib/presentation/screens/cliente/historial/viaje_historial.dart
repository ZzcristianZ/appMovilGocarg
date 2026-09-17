import 'package:gocarg/presentation/screens/cliente/solicitud/solicitud.dart';

/// Estado final de un viaje ya cerrado (no confundir con el estado en vivo
/// de Seguimiento, que aplica solo mientras el viaje está en curso).
enum EstadoViaje { completado, cancelado }

/// Registro de un viaje ya finalizado. Datos de muestra — cuando exista
/// backend esto se reemplaza por el historial real del cliente.
class ViajeHistorial {
  final String id;
  final String conductorNombre;
  final String conductorIniciales;
  final TipoVehiculo tipo;
  final String origen;
  final String destino;
  final DateTime fecha;
  final EstadoViaje estado;
  final int? tarifaFinal;
  final double? calificacionDada;

  const ViajeHistorial({
    required this.id,
    required this.conductorNombre,
    required this.conductorIniciales,
    required this.tipo,
    required this.origen,
    required this.destino,
    required this.fecha,
    required this.estado,
    this.tarifaFinal,
    this.calificacionDada,
  });
}

/// Datos de muestra ordenados del más reciente al más antiguo. El más
/// reciente queda sin calificar a propósito, para poder mostrar el CTA
/// "Calificar viaje" en su detalle.
final historialMock = <ViajeHistorial>[
  ViajeHistorial(
    id: 'h1',
    conductorNombre: 'Jhon Contreras',
    conductorIniciales: 'JC',
    tipo: TipoVehiculo.camion,
    origen: 'Cra 7 # 12-45, Ocaña',
    destino: 'Vereda El Llanito, Ocaña',
    fecha: DateTime(2026, 9, 12, 14, 30),
    estado: EstadoViaje.completado,
    tarifaFinal: 85000,
  ),
  ViajeHistorial(
    id: 'h2',
    conductorNombre: 'Marisol Peña',
    conductorIniciales: 'MP',
    tipo: TipoVehiculo.moto,
    origen: 'Calle 10 # 8-20, Ocaña',
    destino: 'Barrio Buenos Aires, Ocaña',
    fecha: DateTime(2026, 9, 5, 9, 15),
    estado: EstadoViaje.completado,
    tarifaFinal: 22000,
    calificacionDada: 5,
  ),
  ViajeHistorial(
    id: 'h3',
    conductorNombre: 'Eduardo Quintero',
    conductorIniciales: 'EQ',
    tipo: TipoVehiculo.camion,
    origen: 'Cra 20 # 5-10, Ocaña',
    destino: 'Corregimiento San Eduardo',
    fecha: DateTime(2026, 8, 28, 16, 0),
    estado: EstadoViaje.cancelado,
  ),
  ViajeHistorial(
    id: 'h4',
    conductorNombre: 'Laura Sánchez',
    conductorIniciales: 'LS',
    tipo: TipoVehiculo.moto,
    origen: 'Barrio Cristo Rey, Ocaña',
    destino: 'Centro, Ocaña',
    fecha: DateTime(2026, 8, 20, 11, 45),
    estado: EstadoViaje.completado,
    tarifaFinal: 18000,
    calificacionDada: 4,
  ),
];

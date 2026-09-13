/// Modelo mínimo para maquetar el flujo de solicitud. Cuando exista
/// backend, esto se reemplaza por el modelo real (probablemente generado
/// desde la respuesta de la API).
class ConductorDisponible {
  final String id;
  final String nombre;
  final String iniciales;
  final double calificacion;
  final int viajesRealizados;
  final String vehiculo;
  final String placa;
  final double distanciaKm;
  final int etaMinutos;
  final int tarifa;

  const ConductorDisponible({
    required this.id,
    required this.nombre,
    required this.iniciales,
    required this.calificacion,
    required this.viajesRealizados,
    required this.vehiculo,
    required this.placa,
    required this.distanciaKm,
    required this.etaMinutos,
    required this.tarifa,
  });
}

/// Datos de muestra — se reemplazan por la respuesta real del backend.
const conductoresDisponiblesMock = <ConductorDisponible>[
  ConductorDisponible(
    id: 'c1',
    nombre: 'Jhon Contreras',
    iniciales: 'JC',
    calificacion: 4.8,
    viajesRealizados: 214,
    vehiculo: 'Camión de carga',
    placa: 'OCA-142',
    distanciaKm: 1.2,
    etaMinutos: 6,
    tarifa: 85000,
  ),
  ConductorDisponible(
    id: 'c2',
    nombre: 'Marisol Peña',
    iniciales: 'MP',
    calificacion: 4.6,
    viajesRealizados: 132,
    vehiculo: 'Moto carga',
    placa: 'OCA-587',
    distanciaKm: 0.6,
    etaMinutos: 3,
    tarifa: 22000,
  ),
  ConductorDisponible(
    id: 'c3',
    nombre: 'Eduardo Quintero',
    iniciales: 'EQ',
    calificacion: 4.9,
    viajesRealizados: 341,
    vehiculo: 'Camión de carga',
    placa: 'OCA-903',
    distanciaKm: 2.4,
    etaMinutos: 10,
    tarifa: 92000,
  ),
];

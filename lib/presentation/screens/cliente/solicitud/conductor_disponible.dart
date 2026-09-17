import 'package:gocarg/presentation/screens/cliente/solicitud/tipo_vehiculo.dart';

/// Modelo mínimo para maquetar el flujo de disponibilidad. Cuando exista
/// backend, esto se reemplaza por el modelo real (probablemente generado
/// desde la respuesta de la API, con ubicación en vivo del conductor).
class ConductorDisponible {
  final String id;
  final String nombre;
  final String iniciales;
  final double calificacion;
  final int viajesRealizados;
  final TipoVehiculo tipo;
  final String placa;
  final double distanciaKm;
  final int etaMinutos;
  final double lat;
  final double lng;

  const ConductorDisponible({
    required this.id,
    required this.nombre,
    required this.iniciales,
    required this.calificacion,
    required this.viajesRealizados,
    required this.tipo,
    required this.placa,
    required this.distanciaKm,
    required this.etaMinutos,
    required this.lat,
    required this.lng,
  });
}

/// Datos de muestra alrededor del centro de Ocaña — se reemplazan por la
/// respuesta real del backend (con ubicación en vivo de cada conductor).
const conductoresDisponiblesMock = <ConductorDisponible>[
  ConductorDisponible(
    id: 'c1',
    nombre: 'Jhon Contreras',
    iniciales: 'JC',
    calificacion: 4.8,
    viajesRealizados: 214,
    tipo: TipoVehiculo.camion,
    placa: 'OCA-142',
    distanciaKm: 1.2,
    etaMinutos: 6,
    lat: 8.2420,
    lng: -73.3550,
  ),
  ConductorDisponible(
    id: 'c2',
    nombre: 'Marisol Peña',
    iniciales: 'MP',
    calificacion: 4.6,
    viajesRealizados: 132,
    tipo: TipoVehiculo.moto,
    placa: 'OCA-587',
    distanciaKm: 0.6,
    etaMinutos: 3,
    lat: 8.2370,
    lng: -73.3600,
  ),
  ConductorDisponible(
    id: 'c3',
    nombre: 'Eduardo Quintero',
    iniciales: 'EQ',
    calificacion: 4.9,
    viajesRealizados: 341,
    tipo: TipoVehiculo.camion,
    placa: 'OCA-903',
    distanciaKm: 2.4,
    etaMinutos: 10,
    lat: 8.2450,
    lng: -73.3520,
  ),
  ConductorDisponible(
    id: 'c4',
    nombre: 'Laura Sánchez',
    iniciales: 'LS',
    calificacion: 4.7,
    viajesRealizados: 98,
    tipo: TipoVehiculo.moto,
    placa: 'OCA-221',
    distanciaKm: 0.9,
    etaMinutos: 4,
    lat: 8.2405,
    lng: -73.3610,
  ),
];

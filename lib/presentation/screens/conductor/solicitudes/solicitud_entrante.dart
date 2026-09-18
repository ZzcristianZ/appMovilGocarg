import 'package:gocarg/presentation/screens/cliente/solicitud/tipo_vehiculo.dart';

/// Solicitud de flete que le llega a un conductor disponible, antes de que
/// la acepte. Datos de muestra — cuando exista backend esto se reemplaza
/// por las solicitudes reales de clientes cerca de este conductor.
class SolicitudEntrante {
  final String id;
  final String clienteNombre;
  final String clienteIniciales;
  final TipoVehiculo tipo;
  final String origen;
  final String destino;
  final double origenLat;
  final double origenLng;
  final double destinoLat;
  final double destinoLng;
  final String peso;
  final double distanciaKm;
  final int etaMinutos;
  final String haceTiempo;

  const SolicitudEntrante({
    required this.id,
    required this.clienteNombre,
    required this.clienteIniciales,
    required this.tipo,
    required this.origen,
    required this.destino,
    required this.origenLat,
    required this.origenLng,
    required this.destinoLat,
    required this.destinoLng,
    required this.peso,
    required this.distanciaKm,
    required this.etaMinutos,
    required this.haceTiempo,
  });
}

/// Datos de muestra alrededor de Ocaña — se reemplazan por solicitudes
/// reales de clientes una vez exista backend.
const solicitudesEntrantesMock = <SolicitudEntrante>[
  SolicitudEntrante(
    id: 's1',
    clienteNombre: 'Diana Rincón',
    clienteIniciales: 'DR',
    tipo: TipoVehiculo.camion,
    origen: 'Cra 12 # 9-30, Ocaña',
    destino: 'Vereda La Playa, Ocaña',
    origenLat: 8.2410,
    origenLng: -73.3565,
    destinoLat: 8.2510,
    destinoLng: -73.3460,
    peso: '250 kg',
    distanciaKm: 0.8,
    etaMinutos: 4,
    haceTiempo: 'Hace 2 min',
  ),
  SolicitudEntrante(
    id: 's2',
    clienteNombre: 'Fabián Ortega',
    clienteIniciales: 'FO',
    tipo: TipoVehiculo.moto,
    origen: 'Calle 18 # 4-12, Ocaña',
    destino: 'Barrio San Fernando, Ocaña',
    origenLat: 8.2365,
    origenLng: -73.3590,
    destinoLat: 8.2330,
    destinoLng: -73.3620,
    peso: '15 kg',
    distanciaKm: 1.5,
    etaMinutos: 7,
    haceTiempo: 'Hace 5 min',
  ),
  SolicitudEntrante(
    id: 's3',
    clienteNombre: 'Yolanda Pacheco',
    clienteIniciales: 'YP',
    tipo: TipoVehiculo.camion,
    origen: 'Centro, Ocaña',
    destino: 'Corregimiento Aspasica',
    origenLat: 8.2394,
    origenLng: -73.3573,
    destinoLat: 8.2650,
    destinoLng: -73.3300,
    peso: '600 kg',
    distanciaKm: 2.1,
    etaMinutos: 9,
    haceTiempo: 'Hace 8 min',
  ),
];

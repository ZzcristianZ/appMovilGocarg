import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

/// Centro de Ocaña, Norte de Santander — posición por defecto de todos los
/// mapas de la app mientras no hay ubicación real del dispositivo o del
/// conductor. Sirve también para cualquier otro destino: solo cambia el
/// centro inicial que se le pase al widget.
const LatLng ocanaCentro = LatLng(8.2394, -73.3573);

/// Mapa real (OpenStreetMap, sin API key) reutilizable en todo el flujo
/// de solicitud. Usa `com.example.gocarg` como identificador de la app
/// ante los servidores de tiles de OSM — actualízalo si cambias el
/// applicationId del proyecto.
class GoCargMap extends StatelessWidget {
  final MapController? controller;
  final LatLng centroInicial;
  final double zoomInicial;
  final List<Marker> marcadores;
  final bool interactivo;
  final void Function(MapCamera camara)? onPosicionCambia;

  const GoCargMap({
    super.key,
    this.controller,
    this.centroInicial = ocanaCentro,
    this.zoomInicial = 14,
    this.marcadores = const [],
    this.interactivo = true,
    this.onPosicionCambia,
  });

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: controller,
      options: MapOptions(
        initialCenter: centroInicial,
        initialZoom: zoomInicial,
        interactionOptions: InteractionOptions(
          flags: interactivo ? InteractiveFlag.all : InteractiveFlag.none,
        ),
        onPositionChanged: onPosicionCambia == null
            ? null
            : (camara, huboGesto) => onPosicionCambia!(camara),
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.gocarg',
        ),
        if (marcadores.isNotEmpty) MarkerLayer(markers: marcadores),
      ],
    );
  }
}

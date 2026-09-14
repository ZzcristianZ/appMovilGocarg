import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:gocarg/presentation/widgets/gocarg_map.dart';

import 'package:gocarg/config/theme/app_colors.dart';

/// Selector de ubicación con mapa real (OpenStreetMap) — se usa tanto para
/// origen como para destino. Recibe el título ('Origen' / 'Destino') por
/// `extra` y devuelve la dirección elegida vía `context.pop`.
class SelectorUbicacionScreen extends StatefulWidget {
  const SelectorUbicacionScreen({super.key});

  @override
  State<SelectorUbicacionScreen> createState() => _SelectorUbicacionScreenState();
}

class _SelectorUbicacionScreenState extends State<SelectorUbicacionScreen> {
  final _mapController = MapController();
  final _busquedaController = TextEditingController();
  LatLng _centro = ocanaCentro;
  bool _buscando = false;
  bool _localizando = false;

  @override
  void dispose() {
    _busquedaController.dispose();
    super.dispose();
  }

  Future<void> _buscarDireccion() async {
    final texto = _busquedaController.text.trim();
    if (texto.isEmpty) {
      return;
    }
    setState(() => _buscando = true);
    try {
      final resultados = await locationFromAddress(texto);
      if (resultados.isNotEmpty) {
        final destino = LatLng(resultados.first.latitude, resultados.first.longitude);
        _mapController.move(destino, 16);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se encontró esa dirección')),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo buscar la dirección. Revisa tu conexión.')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _buscando = false);
      }
    }
  }

  Future<void> _usarUbicacionActual() async {
    setState(() => _localizando = true);
    try {
      var permiso = await Geolocator.checkPermission();
      if (permiso == LocationPermission.denied) {
        permiso = await Geolocator.requestPermission();
      }
      if (permiso == LocationPermission.deniedForever || permiso == LocationPermission.denied) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Necesitas dar permiso de ubicación')),
          );
        }
        return;
      }
      final servicioActivo = await Geolocator.isLocationServiceEnabled();
      if (!servicioActivo) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Activa el GPS para usar tu ubicación')),
          );
        }
        return;
      }
      final posicion = await Geolocator.getCurrentPosition();
      _mapController.move(LatLng(posicion.latitude, posicion.longitude), 16);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo obtener tu ubicación')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _localizando = false);
      }
    }
  }

  Future<void> _confirmar(String titulo) async {
    String direccion =
        'Lat ${_centro.latitude.toStringAsFixed(5)}, Lng ${_centro.longitude.toStringAsFixed(5)}';
    try {
      final placemarks = await placemarkFromCoordinates(_centro.latitude, _centro.longitude);
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        final partes = [p.street, p.subLocality, p.locality]
            .where((s) => s!.isNotEmpty)
            .toList();
        if (partes.isNotEmpty) {
          direccion = partes.join(', ');
        }
      }
    } catch (_) {
      // Si falla la geocodificación inversa (sin Google Play Services, sin
      // internet, etc.) se usa el texto de coordenadas como respaldo.
    }
    if (mounted) {
      context.pop(direccion);
    }
  }

  @override
  Widget build(BuildContext context) {
    final titulo = (GoRouterState.of(context).extra as String?) ?? 'ubicación';
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: GoCargMap(
              controller: _mapController,
              onPosicionCambia: (camara) => _centro = camara.center,
            ),
          ),

          // Pin fijo al centro — el mapa se mueve detrás, no el pin.
          const Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.only(bottom: 30),
              child: Icon(Icons.location_on_rounded, size: 44, color: AppColors.ruta),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Material(
                    color: colors.surface,
                    shape: const CircleBorder(),
                    child: IconButton(
                      onPressed: () => context.pop(),
                      icon: const Icon(Icons.arrow_back_rounded),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Material(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(14),
                      elevation: 1,
                      child: TextField(
                        controller: _busquedaController,
                        onSubmitted: (_) => _buscarDireccion(),
                        decoration: InputDecoration(
                          hintText: 'Buscar $titulo',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: colors.surface,
                          suffixIcon: _buscando
                              ? const Padding(
                                  padding: EdgeInsets.all(14),
                                  child: SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  ),
                                )
                              : IconButton(
                                  icon: const Icon(Icons.search_rounded),
                                  onPressed: _buscarDireccion,
                                ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            right: 16,
            bottom: 190,
            child: FloatingActionButton.small(
              heroTag: 'ubicacion-actual',
              backgroundColor: colors.surface,
              foregroundColor: colors.primary,
              onPressed: _localizando ? null : _usarUbicacionActual,
              child: _localizando
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.my_location_rounded),
            ),
          ),

          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(titulo, style: textTheme.labelSmall?.copyWith(color: colors.onSurfaceVariant)),
                  const SizedBox(height: 2),
                  Text('Mueve el mapa para ubicar el punto exacto', style: textTheme.bodyMedium),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _confirmar(titulo),
                      child: Text('Confirmar $titulo'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

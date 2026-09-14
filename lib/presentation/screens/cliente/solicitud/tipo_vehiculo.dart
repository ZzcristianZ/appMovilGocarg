import 'package:flutter/material.dart';

/// Tipos de vehículo para filtrar la disponibilidad de conductores.
/// Agrega más valores aquí cuando el proyecto los defina (ej. camioneta,
/// tractomula) — Disponibilidad, Detalle y el formulario ya iteran sobre
/// la lista completa, no hay que tocarlos para sumar un tipo nuevo.
enum TipoVehiculo {
  camion(nombre: 'Camión de carga', icono: Icons.airport_shuttle_rounded),
  moto(nombre: 'Moto carga', icono: Icons.motorcycle_rounded);

  final String nombre;
  final IconData icono;

  const TipoVehiculo({required this.nombre, required this.icono});
}

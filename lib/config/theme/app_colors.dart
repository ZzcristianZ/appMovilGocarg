import 'package:flutter/material.dart';

/// Paleta de GoCarg.
///
/// Construida desde el vocabulario del transporte de carga (ruta, carga,
/// formalidad) en lugar del azul/morado genérico de plantilla. `carga` y
/// `rutaVerde` funcionan como acento por rol: el flujo del cliente usa
/// `carga` (ámbar) para sus acciones, el flujo del conductor usa `rutaVerde`
/// para las suyas, así cada rol se distingue de un vistazo sin ser dos apps
/// separadas.
class AppColors {
  AppColors._();

  // Marca
  static const ruta = Color(0xFF1E4B72);
  static const rutaOscuro = Color(0xFF13324D);
  static const rutaClaro = Color(0xFF4E7FA6);

  // Acento por rol
  static const carga = Color(0xFFE8901F);
  static const cargaSuave = Color(0xFFFCE3BE);
  static const rutaVerde = Color(0xFF2F7D5C);
  static const rutaVerdeSuave = Color(0xFFD7ECE1);

  // Neutros
  static const fondo = Color(0xFFF1F3F1);
  static const superficie = Color(0xFFFFFFFF);
  static const superficieAlterna = Color(0xFFE7EAE7);
  static const borde = Color(0xFFD9DEE3);
  static const bordeSuave = Color(0xFFE3E7E4);
  static const textoPrimario = Color(0xFF1B2126);
  static const textoSecundario = Color(0xFF5B6670);

  // Fondo oscuro
  static const fondoOscuro = Color(0xFF14181C);
  static const superficieOscura = Color(0xFF1C2126);

  // Estado
  static const error = Color(0xFFC0392B);
  static const errorSuave = Color(0xFFF6D9D4);
  static const exito = rutaVerde;
  static const advertencia = carga;
}

/// Rol activo dentro de la app — determina el color de acento en botones,
/// chips de estado y navegación.
enum GoCargRole { cliente, conductor }

extension GoCargRoleColor on GoCargRole {
  Color get acento =>
      this == GoCargRole.cliente ? AppColors.carga : AppColors.rutaVerde;

  Color get acentoSuave => this == GoCargRole.cliente
      ? AppColors.cargaSuave
      : AppColors.rutaVerdeSuave;

  /// Color de texto/ícono legible sobre [acentoSuave] (fondo claro).
  Color get acentoTexto => this == GoCargRole.cliente
      ? AppColors.rutaOscuro
      : const Color(0xFF163A2B);

  /// Color de texto/ícono legible sobre [acento] (fondo saturado).
  Color get onAcento =>
      this == GoCargRole.cliente ? AppColors.rutaOscuro : Colors.white;
}

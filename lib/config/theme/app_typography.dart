import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';


class AppTypography {
  AppTypography._();

  static TextTheme textTheme(Color colorTexto) => TextTheme(
        displaySmall: GoogleFonts.ibmPlexSans(
          fontSize: 28,
          height: 1.2,
          fontWeight: FontWeight.w700,
          color: colorTexto,
        ),
        titleLarge: GoogleFonts.ibmPlexSans(
          fontSize: 20,
          height: 1.3,
          fontWeight: FontWeight.w600,
          color: colorTexto,
        ),
        titleMedium: GoogleFonts.ibmPlexSans(
          fontSize: 16,
          height: 1.3,
          fontWeight: FontWeight.w600,
          color: colorTexto,
        ),
        bodyLarge: GoogleFonts.ibmPlexSans(
          fontSize: 15,
          height: 1.45,
          fontWeight: FontWeight.w400,
          color: colorTexto,
        ),
        bodyMedium: GoogleFonts.ibmPlexSans(
          fontSize: 14,
          height: 1.4,
          fontWeight: FontWeight.w400,
          color: colorTexto,
        ),
        labelLarge: GoogleFonts.ibmPlexSans(
          fontSize: 14,
          height: 1.2,
          fontWeight: FontWeight.w600,
          color: colorTexto,
        ),
        labelSmall: GoogleFonts.ibmPlexSans(
          fontSize: 12,
          height: 1.2,
          fontWeight: FontWeight.w500,
          color: colorTexto,
        ),
      );

  /// Estilo para cifras: tarifas, distancias, ETA, placas.
  static TextStyle dato({
    double fontSize = 16,
    Color? color,
    FontWeight fontWeight = FontWeight.w600,
  }) =>
      GoogleFonts.ibmPlexMono(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color ?? AppColors.textoPrimario,
        fontFeatures: const [FontFeature.tabularFigures()],
      );
}

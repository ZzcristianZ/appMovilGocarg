import 'package:flutter/material.dart';
import 'package:gocarg/config/theme/app_typography.dart';
import 'app_colors.dart';

class AppTheme {
  final bool isDarkMode;

  const AppTheme({this.isDarkMode = false});

  static const ColorScheme _lightScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.ruta,
    onPrimary: Colors.white,
    primaryContainer: AppColors.rutaClaro,
    onPrimaryContainer: AppColors.rutaOscuro,
    secondary: AppColors.carga,
    onSecondary: AppColors.rutaOscuro,
    secondaryContainer: AppColors.cargaSuave,
    onSecondaryContainer: AppColors.rutaOscuro,
    tertiary: AppColors.rutaVerde,
    onTertiary: Colors.white,
    tertiaryContainer: AppColors.rutaVerdeSuave,
    onTertiaryContainer: Color(0xFF163A2B),
    error: AppColors.error,
    onError: Colors.white,
    errorContainer: AppColors.errorSuave,
    onErrorContainer: Color(0xFF4A140C),
    surface: AppColors.superficie,
    onSurface: AppColors.textoPrimario,
    surfaceContainerHighest: AppColors.superficieAlterna,
    onSurfaceVariant: AppColors.textoSecundario,
    outline: AppColors.borde,
    outlineVariant: AppColors.bordeSuave,
    shadow: Colors.black,
    scrim: Colors.black,
    inverseSurface: AppColors.textoPrimario,
    onInverseSurface: AppColors.fondo,
    inversePrimary: AppColors.rutaClaro,
  );

  static const ColorScheme _darkScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.rutaClaro,
    onPrimary: AppColors.rutaOscuro,
    primaryContainer: AppColors.ruta,
    onPrimaryContainer: Colors.white,
    secondary: AppColors.carga,
    onSecondary: AppColors.rutaOscuro,
    secondaryContainer: Color(0xFF5A4218),
    onSecondaryContainer: AppColors.cargaSuave,
    tertiary: AppColors.rutaVerde,
    onTertiary: Colors.white,
    tertiaryContainer: Color(0xFF1E4433),
    onTertiaryContainer: AppColors.rutaVerdeSuave,
    error: Color(0xFFE07A6B),
    onError: Color(0xFF4A140C),
    errorContainer: Color(0xFF6E2A1F),
    onErrorContainer: AppColors.errorSuave,
    surface: AppColors.superficieOscura,
    onSurface: Color(0xFFE7E9EA),
    surfaceContainerHighest: Color(0xFF262C32),
    onSurfaceVariant: Color(0xFFAAB2B8),
    outline: Color(0xFF3A4149),
    outlineVariant: Color(0xFF2A3037),
    shadow: Colors.black,
    scrim: Colors.black,
    inverseSurface: Color(0xFFE7E9EA),
    onInverseSurface: AppColors.textoPrimario,
    inversePrimary: AppColors.ruta,
  );

  ThemeData getTheme() {
    final colorScheme = isDarkMode ? _darkScheme : _lightScheme;
    final textTheme = AppTypography.textTheme(colorScheme.onSurface);

    return ThemeData(
      useMaterial3: true,
      brightness: colorScheme.brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor:
          isDarkMode ? AppColors.fondoOscuro : AppColors.fondo,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: textTheme.titleLarge,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
      ),
      cardTheme: CardThemeData(
        color: colorScheme.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: colorScheme.outline),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.surfaceContainerHighest,
        labelStyle: textTheme.labelSmall!,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        side: BorderSide(color: colorScheme.outlineVariant),
        shape: const StadiumBorder(),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.secondary,
          foregroundColor: colorScheme.onSecondary,
          disabledBackgroundColor: colorScheme.surfaceContainerHighest,
          textStyle: textTheme.labelLarge,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          side: BorderSide(color: colorScheme.primary),
          textStyle: textTheme.labelLarge,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          textStyle: textTheme.labelLarge,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surface,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        labelStyle: textTheme.bodyMedium,
        hintStyle:
            textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.error),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurfaceVariant,
        selectedLabelStyle: textTheme.labelSmall,
        unselectedLabelStyle: textTheme.labelSmall,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        elevation: 0,
      ),
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        space: 1,
        thickness: 1,
      ),
    );
  }

  AppTheme copyWith({bool? isDarkMode}) =>
      AppTheme(isDarkMode: isDarkMode ?? this.isDarkMode);
}
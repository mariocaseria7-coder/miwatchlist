import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Comparte tipografía, colores y controles entre los dos modos de la app.
abstract final class TemaApp {
  static const colorSemilla = Color(0xFFFF7A59);
  static ThemeData get claro => _crear(Brightness.light);
  static ThemeData get oscuro => _crear(Brightness.dark);

  static ThemeData _crear(Brightness brillo) {
    GoogleFonts.config.allowRuntimeFetching = false;
    final oscuro = brillo == Brightness.dark;
    final colores =
        ColorScheme.fromSeed(
          seedColor: colorSemilla,
          brightness: brillo,
        ).copyWith(
          primary: oscuro ? colorSemilla : const Color(0xFFAD3D25),
          onPrimary: oscuro ? const Color(0xFF371207) : Colors.white,
          primaryContainer: oscuro
              ? const Color(0xFF5A2B20)
              : const Color(0xFFFFDBD0),
          onPrimaryContainer: oscuro
              ? const Color(0xFFFFDBD0)
              : const Color(0xFF571B0D),
          secondaryContainer: oscuro
              ? const Color(0xFF4D3526)
              : const Color(0xFFFFE8D8),
          onSecondaryContainer: oscuro
              ? const Color(0xFFFFDDBF)
              : const Color(0xFF58321E),
          surface: oscuro ? const Color(0xFF191715) : const Color(0xFFFAF7F4),
          surfaceContainerLowest: oscuro
              ? const Color(0xFF24201D)
              : const Color(0xFFFFFDFB),
          surfaceContainerLow: oscuro
              ? const Color(0xFF2D2622)
              : const Color(0xFFF3EBE5),
          surfaceContainerHighest: oscuro
              ? const Color(0xFF3C322C)
              : const Color(0xFFE9DDD4),
          onSurface: oscuro ? const Color(0xFFF9EEE8) : const Color(0xFF2E241F),
          onSurfaceVariant: oscuro
              ? const Color(0xFFCEBEB4)
              : const Color(0xFF695950),
          outline: oscuro ? const Color(0xFFA88C7B) : const Color(0xFF8C7467),
          outlineVariant: oscuro
              ? const Color(0xFF4B3B32)
              : const Color(0xFFDCCBC0),
        );
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: colores,
      fontFamily: 'Manrope',
    );
    const radio = BorderRadius.all(Radius.circular(16));
    return base.copyWith(
      scaffoldBackgroundColor: colores.surface,
      textTheme: GoogleFonts.manropeTextTheme(
        base.textTheme.copyWith(
          headlineMedium: base.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: -1.2,
          ),
          titleLarge: base.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
          ),
          titleMedium: base.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
          bodyMedium: base.textTheme.bodyMedium?.copyWith(height: 1.5),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colores.surface,
        foregroundColor: colores.onSurface,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        toolbarHeight: 76,
        titleTextStyle: base.textTheme.titleLarge?.copyWith(
          color: colores.onSurface,
          fontWeight: FontWeight.w800,
          letterSpacing: -.7,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colores.surfaceContainerLowest,
        border: const OutlineInputBorder(borderRadius: radio),
        enabledBorder: OutlineInputBorder(
          borderRadius: radio,
          borderSide: BorderSide(color: colores.outlineVariant),
        ),
        alignLabelWithHint: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(0, 48),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          shape: const RoundedRectangleBorder(borderRadius: radio),
          textStyle: const TextStyle(
            fontFamily: 'Manrope',
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(0, 48),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: const RoundedRectangleBorder(borderRadius: radio),
          side: BorderSide(color: colores.outlineVariant),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(minimumSize: const Size(0, 48)),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colores.primary,
        foregroundColor: colores.onPrimary,
        elevation: 3,
        shape: const RoundedRectangleBorder(borderRadius: radio),
        extendedTextStyle: const TextStyle(
          fontFamily: 'Manrope',
          fontWeight: FontWeight.w700,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: colores.surfaceContainerLowest,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(22)),
          side: BorderSide(color: colores.outlineVariant),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colores.surfaceContainerLowest,
        selectedColor: colores.primaryContainer,
        side: BorderSide(color: colores.outlineVariant),
        shape: const RoundedRectangleBorder(borderRadius: radio),
        checkmarkColor: colores.onPrimaryContainer,
        iconTheme: IconThemeData(color: colores.primary, size: 18),
        labelStyle: TextStyle(
          fontFamily: 'Manrope',
          fontWeight: FontWeight.w600,
          color: colores.onSurface,
        ),
        secondaryLabelStyle: TextStyle(
          fontFamily: 'Manrope',
          fontWeight: FontWeight.w700,
          color: colores.onPrimaryContainer,
        ),
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: radio),
      ),
    );
  }
}

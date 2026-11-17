import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Comparte tipografía, colores y controles entre los dos modos de la app.
abstract final class TemaApp {
  static const colorSemilla = Color(0xFF7761D9);
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
          primary: oscuro ? const Color(0xFFC5B3FF) : const Color(0xFF6449BF),
          onPrimary: oscuro ? const Color(0xFF221A38) : Colors.white,
          primaryContainer: oscuro
              ? const Color(0xFF302942)
              : const Color(0xFFECE6FA),
          onPrimaryContainer: oscuro
              ? const Color(0xFFE8DEFF)
              : const Color(0xFF39266C),
          secondaryContainer: const Color(0xFFDEF1A8),
          onSecondaryContainer: const Color(0xFF283016),
          surface: oscuro ? const Color(0xFF16161B) : const Color(0xFFF7F6F2),
          surfaceContainerLowest: oscuro
              ? const Color(0xFF1F1F26)
              : Colors.white,
          surfaceContainerLow: oscuro
              ? const Color(0xFF24242C)
              : const Color(0xFFEFEEE8),
          surfaceContainerHighest: oscuro
              ? const Color(0xFF34343E)
              : const Color(0xFFE6E4DD),
          onSurface: oscuro ? const Color(0xFFF2F0F7) : const Color(0xFF25242C),
          onSurfaceVariant: oscuro
              ? const Color(0xFFB9B6C5)
              : const Color(0xFF66636F),
          outline: oscuro ? const Color(0xFF696573) : const Color(0xFF8A8595),
          outlineVariant: oscuro
              ? const Color(0xFF38363F)
              : const Color(0xFFE1DED7),
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

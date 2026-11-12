import 'package:flutter/material.dart';

/// Define la identidad visual y los controles Material de toda la aplicación.
abstract final class TemaApp {
  static const colorSemilla = Color(0xFF7155D9);

  static ThemeData get claro {
    final colores = ColorScheme.fromSeed(seedColor: colorSemilla);
    final textos = ThemeData.light().textTheme;
    const radioControl = BorderRadius.all(Radius.circular(14));

    return ThemeData(
      useMaterial3: true,
      colorScheme: colores,
      scaffoldBackgroundColor: colores.surface,
      textTheme: textos.copyWith(
        headlineMedium: textos.headlineMedium?.copyWith(
          fontWeight: FontWeight.w700,
        ),
        titleLarge: textos.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        titleMedium: textos.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colores.surface,
        foregroundColor: colores.onSurface,
        centerTitle: false,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colores.surfaceContainerLowest,
        border: const OutlineInputBorder(borderRadius: radioControl),
        enabledBorder: OutlineInputBorder(
          borderRadius: radioControl,
          borderSide: BorderSide(color: colores.outline),
        ),
        alignLabelWithHint: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(0, 48),
          shape: const RoundedRectangleBorder(borderRadius: radioControl),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(0, 48),
          shape: const RoundedRectangleBorder(borderRadius: radioControl),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 1,
        shadowColor: colores.primary.withValues(alpha: 0.12),
        color: colores.surfaceContainerLowest,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          side: BorderSide(color: colores.outlineVariant),
        ),
      ),
      chipTheme: ChipThemeData(
        selectedColor: colores.primaryContainer,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

/// Comparte las medidas y superficies que se repiten entre pantallas.
abstract final class EstilosApp {
  static const margenPantalla = EdgeInsets.all(24);
  static const margenTarjeta = EdgeInsets.all(16);
  static const anchoContenido = BoxConstraints(maxWidth: 600);
  static const anchoColeccion = BoxConstraints(maxWidth: 760);
  static const radioPanel = BorderRadius.all(Radius.circular(24));

  /// Resuelve los colores desde el tema para conservar contraste y coherencia.
  static BoxDecoration panelDestacado(BuildContext context) => BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Theme.of(context).colorScheme.primaryContainer,
        Theme.of(context).colorScheme.secondaryContainer,
      ],
    ),
    borderRadius: radioPanel,
  );

  static TextStyle? etiqueta(BuildContext context) => Theme.of(context)
      .textTheme
      .labelLarge
      ?.copyWith(
        color: Theme.of(context).colorScheme.primary,
        letterSpacing: 2,
      );

  static TextStyle? textoSecundario(BuildContext context) =>
      Theme.of(context).textTheme.bodyMedium
          ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant);
}

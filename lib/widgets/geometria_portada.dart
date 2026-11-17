import 'dart:math' as math;

import 'package:flutter/painting.dart';

import '../modelos/encuadre.dart';

/// Escala para cubrir el marco y reparte el sobrante según la posición normalizada.
Rect rectanguloPortada(Size imagen, Size marco, Encuadre encuadre) {
  final escala =
      math.max(marco.width / imagen.width, marco.height / imagen.height) *
      encuadre.zoom;
  final ancho = imagen.width * escala;
  final alto = imagen.height * escala;
  return Rect.fromLTWH(
    -math.max(0, ancho - marco.width) * (encuadre.x + 1) / 2,
    -math.max(0, alto - marco.height) * (encuadre.y + 1) / 2,
    ancho,
    alto,
  );
}

/// Mantiene bajo el dedo o ratón el mismo punto y limita el desplazamiento a los bordes.
Encuadre transformarEncuadre(
  Size imagen,
  Size marco,
  Encuadre inicial, {
  required double zoom,
  required Offset focoInicial,
  required Offset focoActual,
}) {
  final nuevoZoom = zoom.clamp(1.0, Encuadre.zoomMaximo);
  final anterior = rectanguloPortada(imagen, marco, inicial);
  final factor = nuevoZoom / inicial.zoom;
  final ancho = anterior.width * factor;
  final alto = anterior.height * factor;
  final excesoX = math.max(0.0, ancho - marco.width);
  final excesoY = math.max(0.0, alto - marco.height);
  final izquierda = ((anterior.left - focoInicial.dx) * factor + focoActual.dx)
      .clamp(-excesoX, 0.0);
  final arriba = ((anterior.top - focoInicial.dy) * factor + focoActual.dy)
      .clamp(-excesoY, 0.0);
  return Encuadre(
    zoom: nuevoZoom,
    x: excesoX < .0001 ? 0 : (-2 * izquierda / excesoX - 1).clamp(-1.0, 1.0),
    y: excesoY < .0001 ? 0 : (-2 * arriba / excesoY - 1).clamp(-1.0, 1.0),
  );
}

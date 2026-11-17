import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:miwatchlist/modelos/encuadre.dart';
import 'package:miwatchlist/widgets/geometria_portada.dart';

void main() {
  const marco = Size(160, 90);

  test(
    'cover centrado por defecto y mismo encuadre relativo al redimensionar',
    () {
      const imagen = Size(400, 100);
      expect(
        rectanguloPortada(imagen, marco, Encuadre()),
        const Rect.fromLTWH(-100, 0, 360, 90),
      );
      final encuadre = Encuadre(zoom: 2.5, x: .8, y: -.4);
      final pequeno = rectanguloPortada(imagen, marco, encuadre);
      final grande = rectanguloPortada(imagen, const Size(320, 180), encuadre);
      expect(grande.left, closeTo(pequeno.left * 2, .00001));
      expect(grande.top, closeTo(pequeno.top * 2, .00001));
      expect(grande.size, pequeno.size * 2);
    },
  );

  test('ningún borde deja huecos con imágenes horizontales, cuadradas o verticales', () {
    for (final imagen in [
      const Size(400, 100),
      const Size(100, 400),
      const Size(100, 100),
    ]) {
      for (final zoom in [1.0, 1.7, Encuadre.zoomMaximo]) {
        for (final x in [-1.0, 0.0, 1.0]) {
          for (final y in [-1.0, 0.0, 1.0]) {
            final rect = rectanguloPortada(
              imagen,
              marco,
              Encuadre(zoom: zoom, x: x, y: y),
            );
            expect(rect.left, lessThanOrEqualTo(.00001));
            expect(rect.top, lessThanOrEqualTo(.00001));
            expect(rect.right, greaterThanOrEqualTo(marco.width - .00001));
            expect(rect.bottom, greaterThanOrEqualTo(marco.height - .00001));
          }
        }
      }
    }
  });

  test(
    'el arrastre se limita a los bordes y el zoom conserva su punto focal',
    () {
      const imagen = Size(400, 100);
      const foco = Offset(100, 40);
      final inicial = Encuadre();
      final antes = rectanguloPortada(imagen, marco, inicial);
      final ampliado = transformarEncuadre(
        imagen,
        marco,
        inicial,
        zoom: 2,
        focoInicial: foco,
        focoActual: foco,
      );
      final despues = rectanguloPortada(imagen, marco, ampliado);
      expect(
        (foco.dx - antes.left) / antes.width,
        closeTo((foco.dx - despues.left) / despues.width, .00001),
      );
      expect(
        (foco.dy - antes.top) / antes.height,
        closeTo((foco.dy - despues.top) / despues.height, .00001),
      );
      final movido = transformarEncuadre(
        imagen,
        marco,
        inicial,
        zoom: 1,
        focoInicial: foco,
        focoActual: const Offset(10000, 10000),
      );
      expect(movido.x, -1);
      expect(movido.y, 0);
      expect(
        transformarEncuadre(
          imagen,
          marco,
          inicial,
          zoom: .1,
          focoInicial: foco,
          focoActual: foco,
        ).zoom,
        1,
      );
      expect(
        transformarEncuadre(
          imagen,
          marco,
          inicial,
          zoom: 100,
          focoInicial: foco,
          focoActual: foco,
        ).zoom,
        Encuadre.zoomMaximo,
      );
    },
  );
}

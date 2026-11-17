@TestOn('browser')
library;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:miwatchlist/modelos/elemento.dart';
import 'package:miwatchlist/modelos/encuadre.dart';
import 'package:miwatchlist/widgets/imagen_elemento.dart';

// Ejecutar junto a: python tool/servidor_portadas_prueba.py
const origen = 'http://127.0.0.1:9153';

Future<void> esperarImagen(WidgetTester tester, Finder resultado) async {
  for (
    var intento = 0;
    intento < 60 && resultado.evaluate().isEmpty;
    intento++
  ) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 100)),
    );
    await tester.pump();
  }
  expect(resultado, findsOneWidget);
}

void main() {
  testWidgets(
    'Chrome: CORS, arrastre, rueda, deslizador, pellizco y restablecer',
    (tester) async {
      Encuadre? actual;
      final scroll = ScrollController();
      addTearDown(scroll.dispose);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              controller: scroll,
              child: Column(
                children: [
                  StatefulBuilder(
                    builder: (context, setState) => SizedBox(
                      width: 320,
                      child: ImagenElemento(
                        tipo: Tipo.pelicula,
                        url: '$origen/cors.png',
                        encuadre: actual,
                        onEncuadreChanged: (valor) =>
                            setState(() => actual = valor),
                      ),
                    ),
                  ),
                  const SizedBox(height: 1200),
                ],
              ),
            ),
          ),
        ),
      );
      final marco = find.byKey(const ValueKey('marco-portada'));
      final slider = find.byKey(const ValueKey('zoom-portada'));
      await esperarImagen(tester, slider);
      expect(tester.getSize(marco).aspectRatio, closeTo(16 / 9, .00001));
      final centro = tester.getCenter(marco);

      final raton = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await raton.down(centro);
      await raton.moveBy(const Offset(70, 0));
      await raton.moveBy(const Offset(40, 0));
      await raton.up();
      await tester.pump();
      expect(actual!.x, lessThan(0));
      final desplazamiento = scroll.offset;
      tester.binding.handlePointerEvent(
        PointerScrollEvent(
          position: centro,
          scrollDelta: const Offset(0, -180),
          kind: PointerDeviceKind.mouse,
        ),
      );
      await tester.pump();
      expect(actual!.zoom, greaterThan(1));
      expect(scroll.offset, desplazamiento);

      await tester.tap(slider);
      await tester.pump();
      expect(actual!.zoom, greaterThan(2));
      await tester.tap(find.text('Restablecer'));
      await tester.pump();
      expect([actual!.zoom, actual!.x, actual!.y], [1, 0, 0]);

      final dedo1 = await tester.createGesture(pointer: 11);
      final dedo2 = await tester.createGesture(pointer: 12);
      await dedo1.down(centro - const Offset(30, 0));
      await dedo2.down(centro + const Offset(30, 0));
      await dedo1.moveTo(centro - const Offset(70, 0));
      await dedo2.moveTo(centro + const Offset(70, 0));
      await dedo1.up();
      await dedo2.up();
      await tester.pump();
      expect(actual!.zoom, greaterThan(1));
      expect(tester.takeException(), isNull);
    },
  );

  for (final ruta in ['sin-cors.png', 'error.png']) {
    testWidgets('Chrome: $ruta conserva el error y oculta el editor', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 320,
              child: ImagenElemento(
                tipo: Tipo.serie,
                url: '$origen/$ruta',
                onEncuadreChanged: (_) =>
                    fail('No debe haber editor sin imagen'),
              ),
            ),
          ),
        ),
      );
      await esperarImagen(tester, find.text('Imagen no disponible'));
      expect(find.byType(Slider), findsNothing);
      expect(find.text('Restablecer'), findsNothing);
      expect(tester.takeException(), isNull);
    });
  }
}

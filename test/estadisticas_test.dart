import 'package:flutter/material.dart';
import 'package:miwatchlist/estilos/tema_app.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:miwatchlist/modelos/elemento.dart';
import 'package:miwatchlist/pantallas/pantalla_estadisticas.dart';

void main() {
  Elemento crear(String id, Tipo tipo, Estado estado, int valoracion) =>
      Elemento(
        id: id,
        titulo: id,
        tipo: tipo,
        estado: estado,
        valoracion: valoracion,
        fechaAlta: DateTime(2026),
      );

  test('media excluye ceros, cuenta estados e incluye empates', () {
    final resumen = ResumenEstadisticas([
      crear('1', Tipo.pelicula, Estado.pendiente, 0),
      crear('2', Tipo.pelicula, Estado.terminado, 4),
      crear('3', Tipo.serie, Estado.enCurso, 2),
      crear('4', Tipo.serie, Estado.terminado, 0),
    ]);
    expect(resumen.total, 4);
    expect(resumen.media, 3);
    expect(resumen.porEstado, {
      Estado.pendiente: 1,
      Estado.enCurso: 1,
      Estado.terminado: 2,
    });
    expect(resumen.tiposFrecuentes, [Tipo.pelicula, Tipo.serie]);
    expect(
      ResumenEstadisticas([crear('0', Tipo.videojuego, Estado.enCurso, 0)])
          .media,
      isNull,
    );
  });

  testWidgets('vacía muestra estados seguros y barras a cero', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: TemaApp.claro,
        home: PantallaEstadisticas(elementos: []),
      ),
    );
    expect(find.byType(LinearProgressIndicator), findsNWidgets(3));
    for (final barra in tester.widgetList<LinearProgressIndicator>(
      find.byType(LinearProgressIndicator),
    )) {
      expect(barra.value, 0);
    }
    await tester.scrollUntilVisible(
      find.text('Sin datos'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Sin valoraciones'), findsOneWidget);
    expect(find.text('Sin datos'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

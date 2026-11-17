import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:miwatchlist/modelos/elemento.dart';
import 'package:miwatchlist/servicios/sugerencia.dart';
import 'package:miwatchlist/pantallas/pantalla_lista.dart';
import 'package:miwatchlist/pantallas/pantalla_detalle.dart';
import 'package:miwatchlist/pantallas/pantalla_formulario.dart';
import 'package:miwatchlist/widgets/dialogo_sugerencia.dart';
import 'package:miwatchlist/estilos/tema_app.dart';

import 'lista_test.dart' show AlmacenMemoria;

void main() {
  final elementos = [
    for (final tipo in Tipo.values)
      for (final estado in Estado.values)
        for (var i = 0; i < 2; i++)
          Elemento(
            id: '${tipo.name}-${estado.name}-$i',
            titulo: '${tipo.etiqueta} $i',
            tipo: tipo,
            estado: estado,
            notas: 'Una nota de prueba',
            fechaAlta: DateTime(2026),
          ),
  ];
  test(
    'solo pendientes de la categoría, cualquiera y sin repetir el anterior',
    () {
      final azar = Random(42);
      for (final tipo in [null, ...Tipo.values]) {
        Elemento? anterior;
        for (var i = 0; i < 100; i++) {
          final elegido = elegirPendiente(
            elementos,
            tipo,
            anterior: anterior?.id,
            azar: azar,
          )!;
          expect(elegido.estado, Estado.pendiente);
          if (tipo != null) expect(elegido.tipo, tipo);
          expect(elegido.id, isNot(anterior?.id));
          anterior = elegido;
        }
      }
    },
  );
  test('vacío, categoría sin pendientes y único candidato', () {
    expect(elegirPendiente([], null), isNull);
    expect(elegirPendiente([elementos.first], Tipo.videojuego), isNull);
    final unico = elementos.first;
    expect(
      elegirPendiente([unico], unico.tipo, anterior: unico.id),
      same(unico),
    );
    expect(
      elegirPendiente(
        elementos.where((e) => e.estado != Estado.pendiente).toList(),
        null,
      ),
      isNull,
    );
  });

  for (final oscuro in [false, true]) {
    testWidgets(
      'selector, otra opción y empezar sin perder datos, oscuro $oscuro',
      (tester) async {
        tester.view.physicalSize = const Size(320, 800);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final almacen = AlmacenMemoria(elementos);
        await tester.pumpWidget(
          MaterialApp(
            theme: oscuro ? TemaApp.oscuro : TemaApp.claro,
            home: PantallaLista(almacen: almacen),
          ),
        );
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('¿Qué veo hoy?'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('¿Qué veo hoy?'));
        await tester.pumpAndSettle();
        expect(find.text('6 pendientes'), findsOneWidget);
        await tester.tap(find.byKey(const ValueKey('sorteo-videojuego')));
        await tester.pumpAndSettle();
        final dialogo = find.byType(DialogoSugerencia);
        final primero = tester
            .widgetList<Text>(
              find.descendant(of: dialogo, matching: find.byType(Text)),
            )
            .firstWhere((t) => t.data?.startsWith('Videojuego ') ?? false)
            .data;
        await tester.tap(find.text('Otra opción'));
        await tester.pumpAndSettle();
        expect(
          find.descendant(of: dialogo, matching: find.text(primero!)),
          findsNothing,
        );
        almacen.falla = true;
        await tester.tap(find.text('Empezar'));
        await tester.pumpAndSettle();
        expect(
          find.text('No se pudo guardar. Inténtalo de nuevo.'),
          findsOneWidget,
        );
        expect(pendientesDe(almacen.elementos, null).length, 6);
        almacen.falla = false;
        await tester.tap(find.text('Empezar'));
        await tester.pumpAndSettle();
        expect(dialogo, findsNothing);
        expect(pendientesDe(almacen.elementos, Tipo.videojuego).length, 1);
        expect(pendientesDe(almacen.elementos, Tipo.pelicula).length, 2);
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets('colección vacía ofrece añadir y detalle no modifica el estado', (
    tester,
  ) async {
    final almacen = AlmacenMemoria([]);
    await tester.pumpWidget(
      MaterialApp(
        theme: TemaApp.claro,
        home: PantallaLista(almacen: almacen),
      ),
    );
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('¿Qué veo hoy?'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('¿Qué veo hoy?'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('sorteo-videojuego')));
    await tester.pumpAndSettle();
    expect(
      find.text('No tienes videojuegos pendientes. ¡Añade alguno!'),
      findsOneWidget,
    );
    await tester.tap(find.text('Añadir uno'));
    await tester.pumpAndSettle();
    expect(find.byType(PantallaFormulario), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    // Se vuelve a montar con un único pendiente para comprobar navegación y botón deshabilitado.
    await tester.pumpWidget(const SizedBox());
    almacen.elementos = [elementos.first];
    await tester.pumpWidget(
      MaterialApp(
        theme: TemaApp.claro,
        home: PantallaLista(almacen: almacen),
      ),
    );
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('¿Qué veo hoy?'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('¿Qué veo hoy?'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('sorteo-cualquiera')));
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<TextButton>(find.widgetWithText(TextButton, 'Otra opción'))
          .onPressed,
      isNull,
    );
    await tester.tap(find.text('Ver detalle'));
    await tester.pumpAndSettle();
    expect(find.byType(PantallaDetalle), findsOneWidget);
    expect(almacen.elementos.single.estado, Estado.pendiente);
  });
}

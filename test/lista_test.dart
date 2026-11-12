import 'dart:async';

import 'package:flutter/material.dart';
import 'package:miwatchlist/estilos/tema_app.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:miwatchlist/modelos/elemento.dart';
import 'package:miwatchlist/servicios/almacen.dart';
import 'package:miwatchlist/pantallas/pantalla_lista.dart';
import 'package:miwatchlist/widgets/tarjeta_elemento.dart';

class AlmacenMemoria extends Almacen {
  AlmacenMemoria(this.elementos);
  List<Elemento> elementos;
  bool falla = false;
  Completer<void>? escritura;
  Completer<List<Elemento>>? lectura;
  @override
  Future<List<Elemento>> cargar() async =>
      lectura == null ? elementos : await lectura!.future;
  @override
  Future<void> guardar(List<Elemento> nuevos) async {
    if (escritura != null) await escritura!.future;
    if (falla) throw StateError('No se pudo escribir');
    elementos = List.of(nuevos);
  }
}

void main() {
  Elemento crear(String id, String titulo, Estado estado) => Elemento(
    id: id,
    titulo: titulo,
    tipo: Tipo.pelicula,
    estado: estado,
    fechaAlta: DateTime(2026),
  );

  Future<void> montar(WidgetTester tester, Almacen almacen) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: TemaApp.claro,
        home: PantallaLista(almacen: almacen),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> pulsar(WidgetTester tester, Finder finder) async {
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();
    if (finder.evaluate().isEmpty) {
      await tester.scrollUntilVisible(
        finder,
        150,
        scrollable: find.byType(Scrollable).first,
      );
    }
    await Scrollable.ensureVisible(tester.element(finder), alignment: 0.5);
    await tester.pumpAndSettle();
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  testWidgets(
    'búsqueda y filtro se combinan y estadísticas usan la colección completa',
    (tester) async {
      final almacen = AlmacenMemoria([
        crear('1', 'Dune', Estado.pendiente),
        crear('2', 'Dune: Parte 2', Estado.terminado),
      ]);
      await montar(tester, almacen);
      await tester.enterText(find.byKey(const ValueKey('buscar')), 'dUnE');
      await pulsar(tester, find.widgetWithText(ChoiceChip, 'Terminado'));
      expect(find.byType(TarjetaElemento), findsOneWidget);
      expect(find.text('Dune: Parte 2'), findsOneWidget);
      expect(almacen.elementos.length, 2);
      await pulsar(tester, find.byTooltip('Estadísticas'));
      expect(find.text('2'), findsOneWidget);
      await tester.pageBack();
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const ValueKey('buscar')),
        'inexistente',
      );
      await tester.pumpAndSettle();
      expect(find.text('No hay coincidencias'), findsOneWidget);
      expect(find.text('Añadir el primero'), findsNothing);
    },
  );

  testWidgets('alta, cancelar edición y borrado confirmado', (tester) async {
    final almacen = AlmacenMemoria([]);
    await montar(tester, almacen);
    await pulsar(tester, find.text('Añadir el primero'));
    await tester.enterText(find.byKey(const ValueKey('titulo')), ' Dune ');
    await pulsar(tester, find.byKey(const ValueKey('guardar')));
    expect(almacen.elementos.single.titulo, 'Dune');
    await pulsar(tester, find.text('Dune'));
    await pulsar(tester, find.text('Editar'));
    await tester.enterText(
      find.byKey(const ValueKey('titulo')),
      'Cambio cancelado',
    );
    await pulsar(tester, find.text('Cancelar'));
    expect(almacen.elementos.single.titulo, 'Dune');
    expect(find.text('Dune'), findsOneWidget);
    await pulsar(tester, find.text('Borrar'));
    await pulsar(tester, find.widgetWithText(TextButton, 'Cancelar'));
    expect(almacen.elementos, hasLength(1));
    await pulsar(tester, find.text('Borrar'));
    await pulsar(tester, find.widgetWithText(FilledButton, 'Borrar'));
    expect(almacen.elementos, isEmpty);
    expect(find.text('Elemento borrado.'), findsOneWidget);
    expect(find.text('Añadir el primero'), findsOneWidget);
  });

  testWidgets(
    'un fallo al guardar edición mantiene el detalle y permite reintentar',
    (tester) async {
      final almacen = AlmacenMemoria([crear('1', 'Dune', Estado.pendiente)])
        ..falla = true;
      await montar(tester, almacen);
      await pulsar(tester, find.text('Dune'));
      await pulsar(tester, find.text('Editar'));
      await tester.enterText(
        find.byKey(const ValueKey('titulo')),
        'Nuevo título',
      );
      await pulsar(tester, find.byKey(const ValueKey('guardar')));
      expect(almacen.elementos.single.titulo, 'Dune');
      expect(find.text('Dune'), findsOneWidget);
      expect(find.textContaining('No se pudo guardar.'), findsOneWidget);
      almacen.falla = false;
      await pulsar(tester, find.text('Editar'));
      await tester.enterText(
        find.byKey(const ValueKey('titulo')),
        'Nuevo título',
      );
      await pulsar(tester, find.byKey(const ValueKey('guardar')));
      expect(almacen.elementos.single.titulo, 'Nuevo título');
      expect(almacen.elementos.single.id, '1');
    },
  );

  testWidgets('espera a cargar antes de permitir altas', (tester) async {
    final almacen = AlmacenMemoria([])..lectura = Completer<List<Elemento>>();
    await tester.pumpWidget(
      MaterialApp(
        theme: TemaApp.claro,
        home: PantallaLista(almacen: almacen),
      ),
    );
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsNothing);
    almacen.lectura!.complete([]);
    await tester.pumpAndSettle();
    expect(find.text('Añadir el primero'), findsOneWidget);
  });
}

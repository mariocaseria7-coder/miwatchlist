import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:miwatchlist/modelos/elemento.dart';
import 'package:miwatchlist/estilos/tema_app.dart';
import 'package:miwatchlist/pantallas/pantalla_lista.dart';
import 'package:miwatchlist/pantallas/pantalla_formulario.dart';
import 'package:miwatchlist/widgets/tarjeta_elemento.dart';

import 'lista_test.dart' show AlmacenMemoria;

void main() {
  final original = Elemento(
    id: 'nuevo',
    titulo: 'Mi película',
    tipo: Tipo.pelicula,
    estado: Estado.pendiente,
    fechaAlta: DateTime(2026),
  );

  test('JSON antiguo, favoritos y fecha opcional conservan los datos', () {
    final antiguo = original.toJson()
      ..remove('favorito')
      ..remove('fechaTerminado');
    final leido = Elemento.fromJson(antiguo);
    expect(leido.favorito, false);
    expect(leido.fechaTerminado, isNull);
    expect(
      Elemento.fromJson({...antiguo, 'estado': 'terminado'}).fechaTerminado,
      isNull,
    );
    final nuevo = original.copyWith(
      favorito: true,
      estado: Estado.terminado,
      fechaTerminado: DateTime(2026, 11, 12),
    );
    expect(Elemento.fromJson(nuevo.toJson()).toJson(), nuevo.toJson());
    expect(nuevo.copyWith(titulo: 'Otro').fechaTerminado, nuevo.fechaTerminado);
    expect(original.favorito, false);
    expect(original.fechaTerminado, isNull);
    expect(Elemento.fechaEnEspanol(nuevo.fechaTerminado!), '12 nov 2026');
  });

  test(
    'terminar asigna hoy, otros cambios conservan y reabrir borra la fecha',
    () {
      final terminado = original.copyWith(estado: Estado.terminado);
      expect(terminado.fechaTerminado, Elemento.hoy());
      final manual = terminado.copyWith(fechaTerminado: DateTime(2020, 1, 2));
      expect(
        manual.copyWith(favorito: true).fechaTerminado,
        DateTime(2020, 1, 2),
      );
      expect(
        manual.copyWith(estado: Estado.terminado).fechaTerminado,
        manual.fechaTerminado,
      );
      for (final estado in [Estado.pendiente, Estado.enCurso]) {
        final reabierto = manual.copyWith(estado: estado);
        expect(reabierto.fechaTerminado, isNull);
        expect(
          reabierto.copyWith(estado: Estado.terminado).fechaTerminado,
          Elemento.hoy(),
        );
      }
    },
  );

  testWidgets(
    'corazón guarda sin navegar, combina filtros y conserva datos si falla',
    (tester) async {
      final almacen = AlmacenMemoria([
        original,
        original.copyWith(titulo: 'Otro', favorito: true),
      ]);
      // Identidades diferentes para comprobar el guardado por id.
      almacen.elementos[1] = Elemento(
        id: 'otro',
        titulo: 'Otro',
        tipo: Tipo.serie,
        estado: Estado.terminado,
        favorito: true,
        fechaAlta: DateTime(2026),
      );
      await tester.pumpWidget(
        MaterialApp(
          theme: TemaApp.claro,
          home: PantallaLista(almacen: almacen),
        ),
      );
      await tester.pumpAndSettle();
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpAndSettle();
      final corazon = find.byTooltip('Marcar favorito').first;
      await tester.ensureVisible(corazon);
      await tester.tap(corazon);
      await tester.pumpAndSettle();
      expect(almacen.elementos.first.favorito, true);
      expect(find.byType(PantallaFormulario), findsNothing);
      final filtro = find.widgetWithText(FilterChip, 'Favoritos');
      await tester.ensureVisible(filtro);
      await tester.tap(filtro);
      await tester.tap(find.widgetWithText(ChoiceChip, 'Pendiente'));
      await tester.tap(find.byKey(const ValueKey('categoria-pelicula')));
      await tester.pumpAndSettle();
      expect(find.byType(TarjetaElemento), findsOneWidget);
      almacen.falla = true;
      final quitar = find.byTooltip('Quitar de favoritos').first;
      await tester.ensureVisible(quitar);
      await tester.tap(quitar);
      await tester.pumpAndSettle();
      expect(almacen.elementos.first.favorito, true);
      expect(find.textContaining('No se pudo guardar.'), findsOneWidget);
    },
  );

  for (final oscuro in [false, true]) {
    testWidgets('tarjeta con notas y fecha sin desbordes, oscuro $oscuro', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: oscuro ? TemaApp.oscuro : TemaApp.claro,
          home: Scaffold(
            body: SizedBox(
              width: 280,
              height: 280 / (16 / 9) + 250,
              child: TarjetaElemento(
                elemento: original.copyWith(
                  estado: Estado.terminado,
                  titulo:
                      'Un título largo que ocupa las dos líneas disponibles',
                  notas: 'Una nota larga con detalles. ' * 20,
                ),
                onTap: () {},
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final notas = tester.widget<Text>(find.textContaining('Una nota larga'));
      expect(notas.maxLines, 2);
      expect(notas.overflow, TextOverflow.ellipsis);
      expect(find.textContaining('Terminado el'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets(
    'formulario asigna fecha, limita calendario y borra al cambiar estado',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(theme: TemaApp.claro, home: const PantallaFormulario()),
      );
      await tester.pumpAndSettle();
      final terminado = find.byKey(const ValueKey('estado-terminado'));
      await tester.ensureVisible(terminado);
      await tester.tap(terminado);
      await tester.pumpAndSettle();
      final fecha = find.byKey(const ValueKey('fechaTerminado'));
      await tester.ensureVisible(fecha);
      await tester.tap(fecha);
      await tester.pumpAndSettle();
      expect(
        tester.widget<DatePickerDialog>(find.byType(DatePickerDialog)).lastDate,
        Elemento.hoy(),
      );
      await tester.tap(find.text('Aceptar'));
      await tester.pumpAndSettle();
      expect(
        find.text('Terminado el ${Elemento.fechaEnEspanol(Elemento.hoy())}'),
        findsOneWidget,
      );
      final pendiente = find.byKey(const ValueKey('estado-pendiente'));
      await tester.ensureVisible(pendiente);
      await tester.tap(pendiente);
      await tester.pumpAndSettle();
      expect(fecha, findsNothing);
    },
  );
}

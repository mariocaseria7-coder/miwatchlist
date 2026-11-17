import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:miwatchlist/estilos/tema_app.dart';
import 'package:miwatchlist/modelos/elemento.dart';
import 'package:miwatchlist/modelos/encuadre.dart';
import 'package:miwatchlist/pantallas/pantalla_formulario.dart';

void main() {
  final juego = Elemento(
    id: 'juego',
    titulo: 'Hollow Knight',
    tipo: Tipo.videojuego,
    estado: Estado.pendiente,
    fechaAlta: DateTime(2026),
  );

  test('portada compatible con datos antiguos y eliminable con copyWith', () {
    final portada = juego.copyWith(
      imagenUrl: 'https://example.com/portada.png',
    );
    expect(Elemento.fromJson(portada.toJson()).imagenUrl, portada.imagenUrl);
    expect(portada.copyWith().imagenUrl, portada.imagenUrl);
    expect(portada.copyWith(imagenUrl: null).imagenUrl, isNull);
    final antiguo = juego.toJson()..remove('imagenUrl');
    expect(Elemento.fromJson(antiguo).imagenUrl, isNull);
  });

  for (final accion in ['conservar', 'cambiar', 'quitar']) {
    testWidgets('editar portada: $accion conserva o elimina el encuadre', (
      tester,
    ) async {
      final inicial = juego.copyWith(
        imagenUrl: 'https://example.com/portada.png',
        encuadre: Encuadre(zoom: 3, x: .5, y: -.4),
      );
      Elemento? resultado;
      await tester.pumpWidget(
        MaterialApp(
          theme: TemaApp.claro,
          home: Builder(
            builder: (context) => TextButton(
              onPressed: () async {
                resultado = await Navigator.push<Elemento>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PantallaFormulario(inicial: inicial),
                  ),
                );
              },
              child: const Text('Abrir'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Abrir'));
      await tester.pumpAndSettle();
      if (accion == 'cambiar') {
        final campo = find.byKey(const ValueKey('imagenUrl'));
        await tester.ensureVisible(campo);
        await tester.enterText(campo, 'https://example.com/otra.png');
      } else if (accion == 'quitar') {
        final quitar = find.text('Quitar imagen');
        await tester.ensureVisible(quitar);
        await tester.tap(quitar);
      }
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('guardar')));
      await tester.pumpAndSettle();
      expect(resultado!.id, inicial.id);
      expect(
        resultado!.encuadre?.toJson(),
        accion == 'conservar' ? inicial.encuadre!.toJson() : isNull,
      );
      expect(resultado!.imagenUrl, switch (accion) {
        'quitar' => isNull,
        'cambiar' => 'https://example.com/otra.png',
        _ => inicial.imagenUrl,
      });
    });
  }

  for (final tipo in Tipo.values) {
    for (final editando in [false, true]) {
      testWidgets('portada ${tipo.name}, editando: $editando', (tester) async {
        Elemento? resultado;
        await tester.pumpWidget(
          MaterialApp(
            theme: TemaApp.claro,
            home: Builder(
              builder: (context) => Scaffold(
                body: TextButton(
                  onPressed: () async {
                    resultado = await Navigator.push<Elemento>(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PantallaFormulario(
                          inicial: editando ? juego.copyWith(tipo: tipo) : null,
                        ),
                      ),
                    );
                  },
                  child: const Text('Abrir'),
                ),
              ),
            ),
          ),
        );
        await tester.tap(find.text('Abrir'));
        await tester.pumpAndSettle();
        if (!editando) {
          await tester.enterText(
            find.byKey(const ValueKey('titulo')),
            'Nuevo elemento',
          );
          final selectorTipo = find.byKey(ValueKey('tipo-${tipo.name}'));
          await tester.ensureVisible(selectorTipo);
          await tester.tap(selectorTipo);
          await tester.pumpAndSettle();
        }
        final campo = find.byKey(const ValueKey('imagenUrl'));
        await tester.ensureVisible(campo);
        await tester.enterText(campo, 'no-es-un-enlace');
        Future<void> guardar() async {
          FocusManager.instance.primaryFocus?.unfocus();
          await tester.pumpAndSettle();
          final boton = find.byKey(const ValueKey('guardar'));
          await Scrollable.ensureVisible(tester.element(boton), alignment: .5);
          await tester.pumpAndSettle();
          await tester.tap(boton);
          await tester.pumpAndSettle();
        }

        await guardar();
        expect(
          find.text('Introduce un enlace http o https válido.'),
          findsOneWidget,
        );
        expect(resultado, isNull);
        await tester.ensureVisible(campo);
        await tester.enterText(campo, ' https://example.com/portada.png ');
        await guardar();
        expect(resultado?.imagenUrl, 'https://example.com/portada.png');
        expect(resultado?.tipo, tipo);
        if (editando) expect(resultado?.id, juego.id);
      });
    }
  }
}

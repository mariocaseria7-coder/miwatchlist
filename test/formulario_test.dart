import 'package:flutter/material.dart';
import 'package:miwatchlist/estilos/tema_app.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:miwatchlist/modelos/elemento.dart';
import 'package:miwatchlist/pantallas/pantalla_formulario.dart';

Future<void> guardar(WidgetTester tester) async {
  FocusManager.instance.primaryFocus?.unfocus();
  await tester.pumpAndSettle();
  final boton = find.byKey(const ValueKey('guardar'));
  await Scrollable.ensureVisible(tester.element(boton), alignment: 0.5);
  await tester.pumpAndSettle();
  await tester.tap(boton);
  await tester.pumpAndSettle();
}

void main() {
  for (final titulo in ['', '   ', 'a' * 61]) {
    testWidgets('rechaza título inválido de longitud ${titulo.length}', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(theme: TemaApp.claro, home: PantallaFormulario()),
      );
      await tester.enterText(find.byKey(const ValueKey('titulo')), titulo);
      await guardar(tester);
      final mensaje = titulo.trim().isEmpty
          ? 'Escribe un título.'
          : 'El título no puede superar los 60 caracteres.';
      expect(find.text(mensaje), findsOneWidget);
      expect(find.byType(PantallaFormulario), findsOneWidget);
    });
  }

  for (final titulo in [' a ', '  ${'a' * 60}  ']) {
    testWidgets(
      'acepta límite válido ${titulo.trim().length} y devuelve datos',
      (tester) async {
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
                        builder: (_) => const PantallaFormulario(),
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
        await tester.enterText(find.byKey(const ValueKey('titulo')), titulo);
        await guardar(tester);
        expect(resultado?.titulo, titulo.trim());
        expect(resultado?.tipo, Tipo.pelicula);
        expect(resultado?.estado, Estado.pendiente);
        expect(resultado?.valoracion, 0);
        expect(resultado?.notas, isNull);
      },
    );
  }

  testWidgets('editar conserva identidad y permite borrar notas y valoración', (
    tester,
  ) async {
    final original = Elemento(
      id: 'estable',
      titulo: 'Dune',
      tipo: Tipo.serie,
      estado: Estado.enCurso,
      valoracion: 4,
      notas: 'Nota',
      fechaAlta: DateTime(2026, 1, 1),
    );
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
                    builder: (_) => PantallaFormulario(inicial: original),
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
    expect(find.text('Dune'), findsOneWidget);
    await tester.ensureVisible(find.text('Quitar valoración'));
    await tester.tap(find.text('Quitar valoración'));
    await tester.enterText(find.byKey(const ValueKey('notas')), '  ');
    await guardar(tester);
    expect(resultado?.id, original.id);
    expect(resultado?.fechaAlta, original.fechaAlta);
    expect(resultado?.notas, isNull);
    expect(resultado?.valoracion, 0);
    expect(original.notas, 'Nota');
  });
}

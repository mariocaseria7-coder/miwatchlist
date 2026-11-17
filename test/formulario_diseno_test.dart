import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:miwatchlist/estilos/tema_app.dart';
import 'package:miwatchlist/pantallas/pantalla_formulario.dart';
import 'package:miwatchlist/widgets/imagen_elemento.dart';

void main() {
  testWidgets('los colores de texto mantienen contraste en ambos temas', (
    tester,
  ) async {
    for (final tema in [TemaApp.claro, TemaApp.oscuro]) {
      final colores = tema.colorScheme;
      for (final par in [
        (colores.primary, colores.onPrimary),
        (colores.surface, colores.primary),
        (colores.surfaceContainerLowest, colores.primary),
        (colores.primaryContainer, colores.onPrimaryContainer),
        (colores.secondaryContainer, colores.onSecondaryContainer),
        (colores.surface, colores.onSurface),
        (colores.surfaceContainerLowest, colores.onSurfaceVariant),
      ]) {
        final a = par.$1.computeLuminance();
        final b = par.$2.computeLuminance();
        final contraste = ((a > b ? a : b) + .05) / ((a > b ? b : a) + .05);
        expect(
          contraste,
          greaterThanOrEqualTo(4.5),
          reason: '${tema.brightness}: $par',
        );
      }
    }
    await tester.pumpAndSettle();
  });

  for (final ancho in [320.0, 1200.0]) {
    for (final oscuro in [false, true]) {
      testWidgets(
        'formulario adaptable $ancho, oscuro: $oscuro, con Guardar fijo',
        (tester) async {
          tester.view.physicalSize = Size(ancho, 800);
          tester.view.devicePixelRatio = 1;
          addTearDown(tester.view.resetPhysicalSize);
          addTearDown(tester.view.resetDevicePixelRatio);
          addTearDown(tester.view.resetViewInsets);
          await tester.pumpWidget(
            MaterialApp(
              theme: oscuro ? TemaApp.oscuro : TemaApp.claro,
              home: const PantallaFormulario(),
            ),
          );
          await tester.pumpAndSettle();
          final portada = tester.getRect(find.byType(ImagenElemento));
          final titulo = tester.getRect(find.byKey(const ValueKey('titulo')));
          if (ancho > 860) {
            expect(portada.right, lessThan(titulo.left));
          } else {
            expect(portada.bottom, lessThan(titulo.top));
          }
          final guardar = find.byKey(const ValueKey('guardar'));
          expect(guardar.hitTestable(), findsOneWidget);
          final posicion = tester.getRect(guardar);
          await tester.drag(
            find.byType(SingleChildScrollView),
            const Offset(0, -400),
          );
          await tester.pumpAndSettle();
          expect(tester.getRect(guardar), posicion);
          tester.view.viewInsets = const FakeViewPadding(bottom: 280);
          await tester.pumpAndSettle();
          expect(guardar.hitTestable(), findsOneWidget);
          expect(tester.getRect(guardar).bottom, lessThanOrEqualTo(520));
          expect(find.byType(DropdownButtonFormField), findsNothing);
          expect(find.textContaining('Entre 1 y 60 caracteres'), findsNothing);
          expect(tester.takeException(), isNull);
        },
      );
    }
  }

  testWidgets(
    'la portada se previsualiza al pegar un enlace y las acciones son condicionales',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(theme: TemaApp.claro, home: const PantallaFormulario()),
      );
      await tester.pumpAndSettle();
      expect(find.text('Ver imagen'), findsNothing);
      expect(find.text('Quitar imagen'), findsNothing);
      final campo = find.byKey(const ValueKey('imagenUrl'));
      await tester.enterText(campo, ' https://example.com/portada.png ');
      await tester.pumpAndSettle();
      expect(
        tester.widget<ImagenElemento>(find.byType(ImagenElemento)).url,
        'https://example.com/portada.png',
      );
      expect(find.text('Ver imagen'), findsOneWidget);
      await tester.ensureVisible(find.text('Quitar imagen'));
      await tester.tap(find.text('Quitar imagen'));
      await tester.pumpAndSettle();
      expect(tester.widget<TextFormField>(campo).controller!.text, isEmpty);
      expect(
        tester.widget<ImagenElemento>(find.byType(ImagenElemento)).url,
        isNull,
      );
      expect(find.text('Ver imagen'), findsNothing);
      expect(find.text('Quitar imagen'), findsNothing);
    },
  );
}

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:miwatchlist/config/app_links.dart';
import 'package:miwatchlist/estilos/tema_app.dart';
import 'package:miwatchlist/main.dart';
import 'package:miwatchlist/modelos/elemento.dart';
import 'package:miwatchlist/pantallas/pantalla_acerca.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'diseno_test.dart';

void main() {
  setUp(() {
    PackageInfo.setMockInitialValues(
      appName: 'Mi Watchlist',
      packageName: 'com.example.miwatchlist',
      version: '1.2.3',
      buildNumber: '7',
      buildSignature: '',
    );
  });

  testWidgets('si no se obtiene la versión se informa sin inventar un número', (
    tester,
  ) async {
    PackageInfo.setMockInitialValues(
      appName: 'Mi Watchlist',
      packageName: 'com.example.miwatchlist',
      version: '',
      buildNumber: '',
      buildSignature: '',
    );
    await tester.pumpWidget(
      MaterialApp(theme: TemaApp.claro, home: const PantallaAcerca()),
    );
    await tester.pumpAndSettle();
    expect(find.text('Versión no disponible'), findsOneWidget);
  });

  testWidgets(
    'abre Acerca de y vuelve conservando la colección y la búsqueda',
    (tester) async {
      final elemento = Elemento(
        id: '1',
        titulo: 'Dune',
        tipo: Tipo.pelicula,
        estado: Estado.pendiente,
        fechaAlta: DateTime(2026),
      );
      final prefs = PreferenciasDiseno()
        ..datos['watchlist'] = jsonEncode([elemento.toJson()]);
      await tester.pumpWidget(MiWatchlistApp(preferencias: prefs));
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const ValueKey('buscar')), 'dUnE');
      await tester.pumpAndSettle();
      final antes = Map<String, Object>.of(prefs.datos);
      await tester.tap(find.byTooltip('Acerca de'));
      await tester.pumpAndSettle();
      expect(find.byType(PantallaAcerca), findsOneWidget);
      expect(find.byType(BackButton), findsOneWidget);
      await tester.scrollUntilVisible(
        find.text('Versión 1.2.3'),
        400,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Versión 1.2.3'), findsOneWidget);
      expect(
        find.textContaining('No se sincronizan entre el móvil y el navegador.'),
        findsOneWidget,
      );
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.byType(PantallaAcerca), findsNothing);
      expect(
        tester
            .widget<TextField>(find.byKey(const ValueKey('buscar')))
            .controller!
            .text,
        'dUnE',
      );
      expect(prefs.datos, antes);
    },
  );

  for (final ancho in [320.0, 1200.0]) {
    for (final oscuro in [false, true]) {
      testWidgets(
        'Acerca de adapta sus tarjetas, ancho: $ancho, oscuro: $oscuro',
        (tester) async {
          tester.view.physicalSize = Size(ancho, 800);
          tester.view.devicePixelRatio = 1;
          addTearDown(tester.view.resetPhysicalSize);
          addTearDown(tester.view.resetDevicePixelRatio);
          await tester.pumpWidget(
            MaterialApp(
              theme: oscuro ? TemaApp.oscuro : TemaApp.claro,
              home: const PantallaAcerca(),
            ),
          );
          await tester.pumpAndSettle();
          final primera = tester.getRect(
            find
                .ancestor(
                  of: find.text('Tu colección'),
                  matching: find.byType(Card),
                )
                .first,
          );
          final segunda = tester.getRect(
            find
                .ancestor(
                  of: find.text('Detalle y edición'),
                  matching: find.byType(Card),
                )
                .first,
          );
          if (ancho < 600) {
            expect(primera.bottom, lessThan(segunda.top));
          } else {
            expect(primera.right, lessThan(segunda.left));
          }
          await tester.scrollUntilVisible(
            find.text('Versión 1.2.3'),
            400,
            scrollable: find.byType(Scrollable).first,
          );
          expect(find.text('Versión 1.2.3'), findsOneWidget);
          expect(
            find.text('Abrir la web'),
            kIsWeb ? findsNothing : findsOneWidget,
          );
          expect(tester.takeException(), isNull);
        },
      );
    }
  }

  testWidgets(
    'los botones abren las direcciones públicas y avisan si falla el navegador',
    (tester) async {
      const canal = MethodChannel('plugins.flutter.io/url_launcher');
      final destinos = <String>[];
      var disponible = true;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(canal, (call) async {
            destinos.add((call.arguments as Map)['url'] as String);
            return disponible;
          });
      addTearDown(
        () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(canal, null),
      );
      await tester.pumpWidget(
        MaterialApp(theme: TemaApp.claro, home: const PantallaAcerca()),
      );
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        find.text('Descargar APK'),
        400,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('Descargar APK'));
      await tester.pumpAndSettle();
      expect(destinos.last, AppLinks.apkUrl);
      if (!kIsWeb) {
        await tester.tap(find.text('Abrir la web'));
        await tester.pumpAndSettle();
        expect(destinos.last, AppLinks.webUrl);
      }
      disponible = false;
      await tester.tap(find.text('Descargar APK'));
      await tester.pumpAndSettle();
      expect(
        find.text('No se pudo abrir el enlace. Comprueba tu navegador.'),
        findsOneWidget,
      );
    },
  );
}

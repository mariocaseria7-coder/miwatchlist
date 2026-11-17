import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:miwatchlist/main.dart';
import 'package:miwatchlist/config/app_links.dart';
import 'package:miwatchlist/servicios/enlaces_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenciasDiseno implements SharedPreferencesAsync {
  final Map<String, Object> datos = {};
  bool get falla => datos['_falla'] == true;
  set falla(bool valor) => datos['_falla'] = valor;

  @override
  Future<String?> getString(String key) async => datos[key] as String?;

  @override
  Future<bool?> getBool(String key) async => datos[key] as bool?;

  @override
  Future<void> setBool(String key, bool value) async {
    if (falla) throw StateError('Escritura no disponible');
    datos[key] = value;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  testWidgets('el tema se aplica a la app y se recupera al volver a abrir', (
    tester,
  ) async {
    final preferencias = PreferenciasDiseno();
    await tester.pumpWidget(MiWatchlistApp(preferencias: preferencias));
    await tester.pumpAndSettle();
    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
      ThemeMode.dark,
    );
    await tester.tap(find.byTooltip('Activar modo claro'));
    await tester.pumpAndSettle();
    expect(preferencias.datos['temaOscuro'], false);
    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
      ThemeMode.light,
    );
    await tester.pumpWidget(const SizedBox());
    await tester.pumpWidget(MiWatchlistApp(preferencias: preferencias));
    await tester.pumpAndSettle();
    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
      ThemeMode.light,
    );
    await tester.tap(find.byTooltip('Activar modo oscuro'));
    await tester.pumpAndSettle();
    expect(preferencias.datos['temaOscuro'], true);
  });

  testWidgets('si falla guardar el tema se conserva el anterior y se avisa', (
    tester,
  ) async {
    final preferencias = PreferenciasDiseno()..falla = true;
    await tester.pumpWidget(MiWatchlistApp(preferencias: preferencias));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Activar modo claro'));
    await tester.pumpAndSettle();
    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
      ThemeMode.dark,
    );
    expect(
      find.text('No se pudo guardar el tema. Vuelve a intentarlo.'),
      findsOneWidget,
    );
  });

  for (final oscuro in [false, true]) {
    testWidgets(
      'cabecera y controles caben en móvil pequeño, oscuro: $oscuro',
      (tester) async {
        tester.view.physicalSize = const Size(320, 720);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final preferencias = PreferenciasDiseno()..datos['temaOscuro'] = oscuro;
        await tester.pumpWidget(MiWatchlistApp(preferencias: preferencias));
        await tester.pumpAndSettle();
        expect(find.text('Descargar APK'), findsOneWidget);
        expect(find.text('Ir a la web'), findsOneWidget);
        await tester.scrollUntilVisible(
          find.text('Añadir el primero'),
          200,
          scrollable: find.byType(Scrollable).first,
        );
        expect(tester.takeException(), isNull);
      },
    );
  }

  test(
    'los enlaces rechazan esquemas inseguros y se envían al navegador nativo',
    () async {
      TestWidgetsFlutterBinding.ensureInitialized();
      const canal = MethodChannel('plugins.flutter.io/url_launcher');
      MethodCall? llamada;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(canal, (call) async {
            llamada = call;
            return true;
          });
      addTearDown(
        () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(canal, null),
      );
      expect(await EnlacesApp.abrir(Uri.parse('javascript:alert(1)')), false);
      expect(llamada, isNull);
      expect(await EnlacesApp.abrir(EnlacesApp.web), true);
      expect(llamada?.method, 'launch');
      expect(llamada?.arguments, containsPair('url', AppLinks.webUrl));
      expect(llamada?.arguments, containsPair('useWebView', false));
      expect(EnlacesApp.apk.toString(), AppLinks.apkUrl);
    },
  );
}

// Renders de los widgets reales con datos de demostración; no usa datos personales.
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:miwatchlist/estilos/tema_app.dart';
import 'package:miwatchlist/modelos/elemento.dart';
import 'package:miwatchlist/pantallas/pantalla_lista.dart';
import 'package:miwatchlist/pantallas/pantalla_formulario.dart';
import 'package:miwatchlist/pantallas/pantalla_detalle.dart';
import 'package:miwatchlist/pantallas/pantalla_estadisticas.dart';
import 'package:miwatchlist/pantallas/pantalla_acerca.dart';

import '../test/lista_test.dart' show AlmacenMemoria;

void main() {
  testWidgets('genera capturas documentales de la interfaz actual', (
    tester,
  ) async {
    final sombrasAnteriores = debugDisableShadows;
    addTearDown(() => debugDisableShadows = sombrasAnteriores);
    debugDisableShadows = false;
    final fuentes = FontLoader('Manrope');
    fuentes.addFont(rootBundle.load('assets/fonts/Manrope-Regular.ttf'));
    await fuentes.load();
    final iconos = FontLoader('MaterialIcons');
    iconos.addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'));
    await iconos.load();
    FocusManager.instance.highlightStrategy =
        FocusHighlightStrategy.alwaysTouch;
    final demo = [
      Elemento(
        id: 'demo-1',
        titulo: 'Dune: Parte 2',
        tipo: Tipo.pelicula,
        estado: Estado.pendiente,
        favorito: true,
        notas: 'Ver en versión original este fin de semana.',
        fechaAlta: DateTime(2026, 11, 12),
      ),
      Elemento(
        id: 'demo-2',
        titulo: 'The Bear',
        tipo: Tipo.serie,
        estado: Estado.enCurso,
        valoracion: 4,
        notas: 'Continuar por la segunda temporada.',
        fechaAlta: DateTime(2026, 11, 12),
      ),
      Elemento(
        id: 'demo-3',
        titulo: 'Hollow Knight',
        tipo: Tipo.videojuego,
        estado: Estado.terminado,
        valoracion: 5,
        fechaTerminado: DateTime(2026, 11, 15),
        notas: 'Exploración y música memorables.',
        fechaAlta: DateTime(2026, 11, 12),
      ),
    ];
    final borde = GlobalKey();
    Future<void> montar(
      Widget pantalla, {
      bool oscuro = false,
      double ancho = 430,
      double alto = 932,
    }) async {
      await tester.pumpWidget(const SizedBox());
      tester.view.physicalSize = Size(ancho, alto);
      tester.view.devicePixelRatio = 1;
      await tester.pumpWidget(
        RepaintBoundary(
          key: borde,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: oscuro ? TemaApp.oscuro : TemaApp.claro,
            home: pantalla,
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    Future<void> guardar(String nombre) async {
      expect(tester.takeException(), isNull);
      final render =
          borde.currentContext!.findRenderObject()! as RenderRepaintBoundary;
      await tester.runAsync(() async {
        final imagen = await render.toImage(pixelRatio: 1.5);
        final bytes = await imagen.toByteData(format: ui.ImageByteFormat.png);
        await File('docs/capturas/$nombre.png')
            .writeAsBytes(bytes!.buffer.asUint8List());
        imagen.dispose();
      });
      // ignore: avoid_print
      print('Captura: $nombre');
    }

    await montar(PantallaLista(almacen: AlmacenMemoria(demo)));
    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('demo-1')),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await guardar('lista');
    await montar(PantallaLista(almacen: AlmacenMemoria(demo)), oscuro: true);
    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('demo-1')),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await guardar('lista-oscura');
    await montar(
      PantallaLista(almacen: AlmacenMemoria(demo)),
      ancho: 1440,
      alto: 1100,
    );
    await tester.drag(find.byType(CustomScrollView), const Offset(0, -280));
    await tester.pumpAndSettle();
    await guardar('escritorio');
    await montar(const PantallaFormulario());
    await tester.ensureVisible(find.byKey(const ValueKey('titulo')));
    await tester.pumpAndSettle();
    await guardar('formulario');
    await montar(PantallaFormulario(inicial: demo.last));
    await tester.ensureVisible(find.byKey(const ValueKey('fechaTerminado')));
    await tester.pumpAndSettle();
    await guardar('edicion');
    await montar(
      PantallaDetalle(
        elemento: demo.last,
        onActualizar: (_) async => true,
        onBorrar: () async => true,
      ),
    );
    await guardar('detalle');
    await montar(PantallaEstadisticas(elementos: demo));
    await guardar('estadisticas');
    await montar(PantallaLista(almacen: AlmacenMemoria([])));
    await tester.scrollUntilVisible(
      find.text('Añadir el primero'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await guardar('vacia');
    await montar(PantallaLista(almacen: AlmacenMemoria(demo)));
    await tester.ensureVisible(find.text('¿Qué veo hoy?'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('¿Qué veo hoy?'));
    await tester.pumpAndSettle();
    await guardar('categorias-azar');
    await tester.tap(find.byKey(const ValueKey('sorteo-pelicula')));
    await tester.pumpAndSettle();
    await guardar('sugerencia');
    await montar(const PantallaAcerca());
    await guardar('acerca');
    await montar(const PantallaFormulario(), ancho: 320, alto: 800);
    await tester.ensureVisible(find.byKey(const ValueKey('titulo')));
    await tester.pumpAndSettle();
    await guardar('movil-pequeno');
    await tester.pumpWidget(const SizedBox());
    debugDisableShadows = sombrasAnteriores;
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
}

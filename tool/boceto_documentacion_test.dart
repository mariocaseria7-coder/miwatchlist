// Diagrama documental reconstruido con IA, no un boceto personal previo.
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('exporta el boceto documental limpio', (tester) async {
    final fuente = FontLoader('Manrope')
      ..addFont(rootBundle.load('assets/fonts/Manrope-Regular.ttf'));
    await fuente.load();
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    const tinta = Color(0xFF302C29);
    const coral = Color(0xFFAD3D25);
    void texto(
      String valor,
      double x,
      double y, {
      double size = 20,
      double ancho = 350,
      Color color = tinta,
    }) {
      final t = TextPainter(
        text: TextSpan(
          text: valor,
          style: TextStyle(
            fontFamily: 'Manrope',
            fontSize: size,
            color: color,
            height: 1.3,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: ancho);
      t.paint(canvas, Offset(x, y));
    }

    void caja(double x, double y, double w, double h, {bool relleno = false}) {
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, y, w, h),
        const Radius.circular(12),
      );
      if (relleno) {
        canvas.drawRRect(rect, Paint()..color = const Color(0xFFF1EAE4));
      }
      canvas.drawRRect(
        rect,
        Paint()
          ..color = tinta
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
    }

    void flecha(Offset a, Offset b) {
      final p = Paint()
        ..color = coral
        ..strokeWidth = 3;
      canvas.drawLine(a, b, p);
      final vector = a - b;
      final direccion = vector / vector.distance;
      final lateral = Offset(-direccion.dy, direccion.dx);
      canvas.drawLine(b, b + direccion * 14 + lateral * 7, p);
      canvas.drawLine(b, b + direccion * 14 - lateral * 7, p);
    }

    canvas.drawColor(const Color(0xFFFFFDF9), BlendMode.src);
    texto('Mi Watchlist · Boceto de pantallas', 35, 30, size: 40, ancho: 1600);
    texto(
      'Distribución de pantallas y rutas de navegación',
      35,
      95,
      size: 23,
      ancho: 1600,
      color: coral,
    );

    final titulos = [
      '1. Colección',
      '2. Nuevo / editar',
      '3. Detalle',
      '4. Estadísticas',
    ];
    for (var i = 0; i < 4; i++) {
      final x = 35.0 + i * 415;
      caja(x, 165, 375, 650);
      texto(titulos[i], x + 18, 185, size: 25);
      canvas.drawLine(
        Offset(x + 16, 230),
        Offset(x + 359, 230),
        Paint()..color = tinta,
      );
    }
    const x1 = 35.0;
    texto('Info · Tema · Estadísticas', x1 + 20, 250);
    caja(x1 + 20, 295, 335, 45);
    texto('Buscar por título...', x1 + 32, 306);
    texto('Películas · Series · Juegos', x1 + 20, 360);
    texto('¿Qué veo hoy?', x1 + 20, 403, color: coral);
    texto('Estado · Favoritos', x1 + 20, 446);
    caja(x1 + 20, 490, 335, 222, relleno: true);
    texto('Portada 16:9', x1 + 45, 515, size: 23);
    texto('Título · Estado · Corazón', x1 + 35, 569);
    texto('Notas (hasta dos líneas)', x1 + 35, 611);
    texto('Fecha · Estrellas', x1 + 35, 652);
    texto('Agrupación y orden A–Z', x1 + 20, 734);
    texto('+ Añadir', x1 + 230, 774, color: coral);

    const x2 = 450.0;
    caja(x2 + 20, 250, 335, 130, relleno: true);
    texto('Portada y encuadre', x2 + 40, 275, size: 23);
    texto('Arrastre · Zoom · Restablecer', x2 + 40, 325);
    texto('Enlace de imagen', x2 + 20, 405);
    caja(x2 + 20, 447, 335, 46);
    texto('Título (1–60)', x2 + 35, 460);
    texto('Tipo: película / serie / juego', x2 + 20, 515);
    texto('Estado · Favorito', x2 + 20, 558);
    texto('Fecha si está terminado', x2 + 20, 601);
    texto('Valoración · Notas', x2 + 20, 644);
    caja(x2 + 20, 737, 335, 54, relleno: true);
    texto('Cancelar       Guardar', x2 + 40, 752, color: coral);

    const x3 = 865.0;
    caja(x3 + 20, 250, 335, 130, relleno: true);
    texto('Portada cuando corresponde', x3 + 35, 292, ancho: 305);
    texto('Tipo · Título · Estado', x3 + 20, 410, size: 23);
    texto('Valoración', x3 + 20, 462);
    caja(x3 + 20, 507, 335, 110);
    texto('Notas completas', x3 + 35, 532);
    texto('Fecha de alta · Identidad', x3 + 20, 651);
    texto('Editar', x3 + 20, 714, color: coral);
    texto('Borrar → Confirmación', x3 + 20, 764, color: coral);

    const x4 = 1280.0;
    caja(x4 + 20, 250, 335, 80, relleno: true);
    texto('Total de elementos', x4 + 35, 276, size: 23);
    for (var i = 0; i < 3; i++) {
      final y = 370.0 + i * 82;
      texto(['Pendiente', 'Viendo / Jugando', 'Terminado'][i], x4 + 20, y);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x4 + 20, y + 38, 310, 12),
          const Radius.circular(6),
        ),
        Paint()..color = const Color(0xFFE2D8D0),
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x4 + 20, y + 38, [180.0, 100.0, 240.0][i], 12),
          const Radius.circular(6),
        ),
        Paint()..color = coral,
      );
    }
    texto('Media de valorados', x4 + 20, 655, size: 23);
    texto('Tipo(s) más frecuente(s)', x4 + 20, 710, size: 23);
    texto('Siempre toda la colección', x4 + 20, 770, size: 18);

    texto('Navegación principal', 35, 865, size: 30, ancho: 700);
    caja(65, 1010, 260, 70, relleno: true);
    texto('Colección', 100, 1030, size: 25);
    for (var i = 0; i < 3; i++) {
      final y = 940.0 + i * 105;
      caja(730, y, 300, 64);
      texto(
        ['Formulario', 'Detalle', 'Estadísticas'][i],
        755,
        y + 18,
        size: 23,
      );
      flecha(const Offset(325, 1045), Offset(730, y + 32));
    }
    texto('Añadir', 515, 940, color: coral);
    texto('Tocar tarjeta', 490, 1038, color: coral);
    texto('Icono de barras', 460, 1150, color: coral);
    canvas.drawLine(
      const Offset(1070, 1077),
      const Offset(1070, 972),
      Paint()
        ..color = coral
        ..strokeWidth = 3,
    );
    canvas.drawLine(
      const Offset(1030, 1077),
      const Offset(1070, 1077),
      Paint()
        ..color = coral
        ..strokeWidth = 3,
    );
    flecha(const Offset(1070, 972), const Offset(1030, 972));
    texto('Editar', 1090, 1005, color: coral);
    texto(
      'Guardar, cancelar o volver regresan a la pantalla de origen.',
      35,
      1250,
      size: 21,
      ancho: 1600,
    );

    await tester.runAsync(() async {
      final picture = recorder.endRecording();
      final image = await picture.toImage(1690, 1300);
      final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
      expect(bytes!.lengthInBytes, greaterThan(1000));
      await File('docs/boceto.png').writeAsBytes(bytes.buffer.asUint8List());
      image.dispose();
      picture.dispose();
    });
  });
}

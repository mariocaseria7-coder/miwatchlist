import 'package:flutter/material.dart';

import '../modelos/elemento.dart';

/// Presenta una portada remota y mantiene una cabecera legible si no está disponible.
class ImagenElemento extends StatelessWidget {
  const ImagenElemento({
    super.key,
    required this.tipo,
    this.url,
    this.alto = 160,
  });
  final Tipo tipo;
  final String? url;
  final double alto;

  @override
  Widget build(BuildContext context) {
    final colores = Theme.of(context).colorScheme;
    final fondo = Container(
      height: alto,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colores.primary, const Color(0xFF252347)],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            switch (tipo) {
              Tipo.pelicula => Icons.movie_outlined,
              Tipo.serie => Icons.tv_rounded,
              Tipo.videojuego => Icons.sports_esports_rounded,
            },
            color: colores.onPrimary,
            size: 48,
          ),
          const SizedBox(height: 8),
          Text(
            tipo == Tipo.videojuego
                ? 'TU PRÓXIMA AVENTURA'
                : 'TU PRÓXIMA HISTORIA',
            style: TextStyle(
              color: colores.onPrimary,
              fontWeight: FontWeight.w600,
              letterSpacing: 2,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
    if (url == null || url!.trim().isEmpty) return fondo;
    return SizedBox(
      height: alto,
      width: double.infinity,
      child: Image.network(
        url!,
        height: alto,
        width: double.infinity,
        fit: BoxFit.cover,
        semanticLabel: 'Portada',
        loadingBuilder: (context, child, progreso) => progreso == null
            ? child
            : Stack(
                fit: StackFit.expand,
                children: [
                  fondo,
                  const Align(
                    alignment: Alignment.bottomCenter,
                    child: LinearProgressIndicator(),
                  ),
                ],
              ),
        errorBuilder: (context, error, stack) => Stack(
          fit: StackFit.expand,
          children: [
            fondo,
            const Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  'Imagen no disponible',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

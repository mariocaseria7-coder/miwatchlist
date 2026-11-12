import 'package:flutter/material.dart';

import '../modelos/elemento.dart';
import 'selector_estrellas.dart';

/// Presenta un resumen y delega la apertura del detalle en la pantalla padre.
class TarjetaElemento extends StatelessWidget {
  const TarjetaElemento({
    super.key,
    required this.elemento,
    required this.onTap,
  });

  final Elemento elemento;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colores = Theme.of(context).colorScheme;
    final icono = switch (elemento.tipo) {
      Tipo.pelicula => Icons.movie_outlined,
      Tipo.serie => Icons.tv_rounded,
      Tipo.videojuego => Icons.sports_esports_outlined,
    };
    return Card.outlined(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colores.primaryContainer,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icono, color: colores.onPrimaryContainer),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      elemento.titulo,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${elemento.tipo.etiqueta} · ${elemento.etiquetaEstado}',
                      style: TextStyle(color: colores.onSurfaceVariant),
                    ),
                    const SizedBox(height: 8),
                    SelectorEstrellas(valor: elemento.valoracion),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      ),
    );
  }
}

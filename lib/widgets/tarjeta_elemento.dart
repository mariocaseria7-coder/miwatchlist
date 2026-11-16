import 'package:flutter/material.dart';

import '../estilos/estilos_app.dart';

import '../modelos/elemento.dart';
import 'selector_estrellas.dart';
import 'imagen_elemento.dart';

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (elemento.tipo == Tipo.videojuego ||
                (elemento.imagenUrl?.trim().isNotEmpty ?? false))
              ImagenElemento(
                tipo: elemento.tipo,
                url: elemento.imagenUrl,
                alto: 144,
              ),
            Padding(
              padding: EstilosApp.margenTarjeta,
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    alignment: Alignment.center,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: colores.primaryContainer,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: (elemento.imagenUrl?.trim().isNotEmpty ?? false)
                        ? Image.network(
                            elemento.imagenUrl!,
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                            semanticLabel: 'Miniatura de ${elemento.titulo}',
                            errorBuilder: (context, error, stackTrace) =>
                                Icon(icono, color: colores.onPrimaryContainer),
                          )
                        : Icon(icono, color: colores.onPrimaryContainer),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(icono, size: 18, color: colores.primary),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                elemento.titulo,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${elemento.tipo.etiqueta} · ${elemento.etiquetaEstado}',
                          style: EstilosApp.textoSecundario(context),
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
          ],
        ),
      ),
    );
  }
}

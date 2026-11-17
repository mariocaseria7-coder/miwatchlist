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
    final icono = EstilosApp.iconoTipo(elemento.tipo);
    return Card.outlined(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                ImagenElemento(
                  tipo: elemento.tipo,
                  url: elemento.imagenUrl,
                  encuadre: elemento.encuadre,
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: colores.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      elemento.etiquetaEstado,
                      style: Theme.of(context).textTheme.labelSmall
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(icono, size: 16, color: colores.primary),
                        const SizedBox(width: 6),
                        Text(
                          elemento.tipo.etiqueta,
                          style: EstilosApp.textoSecundario(context)
                              ?.copyWith(fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      elemento.titulo,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium
                          ?.copyWith(fontSize: 18),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        SelectorEstrellas(valor: elemento.valoracion),
                        const Spacer(),
                        Icon(
                          Icons.arrow_outward_rounded,
                          size: 19,
                          color: colores.onSurfaceVariant,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

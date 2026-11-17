import 'package:flutter/material.dart';

import '../estilos/estilos_app.dart';

import '../modelos/elemento.dart';
import 'selector_estrellas.dart';
import 'imagen_elemento.dart';

/// Resume un elemento; abrirlo o marcar favorito se delega mediante callbacks al padre.
class TarjetaElemento extends StatelessWidget {
  const TarjetaElemento({
    super.key,
    required this.elemento,
    required this.onTap,
    this.onFavorito,
  });

  final Elemento elemento;
  final VoidCallback onTap;
  final VoidCallback? onFavorito;

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
                  top: 8,
                  right: 8,
                  child: IconButton.filledTonal(
                    tooltip: elemento.favorito
                        ? 'Quitar de favoritos'
                        : 'Marcar favorito',
                    isSelected: elemento.favorito,
                    onPressed: onFavorito,
                    icon: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 220),
                      transitionBuilder: (child, animation) =>
                          ScaleTransition(scale: animation, child: child),
                      child: Icon(
                        elemento.favorito
                            ? Icons.favorite
                            : Icons.favorite_border,
                        key: ValueKey(elemento.favorito),
                        color: colores.primary,
                      ),
                    ),
                  ),
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
                    const SizedBox(height: 6),
                    if (elemento.notas?.trim().isNotEmpty ?? false)
                      Text(
                        elemento.notas!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: EstilosApp.textoSecundario(context)
                            ?.copyWith(fontSize: 13),
                      ),
                    const Spacer(),
                    if (elemento.estado == Estado.terminado &&
                        elemento.fechaTerminado != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_today_outlined,
                              size: 13,
                              color: colores.onSurfaceVariant,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                'Terminado el ${Elemento.fechaEnEspanol(elemento.fechaTerminado!)}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: EstilosApp.textoSecundario(context)
                                    ?.copyWith(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
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

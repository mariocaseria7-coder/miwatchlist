import 'package:flutter/material.dart';

/// Muestra cinco estrellas; solo permite cambios cuando recibe un callback.
class SelectorEstrellas extends StatelessWidget {
  const SelectorEstrellas({super.key, required this.valor, this.onChanged});

  final int valor;
  final ValueChanged<int>? onChanged;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    if (onChanged == null) {
      return Semantics(
        label: valor == 0 ? 'Sin valorar' : '$valor de 5 estrellas',
        child: ExcludeSemantics(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              5,
              (i) => Icon(
                i < valor ? Icons.star_rounded : Icons.star_outline_rounded,
                color: color,
                size: 20,
              ),
            ),
          ),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          children: List.generate(
            5,
            (i) => IconButton(
              tooltip: '${i + 1} de 5 estrellas',
              isSelected: i < valor,
              onPressed: () => onChanged!(i + 1),
              icon: Icon(
                i < valor ? Icons.star_rounded : Icons.star_outline_rounded,
                color: color,
                size: 32,
              ),
            ),
          ),
        ),
        TextButton.icon(
          onPressed: valor == 0 ? null : () => onChanged!(0),
          icon: const Icon(Icons.restart_alt, size: 18),
          label: Text(valor == 0 ? 'Sin valorar' : 'Quitar valoración'),
        ),
      ],
    );
  }
}

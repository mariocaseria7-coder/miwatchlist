import 'package:flutter/material.dart';

import '../modelos/elemento.dart';

/// Calcula un resumen de toda la colección sin depender de sus filtros.
class ResumenEstadisticas {
  ResumenEstadisticas(List<Elemento> elementos)
    : total = elementos.length,
      porEstado = {
        for (final estado in Estado.values)
          estado: elementos.where((e) => e.estado == estado).length,
      },
      porTipo = {
        for (final tipo in Tipo.values)
          tipo: elementos.where((e) => e.tipo == tipo).length,
      } {
    final valorados = elementos.where((e) => e.valoracion > 0).toList();
    media = valorados.isEmpty
        ? null
        : valorados.fold<int>(0, (suma, e) => suma + e.valoracion) /
              valorados.length;
  }

  final int total;
  final Map<Estado, int> porEstado;
  final Map<Tipo, int> porTipo;
  late final double? media;

  /// Incluye todos los tipos empatados con el máximo, salvo con lista vacía.
  List<Tipo> get tiposFrecuentes {
    if (total == 0) return [];
    final maximo = porTipo.values.reduce((a, b) => a > b ? a : b);
    return Tipo.values.where((tipo) => porTipo[tipo] == maximo).toList();
  }
}

/// Presenta recuentos, proporciones y media sin paquetes de gráficos.
class PantallaEstadisticas extends StatelessWidget {
  const PantallaEstadisticas({super.key, required this.elementos});
  final List<Elemento> elementos;

  @override
  Widget build(BuildContext context) {
    final resumen = ResumenEstadisticas(elementos);
    final tema = Theme.of(context);
    final favoritos = resumen.tiposFrecuentes;
    return Scaffold(
      appBar: AppBar(title: const Text('Estadísticas')),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Text(
                  'Tu colección, en perspectiva',
                  style: tema.textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                const Text('Cada historia cuenta. Así va tu recorrido.'),
                const SizedBox(height: 28),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: tema.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.collections_bookmark_outlined,
                        color: tema.colorScheme.onPrimaryContainer,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '${resumen.total}',
                        style: tema.textTheme.displayMedium?.copyWith(
                          color: tema.colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'elementos en tu lista',
                        style: TextStyle(
                          color: tema.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                Text('Por estado', style: tema.textTheme.titleLarge),
                const SizedBox(height: 16),
                for (final estado in Estado.values)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(child: Text(estado.etiqueta)),
                            Text('${resumen.porEstado[estado]}'),
                          ],
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: resumen.total == 0
                              ? 0
                              : resumen.porEstado[estado]! / resumen.total,
                          minHeight: 10,
                          borderRadius: BorderRadius.circular(10),
                          semanticsLabel:
                              '${estado.etiqueta}: ${resumen.porEstado[estado]} de ${resumen.total} elementos',
                        ),
                      ],
                    ),
                  ),
                Card.outlined(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.star_outline_rounded,
                          color: tema.colorScheme.primary,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Valoración media',
                          style: tema.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          resumen.media == null
                              ? 'Sin valoraciones'
                              : '${resumen.media!.toStringAsFixed(1).replaceAll('.', ',')} de 5 estrellas',
                          style: tema.textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        const Text('Solo cuentan los elementos valorados.'),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Divider(),
                        ),
                        Text(
                          favoritos.length > 1
                              ? 'Tipos más frecuentes (empate)'
                              : 'Tipo más frecuente',
                          style: tema.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          favoritos.isEmpty
                              ? 'Sin datos'
                              : favoritos.map((t) => t.etiqueta).join(' · '),
                          style: tema.textTheme.titleLarge,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../estilos/estilos_app.dart';
import '../modelos/elemento.dart';
import '../servicios/sugerencia.dart';
import 'imagen_elemento.dart';

class DialogoSugerencia extends StatefulWidget {
  const DialogoSugerencia({
    super.key,
    required this.elementos,
    this.tipo,
    required this.onEmpezar,
    required this.onDetalle,
    required this.onAnadir,
  });
  final List<Elemento> elementos;
  final Tipo? tipo;
  final Future<bool> Function(Elemento) onEmpezar;
  final ValueChanged<Elemento> onDetalle;
  final VoidCallback onAnadir;

  @override
  State<DialogoSugerencia> createState() => _DialogoSugerenciaState();
}

class _DialogoSugerenciaState extends State<DialogoSugerencia> {
  late Elemento? _elegido = elegirPendiente(widget.elementos, widget.tipo);
  bool _guardando = false;
  bool _error = false;

  @override
  Widget build(BuildContext context) {
    final elemento = _elegido;
    final ancho = (MediaQuery.sizeOf(context).width - 128).clamp(1.0, 420.0);
    return PopScope(
      canPop: !_guardando,
      child: AlertDialog(
        constraints: BoxConstraints(maxWidth: ancho + 48),
        scrollable: true,
        title: const Text('¿Qué veo hoy?'),
        content: SizedBox(
          width: ancho,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (elemento == null)
                Text(
                  widget.tipo == null
                      ? 'No tienes elementos pendientes. ¡Añade alguno!'
                      : 'No tienes ${widget.tipo!.categoria.toLowerCase()} pendientes. ¡Añade alguno!',
                )
              else ...[
                SizedBox(
                  height: ancho / EstilosApp.proporcionPortada,
                  child: ImagenElemento(
                    tipo: elemento.tipo,
                    url: elemento.imagenUrl,
                    encuadre: elemento.encuadre,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  elemento.titulo,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                if (elemento.notas?.trim().isNotEmpty ?? false) ...[
                  const SizedBox(height: 8),
                  Text(
                    elemento.notas!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: EstilosApp.textoSecundario(context),
                  ),
                ],
                if (_error) ...[
                  const SizedBox(height: 12),
                  Text(
                    'No se pudo guardar. Inténtalo de nuevo.',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: _guardando ? null : () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
          if (elemento == null)
            FilledButton.icon(
              onPressed: () {
                Navigator.pop(context);
                widget.onAnadir();
              },
              icon: const Icon(Icons.add),
              label: const Text('Añadir uno'),
            )
          else ...[
            TextButton(
              onPressed:
                  _guardando ||
                      pendientesDe(widget.elementos, widget.tipo).length < 2
                  ? null
                  : () => setState(() {
                      _elegido = elegirPendiente(
                        widget.elementos,
                        widget.tipo,
                        anterior: elemento.id,
                      );
                      _error = false;
                    }),
              child: const Text('Otra opción'),
            ),
            OutlinedButton(
              onPressed: _guardando
                  ? null
                  : () {
                      Navigator.pop(context);
                      widget.onDetalle(elemento);
                    },
              child: const Text('Ver detalle'),
            ),
            FilledButton.icon(
              onPressed: _guardando
                  ? null
                  : () async {
                      setState(() {
                        _guardando = true;
                        _error = false;
                      });
                      final guardado = await widget.onEmpezar(elemento);
                      if (!context.mounted) return;
                      if (guardado) {
                        Navigator.pop(context);
                      } else {
                        setState(() {
                          _guardando = false;
                          _error = true;
                        });
                      }
                    },
              icon: const Icon(Icons.play_arrow_rounded),
              label: Text(_guardando ? 'Guardando…' : 'Empezar'),
            ),
          ],
        ],
      ),
    );
  }
}

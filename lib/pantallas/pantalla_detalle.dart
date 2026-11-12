import 'package:flutter/material.dart';

import '../estilos/estilos_app.dart';

import '../modelos/elemento.dart';
import '../widgets/selector_estrellas.dart';
import '../widgets/imagen_elemento.dart';
import 'pantalla_formulario.dart';

/// Muestra un elemento y solicita al padre que guarde sus modificaciones.
class PantallaDetalle extends StatefulWidget {
  const PantallaDetalle({
    super.key,
    required this.elemento,
    required this.onActualizar,
    required this.onBorrar,
  });
  final Elemento elemento;
  final Future<bool> Function(Elemento) onActualizar;
  final Future<bool> Function() onBorrar;

  @override
  State<PantallaDetalle> createState() => _PantallaDetalleState();
}

class _PantallaDetalleState extends State<PantallaDetalle> {
  late Elemento _elemento;
  bool _ocupado = false;

  @override
  void initState() {
    super.initState();
    _elemento = widget.elemento;
  }

  /// Abre el mismo formulario y actualiza el detalle tras guardar con éxito.
  Future<void> _editar() async {
    final actualizado = await Navigator.push<Elemento>(
      context,
      MaterialPageRoute(
        builder: (context) => PantallaFormulario(inicial: _elemento),
      ),
    );
    if (!mounted || actualizado == null) return;
    setState(() => _ocupado = true);
    final guardado = await widget.onActualizar(actualizado);
    if (!mounted) return;
    setState(() {
      _ocupado = false;
      if (guardado) _elemento = actualizado;
    });
  }

  /// Solo borra si el diálogo devuelve true y el almacenamiento lo confirma.
  Future<void> _borrar() async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Borrar elemento?'),
        content: Text('Se eliminará «${_elemento.titulo}» de tu lista.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Borrar'),
          ),
        ],
      ),
    );
    if (!mounted || confirmar != true) return;
    setState(() => _ocupado = true);
    final borrado = await widget.onBorrar();
    if (!mounted) return;
    if (borrado) {
      Navigator.pop(context);
    } else {
      setState(() => _ocupado = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final fecha = _elemento.fechaAlta.toLocal();
    final fechaTexto =
        '${fecha.day.toString().padLeft(2, '0')}/${fecha.month.toString().padLeft(2, '0')}/${fecha.year} · ${fecha.hour.toString().padLeft(2, '0')}:${fecha.minute.toString().padLeft(2, '0')}';
    return PopScope(
      canPop: !_ocupado,
      child: Scaffold(
        appBar: AppBar(title: const Text('Detalle')),
        body: SafeArea(
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: EstilosApp.anchoContenido,
              child: SingleChildScrollView(
                padding: EstilosApp.margenPantalla,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (_elemento.tipo == Tipo.videojuego ||
                        (_elemento.imagenUrl?.trim().isNotEmpty ?? false)) ...[
                      ClipRRect(
                        borderRadius: EstilosApp.radioPanel,
                        child: ImagenElemento(
                          tipo: _elemento.tipo,
                          url: _elemento.imagenUrl,
                          alto: 220,
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    Container(
                      padding: EstilosApp.margenPantalla,
                      decoration: EstilosApp.panelDestacado(context),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _elemento.tipo.etiqueta.toUpperCase(),
                            style: TextStyle(
                              color: tema.colorScheme.onPrimaryContainer,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _elemento.titulo,
                            style: tema.textTheme.headlineMedium?.copyWith(
                              color: tema.colorScheme.onPrimaryContainer,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Chip(label: Text(_elemento.etiquetaEstado)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    Text('Tu valoración', style: tema.textTheme.titleMedium),
                    const SizedBox(height: 8),
                    SelectorEstrellas(valor: _elemento.valoracion),
                    const SizedBox(height: 8),
                    Text(
                      _elemento.valoracion == 0
                          ? 'Sin valorar'
                          : '${_elemento.valoracion} de 5 estrellas',
                    ),
                    const SizedBox(height: 28),
                    Text('Notas', style: tema.textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text(_elemento.notas ?? 'Todavía no has añadido notas.'),
                    const SizedBox(height: 28),
                    Text(
                      'En tu lista desde',
                      style: tema.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(fechaTexto),
                    const SizedBox(height: 8),
                    Text(
                      'ID: ${_elemento.id}',
                      style: tema.textTheme.bodySmall,
                    ),
                    const SizedBox(height: 32),
                    if (_ocupado)
                      const Center(child: CircularProgressIndicator()),
                    FilledButton.icon(
                      onPressed: _ocupado ? null : _editar,
                      icon: const Icon(Icons.edit_outlined),
                      label: const Text('Editar'),
                    ),
                    const SizedBox(height: 8),
                    TextButton.icon(
                      onPressed: _ocupado ? null : _borrar,
                      style: TextButton.styleFrom(
                        foregroundColor: tema.colorScheme.error,
                      ),
                      icon: const Icon(Icons.delete_outline),
                      label: const Text('Borrar'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

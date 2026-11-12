import 'package:flutter/material.dart';

import '../modelos/elemento.dart';
import '../widgets/selector_estrellas.dart';

/// Formulario compartido que devuelve una copia solo al guardar.
class PantallaFormulario extends StatefulWidget {
  const PantallaFormulario({super.key, this.inicial});
  final Elemento? inicial;
  @override
  State<PantallaFormulario> createState() => _PantallaFormularioState();
}

class _PantallaFormularioState extends State<PantallaFormulario> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titulo;
  late final TextEditingController _notas;
  late Tipo _tipo;
  late Estado _estado;
  late int _valoracion;

  @override
  void initState() {
    super.initState();
    _titulo = TextEditingController(text: widget.inicial?.titulo ?? '');
    _notas = TextEditingController(text: widget.inicial?.notas ?? '');
    _tipo = widget.inicial?.tipo ?? Tipo.pelicula;
    _estado = widget.inicial?.estado ?? Estado.pendiente;
    _valoracion = widget.inicial?.valoracion ?? 0;
  }

  @override
  void dispose() {
    _titulo.dispose();
    _notas.dispose();
    super.dispose();
  }

  /// Valida los campos y conserva id y fecha al editar.
  void _guardar() {
    if (!_formKey.currentState!.validate()) return;
    final ahora = DateTime.now();
    final notas = _notas.text.trim();
    Navigator.pop(
      context,
      Elemento(
        id: widget.inicial?.id ?? ahora.microsecondsSinceEpoch.toString(),
        titulo: _titulo.text.trim(),
        tipo: _tipo,
        estado: _estado,
        valoracion: _valoracion,
        notas: notas.isEmpty ? null : notas,
        fechaAlta: widget.inicial?.fechaAlta ?? ahora,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(
        widget.inicial == null ? 'Nuevo elemento' : 'Editar elemento',
      ),
    ),
    body: SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Una historia más en tu lista',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Guarda lo que te apetece ver o jugar, a tu ritmo.',
                  ),
                  const SizedBox(height: 28),
                  TextFormField(
                    key: const ValueKey('titulo'),
                    controller: _titulo,
                    decoration: const InputDecoration(
                      labelText: 'Título',
                      hintText: 'Ej. Dune: Parte 2',
                      helperText: 'Entre 1 y 60 caracteres, sin espacios en los extremos.',
                      helperMaxLines: 2,
                      errorMaxLines: 2,
                    ),
                    textCapitalization: TextCapitalization.sentences,
                    textInputAction: TextInputAction.next,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (texto) {
                      final titulo = texto?.trim() ?? '';
                      if (titulo.isEmpty) return 'Escribe un título.';
                      if (titulo.length > 60) {
                        return 'El título no puede superar los 60 caracteres.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  DropdownButtonFormField<Tipo>(
                    key: const ValueKey('tipo'),
                    initialValue: _tipo,
                    decoration: const InputDecoration(labelText: 'Tipo'),
                    items: Tipo.values
                        .map(
                          (t) => DropdownMenuItem(
                            value: t,
                            child: Text(t.etiqueta),
                          ),
                        )
                        .toList(),
                    onChanged: (t) {
                      if (t != null) setState(() => _tipo = t);
                    },
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<Estado>(
                    key: const ValueKey('estado'),
                    initialValue: _estado,
                    decoration: const InputDecoration(labelText: 'Estado'),
                    items: Estado.values
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Text(e.etiqueta),
                          ),
                        )
                        .toList(),
                    onChanged: (e) {
                      if (e != null) setState(() => _estado = e);
                    },
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Tu valoración',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SelectorEstrellas(
                    valor: _valoracion,
                    onChanged: (v) => setState(() => _valoracion = v),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    key: const ValueKey('notas'),
                    controller: _notas,
                    minLines: 3,
                    maxLines: 6,
                    decoration: const InputDecoration(
                      labelText: 'Notas (opcional)',
                      hintText: '¿Por qué está en tu lista?',
                    ),
                    textCapitalization: TextCapitalization.sentences,
                  ),
                  const SizedBox(height: 28),
                  FilledButton.icon(
                    key: const ValueKey('guardar'),
                    onPressed: _guardar,
                    icon: const Icon(Icons.check),
                    label: const Text('Guardar'),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancelar'),
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

import 'package:flutter/material.dart';

import '../estilos/estilos_app.dart';

import '../modelos/elemento.dart';
import '../modelos/encuadre.dart';
import '../widgets/selector_estrellas.dart';
import '../widgets/imagen_elemento.dart';

/// Formulario compartido que devuelve una copia solo al guardar.
class PantallaFormulario extends StatefulWidget {
  const PantallaFormulario({
    super.key,
    this.inicial,
    this.tipoInicial = Tipo.pelicula,
  });
  final Tipo tipoInicial;
  final Elemento? inicial;
  @override
  State<PantallaFormulario> createState() => _PantallaFormularioState();
}

/// Edita datos locales: no modifica la colección mientras no se pulse Guardar.
class _PantallaFormularioState extends State<PantallaFormulario> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titulo;
  late final TextEditingController _notas;
  late final TextEditingController _imagen;
  String? _vistaPrevia;
  Encuadre? _encuadre;
  late Tipo _tipo;
  late Estado _estado;
  late int _valoracion;
  late bool _favorito;
  DateTime? _fechaTerminado;

  /// Carga una copia de los datos iniciales o los valores de un alta nueva.
  @override
  void initState() {
    super.initState();
    _titulo = TextEditingController(text: widget.inicial?.titulo ?? '');
    _notas = TextEditingController(text: widget.inicial?.notas ?? '');
    _imagen = TextEditingController(text: widget.inicial?.imagenUrl ?? '');
    _vistaPrevia = widget.inicial?.imagenUrl;
    _encuadre = widget.inicial?.encuadre;
    _tipo = widget.inicial?.tipo ?? widget.tipoInicial;
    _estado = widget.inicial?.estado ?? Estado.pendiente;
    _valoracion = widget.inicial?.valoracion ?? 0;
    _favorito = widget.inicial?.favorito ?? false;
    _fechaTerminado = widget.inicial?.fechaTerminado;
  }

  /// Libera los controladores de texto cuando el formulario deja de utilizarse.
  @override
  void dispose() {
    _titulo.dispose();
    _notas.dispose();
    _imagen.dispose();
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
        favorito: _favorito,
        fechaTerminado: _estado == Estado.terminado
            ? (_fechaTerminado ?? Elemento.hoy())
            : null,
        notas: notas.isEmpty ? null : notas,
        imagenUrl: _imagen.text.trim().isNotEmpty ? _imagen.text.trim() : null,
        encuadre: _encuadre,
        fechaAlta: widget.inicial?.fechaAlta ?? ahora,
      ),
    );
  }

  /// La portada es opcional; si hay texto, exige un enlace http o https con servidor.
  String? _validarImagen(String? valor) {
    final texto = valor?.trim() ?? '';
    if (texto.isEmpty) return null;
    final uri = Uri.tryParse(texto);
    if (uri == null ||
        !['http', 'https'].contains(uri.scheme) ||
        uri.host.isEmpty) {
      return 'Introduce un enlace http o https válido.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final colores = tema.colorScheme;
    final tieneEnlace = _imagen.text.trim().isNotEmpty;
    final acciones = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: colores.surfaceContainerLowest,
        border: Border(top: BorderSide(color: colores.outlineVariant)),
      ),
      child: Center(
        heightFactor: 1,
        child: ConstrainedBox(
          constraints: EstilosApp.anchoColeccion,
          child: Align(
            alignment: Alignment.centerRight,
            heightFactor: 1,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancelar'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      key: const ValueKey('guardar'),
                      onPressed: _guardar,
                      icon: const Icon(Icons.check_rounded),
                      label: const Text('Guardar'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.inicial == null ? 'Nuevo elemento' : 'Editar elemento',
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: SafeArea(top: false, child: acciones),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: EstilosApp.anchoColeccion,
                    child: LayoutBuilder(
                      builder: (context, medidas) {
                        final ancho = medidas.maxWidth >= 860;
                        final portada = Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: colores.surfaceContainerLowest,
                            border: Border.all(color: colores.outlineVariant),
                            borderRadius: EstilosApp.radioPanel,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.image_outlined,
                                    color: colores.primary,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      'Imagen de portada',
                                      style: tema.textTheme.titleMedium,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 18),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: ImagenElemento(
                                  tipo: _tipo,
                                  url: _vistaPrevia,
                                  encuadre: _encuadre,
                                  onEncuadreChanged: (valor) =>
                                      setState(() => _encuadre = valor),
                                ),
                              ),
                              const SizedBox(height: 18),
                              TextFormField(
                                key: const ValueKey('imagenUrl'),
                                controller: _imagen,
                                keyboardType: TextInputType.url,
                                autocorrect: false,
                                decoration: const InputDecoration(
                                  labelText: 'Enlace de imagen (opcional)',
                                  hintText: 'https://ejemplo.com/portada.jpg',
                                  errorMaxLines: 2,
                                ),
                                validator: _validarImagen,
                                onChanged: (valor) => setState(() {
                                  if (valor.trim() != (_vistaPrevia ?? '')) {
                                    _encuadre = null;
                                  }
                                  _vistaPrevia =
                                      valor.trim().isNotEmpty &&
                                          _validarImagen(valor) == null
                                      ? valor.trim()
                                      : null;
                                }),
                              ),
                              if (tieneEnlace) ...[
                                const SizedBox(height: 6),
                                Wrap(
                                  spacing: 8,
                                  children: [
                                    TextButton.icon(
                                      onPressed:
                                          _validarImagen(_imagen.text) == null
                                          ? () => setState(
                                              () => _vistaPrevia = _imagen.text
                                                  .trim(),
                                            )
                                          : null,
                                      icon: const Icon(
                                        Icons.visibility_outlined,
                                        size: 18,
                                      ),
                                      label: const Text('Ver imagen'),
                                    ),
                                    TextButton.icon(
                                      onPressed: () => setState(() {
                                        _imagen.clear();
                                        _vistaPrevia = null;
                                        _encuadre = null;
                                      }),
                                      icon: const Icon(
                                        Icons.close_rounded,
                                        size: 18,
                                      ),
                                      label: const Text('Quitar imagen'),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        );
                        final campos = Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextFormField(
                              key: const ValueKey('titulo'),
                              controller: _titulo,
                              decoration: const InputDecoration(
                                labelText: 'Título',
                                hintText: 'Ej. Dune: Parte 2',
                                errorMaxLines: 2,
                              ),
                              textCapitalization: TextCapitalization.sentences,
                              textInputAction: TextInputAction.next,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (texto) {
                                final titulo = texto?.trim() ?? '';
                                if (titulo.isEmpty) return 'Escribe un título.';
                                if (titulo.length > 60) {
                                  return 'El título no puede superar los 60 caracteres.';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 28),
                            Text(
                              'Tipo de contenido',
                              style: tema.textTheme.titleMedium,
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              key: const ValueKey('tipo'),
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                for (final tipo in Tipo.values)
                                  ChoiceChip(
                                    key: ValueKey('tipo-${tipo.name}'),
                                    avatar: Icon(
                                      EstilosApp.iconoTipo(tipo),
                                      size: 18,
                                    ),
                                    label: Text(tipo.etiqueta),
                                    selected: _tipo == tipo,
                                    onSelected: (_) =>
                                        setState(() => _tipo = tipo),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 28),
                            Text('Estado', style: tema.textTheme.titleMedium),
                            const SizedBox(height: 10),
                            Wrap(
                              key: const ValueKey('estado'),
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                for (final estado in Estado.values)
                                  ChoiceChip(
                                    key: ValueKey('estado-${estado.name}'),
                                    avatar: Icon(switch (estado) {
                                      Estado.pendiente =>
                                        Icons.schedule_rounded,
                                      Estado.enCurso =>
                                        Icons.play_circle_outline_rounded,
                                      Estado.terminado =>
                                        Icons.check_circle_outline_rounded,
                                    }, size: 18),
                                    label: Text(estado.etiqueta),
                                    selected: _estado == estado,
                                    onSelected: (_) => setState(() {
                                      if (_estado != estado) {
                                        _fechaTerminado =
                                            estado == Estado.terminado
                                            ? Elemento.hoy()
                                            : null;
                                      }
                                      _estado = estado;
                                    }),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 28),
                            SwitchListTile.adaptive(
                              contentPadding: EdgeInsets.zero,
                              title: const Text('Favorito'),
                              secondary: Icon(
                                _favorito
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: colores.primary,
                              ),
                              value: _favorito,
                              onChanged: (valor) =>
                                  setState(() => _favorito = valor),
                            ),
                            if (_estado == Estado.terminado) ...[
                              OutlinedButton.icon(
                                key: const ValueKey('fechaTerminado'),
                                icon: const Icon(Icons.calendar_today_outlined),
                                label: Text(
                                  'Terminado el ${Elemento.fechaEnEspanol(_fechaTerminado ?? Elemento.hoy())}',
                                ),
                                onPressed: () async {
                                  final hoy = Elemento.hoy();
                                  final fecha = await showDatePicker(
                                    context: context,
                                    initialDate: _fechaTerminado ?? hoy,
                                    firstDate: DateTime(1),
                                    lastDate: hoy,
                                    helpText: 'Fecha de terminado',
                                    cancelText: 'Cancelar',
                                    confirmText: 'Aceptar',
                                    fieldLabelText: 'Fecha',
                                    errorInvalidText:
                                        'Elige una fecha no futura.',
                                  );
                                  if (fecha != null && mounted) {
                                    setState(() => _fechaTerminado = fecha);
                                  }
                                },
                              ),
                              const SizedBox(height: 20),
                            ],
                            Text(
                              'Tu valoración',
                              style: tema.textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            SelectorEstrellas(
                              valor: _valoracion,
                              onChanged: (v) => setState(() => _valoracion = v),
                            ),
                            const SizedBox(height: 24),
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
                          ],
                        );
                        return SingleChildScrollView(
                          padding: EstilosApp.margenPantalla,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'Dale un sitio en tu colección.',
                                style: tema.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Una película, una serie o un juego. A tu ritmo.',
                                style: EstilosApp.textoSecundario(context),
                              ),
                              const SizedBox(height: 28),
                              if (ancho)
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(flex: 3, child: portada),
                                    const SizedBox(width: 32),
                                    Expanded(flex: 5, child: campos),
                                  ],
                                )
                              else ...[
                                portada,
                                const SizedBox(height: 28),
                                campos,
                              ],
                              const SizedBox(height: 12),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

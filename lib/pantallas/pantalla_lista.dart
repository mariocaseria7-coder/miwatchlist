import 'package:flutter/material.dart';

import '../estilos/estilos_app.dart';

import '../modelos/elemento.dart';
import '../servicios/almacen.dart';
import '../servicios/sugerencia.dart';
import '../widgets/dialogo_sugerencia.dart';
import '../widgets/tarjeta_elemento.dart';
import '../widgets/cabecera_coleccion.dart';
import 'pantalla_formulario.dart';
import 'pantalla_detalle.dart';
import 'pantalla_estadisticas.dart';
import 'pantalla_acerca.dart';

/// Es la propietaria de la colección completa y coordina sus cambios.
class PantallaLista extends StatefulWidget {
  const PantallaLista({super.key, this.almacen, this.onCambiarTema});
  final Almacen? almacen;
  final VoidCallback? onCambiarTema;
  @override
  State<PantallaLista> createState() => _PantallaListaState();
}

/// Mantiene los datos originales separados de los filtros que cambian lo visible.
class _PantallaListaState extends State<PantallaLista> {
  List<Elemento> _elementos = [];
  late final Almacen _almacen;
  final _busqueda = TextEditingController();
  Estado? _filtro;
  bool _soloFavoritos = false;
  Tipo? _categoria;
  bool _cargando = true;
  bool _guardando = false;
  bool _errorCarga = false;

  /// Selecciona el almacén e inicia la carga; Flutter no espera un Future de initState.
  @override
  void initState() {
    super.initState();
    _almacen = widget.almacen ?? Almacen();
    _cargar();
  }

  /// Carga al arrancar; separa un error de acceso de una colección vacía y ofrece reintento.
  Future<void> _cargar() async {
    setState(() {
      _cargando = true;
      _errorCarga = false;
    });
    try {
      final elementos = await _almacen.cargar();
      if (!mounted) return;
      setState(() => _elementos = elementos);
    } catch (_) {
      if (!mounted) return;
      setState(() => _errorCarga = true);
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

  /// Libera el controlador de búsqueda al salir de la pantalla.
  @override
  void dispose() {
    _busqueda.dispose();
    super.dispose();
  }

  /// Confirma la propuesta solo al terminar la escritura; un fallo conserva lo anterior.
  Future<bool> _guardar(List<Elemento> propuesta) async {
    if (_guardando || _cargando || _errorCarga) return false;
    setState(() => _guardando = true);
    try {
      await _almacen.guardar(propuesta);
      if (!mounted) return false;
      setState(() => _elementos = propuesta);
      return true;
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'No se pudo guardar. Tus datos anteriores se conservan. Vuelve a intentarlo.',
            ),
          ),
        );
      }
      return false;
    } finally {
      if (mounted) setState(() => _guardando = false);
    }
  }

  /// Espera el formulario y añade su resultado; cancelar devuelve null y no guarda nada.
  Future<void> _anadir({Tipo tipo = Tipo.pelicula}) async {
    final elemento = await Navigator.push<Elemento>(
      context,
      MaterialPageRoute(
        builder: (context) => PantallaFormulario(tipoInicial: tipo),
      ),
    );
    if (!mounted || elemento == null) return;
    await _guardar([..._elementos, elemento]);
  }

  /// Abre el detalle y aplica sus cambios por id sobre toda la colección, no sobre el filtro.
  void _abrirDetalle(Elemento elemento) {
    Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (context) => PantallaDetalle(
          elemento: elemento,
          onActualizar: (actualizado) => _guardar([
            for (final e in _elementos)
              if (e.id == actualizado.id) actualizado else e,
          ]),
          onBorrar: () async {
            final borrado = await _guardar(
              _elementos.where((e) => e.id != elemento.id).toList(),
            );
            if (borrado && mounted) {
              ScaffoldMessenger.of(this.context).showSnackBar(
                const SnackBar(content: Text('Elemento borrado.')),
              );
            }
            return borrado;
          },
        ),
      ),
    );
  }

  /// Cuenta todos los pendientes y abre el sorteo sin aplicar los filtros de la lista.
  Future<void> _queVeoHoy() async {
    final categoria = await showDialog<int>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Elige una categoría'),
        children: [
          for (final indice in [0, 1, 2, -1])
            Builder(
              builder: (context) {
                final tipo = indice < 0 ? null : Tipo.values[indice];
                final total = pendientesDe(_elementos, tipo).length;
                return ListTile(
                  key: ValueKey('sorteo-${tipo?.name ?? "cualquiera"}'),
                  leading: Icon(
                    tipo == null
                        ? Icons.casino_outlined
                        : EstilosApp.iconoTipo(tipo),
                  ),
                  title: Text(tipo?.categoria ?? 'Cualquiera'),
                  subtitle: Text('$total pendientes'),
                  textColor: total == 0
                      ? Theme.of(context).colorScheme.onSurfaceVariant
                      : null,
                  iconColor: total == 0
                      ? Theme.of(context).colorScheme.outline
                      : Theme.of(context).colorScheme.primary,
                  onTap: () => Navigator.pop(context, indice),
                );
              },
            ),
        ],
      ),
    );
    if (!mounted || categoria == null) return;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => DialogoSugerencia(
        elementos: List.unmodifiable(_elementos),
        tipo: categoria < 0 ? null : Tipo.values[categoria],
        onAnadir: () => _anadir(
          tipo: categoria < 0 ? Tipo.pelicula : Tipo.values[categoria],
        ),
        onDetalle: _abrirDetalle,
        onEmpezar: (elemento) => _guardar([
          for (final e in _elementos)
            e.id == elemento.id ? e.copyWith(estado: Estado.enCurso) : e,
        ]),
      ),
    );
  }

  /// Calcula resultados y grupos sin tocar la colección original ni reducir las estadísticas.
  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final colores = tema.colorScheme;
    final consulta = _busqueda.text.trim().toLowerCase();
    final visibles =
        _elementos
            .where(
              (e) =>
                  (!_soloFavoritos || e.favorito) &&
                  (_filtro == null || e.estado == _filtro) &&
                  (_categoria == null || e.tipo == _categoria) &&
                  e.titulo.toLowerCase().contains(consulta),
            )
            .toList()
          ..sort(
            (a, b) => a.titulo.toLowerCase().compareTo(b.titulo.toLowerCase()),
          );
    final grupos = {
      for (final tipo in Tipo.values)
        tipo: visibles.where((e) => e.tipo == tipo).toList(),
    };
    final ocupado = _cargando || _guardando || _errorCarga;
    final oscuro = tema.brightness == Brightness.dark;
    return PopScope(
      canPop: !_guardando,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colores.secondaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.bookmarks_rounded,
                  size: 22,
                  color: colores.onSecondaryContainer,
                ),
              ),
              const SizedBox(width: 10),
              const Flexible(
                child: Text('Mi Watchlist', overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
          actions: [
            IconButton(
              tooltip: 'Acerca de',
              icon: const Icon(Icons.info_outline),
              onPressed: () => Navigator.push<void>(
                context,
                MaterialPageRoute(builder: (_) => const PantallaAcerca()),
              ),
            ),
            IconButton(
              tooltip: oscuro ? 'Activar modo claro' : 'Activar modo oscuro',
              onPressed: widget.onCambiarTema,
              icon: Icon(
                oscuro ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
              ),
            ),
            IconButton(
              tooltip: 'Estadísticas',
              icon: const Icon(Icons.bar_chart_rounded),
              onPressed: ocupado
                  ? null
                  : () => Navigator.push<void>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PantallaEstadisticas(
                          elementos: List.unmodifiable(_elementos),
                        ),
                      ),
                    ),
            ),
            const SizedBox(width: 8),
          ],
        ),
        floatingActionButton: ocupado
            ? null
            : FloatingActionButton.extended(
                onPressed: _anadir,
                icon: const Icon(Icons.add_rounded),
                label: const Text('Añadir'),
              ),
        body: _errorCarga
            ? Center(
                child: Padding(
                  padding: EstilosApp.margenPantalla,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'No se pudo abrir tu colección.',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      FilledButton(
                        onPressed: _cargar,
                        child: const Text('Reintentar'),
                      ),
                    ],
                  ),
                ),
              )
            : _cargando
            ? const Center(child: CircularProgressIndicator())
            : SafeArea(
                child: Center(
                  child: ConstrainedBox(
                    constraints: EstilosApp.anchoColeccion,
                    child: AbsorbPointer(
                      absorbing: _guardando,
                      child: CustomScrollView(
                        key: const ValueKey('coleccion'),
                        slivers: [
                          SliverPadding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            sliver: SliverToBoxAdapter(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const CabeceraColeccion(),
                                  const Divider(height: 1),
                                  const SizedBox(height: 28),
                                  Wrap(
                                    spacing: 14,
                                    runSpacing: 8,
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    children: [
                                      Text(
                                        'Mi colección',
                                        style: tema.textTheme.headlineSmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.w800,
                                            ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 5,
                                        ),
                                        decoration: BoxDecoration(
                                          color: colores.primaryContainer,
                                          borderRadius: BorderRadius.circular(
                                            30,
                                          ),
                                        ),
                                        child: Text(
                                          '${_elementos.length} elementos',
                                          style: TextStyle(
                                            color: colores.onPrimaryContainer,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Tus favoritos, cada uno en su sitio.',
                                    style: EstilosApp.textoSecundario(context),
                                  ),
                                  const SizedBox(height: 22),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: [
                                      ChoiceChip(
                                        label: Text(
                                          'Todo · ${_elementos.length}',
                                        ),
                                        avatar: const Icon(
                                          Icons.grid_view_rounded,
                                          size: 18,
                                        ),
                                        selected: _categoria == null,
                                        onSelected: (_) =>
                                            setState(() => _categoria = null),
                                      ),
                                      for (final tipo in Tipo.values)
                                        ChoiceChip(
                                          key: ValueKey(
                                            'categoria-${tipo.name}',
                                          ),
                                          avatar: Icon(
                                            EstilosApp.iconoTipo(tipo),
                                            size: 18,
                                          ),
                                          label: Text(
                                            '${tipo.categoria} · ${_elementos.where((e) => e.tipo == tipo).length}',
                                          ),
                                          selected: _categoria == tipo,
                                          onSelected: (_) =>
                                              setState(() => _categoria = tipo),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: FilledButton.tonalIcon(
                                      onPressed: ocupado ? null : _queVeoHoy,
                                      icon: const Icon(Icons.casino_outlined),
                                      label: const Text('¿Qué veo hoy?'),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  TextField(
                                    key: const ValueKey('buscar'),
                                    controller: _busqueda,
                                    decoration: InputDecoration(
                                      hintText: 'Buscar tu próxima historia...',
                                      prefixIcon: const Icon(
                                        Icons.search_rounded,
                                      ),
                                      suffixIcon: _busqueda.text.isEmpty
                                          ? null
                                          : IconButton(
                                              tooltip: 'Limpiar búsqueda',
                                              onPressed: () =>
                                                  setState(_busqueda.clear),
                                              icon: const Icon(
                                                Icons.close_rounded,
                                              ),
                                            ),
                                    ),
                                    onChanged: (_) => setState(() {}),
                                  ),
                                  const SizedBox(height: 14),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 4,
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    children: [
                                      ChoiceChip(
                                        label: const Text('Todos'),
                                        selected: _filtro == null,
                                        onSelected: (_) =>
                                            setState(() => _filtro = null),
                                      ),
                                      FilterChip(
                                        label: const Text('Favoritos'),
                                        avatar: const Icon(
                                          Icons.favorite_border,
                                          size: 18,
                                        ),
                                        selected: _soloFavoritos,
                                        onSelected: (valor) => setState(
                                          () => _soloFavoritos = valor,
                                        ),
                                      ),
                                      for (final estado in Estado.values)
                                        ChoiceChip(
                                          label: Text(estado.etiqueta),
                                          selected: _filtro == estado,
                                          onSelected: (_) =>
                                              setState(() => _filtro = estado),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.sort_by_alpha_rounded,
                                        size: 16,
                                        color: colores.onSurfaceVariant,
                                      ),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          'Ordenados por título · A–Z',
                                          style: EstilosApp.textoSecundario(
                                            context,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (_guardando)
                                    const Padding(
                                      padding: EdgeInsets.only(top: 12),
                                      child: LinearProgressIndicator(),
                                    ),
                                ],
                              ),
                            ),
                          ),
                          if (visibles.isEmpty)
                            SliverFillRemaining(
                              hasScrollBody: false,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  24,
                                  40,
                                  24,
                                  112,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(22),
                                      decoration: BoxDecoration(
                                        color: colores.primaryContainer,
                                        borderRadius: BorderRadius.circular(28),
                                      ),
                                      child: Icon(
                                        _elementos.isEmpty
                                            ? Icons.bookmarks_outlined
                                            : Icons.search_off_rounded,
                                        size: 44,
                                        color: colores.primary,
                                      ),
                                    ),
                                    const SizedBox(height: 22),
                                    Text(
                                      _elementos.isEmpty
                                          ? 'Tu próxima historia empieza aquí'
                                          : 'No hay coincidencias',
                                      textAlign: TextAlign.center,
                                      style: tema.textTheme.titleLarge,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      _elementos.isEmpty
                                          ? 'Esa película pendiente, la serie que te recomendaron,\nel juego que no te quieres perder. Guárdalos aquí.'
                                          : 'Prueba otro título, estado o categoría.',
                                      textAlign: TextAlign.center,
                                      style: EstilosApp.textoSecundario(
                                        context,
                                      ),
                                    ),
                                    const SizedBox(height: 22),
                                    if (_elementos.isEmpty)
                                      FilledButton.icon(
                                        onPressed: _anadir,
                                        icon: const Icon(Icons.add_rounded),
                                        label: const Text('Añadir el primero'),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          for (final tipo in Tipo.values)
                            if (grupos[tipo]!.isNotEmpty) ...[
                              SliverPadding(
                                padding: const EdgeInsets.fromLTRB(
                                  20,
                                  28,
                                  20,
                                  16,
                                ),
                                sliver: SliverToBoxAdapter(
                                  child: Row(
                                    children: [
                                      Icon(
                                        EstilosApp.iconoTipo(tipo),
                                        color: colores.primary,
                                      ),
                                      const SizedBox(width: 10),
                                      Flexible(
                                        child: Text(
                                          tipo.categoria,
                                          style: tema.textTheme.titleLarge,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        '${grupos[tipo]!.length}',
                                        style: EstilosApp.textoSecundario(
                                          context,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Divider(
                                          color: colores.outlineVariant,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SliverPadding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                sliver: SliverLayoutBuilder(
                                  builder: (context, medidas) {
                                    final columnas =
                                        medidas.crossAxisExtent >= 960
                                        ? 3
                                        : medidas.crossAxisExtent >= 620
                                        ? 2
                                        : 1;
                                    final anchoTarjeta =
                                        (medidas.crossAxisExtent -
                                            (columnas - 1) * 18) /
                                        columnas;
                                    final escala =
                                        MediaQuery.textScalerOf(context)
                                            .scale(14) /
                                        14;
                                    return SliverGrid.builder(
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: columnas,
                                            mainAxisSpacing: 18,
                                            crossAxisSpacing: 18,
                                            mainAxisExtent:
                                                anchoTarjeta /
                                                    EstilosApp
                                                        .proporcionPortada +
                                                250 +
                                                (escala - 1).clamp(
                                                      0,
                                                      double.infinity,
                                                    ) *
                                                    150,
                                          ),
                                      itemCount: grupos[tipo]!.length,
                                      itemBuilder: (context, index) {
                                        final elemento = grupos[tipo]![index];
                                        return TarjetaElemento(
                                          key: ValueKey(elemento.id),
                                          elemento: elemento,
                                          onTap: () => _abrirDetalle(elemento),
                                          onFavorito: ocupado
                                              ? null
                                              : () => _guardar([
                                                  for (final e in _elementos)
                                                    e.id == elemento.id
                                                        ? e.copyWith(
                                                            favorito:
                                                                !e.favorito,
                                                          )
                                                        : e,
                                                ]),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          if (visibles.isNotEmpty)
                            const SliverToBoxAdapter(
                              child: SizedBox(height: 112),
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

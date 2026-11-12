import 'package:flutter/material.dart';

import '../estilos/estilos_app.dart';

import '../modelos/elemento.dart';
import '../servicios/almacen.dart';
import '../widgets/tarjeta_elemento.dart';
import 'pantalla_formulario.dart';
import 'pantalla_detalle.dart';
import 'pantalla_estadisticas.dart';

/// Es la propietaria de la colección completa y coordina sus cambios.
class PantallaLista extends StatefulWidget {
  const PantallaLista({super.key, this.almacen});
  final Almacen? almacen;
  @override
  State<PantallaLista> createState() => _PantallaListaState();
}

class _PantallaListaState extends State<PantallaLista> {
  List<Elemento> _elementos = [];
  late final Almacen _almacen;
  final _busqueda = TextEditingController();
  Estado? _filtro;
  bool _cargando = true;
  bool _guardando = false;
  bool _errorCarga = false;

  @override
  void initState() {
    super.initState();
    _almacen = widget.almacen ?? Almacen();
    _cargar();
  }

  /// Inicia la lectura fuera de initState y evita perder datos si falla el acceso.
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

  @override
  void dispose() {
    _busqueda.dispose();
    super.dispose();
  }

  /// Reemplaza la colección completa después de validar una operación.
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

  /// El formulario devuelve null cuando se cierra sin guardar.
  Future<void> _anadir() async {
    final elemento = await Navigator.push<Elemento>(
      context,
      MaterialPageRoute(builder: (context) => const PantallaFormulario()),
    );
    if (!mounted || elemento == null) return;
    await _guardar([..._elementos, elemento]);
  }

  /// Las operaciones del detalle se aplican por id a la lista original.
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

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final consulta = _busqueda.text.trim().toLowerCase();
    final visibles = _elementos
        .where(
          (e) =>
              (_filtro == null || e.estado == _filtro) &&
              e.titulo.toLowerCase().contains(consulta),
        )
        .toList();
    final ocupado = _cargando || _guardando || _errorCarga;
    return PopScope(
      canPop: !_guardando,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Mi Watchlist'),
          actions: [
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
                icon: const Icon(Icons.add),
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
                        slivers: [
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                24,
                                16,
                                24,
                                12,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'TU COLECCIÓN',
                                    style: EstilosApp.etiqueta(context),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Historias por descubrir.',
                                    style: tema.textTheme.headlineMedium,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '${_elementos.length} elementos · Películas, series y videojuegos',
                                    style: EstilosApp.textoSecundario(context),
                                  ),
                                  const SizedBox(height: 24),
                                  TextField(
                                    key: const ValueKey('buscar'),
                                    controller: _busqueda,
                                    decoration: InputDecoration(
                                      hintText: 'Buscar por título',
                                      prefixIcon: const Icon(Icons.search),
                                      suffixIcon: _busqueda.text.isEmpty
                                          ? null
                                          : IconButton(
                                              tooltip: 'Limpiar búsqueda',
                                              onPressed: () =>
                                                  setState(_busqueda.clear),
                                              icon: const Icon(Icons.close),
                                            ),
                                    ),
                                    onChanged: (_) => setState(() {}),
                                  ),
                                  const SizedBox(height: 16),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 4,
                                    children: [
                                      ChoiceChip(
                                        label: const Text('Todos'),
                                        selected: _filtro == null,
                                        onSelected: (_) =>
                                            setState(() => _filtro = null),
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
                                  24,
                                  24,
                                  112,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      _elementos.isEmpty
                                          ? Icons.auto_stories_outlined
                                          : Icons.search_off,
                                      size: 64,
                                      color: tema.colorScheme.primary,
                                    ),
                                    const SizedBox(height: 20),
                                    Text(
                                      _elementos.isEmpty
                                          ? 'Tu próxima historia empieza aquí'
                                          : 'No hay coincidencias',
                                      textAlign: TextAlign.center,
                                      style: tema.textTheme.titleLarge,
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      _elementos.isEmpty
                                          ? 'Haz sitio a esa película, serie o videojuego\nque tienes en mente.'
                                          : 'Prueba otro título o cambia el filtro.',
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 24),
                                    if (_elementos.isEmpty)
                                      FilledButton.icon(
                                        onPressed: _anadir,
                                        icon: const Icon(Icons.add),
                                        label: const Text('Añadir el primero'),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          SliverPadding(
                            padding: const EdgeInsets.fromLTRB(20, 4, 20, 104),
                            sliver: SliverList.builder(
                              itemCount: visibles.length,
                              itemBuilder: (context, index) => TarjetaElemento(
                                key: ValueKey(visibles[index].id),
                                elemento: visibles[index],
                                onTap: () => _abrirDetalle(visibles[index]),
                              ),
                            ),
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

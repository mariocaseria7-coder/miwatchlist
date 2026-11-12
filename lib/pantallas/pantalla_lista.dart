import 'package:flutter/material.dart';

import '../modelos/elemento.dart';
import '../widgets/tarjeta_elemento.dart';
import 'pantalla_formulario.dart';

/// Mantiene la colección y coordina las operaciones de las otras pantallas.
class PantallaLista extends StatefulWidget {
  const PantallaLista({super.key});

  @override
  State<PantallaLista> createState() => _PantallaListaState();
}

class _PantallaListaState extends State<PantallaLista> {
  final List<Elemento> _elementos = [
    Elemento(
      id: '1',
      titulo: 'Dune: Parte 2',
      tipo: Tipo.pelicula,
      estado: Estado.pendiente,
      fechaAlta: DateTime(2026, 11, 1),
    ),
    Elemento(
      id: '2',
      titulo: 'The Bear',
      tipo: Tipo.serie,
      estado: Estado.enCurso,
      valoracion: 4,
      fechaAlta: DateTime(2026, 11, 2),
    ),
    Elemento(
      id: '3',
      titulo: 'Hollow Knight',
      tipo: Tipo.videojuego,
      estado: Estado.enCurso,
      valoracion: 5,
      fechaAlta: DateTime(2026, 11, 3),
    ),
    Elemento(
      id: '4',
      titulo: 'Interstellar',
      tipo: Tipo.pelicula,
      estado: Estado.terminado,
      valoracion: 5,
      fechaAlta: DateTime(2026, 11, 4),
    ),
  ];

  /// Espera el resultado sin cambiar la colección si se cancela.
  Future<void> _anadir() async {
    final elemento = await Navigator.push<Elemento>(
      context,
      MaterialPageRoute(builder: (context) => const PantallaFormulario()),
    );
    if (!mounted || elemento == null) return;
    setState(() => _elementos.add(elemento));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mi Watchlist')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _anadir,
        icon: const Icon(Icons.add),
        label: const Text('Añadir'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: _elementos.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Tu próxima historia empieza aquí.'),
                      const SizedBox(height: 16),
                      FilledButton(
                        onPressed: _anadir,
                        child: const Text('Añadir el primero'),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: _elementos.length,
                  itemBuilder: (context, index) => TarjetaElemento(
                    key: ValueKey(_elementos[index].id),
                    elemento: _elementos[index],
                    onTap: () {},
                  ),
                ),
        ),
      ),
    );
  }
}

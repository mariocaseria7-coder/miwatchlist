import 'package:flutter/material.dart';

import 'estilos/tema_app.dart';
import 'pantallas/pantalla_lista.dart';

/// Inicia la aplicación con los servicios de Flutter disponibles.
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MiWatchlistApp());
}

/// Configura la navegación inicial y un tema común para todas las pantallas.
class MiWatchlistApp extends StatelessWidget {
  const MiWatchlistApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi Watchlist',
      debugShowCheckedModeBanner: false,
      theme: TemaApp.claro,
      home: const PantallaLista(),
    );
  }
}

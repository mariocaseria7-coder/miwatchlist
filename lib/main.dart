import 'package:flutter/material.dart';

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
    final colores = ColorScheme.fromSeed(seedColor: const Color(0xFF6750A4));
    return MaterialApp(
      title: 'Mi Watchlist',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: colores,
        scaffoldBackgroundColor: colores.surface,
        appBarTheme: AppBarTheme(
          backgroundColor: colores.surface,
          foregroundColor: colores.onSurface,
          centerTitle: false,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          alignLabelWithHint: true,
        ),
      ),
      home: const PantallaLista(),
    );
  }
}

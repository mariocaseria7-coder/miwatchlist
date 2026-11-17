import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'estilos/tema_app.dart';
import 'pantallas/pantalla_lista.dart';
import 'servicios/almacen.dart';

/// Inicia la aplicación con los servicios de Flutter disponibles.
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MiWatchlistApp());
}

/// Configura la navegación inicial y un tema común para todas las pantallas.
class MiWatchlistApp extends StatefulWidget {
  const MiWatchlistApp({super.key, this.preferencias});
  final SharedPreferencesAsync? preferencias;

  @override
  State<MiWatchlistApp> createState() => _MiWatchlistAppState();
}

/// Conserva la elección de tema y comparte el almacén con la pantalla inicial.
class _MiWatchlistAppState extends State<MiWatchlistApp> {
  late final SharedPreferencesAsync _preferencias;
  late final Almacen _almacen;
  bool _oscuro = true;
  bool _temaOcupado = true;

  /// Prepara el almacén y empieza a recuperar el tema sin bloquear el arranque.
  @override
  void initState() {
    super.initState();
    _preferencias = widget.preferencias ?? SharedPreferencesAsync();
    _almacen = Almacen(preferencias: _preferencias);
    _cargarTema();
  }

  /// Lee la preferencia al arrancar; si no existe, mantiene el modo oscuro inicial.
  Future<void> _cargarTema() async {
    try {
      final oscuro = await _preferencias.getBool('temaOscuro');
      if (mounted) setState(() => _oscuro = oscuro ?? true);
    } catch (error) {
      debugPrint('No se pudo recuperar el tema: $error');
    } finally {
      if (mounted) setState(() => _temaOcupado = false);
    }
  }

  /// Cambia toda la app y conserva la elección para el próximo arranque.
  Future<void> _cambiarTema(BuildContext contexto) async {
    if (_temaOcupado) return;
    final anterior = _oscuro;
    setState(() {
      _oscuro = !anterior;
      _temaOcupado = true;
    });
    try {
      await _preferencias.setBool('temaOscuro', _oscuro);
    } catch (_) {
      if (mounted) setState(() => _oscuro = anterior);
      if (contexto.mounted) {
        ScaffoldMessenger.of(contexto).showSnackBar(
          const SnackBar(
            content: Text('No se pudo guardar el tema. Vuelve a intentarlo.'),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _temaOcupado = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi Watchlist',
      debugShowCheckedModeBanner: false,
      theme: TemaApp.claro,
      darkTheme: TemaApp.oscuro,
      themeMode: _oscuro ? ThemeMode.dark : ThemeMode.light,
      home: Builder(
        builder: (context) => PantallaLista(
          almacen: _almacen,
          onCambiarTema: _temaOcupado ? null : () => _cambiarTema(context),
        ),
      ),
    );
  }
}

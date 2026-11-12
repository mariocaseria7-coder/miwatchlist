import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../modelos/elemento.dart';

/// Guarda la colección completa como un único texto JSON en el dispositivo.
class Almacen {
  Almacen({this.preferencias});
  final SharedPreferencesAsync? preferencias;
  late final SharedPreferencesAsync _prefs =
      preferencias ?? SharedPreferencesAsync();

  /// Recupera una lista vacía si no hay datos o su contenido está dañado.
  Future<List<Elemento>> cargar() async {
    final texto = await _prefs.getString('watchlist');
    if (texto == null) return [];
    try {
      final json = jsonDecode(texto) as List<dynamic>;
      final elementos = json
          .map((e) => Elemento.fromJson(e as Map<String, dynamic>))
          .toList();
      if (elementos.map((e) => e.id).toSet().length != elementos.length) {
        return [];
      }
      return elementos;
    } on FormatException {
      return [];
    } on TypeError {
      return [];
    } on ArgumentError {
      return [];
    }
  }

  /// Espera la escritura y propaga sus errores para que la interfaz los muestre.
  Future<void> guardar(List<Elemento> elementos) async {
    final texto = jsonEncode(elementos.map((e) => e.toJson()).toList());
    await _prefs.setString('watchlist', texto);
  }
}

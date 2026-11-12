import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:miwatchlist/servicios/almacen.dart';
import 'package:miwatchlist/modelos/elemento.dart';

class PreferenciasMemoria implements SharedPreferencesAsync {
  final Map<String, Object?> datos = {};
  String? get texto => datos['texto'] as String?;
  set texto(String? valor) => datos['texto'] = valor;
  String? get clave => datos['clave'] as String?;
  set clave(String? valor) => datos['clave'] = valor;
  bool get falla => datos['falla'] == true;
  set falla(bool valor) => datos['falla'] = valor;

  @override
  Future<String?> getString(String key) async => texto;

  @override
  Future<void> setString(String key, String value) async {
    if (falla) throw StateError('Disco no disponible');
    clave = key;
    texto = value;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  final elemento = Elemento(
    id: '1',
    titulo: 'Dune',
    tipo: Tipo.pelicula,
    estado: Estado.pendiente,
    fechaAlta: DateTime(2026, 11, 12),
  );

  test('guarda en watchlist y recupera desde otra instancia', () async {
    final prefs = PreferenciasMemoria();
    await Almacen(preferencias: prefs).guardar([elemento]);
    expect(prefs.clave, 'watchlist');
    expect(jsonDecode(prefs.texto!), isA<List<dynamic>>());
    final recuperados = await Almacen(preferencias: prefs).cargar();
    expect(recuperados.single.toJson(), elemento.toJson());
  });

  test('sin datos y JSON inválido recuperan una lista vacía', () async {
    final prefs = PreferenciasMemoria();
    final almacen = Almacen(preferencias: prefs);
    for (final texto in [
      null,
      '{roto',
      '{}',
      '[1]',
      '[{}]',
      jsonEncode([elemento.toJson(), elemento.toJson()]),
      jsonEncode([
        {...elemento.toJson(), 'tipo': 'desconocido'},
      ]),
      jsonEncode([
        {...elemento.toJson(), 'valoracion': 8},
      ]),
    ]) {
      prefs.texto = texto;
      expect(await almacen.cargar(), isEmpty, reason: '$texto');
    }
  });

  test('propaga errores de escritura y conserva los datos guardados', () async {
    final prefs = PreferenciasMemoria();
    final almacen = Almacen(preferencias: prefs);
    await almacen.guardar([elemento]);
    prefs.falla = true;
    await expectLater(almacen.guardar([]), throwsStateError);
    expect((await almacen.cargar()).single.id, elemento.id);
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:miwatchlist/modelos/elemento.dart';
import 'package:miwatchlist/modelos/encuadre.dart';

void main() {
  final original = Elemento(
    id: '1',
    titulo: 'Dune: Parte 2',
    tipo: Tipo.pelicula,
    estado: Estado.pendiente,
    valoracion: 4,
    notas: 'Ver en versión original',
    fechaAlta: DateTime(2026, 11, 12, 10, 30),
  );

  test('JSON conserva todos los datos para todos los tipos y estados', () {
    for (final tipo in Tipo.values) {
      for (final estado in Estado.values) {
        final elemento = original.copyWith(tipo: tipo, estado: estado);
        expect(
          Elemento.fromJson(elemento.toJson()).toJson(),
          elemento.toJson(),
        );
      }
    }
  });

  test('notas ausentes se recuperan como null', () {
    final json = original.toJson()..remove('notas');
    expect(Elemento.fromJson(json).notas, isNull);
  });

  test('copyWith solo cambia lo solicitado y no modifica el original', () {
    final copia = original.copyWith(estado: Estado.terminado, valoracion: 5);
    expect(copia.toJson(), {
      ...original.toJson(),
      'estado': 'terminado',
      'valoracion': 5,
    });
    expect(original.estado, Estado.pendiente);
    expect(original.valoracion, 4);
    expect(original.copyWith().toJson(), original.toJson());
    expect(original.copyWith(notas: null).notas, isNull);
    expect(original.copyWith(notas: 'Otra nota').notas, 'Otra nota');
  });

  test('valida límites y recorta el título', () {
    expect(original.copyWith(titulo: '  Dune  ').titulo, 'Dune');
    expect(() => original.copyWith(titulo: '  '), throwsArgumentError);
    expect(() => original.copyWith(titulo: 'a' * 61), throwsArgumentError);
    expect(() => original.copyWith(valoracion: -1), throwsArgumentError);
    expect(() => original.copyWith(valoracion: 6), throwsArgumentError);
  });

  test('encuadre opcional compatible con JSON antiguo y números enteros', () {
    final antiguo = original
        .copyWith(imagenUrl: 'https://example.com/portada.png')
        .toJson();
    expect(antiguo.containsKey('encuadre'), false);
    expect(Elemento.fromJson(antiguo).encuadre, isNull);
    final recuperado = Elemento.fromJson({
      ...antiguo,
      'encuadre': {'zoom': 2, 'x': 1, 'y': -1},
    });
    expect(recuperado.encuadre!.toJson(), {'zoom': 2.0, 'x': 1.0, 'y': -1.0});
  });

  test('encuadre se serializa y copyWith conserva la inmutabilidad', () {
    final portada = original.copyWith(
      imagenUrl: 'https://example.com/portada.png',
      encuadre: Encuadre(zoom: 2.5, x: -.4, y: .8),
    );
    expect(
      Elemento.fromJson(portada.toJson()).encuadre!.toJson(),
      portada.encuadre!.toJson(),
    );
    final editado = portada.copyWith(titulo: 'Otro título');
    expect(editado.encuadre, same(portada.encuadre));
    expect(portada.titulo, original.titulo);
    expect(portada.copyWith(encuadre: null).encuadre, isNull);
    expect(original.encuadre, isNull);
  });

  test('cambiar o quitar la imagen elimina su encuadre anterior', () {
    const url = 'https://example.com/portada.png';
    final portada = original.copyWith(
      imagenUrl: url,
      encuadre: Encuadre(zoom: 3),
    );
    expect(portada.copyWith(imagenUrl: url).encuadre, same(portada.encuadre));
    expect(
      portada.copyWith(imagenUrl: 'https://example.com/otra.png').encuadre,
      isNull,
    );
    expect(portada.copyWith(imagenUrl: null).encuadre, isNull);
    expect(
      portada.copyWith(imagenUrl: null).toJson().containsKey('encuadre'),
      false,
    );
  });

  test('rechaza encuadres inválidos y valores no finitos', () {
    for (final zoom in [.5, 6.0, double.nan, double.infinity]) {
      expect(() => Encuadre(zoom: zoom), throwsArgumentError);
    }
    expect(() => Encuadre(x: 1.01), throwsArgumentError);
    expect(() => Encuadre(y: -1.01), throwsArgumentError);
    expect(() => Encuadre(y: double.nan), throwsArgumentError);
    expect(() => Encuadre.fromJson({'zoom': '2'}), throwsA(isA<TypeError>()));
  });
}

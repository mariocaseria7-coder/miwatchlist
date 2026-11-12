import 'package:flutter_test/flutter_test.dart';
import 'package:miwatchlist/modelos/elemento.dart';

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
}

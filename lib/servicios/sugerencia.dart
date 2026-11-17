import 'dart:math';

import '../modelos/elemento.dart';

List<Elemento> pendientesDe(List<Elemento> elementos, Tipo? tipo) => elementos
    .where(
      (e) => e.estado == Estado.pendiente && (tipo == null || e.tipo == tipo),
    )
    .toList();

/// Excluye la opción anterior cuando existe una alternativa pendiente.
Elemento? elegirPendiente(
  List<Elemento> elementos,
  Tipo? tipo, {
  String? anterior,
  Random? azar,
}) {
  final pendientes = pendientesDe(elementos, tipo);
  if (pendientes.isEmpty) return null;
  final opciones = pendientes.length > 1
      ? pendientes.where((e) => e.id != anterior).toList()
      : pendientes;
  return opciones[(azar ?? Random()).nextInt(opciones.length)];
}

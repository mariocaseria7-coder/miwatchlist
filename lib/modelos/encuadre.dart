/// Posición relativa de la portada: zoom sobre cover y alineación entre -1 y 1.
class Encuadre {
  /// Solo admite zoom 1–5 y posiciones finitas entre -1 y 1.
  Encuadre({this.zoom = 1, this.x = 0, this.y = 0}) {
    if (!zoom.isFinite ||
        zoom < 1 ||
        zoom > zoomMaximo ||
        !x.isFinite ||
        x < -1 ||
        x > 1 ||
        !y.isFinite ||
        y < -1 ||
        y > 1) {
      throw ArgumentError('El encuadre de la portada no es válido.');
    }
  }

  static const double zoomMaximo = 5;
  final double zoom;
  final double x;
  final double y;

  /// Guarda los números del encuadre; no contiene una copia de la imagen.
  Map<String, dynamic> toJson() => {'zoom': zoom, 'x': x, 'y': y};

  /// Acepta números enteros o decimales y centra los parámetros que falten.
  factory Encuadre.fromJson(Map<String, dynamic> json) => Encuadre(
    zoom: (json['zoom'] as num?)?.toDouble() ?? 1,
    x: (json['x'] as num?)?.toDouble() ?? 0,
    y: (json['y'] as num?)?.toDouble() ?? 0,
  );
}

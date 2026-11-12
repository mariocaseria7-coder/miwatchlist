/// Tipos de contenido que se pueden guardar en la colección.
enum Tipo {
  pelicula('Película'),
  serie('Serie'),
  videojuego('Videojuego');

  const Tipo(this.etiqueta);
  final String etiqueta;
}

/// Progreso de un elemento, independiente de su valoración.
enum Estado {
  pendiente('Pendiente'),
  enCurso('Viendo/Jugando'),
  terminado('Terminado');

  const Estado(this.etiqueta);
  final String etiqueta;
}

/// Datos inmutables de una película, serie o videojuego.
class Elemento {
  Elemento({
    required this.id,
    required String titulo,
    required this.tipo,
    required this.estado,
    this.valoracion = 0,
    this.notas,
    this.imagenUrl,
    required this.fechaAlta,
  }) : titulo = titulo.trim() {
    if (id.isEmpty || this.titulo.isEmpty || this.titulo.length > 60) {
      throw ArgumentError('El id y el título deben ser válidos.');
    }
    if (valoracion < 0 || valoracion > 5) {
      throw ArgumentError.value(
        valoracion,
        'valoracion',
        'Debe estar entre 0 y 5',
      );
    }
  }

  final String id;
  final String titulo;
  final Tipo tipo;
  final Estado estado;
  final int valoracion;
  final String? notas;
  final String? imagenUrl;
  final DateTime fechaAlta;

  String get etiquetaEstado => estado == Estado.enCurso
      ? (tipo == Tipo.videojuego ? 'Jugando' : 'Viendo')
      : estado.etiqueta;

  /// Convierte los campos a valores compatibles con JSON.
  Map<String, dynamic> toJson() => {
    'id': id,
    'titulo': titulo,
    'tipo': tipo.name,
    'estado': estado.name,
    'valoracion': valoracion,
    'notas': notas,
    'imagenUrl': imagenUrl,
    'fechaAlta': fechaAlta.toIso8601String(),
  };

  /// Reconstruye un elemento; los datos inválidos provocan una excepción.
  factory Elemento.fromJson(Map<String, dynamic> json) => Elemento(
    id: json['id'] as String,
    titulo: json['titulo'] as String,
    tipo: Tipo.values.byName(json['tipo'] as String),
    estado: Estado.values.byName(json['estado'] as String),
    valoracion: json['valoracion'] as int,
    notas: json['notas'] as String?,
    imagenUrl: json['imagenUrl'] as String?,
    fechaAlta: DateTime.parse(json['fechaAlta'] as String),
  );

  static const _sinCambio = Object();

  /// Crea otra versión; omitir notas las conserva y pasar null las elimina.
  Elemento copyWith({
    String? titulo,
    Tipo? tipo,
    Estado? estado,
    int? valoracion,
    Object? notas = _sinCambio,
    Object? imagenUrl = _sinCambio,
  }) => Elemento(
    id: id,
    titulo: titulo ?? this.titulo,
    tipo: tipo ?? this.tipo,
    estado: estado ?? this.estado,
    valoracion: valoracion ?? this.valoracion,
    notas: identical(notas, _sinCambio) ? this.notas : notas as String?,
    imagenUrl: identical(imagenUrl, _sinCambio)
        ? this.imagenUrl
        : imagenUrl as String?,
    fechaAlta: fechaAlta,
  );
}

import 'encuadre.dart';

/// Tipos de contenido que se pueden guardar en la colección.
enum Tipo {
  pelicula('Película', 'Películas'),
  serie('Serie', 'Series'),
  videojuego('Videojuego', 'Videojuegos');

  const Tipo(this.etiqueta, this.categoria);
  final String etiqueta;
  final String categoria;
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
  /// Construye un elemento válido y descarta fecha o encuadre cuando no corresponden.
  Elemento({
    required this.id,
    required String titulo,
    required this.tipo,
    required this.estado,
    this.valoracion = 0,
    this.favorito = false,
    DateTime? fechaTerminado,
    this.notas,
    this.imagenUrl,
    Encuadre? encuadre,
    required this.fechaAlta,
  }) : titulo = titulo.trim(),
       fechaTerminado = estado == Estado.terminado ? fechaTerminado : null,
       encuadre = imagenUrl == null || imagenUrl.trim().isEmpty
           ? null
           : encuadre {
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
  final bool favorito;
  final DateTime? fechaTerminado;
  final String? notas;
  final String? imagenUrl;
  final Encuadre? encuadre;
  final DateTime fechaAlta;

  /// En curso se muestra como Jugando para juegos y Viendo para películas o series.
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
    'favorito': favorito,
    'fechaTerminado': fechaTerminado?.toIso8601String(),
    'notas': notas,
    'imagenUrl': imagenUrl,
    if (encuadre != null) 'encuadre': encuadre!.toJson(),
    'fechaAlta': fechaAlta.toIso8601String(),
  };

  /// Reconstruye un elemento; los datos inválidos provocan una excepción.
  factory Elemento.fromJson(Map<String, dynamic> json) => Elemento(
    id: json['id'] as String,
    titulo: json['titulo'] as String,
    tipo: Tipo.values.byName(json['tipo'] as String),
    estado: Estado.values.byName(json['estado'] as String),
    valoracion: json['valoracion'] as int,
    favorito: json['favorito'] as bool? ?? false,
    fechaTerminado: json['fechaTerminado'] == null
        ? null
        : DateTime.parse(json['fechaTerminado'] as String),
    notas: json['notas'] as String?,
    imagenUrl: json['imagenUrl'] as String?,
    encuadre: json['encuadre'] == null
        ? null
        : Encuadre.fromJson(json['encuadre'] as Map<String, dynamic>),
    fechaAlta: DateTime.parse(json['fechaAlta'] as String),
  );

  /// Obtiene la fecha local sin hora para comparar y seleccionar días del calendario.
  static DateTime hoy() {
    final ahora = DateTime.now();
    return DateTime(ahora.year, ahora.month, ahora.day);
  }

  /// Muestra día, mes abreviado en español y año sin añadir una dependencia.
  static String fechaEnEspanol(DateTime fecha) {
    const meses = [
      'ene',
      'feb',
      'mar',
      'abr',
      'may',
      'jun',
      'jul',
      'ago',
      'sep',
      'oct',
      'nov',
      'dic',
    ];
    return '${fecha.day} ${meses[fecha.month - 1]} ${fecha.year}';
  }

  /// Distingue un campo omitido de null: omitir conserva el dato y null lo elimina.
  static const _sinCambio = Object();

  /// Crea una copia sin cambiar el original; conserva identidad y aplica las reglas de fecha.
  /// Los campos anulables omitidos se conservan y un null explícito los elimina.
  Elemento copyWith({
    String? titulo,
    Tipo? tipo,
    Estado? estado,
    int? valoracion,
    bool? favorito,
    Object? fechaTerminado = _sinCambio,
    Object? notas = _sinCambio,
    Object? imagenUrl = _sinCambio,
    Object? encuadre = _sinCambio,
  }) => Elemento(
    id: id,
    titulo: titulo ?? this.titulo,
    tipo: tipo ?? this.tipo,
    estado: estado ?? this.estado,
    valoracion: valoracion ?? this.valoracion,
    favorito: favorito ?? this.favorito,
    fechaTerminado: identical(fechaTerminado, _sinCambio)
        ? (estado == Estado.terminado && this.estado != Estado.terminado
              ? hoy()
              : this.fechaTerminado)
        : fechaTerminado as DateTime?,
    notas: identical(notas, _sinCambio) ? this.notas : notas as String?,
    imagenUrl: identical(imagenUrl, _sinCambio)
        ? this.imagenUrl
        : imagenUrl as String?,
    encuadre: identical(encuadre, _sinCambio)
        ? (!identical(imagenUrl, _sinCambio) && imagenUrl != this.imagenUrl
              ? null
              : this.encuadre)
        : encuadre as Encuadre?,
    fechaAlta: fechaAlta,
  );
}

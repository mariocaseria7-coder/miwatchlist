import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../estilos/estilos_app.dart';
import '../modelos/elemento.dart';
import '../modelos/encuadre.dart';
import 'geometria_portada.dart';

/// Comparte el marco y el encuadre; solo muestra controles al recibir un callback.
class ImagenElemento extends StatefulWidget {
  const ImagenElemento({
    super.key,
    required this.tipo,
    this.url,
    this.encuadre,
    this.onEncuadreChanged,
  });
  final Tipo tipo;
  final String? url;
  final Encuadre? encuadre;
  final ValueChanged<Encuadre>? onEncuadreChanged;

  @override
  State<ImagenElemento> createState() => _ImagenElementoState();
}

/// Escucha la carga de imagen y transforma los gestos en parámetros de encuadre.
class _ImagenElementoState extends State<ImagenElemento> {
  ImageStream? _stream;
  ImageInfo? _imagen;
  bool _error = false;
  late Encuadre _inicio;
  late Offset _focoInicial;
  late final _listener = ImageStreamListener(
    (imagen, _) {
      if (!mounted) {
        imagen.dispose();
        return;
      }
      setState(() {
        _imagen?.dispose();
        _imagen = imagen;
      });
    },
    onError: (Object error, StackTrace? stack) {
      if (mounted) setState(() => _error = true);
    },
  );

  /// Empieza a resolver la portada cuando el widget entra en el árbol.
  @override
  void initState() {
    super.initState();
    _cargar();
  }

  @override
  void didUpdateWidget(ImagenElemento oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url?.trim() != widget.url?.trim()) _cargar();
  }

  /// Desconecta la portada anterior y escucha la nueva URL para evitar respuestas antiguas.
  void _cargar() {
    _stream?.removeListener(_listener);
    _stream = null;
    _imagen?.dispose();
    _imagen = null;
    _error = false;
    final url = widget.url?.trim();
    if (url != null && url.isNotEmpty) {
      _stream = NetworkImage(url).resolve(ImageConfiguration.empty)
        ..addListener(_listener);
    }
  }

  /// Retira el oyente y libera la imagen recibida para no conservar recursos fuera de uso.
  @override
  void dispose() {
    _stream?.removeListener(_listener);
    _imagen?.dispose();
    super.dispose();
  }

  /// Ofrece una reserva legible cuando no hay imagen o no se puede cargar.
  Widget _fondo(BuildContext context) {
    final colores = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colores.primaryContainer, colores.surfaceContainerLow],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              EstilosApp.iconoTipo(widget.tipo),
              color: colores.primary,
              size: 40,
            ),
            const SizedBox(height: 8),
            Text(
              _error
                  ? 'Imagen no disponible'
                  : widget.tipo == Tipo.videojuego
                  ? 'TU PRÓXIMA AVENTURA'
                  : 'TU PRÓXIMA HISTORIA',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colores.onPrimaryContainer,
                fontSize: 11,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Comparte el marco de portada y solo añade gestos y controles cuando la imagen está cargada.
  @override
  Widget build(BuildContext context) {
    final encuadre = widget.encuadre ?? Encuadre();
    final info = _imagen;
    final editable =
        info != null && !_error && widget.onEncuadreChanged != null;
    final imagen = info == null
        ? null
        : Size(info.image.width.toDouble(), info.image.height.toDouble());
    return LayoutBuilder(
      builder: (context, medidas) {
        final marco = Size(
          medidas.maxWidth,
          medidas.maxWidth / EstilosApp.proporcionPortada,
        );
        void zoom(double valor, Offset foco) {
          if (!editable) return;
          widget.onEncuadreChanged!(
            transformarEncuadre(
              imagen!,
              marco,
              encuadre,
              zoom: valor,
              focoInicial: foco,
              focoActual: foco,
            ),
          );
        }

        Widget contenido;
        if (info == null || _error) {
          contenido = Stack(
            fit: StackFit.expand,
            children: [
              _fondo(context),
              if (!_error && _stream != null)
                const Align(
                  alignment: Alignment.bottomCenter,
                  child: LinearProgressIndicator(),
                ),
            ],
          );
        } else {
          final rect = rectanguloPortada(imagen!, marco, encuadre);
          contenido = Semantics(
            label: 'Portada',
            image: true,
            child: Stack(
              fit: StackFit.expand,
              clipBehavior: Clip.hardEdge,
              children: [
                Positioned.fromRect(
                  rect: rect,
                  child: RawImage(
                    image: info.image,
                    fit: BoxFit.fill,
                    filterQuality: FilterQuality.medium,
                  ),
                ),
              ],
            ),
          );
        }
        if (editable) {
          contenido = MouseRegion(
            cursor: SystemMouseCursors.move,
            child: Listener(
              onPointerSignal: (evento) {
                if (evento is PointerScrollEvent) {
                  GestureBinding.instance.pointerSignalResolver.register(
                    evento,
                    (_) {
                      zoom(
                        encuadre.zoom * math.exp(-evento.scrollDelta.dy / 300),
                        evento.localPosition,
                      );
                    },
                  );
                }
              },
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onScaleStart: (detalle) {
                  _inicio = widget.encuadre ?? Encuadre();
                  _focoInicial = detalle.localFocalPoint;
                },
                onScaleUpdate: (detalle) => widget.onEncuadreChanged!(
                  transformarEncuadre(
                    imagen!,
                    marco,
                    _inicio,
                    zoom: _inicio.zoom * detalle.scale,
                    focoInicial: _focoInicial,
                    focoActual: detalle.localFocalPoint,
                  ),
                ),
                child: contenido,
              ),
            ),
          );
        }
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: EstilosApp.radioPanel,
              child: AspectRatio(
                key: const ValueKey('marco-portada'),
                aspectRatio: EstilosApp.proporcionPortada,
                child: contenido,
              ),
            ),
            if (editable) ...[
              const SizedBox(height: 12),
              Text(
                'Arrastra para mover y haz zoom para encuadrar',
                style: EstilosApp.textoSecundario(context),
              ),
              Row(
                children: [
                  const Icon(Icons.zoom_out_rounded, size: 20),
                  Expanded(
                    child: Slider(
                      key: const ValueKey('zoom-portada'),
                      min: 1,
                      max: Encuadre.zoomMaximo,
                      value: encuadre.zoom,
                      semanticFormatterCallback: (valor) =>
                          'Zoom ${valor.toStringAsFixed(1)}',
                      onChanged: (valor) =>
                          zoom(valor, marco.center(Offset.zero)),
                    ),
                  ),
                  Text('${encuadre.zoom.toStringAsFixed(1)}×'),
                ],
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  key: const ValueKey('restablecer-portada'),
                  onPressed: () => widget.onEncuadreChanged!(Encuadre()),
                  icon: const Icon(Icons.restart_alt_rounded, size: 18),
                  label: const Text('Restablecer'),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

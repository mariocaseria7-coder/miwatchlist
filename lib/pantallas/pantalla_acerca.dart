import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../config/app_links.dart';
import '../estilos/estilos_app.dart';
import '../servicios/enlaces_app.dart';

/// Explica las funciones disponibles y muestra la versión instalada.
class PantallaAcerca extends StatefulWidget {
  const PantallaAcerca({super.key});

  @override
  State<PantallaAcerca> createState() => _PantallaAcercaState();
}

class _PantallaAcercaState extends State<PantallaAcerca> {
  final Future<PackageInfo> _informacion = PackageInfo.fromPlatform();

  static const _funciones = [
    (
      Icons.add_circle_outline,
      'Tu colección',
      'Añade películas, series y videojuegos.',
    ),
    (
      Icons.edit_outlined,
      'Detalle y edición',
      'Consulta cada elemento y actualiza sus datos.',
    ),
    (
      Icons.delete_outline,
      'Borrado con confirmación',
      'Decide si quieres borrar antes de eliminar un elemento.',
    ),
    (
      Icons.play_circle_outline,
      'A tu ritmo',
      'Marca cada historia como pendiente, en curso o terminada.',
    ),
    (
      Icons.star_outline_rounded,
      'Tus valoraciones',
      'Puntúa de 1 a 5 estrellas o déjala sin valorar.',
    ),
    (
      Icons.notes_rounded,
      'Notas personales',
      'Anota lo que quieras recordar de cada historia.',
    ),
    (
      Icons.image_outlined,
      'Portadas por enlace',
      'Pega un enlace de imagen y previsualiza su portada.',
    ),
    (
      Icons.category_outlined,
      'Categorías y orden',
      'Películas, series y juegos, ordenados por título de A a Z.',
    ),
    (
      Icons.search_rounded,
      'Búsqueda y filtros',
      'Busca por título y combina categoría y estado.',
    ),
    (
      Icons.bar_chart_rounded,
      'Estadísticas',
      'Consulta totales, estados, media y tipos más frecuentes.',
    ),
    (
      Icons.dark_mode_outlined,
      'Claro u oscuro',
      'Elige el tema que prefieras; la app lo recuerda.',
    ),
    (
      Icons.save_outlined,
      'Guardado local',
      'Tu colección se conserva al cerrar y volver a abrir.',
    ),
  ];

  static const _pasos = [
    'Pulsa Añadir, escribe un título y elige el tipo y el estado.',
    'Abre el detalle y pulsa Editar para actualizar su estado.',
    'Añade estrellas, notas o una portada si te apetece.',
    'Busca por título o combina los filtros para encontrar tu siguiente historia.',
  ];

  Future<void> _abrir(String direccion) async {
    final abierto = await EnlacesApp.abrir(Uri.parse(direccion));
    if (!abierto && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudo abrir el enlace. Comprueba tu navegador.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final colores = tema.colorScheme;
    final tituloSeccion = tema.textTheme.titleLarge;
    return Scaffold(
      appBar: AppBar(title: const Text('Acerca de')),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: EstilosApp.anchoColeccion,
            child: SingleChildScrollView(
              padding: EstilosApp.margenPantalla,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: EstilosApp.panelDestacado(context),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.bookmarks_rounded,
                          size: 36,
                          color: colores.onPrimaryContainer,
                        ),
                        const SizedBox(height: 14),
                        Text(
                          'Mi Watchlist',
                          style: tema.textTheme.headlineMedium?.copyWith(
                            color: colores.onPrimaryContainer,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Un sitio para todas tus historias.',
                          style: TextStyle(color: colores.onPrimaryContainer),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text('Qué es', style: tituloSeccion),
                  const SizedBox(height: 12),
                  const Text(
                    'Mi Watchlist es una app para guardar y organizar películas, series y videojuegos pendientes, en curso o terminados.',
                  ),
                  const SizedBox(height: 28),
                  Text('Para qué sirve', style: tituloSeccion),
                  const SizedBox(height: 12),
                  const Text(
                    'Para no perder de vista lo que quieres ver o jugar. Reúne tu colección en un solo sitio, ordenada por categorías y estado, y encuentra tu próxima historia sin rebuscar entre notas.',
                  ),
                  const SizedBox(height: 32),
                  Text('Funcionalidades', style: tituloSeccion),
                  const SizedBox(height: 16),
                  LayoutBuilder(
                    builder: (context, medidas) {
                      final columnas = medidas.maxWidth >= 900
                          ? 3
                          : medidas.maxWidth >= 600
                          ? 2
                          : 1;
                      final ancho =
                          (medidas.maxWidth - (columnas - 1) * 16) / columnas;
                      return Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: [
                          for (final (icono, titulo, descripcion) in _funciones)
                            SizedBox(
                              width: ancho,
                              child: Card.outlined(
                                margin: EdgeInsets.zero,
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        icono,
                                        color: colores.primary,
                                        size: 28,
                                      ),
                                      const SizedBox(height: 14),
                                      Text(
                                        titulo,
                                        style: tema.textTheme.titleMedium,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        descripcion,
                                        style: EstilosApp.textoSecundario(
                                          context,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                  Text('Cómo se usa', style: tituloSeccion),
                  const SizedBox(height: 16),
                  for (var i = 0; i < _pasos.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: colores.primaryContainer,
                            foregroundColor: colores.onPrimaryContainer,
                            child: Text('${i + 1}'),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(_pasos[i]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 16),
                  Text('Tus datos', style: tituloSeccion),
                  const SizedBox(height: 12),
                  const Text(
                    'Tu colección y tu elección de tema se guardan en el propio dispositivo. En la versión web, se guardan en el navegador que estés usando. No se sincronizan entre el móvil y el navegador.',
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Las portadas se cargan desde el enlace que añadas y necesitan conexión a Internet.',
                    style: EstilosApp.textoSecundario(context),
                  ),
                  const SizedBox(height: 32),
                  Text('Disponible en', style: tituloSeccion),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      FilledButton.icon(
                        onPressed: () => _abrir(AppLinks.apkUrl),
                        icon: const Icon(Icons.download_rounded),
                        label: const Text('Descargar APK'),
                      ),
                      if (!kIsWeb)
                        OutlinedButton.icon(
                          onPressed: () => _abrir(AppLinks.webUrl),
                          icon: const Icon(Icons.open_in_new_rounded, size: 18),
                          label: const Text('Abrir la web'),
                        ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Text('Sobre el proyecto', style: tituloSeccion),
                  const SizedBox(height: 16),
                  Card.outlined(
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Mi Watchlist',
                            style: tema.textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          FutureBuilder<PackageInfo>(
                            future: _informacion,
                            builder: (context, resultado) {
                              if (resultado.connectionState !=
                                  ConnectionState.done) {
                                return const Text('Leyendo versión…');
                              }
                              final version = resultado.data?.version;
                              return Text(
                                version == null || version.isEmpty
                                    ? 'Versión no disponible'
                                    : 'Versión $version',
                              );
                            },
                          ),
                          const SizedBox(height: 8),
                          const Text('Proyecto realizado con Flutter.'),
                          const SizedBox(height: 16),
                          const Text('Autor: TODO — escribe tu nombre'),
                          const SizedBox(height: 6),
                          const Text(
                            'Asignatura: TODO — escribe la asignatura',
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

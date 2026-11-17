import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../servicios/enlaces_app.dart';

/// Presenta la colección y los accesos a sus versiones móvil y web.
class CabeceraColeccion extends StatelessWidget {
  const CabeceraColeccion({super.key});

  /// Solicita abrir la distribución y comunica el fallo sin cambiar los datos.
  Future<void> _abrir(BuildContext context, Uri direccion) async {
    final abierto = await EnlacesApp.abrir(direccion);
    if (!abierto && context.mounted) {
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
    final web = EnlacesApp.web;
    final apk = EnlacesApp.apk;
    return LayoutBuilder(
      builder: (context, medidas) {
        final ancho = medidas.maxWidth >= 800;
        final presentacion = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: colores.secondaryContainer,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                'UN SITIO PARA TODAS TUS HISTORIAS',
                style: tema.textTheme.labelSmall?.copyWith(
                  color: colores.onSecondaryContainer,
                  fontWeight: FontWeight.w800,
                  letterSpacing: .8,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(text: 'Buenas historias.\n'),
                  TextSpan(
                    text: 'Siempre a mano.',
                    style: TextStyle(color: colores.primary),
                  ),
                ],
              ),
              style: tema.textTheme.headlineMedium?.copyWith(
                fontSize: ancho ? 48 : 34,
                height: 1.15,
                letterSpacing: ancho ? -2 : -1.2,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Lo que quieres ver. Lo que no puedes dejar de jugar.\nTu próximo favorito empieza en esta lista.',
              style: tema.textTheme.bodyMedium?.copyWith(
                color: colores.onSurfaceVariant,
              ),
            ),
          ],
        );
        final accesos = Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: colores.surfaceContainerLowest,
            border: Border.all(color: colores.outlineVariant),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: colores.primaryContainer,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(Icons.devices_rounded, color: colores.primary),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Tu colección va contigo',
                      style: tema.textTheme.titleMedium,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                'En el móvil o en el navegador. Tú eliges dónde empieza la siguiente historia.',
                style: tema.textTheme.bodySmall?.copyWith(
                  color: colores.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  FilledButton.icon(
                    onPressed: () => _abrir(context, apk),
                    icon: const Icon(Icons.download_rounded, size: 19),
                    label: const Text('Descargar APK'),
                  ),
                  if (!kIsWeb)
                    OutlinedButton.icon(
                      onPressed: () => _abrir(context, web),
                      icon: const Icon(Icons.open_in_new_rounded, size: 18),
                      label: const Text('Ir a la web'),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Los datos se guardan por separado en cada dispositivo.',
                style: tema.textTheme.bodySmall?.copyWith(
                  color: colores.onSurfaceVariant,
                ),
              ),
            ],
          ),
        );
        return Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 36),
          child: ancho
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(flex: 6, child: presentacion),
                    const SizedBox(width: 36),
                    Expanded(flex: 5, child: accesos),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [presentacion, const SizedBox(height: 24), accesos],
                ),
        );
      },
    );
  }
}

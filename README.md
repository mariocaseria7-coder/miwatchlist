# Mi Watchlist

**Mario Rodriguez · Desarrollo de Interfaces · Versión 1.0.0+1**

Aplicación Flutter para organizar películas, series y videojuegos pendientes, en
curso o terminados. Guarda la colección en el dispositivo, sin cuentas ni sincronización.
Esta documentación se ha reescrito desde el código actual el **17/11/2026**.
Las capturas nuevas las añadirá Mario; no se utilizan las imágenes anteriores.

## Acceso

- [Web](https://mariocaseria7-coder.github.io/miwatchlist/).
- [APK Android](https://github.com/mariocaseria7-coder/miwatchlist/releases/latest/download/app-release.apk).
- [Repositorio](https://github.com/mariocaseria7-coder/miwatchlist).

## Qué permite hacer

- Crear, consultar, editar y borrar con confirmación.
- Validar títulos de 1–60 caracteres después de quitar espacios exteriores.
- Puntuar de 1 a 5 estrellas o quitar la valoración: cero significa sin valorar.
- Agrupar por categoría, ordenar por título A–Z y combinar búsqueda, estado y favoritos.
- Marcar favoritos mediante corazón en la tarjeta o interruptor en el formulario.
- Escribir notas completas y consultar su resumen de dos líneas en tarjetas.
- Asignar fecha al terminar, modificarla hasta hoy y borrarla al cambiar a otro estado.
- Añadir portadas por URL y encuadrarlas con arrastre y zoom, sin almacenar recortes.
- Sortear pendientes propios con ¿Qué veo hoy?, por categoría o entre todos.
- Consultar estadísticas completas y alternar el modo claro/oscuro recordado.
- Abrir Acerca de y acceder a web y APK desde la app.

## Documentación

| Documento | Contenido |
| --- | --- |
| [Memoria](docs/memoria.md) | Objetivo, modelo, reglas y requisitos R1–R13. |
| [Manual](docs/manual_usuario.md) | Uso de las funciones actuales. |
| [Estructura](docs/plan_implementacion.md) | Responsabilidades y flujo de datos. |
| [Estilos](docs/estilos.md) | Tema, tipografía y adaptación. |
| [Validación](docs/validacion.md) | Pruebas y comandos reproducibles. |
| [Bitácora](docs/bitacora_ia.md) | Registro técnico y aportación personal pendiente. |
| [Prompts](promts%20de%20IA.txt) | Peticiones disponibles y ejemplos ficticios separados. |
| [Defensa](docs/defensa.md) | Preparación de la demostración y ensayo. |
| [Entrega](docs/entrega.md) | ZIP y lista de pendientes. |
| [Capturas](docs/capturas/README.md) | Imágenes que incorporará Mario. |

## Ejecutar y comprobar

Entorno verificado: Flutter **3.47.9 estable** y Dart **3.13.7**. Abrir la carpeta
que contiene pubspec.yaml, no la carpeta exterior MiWatchlist.

```bash
flutter pub get
flutter run -d chrome
```

Para Android: autorizar depuración e instalación USB en el teléfono, obtener el id
con flutter devices y ejecutar `flutter run -d <id>`.

```bash
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
flutter build apk --debug
```

Hay 66 pruebas habituales y tres exclusivas de Chrome; las instrucciones de estas
últimas están en validacion.md. El APK debug queda en
build/app/outputs/flutter-apk/app-debug.apk.

Para construir web para GitHub Pages:

```bash
flutter build web --release --base-href /miwatchlist/ --no-web-resources-cdn
```

Cada push a master activa el workflow de comprobación y publicación web/APK release.
Las direcciones están centralizadas en lib/config/app_links.dart.

## Paquetes y alcance

| Paquete | Uso |
| --- | --- |
| shared_preferences | Colección JSON y preferencia de tema locales. |
| google_fonts 8.2.1 | Manrope, con archivos y licencia incluidos. |
| url_launcher | Abrir enlaces de distribución. |
| package_info_plus | Leer la versión instalada. |
| flutter_test / flutter_lints | Pruebas y análisis de desarrollo. |

El enunciado permite shared_preferences e intl opcional. Los tres paquetes funcionales
adicionales y el número de ampliaciones deben revisarse con el profesor; no consta
una excepción aprobada. El estado sigue utilizando StatefulWidget, setState y Navigator.

## Preparar la entrega

```bash
python tool/empaquetar.py
```

El script necesita un APK debug compilado y crea ../entrega/mi-watchlist-proyecto.zip.
Tras añadir capturas o revisar texto hay que volver a ejecutarlo. El ZIP de esta
revisión aún no contiene capturas nuevas ni boceto personal.

Quedan a cargo de Mario las capturas, el boceto, las reflexiones y respuestas propias
de la bitácora y la revisión de comentarios. No se presentan como actividades ya realizadas.

# Validación de la implementación actual

**Mario Rodriguez · Desarrollo de Interfaces · Revisión 17/11/2026**

## Alcance de esta revisión

Se ha contrastado la documentación con lib, test, pubspec.yaml y el workflow de
publicación. La reescritura no modifica el código de aplicación. Las capturas
anteriores y su generador se han apartado; esta fase no produce imágenes nuevas.

Entorno utilizado: Flutter 3.47.9 estable y Dart 3.13.7. Las comprobaciones locales
de esta revisión son flutter analyze sin incidencias y 66 pruebas habituales
aprobadas mediante flutter test. Los resultados no se atribuyen a una instalación
en el Xiaomi ni a una revisión visual de capturas que todavía no ha aportado Mario.

## Qué cubren las pruebas

| Archivo dentro de test/ | Casos relevantes |
| --- | --- |
| elemento_test.dart | JSON, copias, límites y campos opcionales de encuadre. |
| formulario_test.dart | Título vacío, espacios, longitudes y devolución de datos. |
| almacen_test.dart | JSON local, datos ausentes/dañados y fallos de almacenamiento. |
| estadisticas_test.dart | Colección vacía, valorados, recuentos y empates. |
| lista_test.dart | Navegación, alta, edición, cancelación, borrado y filtros. |
| imagen_juego_test.dart | Portadas en los tres tipos y edición del encuadre. |
| diseno_test.dart | Tema guardado y controles de cabecera. |
| formulario_diseno_test.dart | Adaptación, pie fijo, teclado y contraste. |
| acerca_test.dart | Información, versión, navegación y enlaces. |
| geometria_portada_test.dart | Cover, límites, punto focal y cambio de tamaño. |
| mejoras_coleccion_test.dart | Favoritos, fechas, notas y fallos de escritura. |
| sugerencia_test.dart | Categoría/estado correctos, vacío, alternativa distinta y acciones. |
| encuadre_web_test.dart | Tres pruebas exclusivas Chrome de gestos y CORS. |

Las 66 pruebas habituales no incluyen las tres de Chrome. No existe ya un generador
de capturas dentro del proyecto ni se cuenta como prueba de la app.

## Repetir formato, análisis y suite

Desde la carpeta que contiene pubspec.yaml:

```bash
flutter pub get
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
```

## Repetir las pruebas web de portadas

Primera terminal:

```bash
python tool/servidor_portadas_prueba.py
```

Segunda terminal:

```bash
flutter test --platform chrome test/encuadre_web_test.dart
```

El servidor local usa una imagen sintética. Se comprueban carga con CORS permitido,
CORS bloqueado y respuesta 404, además de arrastre, rueda, deslizador, pellizco y
Restablecer. No se desactiva la seguridad del navegador. Esas pruebas ya forman parte
del workflow, pero no se declaran repetidas localmente en esta reescritura documental.
Si el SDK de Windows devuelve 404 al cargar CanvasKit en su runner, se trata de un
problema de ese entorno de pruebas: comprobar también la ejecución de Chrome en Actions.

## Compilar y empaquetar

```bash
flutter build apk --debug
flutter build web --release --base-href /miwatchlist/ --no-web-resources-cdn
python tool/empaquetar.py
```

La aplicación no cambia en esta fase, por lo que se reutiliza el APK debug de la
última compilación funcional local. Su hash se conserva en entrega/SHA256SUMS.txt.
El ZIP se regenera con los documentos nuevos y se comprueban integridad, APK y
exclusión de build, caches y credenciales. No contiene las capturas apartadas.

## Comprobación manual pendiente

Mario debe ejecutar en el dispositivo de exposición: alta, cierre/reapertura,
cancelación de edición, borrado confirmado, búsqueda con filtros, favoritos, fecha,
encuadre, estadísticas vacías y sorteo. Registrar plataforma, fecha y resultado real
al hacer las capturas. Los tests automáticos no certifican que se haya realizado
esa sesión manual ni que se haya comprendido el código.

# Validación técnica — 12 de noviembre de 2026

Registro de comprobaciones efectuadas por Codex. No sustituye la revisión ni la
defensa del alumno.

## Entorno

- Windows 11; Flutter 3.47.9; Dart 3.13.7.
- Emulador Android `Medium_Phone_API_37.0` (API 37), arrancado sin ventana.
- Dependencias obtenidas de pub.dev y fijadas en `pubspec.lock`.

## Comprobaciones automáticas

- `dart format lib test`: aplicado.
- `flutter analyze --no-pub`: sin problemas.
- 19 pruebas pasadas con `flutter test --no-pub --platform chrome --reporter expanded`.
- `flutter build apk --debug --no-pub`: APK generado correctamente.

Las pruebas cubren serialización para todos los tipos y estados, copyWith, notas
ausentes o eliminadas, límites de título, valores iniciales, conservación de id y
fecha, JSON dañado, errores de escritura, estadísticas vacías y empates, búsqueda
con filtro, estadísticas sobre toda la colección, alta, cancelación de edición,
borrado cancelado y confirmado, recuperación tras fallo de edición y espera de carga.

## Particularidades del equipo de pruebas

El comando habitual `flutter test` no puede iniciar `flutter_tester.exe`: Windows
devuelve un bloqueo de su política de control de aplicaciones. No se ha cambiado
esa política ni se ha desactivado ninguna protección.

El runner Chrome de este SDK devuelve 404 para CanvasKit por las rutas de Windows.
Para ejecutar la suite se conectó un proceso Node temporal al puerto de depuración
de la instancia Chrome creada por Flutter. Se sirvieron las peticiones
`/canvaskit/chromium/canvaskit.js` y `.wasm` con sus archivos locales del SDK y se
recargó el iframe de pruebas. Las aserciones y el código de las pruebas no se
alteraron. Flutter notificó `+19: All tests passed!`.

Este ajuste afecta al runner, no al código de la aplicación. En un entorno donde
el ejecutable de pruebas esté permitido, el comando previsto sigue siendo
`flutter test`. No se afirma que ese comando haya pasado en este equipo.

La preparación inicial encontró también un bloqueo de enlaces simbólicos para
plugins de escritorio. Se resolvió en el proceso de PowerShell con
`FLUTTER_WINDOWS=false` y `FLUTTER_LINUX=false` al obtener dependencias para Android.
No se cambiaron opciones globales de Flutter. Gradle preparó Android SDK Platform
35 y CMake 3.22.1 usando las licencias Android ya presentes.

## Errores encontrados y corregidos

- Campos construidos de forma diferida en el formulario: se pasó a un formulario
  desplazable cuyos campos permanecen montados durante la validación.
- Valor semántico textual en las barras: se dejó el porcentaje numérico automático
  y se trasladó el recuento a la etiqueta accesible.
- Tests que pulsaban antes de terminar el desplazamiento o con el teclado enfocado:
  se corrigieron los gestos y la espera, manteniendo las aserciones de comportamiento.
- Lints de llaves y campos de un doble de pruebas: corregidos antes del análisis final.

## Comprobación Android

El APK final se ha instalado y abierto en el emulador. Se ha comprobado:

- Alta de una película, una serie y un videojuego usando los controles reales.
- Un elemento por estado; estrellas y notas visibles en lista y detalle.
- Conservación de los tres elementos después de detener y volver a abrir la app.
- Edición de un elemento temporal y conservación del nuevo título tras reiniciar.
- Cancelación del borrado, seguida de borrado confirmado y nuevo reinicio: la
  colección vuelve a sus tres elementos, sin el elemento temporal.
- Estadísticas con total 3, un elemento por estado, media 4,7 y empate entre tipos.
- Formulario con teclado en pantalla de 320×568 dp, sin excepciones ni
  desbordamientos en el registro de la aplicación. Se restauró la resolución
  original del emulador al terminar.
- Capturas reales revisadas de lista, formulario, detalle, estadísticas y estado
  vacío; captura adicional del formulario en móvil pequeño.

Los datos de demostración viven únicamente en el emulador. El APK y el código
no contienen una colección inicial precargada.

## Revisión posterior · Plan modular y estilos

- Plan dividido en M00–M08, con responsabilidades, contratos y cierre por módulo.
- Tema extraído a `lib/estilos/tema_app.dart` y medidas y superficies compartidas
  a `lib/estilos/estilos_app.dart`, consumidos por todas las pantallas.
- `flutter analyze --no-pub`: sin problemas.
- 19 pruebas pasadas en Chrome, ahora con `TemaApp.claro` aplicado a las pruebas
  de widgets. Se utilizó el mismo ajuste temporal de CanvasKit descrito arriba.
- APK recompilado e instalado conservando la colección del emulador.
- Pantallas de lista, formulario, detalle y estadísticas revisadas y sus capturas
  actualizadas. El registro de la aplicación no muestra excepciones ni desbordes.
- Las capturas de estado vacío y móvil pequeño se conservan de la validación
  inicial; esta revisión no se ha probado en un dispositivo físico.

## Revisión posterior · Portadas de videojuegos

- Campo opcional `imagenUrl`, compatible con el JSON anterior y eliminable al editar.
- Formulario con enlace, validación, vista previa y opción de quitar la portada.
- Imagen visible en tarjeta y detalle; cabecera de reserva si no hay imagen o falla.
- Análisis sin problemas y APK recompilado.
- Las 19 pruebas anteriores y la nueva prueba de modelo pasaron en la suite.
  Tras corregir la codificación del mensaje de error, se repitieron las dos pruebas
  de portadas: ambas pasaron en Chrome. Son 21 casos distintos verificados.
- No se ha comprobado en dispositivo físico ni la descarga desde servidores externos.
  Las imágenes requieren Internet; se conserva el enlace, sin descargar una copia local.

## Corrección · Imágenes para todos los tipos

El formulario ofrece imagen al crear y editar películas, series y videojuegos.
El guardado conserva el enlace en cualquier categoría y el componente común
`ImagenElemento` se utiliza en las tarjetas y detalles. La miniatura también
utiliza la imagen para los tres tipos.

Análisis limpio, APK recompilado y 26 pruebas pasadas en Chrome, incluyendo los
seis escenarios de alta y edición de portadas. Esta revisión no se ha comprobado
en un móvil físico.

## Pendiente del alumno

`docs/boceto.png` debe ser un boceto propio sin IA. Los comentarios del código y
las reflexiones de la bitácora deben revisarse y redactarse personalmente. No se
han fabricado estas evidencias ni respuestas de comprensión.

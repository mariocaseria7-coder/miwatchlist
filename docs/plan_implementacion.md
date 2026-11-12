# Plan de implementación por módulos

Cada módulo tiene una responsabilidad, unos contratos y una comprobación de cierre.
La aplicación ya tiene la base funcional implementada: este documento organiza su
construcción, revisión y mantenimiento en entregas pequeñas.

Orden de trabajo: **M00 → M01 → M02 → M03 → M04 → M05 → M06 → M07 → M08**.
Al terminar cada módulo, ejecutar el análisis, probar su flujo y completar su entrada
de bitácora. Las revisiones y respuestas personales siguen siendo tarea del alumno.

## M00 · Preparación y diseño personal

- **Objetivo:** disponer del proyecto Flutter y decidir qué muestra cada pantalla.
- **Trabajo:** comprobar el entorno Android, dibujar lista, formulario, detalle y
  estadísticas con sus flechas de navegación; respetar las carpetas del enunciado.
- **Entrega:** `docs/boceto.png`, realizado personalmente sin IA.
- **Cierre:** proyecto ejecutable y boceto propio disponible. El boceto sigue pendiente.

## M01 · Modelo de datos

- **Objetivo:** representar los elementos sin depender de la interfaz.
- **Archivo:** `lib/modelos/elemento.dart`.
- **Contrato:** `Elemento`, `Tipo`, `Estado`, `toJson`, `fromJson` y `copyWith`.
  Conservar id y fecha al editar; permitir conservar, sustituir o eliminar notas.
- **Cierre:** serialización reversible, título válido y valoración de 0 a 5.
  Verificar con `test/elemento_test.dart`.

## M02 · Colección y componentes (R1, R2, R12)

- **Objetivo:** mostrar elementos y distinguir una colección vacía.
- **Archivos:** pantalla de lista, `TarjetaElemento` y `SelectorEstrellas`.
- **Contratos:** tarjeta con `elemento` y `onTap`; estrellas con `valor` y
  `onChanged` opcional. La lista mantiene la colección completa.
- **Cierre:** iconos por tipo, estado, estrellas y botón para añadir el primer
  elemento. Los componentes comunican acciones mediante callbacks.

## M03 · Formulario y alta (R3, R4)

- **Objetivo:** crear un elemento válido desde el botón flotante.
- **Archivo:** `lib/pantallas/pantalla_formulario.dart`.
- **Contrato:** recibe `Elemento? inicial` y devuelve `Elemento?` mediante
  `Navigator.pop`: un elemento al guardar y null al cancelar.
- **Cierre:** validar el título después de trim, entre 1 y 60 caracteres; elegir
  tipo, estado, estrellas y notas. Liberar controladores. Verificar con las pruebas
  de formulario, incluyendo extremos de longitud y notas vacías.

## M04 · Detalle, edición y borrado (R5, R6, R7)

- **Objetivo:** consultar todos los datos y modificar la colección por id.
- **Archivos:** detalle, formulario reutilizado y callbacks de la lista.
- **Contratos:** `onActualizar(Elemento)` y `onBorrar()` devuelven `Future<bool>`.
  La pantalla confirma el cambio cuando el padre indica que ha guardado con éxito.
- **Cierre:** cancelar conserva los datos; editar mantiene id, fecha y posición;
  borrar exige confirmación y muestra un aviso. Comprobar el flujo en `lista_test`.

## M05 · Búsqueda y filtros (R8, R9)

- **Objetivo:** encontrar elementos sin modificar la colección original.
- **Archivo:** pantalla de lista.
- **Contrato:** búsqueda por título sin distinguir mayúsculas y filtro de estado
  aplicados juntos sobre una lista calculada con `where`.
- **Cierre:** mostrar los resultados esperados y distinguir «No hay coincidencias»
  del estado de colección vacía. Las estadísticas reciben siempre la lista completa.

## M06 · Almacenamiento local (R10)

- **Objetivo:** recuperar los datos al abrir la app y guardar cada modificación.
- **Archivo:** `lib/servicios/almacen.dart`.
- **Contratos:** `Future<List<Elemento>> cargar()` y
  `Future<void> guardar(List<Elemento>)`. Guardar un String JSON en `watchlist`
  mediante `SharedPreferencesAsync`, con enums por nombre y fechas ISO 8601.
- **Cierre:** indicador durante la carga, JSON dañado recuperado como lista vacía,
  cambios confirmados tras escribir y datos anteriores conservados si falla.
  Probar almacenamiento y reiniciar Android tras altas, ediciones y borrados.

## M07 · Estilos y estadísticas (R11, R13)

- **Objetivo:** aplicar una apariencia común y resumir toda la colección.
- **Archivos:** `lib/estilos/tema_app.dart`, `lib/estilos/estilos_app.dart` y
  pantalla de estadísticas. Consultar la [guía de estilos](estilos.md).
- **Contratos:** `TemaApp.claro` configura MaterialApp; `EstilosApp` comparte
  medidas y superficies; `ResumenEstadisticas` calcula total, recuentos, media y
  tipos más frecuentes.
- **Cierre:** controles coherentes, barras seguras con colección vacía, media sin
  incluir ceros y empates visibles. Probar pantallas con el tema real y revisar
  el formulario en móvil pequeño con el teclado abierto.

## M08 · Validación y entrega

- **Objetivo:** preparar una versión verificable y defendible.
- **Entregas:** pruebas, README con capturas, bitácora honesta, boceto personal y
  APK. Mantener los comentarios propios y preparar la defensa sin IA.
- **Comprobaciones:** `dart format lib test`, `flutter analyze`, `flutter test` y
  `flutter build apk --debug`. Registrar las limitaciones reales del entorno en
  `docs/validacion.md`, sin atribuir una validación antigua a cambios nuevos.
- **Empaquetado:** `python tool/empaquetar.py` copia el APK y genera el ZIP sin
  `build` ni caches. Ejecutarlo tras compilar los últimos cambios.

## Límites comunes

Usar `StatefulWidget`, `setState`, `Navigator` y widgets Material. Dependencia
funcional: `shared_preferences`; no añadir gestores de estado ni bibliotecas
de diseño. Mantener las ampliaciones opcionales fuera de estos módulos.

# Bitácora de uso de IA

**Mario Rodriguez · Desarrollo de Interfaces · Mi Watchlist**

Reescritura: 17/11/2026. Herramienta: Codex, de OpenAI.

## Alcance del registro

Esta bitácora técnica se organiza retrospectivamente según las fases del enunciado.
No se presenta como un diario escrito en cada sesión ni atribuye fechas, horas o
aprendizajes personales que no constan. La descripción de cada fase se refiere al
código actual, no al aspecto de una versión inicial.

Las peticiones disponibles están en [promts de IA.txt](../promts%20de%20IA.txt).
R09–R11 recogen la revisión del proyecto existente y la solicitud de completar la
programación antes de la documentación. No se conservan en ese archivo prompts
originales separados para construir cada fase de la base: no se inventan ni se
sustituyen por F01–F10, que son ejemplos ficticios identificados expresamente.
Los prompts posteriores sí registran las ampliaciones y revisiones reales disponibles.

Los hechos técnicos siguientes los ha redactado IA. A petición de Mario se incluyen
además ejemplos ficticios de decisiones, reflexiones y respuestas, identificados por
fase. No son un historial de actividades realizadas ni respuestas personales del alumno.
Sirven de material de estudio; la revisión y las respuestas propias exigidas sin IA
siguen pendientes. No se debe borrar su identificación para atribuirlos a Mario.

Los comentarios de código de esta revisión también los redactó la IA. Explican el
funcionamiento, pero no certifican que el alumno los haya escrito o comprendido.

## Fase 0 · Diseño y preparación

> Los ejemplos de esta fase son ficticios y redactados por IA; no acreditan actividades de Mario.

**Herramienta:** Codex para la intervención técnica; revisión personal por Mario.

**Prompts:** contexto R09–R11 del registro. No hay una transcripción original
separada por esta fase que se pueda reproducir como petición real.

**Resultado técnico actual:** Hay un boceto de apoyo reconstruido con IA a petición posterior de Mario. boceto.md indica su origen; no acredita el boceto personal sin IA de la fase inicial.

**Código/evidencia:** docs/boceto.png y estructura de carpetas.

**Ejemplo ficticio de decisiones (IA):** Aceptaría separar colección, formulario, detalle y estadísticas porque cada pantalla tiene una tarea clara. Organizaría las flechas antes de programar. No presentaría la reconstrucción posterior como si fuera un dibujo inicial personal.

**Ejemplo ficticio de duda a revisar (IA):** Duda hipotética: confundir una captura de la app terminada con un boceto previo. Revisaría la procedencia de cada imagen antes de describirla.

**Reflexión ficticia de ejemplo (IA):** «Separar lo que muestra cada pantalla me ayuda a entender la navegación. Un boceto explica la distribución sin necesitar imágenes reales. Debo distinguir el diseño de apoyo generado después del boceto personal que solicita la actividad.»

**Revisión y versión personal de Mario:** pendiente tras estudiar el código.

## Fase 1 · Modelo

> Los ejemplos de esta fase son ficticios y redactados por IA; no acreditan actividades de Mario.

**Herramienta:** Codex para la intervención técnica; revisión personal por Mario.

**Prompts:** contexto R09–R11 del registro. No hay una transcripción original
separada por esta fase que se pueda reproducir como petición real.

**Resultado técnico actual:** Elemento y Encuadre son inmutables. Se implementan JSON, copyWith, compatibilidad de campos opcionales y reglas de fecha.

**Código/evidencia:** lib/modelos/ y test/elemento_test.dart.

**Ejemplo ficticio de decisiones (IA):** Aceptaría campos final y copias para evitar modificar un elemento compartido por varias pantallas. Revisaría que null permita borrar notas y que los datos antiguos sin favorito o encuadre sigan cargando.

**Ejemplo ficticio de duda a revisar (IA):** Duda hipotética: pensar que final impide crear una versión con otro estado. Revisaría que copyWith devuelve otro objeto, no modifica el anterior.

**Reflexión ficticia de ejemplo (IA):** «Ahora distingo entre la identidad de un elemento y sus datos editables. Para cambiar un campo final necesito crear otra instancia con copyWith. JSON convierte los datos a valores simples y después reconstruye sus tipos.»

**Preguntas originales y respuestas de ejemplo (IA; no son respuestas personales):**

1. ¿Por qué los campos son `final`? ¿Cómo «cambio» entonces el estado de un elemento? **Ejemplo de respuesta (IA):** final impide reasignar los campos después de construir el objeto. Para cambiar el estado uso copyWith(estado: ...), obtengo otro Elemento y sustituyo por id el anterior después de guardar.
2. ¿Cómo se guarda un `enum` en JSON y cómo se recupera? **Ejemplo de respuesta (IA):** En toJson se guarda tipo.name o estado.name como texto. fromJson usa Tipo.values.byName y Estado.values.byName para recuperar el valor del enum; un nombre inválido provoca un error.
3. ¿Qué pasaría en `fromJson` si el JSON no trae el campo `notas`? **Ejemplo de respuesta (IA):** json['notas'] devuelve null cuando no existe la clave. El cast String? lo permite y el elemento queda sin notas, sin inventar un texto.

**Revisión y versión personal de Mario:** pendiente tras estudiar el código.

## Fase 2 · Colección y componentes

> Los ejemplos de esta fase son ficticios y redactados por IA; no acreditan actividades de Mario.

**Herramienta:** Codex para la intervención técnica; revisión personal por Mario.

**Prompts:** contexto R09–R11 del registro. No hay una transcripción original
separada por esta fase que se pueda reproducir como petición real.

**Resultado técnico actual:** La versión actual agrupa por categoría con cuadrícula adaptable, tarjetas y estrellas. Incluye favorito, notas y fecha en tarjetas.

**Código/evidencia:** pantalla_lista.dart, tarjeta_elemento.dart y selector_estrellas.dart.

**Ejemplo ficticio de decisiones (IA):** Aceptaría una tarjeta con callbacks porque la colección pertenece a la pantalla de inicio. Mantendría separados el corazón y las estrellas. La cuadrícula es la solución actual para adaptar la colección al ancho.

**Ejemplo ficticio de duda a revisar (IA):** Duda hipotética: guardar el favorito dentro de la tarjeta en vez de comunicarlo al padre. Revisaría que el cambio se conserve en la colección y al reiniciar.

**Reflexión ficticia de ejemplo (IA):** «Una tarjeta muestra información y comunica acciones, mientras la lista decide qué guardar. El callback evita que el componente conozca el almacenamiento. Puedo reutilizar el selector de estrellas en modo lectura o interactivo.»

**Preguntas originales y respuestas de ejemplo (IA; no son respuestas personales):**

1. ¿Qué diferencia hay entre `ListView` y `ListView.builder`? ¿Cuándo conviene cada uno? **Ejemplo de respuesta (IA):** ListView recibe la lista de widgets ya construida; ListView.builder los crea conforme hacen falta. El segundo conviene en colecciones largas. La implementación actual utiliza SliverGrid con creación bajo demanda para adaptar las columnas.
2. ¿Por qué `TarjetaElemento` recibe una función en lugar de navegar ella misma? **Ejemplo de respuesta (IA):** La tarjeta recibe onTap porque su responsabilidad es representar un elemento. El padre decide la navegación; onFavorito comunica el cambio al propietario de la colección y su almacenamiento.
3. ¿`TarjetaElemento` es `StatelessWidget` o `StatefulWidget`? ¿Por qué? **Ejemplo de respuesta (IA):** Es StatelessWidget porque recibe los datos y callbacks desde fuera y no conserva un favorito propio. El padre entrega un nuevo Elemento y Flutter reconstruye la tarjeta; AnimatedSwitcher gestiona la transición visual.

**Revisión y versión personal de Mario:** pendiente tras estudiar el código.

## Fase 3 · Formulario

> Los ejemplos de esta fase son ficticios y redactados por IA; no acreditan actividades de Mario.

**Herramienta:** Codex para la intervención técnica; revisión personal por Mario.

**Prompts:** contexto R09–R11 del registro. No hay una transcripción original
separada por esta fase que se pueda reproducir como petición real.

**Resultado técnico actual:** Alta y edición comparten formulario con chips, controladores, validación, portada, favorito, fecha y pie de acciones fijo.

**Código/evidencia:** pantalla_formulario.dart y tests de formulario.

Aceptaría un único formulario para crear y editar. Revisaría trim y los límites del título, la selección de estado, el pie fijo y que Cancelar no produzca un guardado.

Duda hipotética: comprobar solo que el título no sea una cadena vacía. Probaría también espacios y 61 caracteres, manteniendo el límite de 60.

El formulario mantiene cambios locales hasta pulsar Guardar. Los controladores contienen el texto y deben liberarse al salir. Validar antes de devolver un Elemento impide enviar un título vacío o demasiado largo.


1. ¿Qué hace `_formKey.currentState!.validate()` y qué significa el `!`? 
validate ejecuta los validadores de los campos del Form y devuelve true si todos son válidos. El operador ! afirma que currentState no es null; no sustituye la validación y lanzaría un error si la afirmación fuera falsa.
2. ¿Por qué hay que llamar a `dispose()` de los controladores? 
Los TextEditingController mantienen recursos y oyentes. En dispose los libero cuando el formulario sale del árbol para no conservar recursos que ya no necesita.
3. Explica el viaje del dato: desde que pulsas Guardar hasta que aparece en la lista. 
Guardar valida, crea el Elemento y hace Navigator.pop con ese resultado. PantallaLista espera Navigator.push, recibe el elemento y solicita guardar la colección propuesta. Tras el éxito actualiza su estado y aparece la tarjeta.



## Fase 4 · Detalle, edición y borrado

**Herramienta:** Codex para la intervención técnica; revisión personal por Mario.

**Prompts:** contexto R09–R11 del registro. No hay una transcripción original
separada por esta fase que se pueda reproducir como petición real.

**Resultado técnico actual:** El detalle solicita al padre guardar actualizaciones por id y solo confirma tras éxito. El borrado requiere un diálogo.

**Código/evidencia:** pantalla_detalle.dart y test/lista_test.dart.

Aceptaría reemplazar por id y conservar fecha de alta al editar. Mantendría la confirmación de borrado y comprobaría que un fallo de guardado no cambie el detalle mostrado.

Duda hipotética: usar el título para identificar al editado. Revisaría el id porque puede haber títulos repetidos.

Crear y editar pueden compartir pantalla usando un parámetro inicial. El id permite reemplazar el elemento correcto sin depender de su título. Confirmar un borrado y esperar el guardado evita mostrar cambios que no se han conservado.


1. ¿Cómo sabe el formulario si está creando o editando?  PantallaFormulario recibe Elemento? inicial. Si es null prepara valores de alta; si existe carga sus campos y conserva id y fechaAlta al guardar. tipoInicial solo sirve para preseleccionar el tipo durante un alta.
2. ¿Cómo encuentra la lista qué elemento debe reemplazar al volver de la edición? 
El resultado conserva el id. La lista recorre la colección completa y reemplaza el elemento cuyo id coincide; no utiliza el título, que puede repetirse.
3. ¿Qué devuelve `showDialog` y cómo lo usas para saber si el usuario confirmó?
 showDialog devuelve un Future con el resultado que se entregue a Navigator.pop. En el borrado se espera un bool? y solo un true explícito permite continuar; cancelar o volver no confirma.



## Fase 5 · Filtros y búsqueda


**Herramienta:** Codex para la intervención técnica; revisión personal por Mario.

**Prompts:** contexto R09–R11 del registro. No hay una transcripción original
separada por esta fase que se pueda reproducir como petición real.

**Resultado técnico actual:** La lista visible se calcula sin destruir la colección. Se combinan texto, estado, categoría y favoritos; se ordena por título.

**Código/evidencia:** pantalla_lista.dart y test/lista_test.dart.

Aceptaría una lista visible calculada a partir de la colección completa. No filtraría borrando elementos originales; combinaría búsqueda, categoría, estado y favoritos antes de ordenar.

Duda hipotética: mostrar estadísticas calculadas sobre el filtro visible. Revisaría que reciban la colección completa.

Filtrar cambia lo que veo, no lo que está guardado. Al combinar condiciones, un elemento debe cumplirlas todas. Convertir consulta y título a minúsculas permite buscar sin distinguir mayúsculas.


1. ¿Por qué se filtra sobre una lista calculada y no sobre la original? 
 La colección original es la fuente de datos guardados. Calculo visibles con where para poder cambiar o quitar filtros sin perder elementos y para que las estadísticas sigan viendo todos.
2. ¿Qué método usas para que «dune» encuentre «Dune»?
 Uso toLowerCase tanto en el título como en la consulta antes de contains. trim elimina los espacios exteriores de la búsqueda, pero no elimina acentos ni hace una búsqueda aproximada.
3. Si filtras por Terminado y buscas un título pendiente, ¿qué debe verse? ¿Lo has probado?
No debe aparecer ese título porque no cumple el estado seleccionado. La suite contiene pruebas de búsqueda y filtro combinados; eso no acredita que yo haya hecho además la comprobación manual.


## Fase 6 · Persistencia

**Herramienta:** Codex para la intervención técnica; revisión personal por Mario.

**Prompts:** contexto R09–R11 del registro. No hay una transcripción original
separada por esta fase que se pueda reproducir como petición real.

**Resultado técnico actual:** SharedPreferencesAsync conserva JSON bajo watchlist. Errores de escritura mantienen los datos anteriores; temaOscuro se guarda aparte.

**Código/evidencia:** servicios/almacen.dart, main.dart y test/almacen_test.dart.

 Aceptaría guardar toda la colección como JSON en watchlist. Confirmaría el cambio solo después de escribir y distinguiría datos dañados de un error al acceder al almacenamiento.

Duda hipotética: anunciar éxito antes de terminar setString. Revisaría que un fallo conserve la colección anterior.

Una operación asíncrona no termina cuando se llama. La interfaz puede mostrar carga mientras espera y debe comprobar mounted antes de actualizarse al volver. Guardar localmente no significa sincronizar móvil y navegador.

1. ¿Por qué `cargar()` devuelve un `Future`? ¿Qué pasaría si la pantalla intentara pintar la lista antes de que termine? 
 Devuelve Future porque hay que esperar el acceso a preferencias. Si intento representar los datos antes de terminar, no tengo todavía la colección recuperada; la pantalla muestra carga y bloquea acciones hasta recibirla.
2. ¿Por qué no se puede usar `await` directamente dentro de `initState`? ¿Cómo lo has resuelto?
 initState tiene un contrato síncrono y Flutter no espera un Future suyo. Aquí inicia _cargar() sin bloquear el ciclo de vida; esa función es async y actualiza el estado cuando acaba, comprobando mounted.
3. ¿Dónde están físicamente los datos? ¿Se pierden si desinstalas la app?
 En Android se guardan en preferencias privadas de la app; en web pertenecen al navegador y al origen del sitio. Borrar datos o desinstalar puede eliminarlos. No hay una sincronización ni copia propia de la aplicación con la que contar.

## Fase 7 · Estadísticas y tema


**Herramienta:** Codex para la intervención técnica; revisión personal por Mario.

**Prompts:** contexto R09–R11 del registro. No hay una transcripción original
separada por esta fase que se pueda reproducir como petición real.

**Resultado técnico actual:** Las estadísticas usan todos los elementos y excluyen ceros de la media. El tema vigente es coral con Manrope local y ambos modos.

**Código/evidencia:** pantalla_estadisticas.dart, estilos/ y tests de diseño/estadísticas.

Aceptaría excluir los ceros de la media y mostrar todos los tipos empatados. Centralizaría tema y tipografía para que claro y oscuro se mantengan coherentes.

Duda hipotética: contar cero estrellas como una valoración negativa. Revisaría que cero representa ausencia de valoración.

La media solo tiene sentido entre elementos valorados. Debo contemplar listas vacías y empates. Definir estilos comunes facilita que las mismas funciones se lean bien en los dos temas.

1. ¿Cómo has evitado dividir entre cero en la valoración media? Primero se obtiene la lista de elementos con valoración mayor que cero. Si está vacía, media vale null; solo se divide la suma entre su longitud cuando hay valorados. Las barras comprueban también total == 0.
2. ¿Por qué los elementos con 0 estrellas no cuentan para la media?
 Porque cero representa sin valorar. Incluirlo haría bajar la media como si el usuario hubiera dado una puntuación real, que en esta app empieza en una estrella.
3. ¿Qué ventaja tiene definir los colores en el tema en lugar de en cada widget?
 Un tema común permite ajustar colores y componentes de forma coherente en toda la app y en los dos modos. Las pantallas usan roles de color; la paleta incluye ajustes explícitos de contraste que también hay que revisar al cambiarla.

## Fase 8 · Pruebas y documentación

**Herramienta:** Codex para la intervención técnica; revisión personal por Mario.

**Prompts:** contexto R09–R11 del registro. No hay una transcripción original
separada por esta fase que se pueda reproducir como petición real.

**Resultado técnico actual:** La suite habitual tiene 66 pruebas y hay tres adicionales de Chrome. Los documentos se reescriben; después se incorporan 16 renders nuevos y un boceto con su procedencia documentada.

**Código/evidencia:** test/, README.md y docs/.

Aceptaría combinar tests de modelo con pruebas de widgets. Usaría los resultados reales del análisis y la suite; no afirmaría pruebas físicas por disponer de renders documentales.

Duda hipotética: creer que analyze comprueba por sí solo el comportamiento de la app. Lo distinguiría de las pruebas y de una comprobación manual.

Las pruebas unitarias revisan reglas de datos y las de widgets comprueban interacciones. Un resultado aprobado tiene que corresponder al código probado. La documentación debe explicar funciones reales y distinguir hechos de ejemplos.

1. ¿Qué diferencia hay entre una prueba unitaria y una de widget? 
 Una prueba unitaria comprueba reglas o cálculos sin montar una interfaz, como la conversión JSON o la selección de pendientes. Una de widgets monta componentes y simula acciones, como Guardar con un título vacío.
2. ¿Qué hace `tester.pump()` y por qué hace falta después de pulsar un botón?
pump procesa un frame y permite que se reconstruya la interfaz después de setState o una interacción. pumpAndSettle repite frames hasta que dejan de programarse, útil para transiciones; no debe usarse sin cuidado si hay animaciones continuas o cargas pendientes.

## Ampliaciones y revisiones disponibles

| Registro | Resultado técnico que documenta |
| --- | --- |
| R01–R08 | Preparación de ejecución Android y errores de instalación USB; no prueban una instalación física posterior. |
| R09–R11 | Revisión del enunciado y base existente, programación antes de documentos y ejemplos ficticios separados. |
| R12–R14 | Colección rediseñada, distribución web/APK, tema guardado y orden A–Z. |
| R15 | Coral y formulario adaptable con chips y pie fijo. |
| R16 | Acerca de y lectura de versión con package_info_plus. |
| R17 | Encuadre manual compartido, JSON compatible y pruebas de gestos/CORS. |
| R18 | Favoritos, fecha de terminado y notas en tarjetas. |
| R19 | Selección aleatoria por categoría, alternativa distinta, detalle y empezar. |
| R20 | Primera preparación documental y datos de autor/asignatura. |
| R21 | Rehacer todos los documentos desde el código y reservar capturas a Mario; se retiran las imágenes anteriores de la entrega. |
| R22 | Mario solicita después nuevas capturas y boceto a la IA. Se generan 16 renders del código actual y una reconstrucción marcada como IA, incorporados a documentos y ZIP. |
| R23 | Se retiran los avisos de la imagen del boceto a petición de Mario; boceto.md y esta bitácora conservan la procedencia real. |
| R24 | Se solicitan textos ficticios para la parte personal y comentarios. La IA añade ejemplos identificados por fase y respuestas de estudio; aclara comentarios sin modificar la lógica. |

## Decisiones y problemas técnicos observados por la IA

- Se mantuvieron StatefulWidget/setState y Navigator; no se añadieron gestores de estado.
- La escritura se confirma antes de sustituir la colección para evitar cambios ficticios tras fallos.
- La geometría compartida mantiene cover y límites del encuadre al redimensionar.
- El sorteo excluye solo el id anterior, sin prometer una ronda completa sin repetición.
- El diálogo requirió ajustes de dimensiones y las pruebas desplazamiento hasta controles visibles.
- El runner de Chrome en Windows presentó problemas de carga de CanvasKit; las pruebas
  web se incorporaron también a Actions sin desactivar las restricciones CORS.
- google_fonts, url_launcher y package_info_plus exceden los paquetes permitidos por
  el enunciado. No consta aceptación docente y no se oculta esa diferencia.
- Después de rehacer la documentación, Mario solicita a la IA las capturas y el boceto.
  Se generan desde los widgets actuales y con un diagrama cuya procedencia se conserva documentada,
  sin presentar renders como capturas físicas ni reconstrucciones como bocetos propios.

## Reflexión sobre las ampliaciones

| Bloque | Decisión de ejemplo y reflexión ficticia |
| --- | --- |
| Tema y tipografía | «Mantendría el tema en un solo archivo y las fuentes incluidas. Ahora distingo el estilo visible de la preferencia guardada; si falla escribir esa preferencia, la app restaura el modo anterior.» |
| Web y APK | «No confundiría publicar la app con publicar mi colección. Los enlaces están centralizados, pero Android y navegador mantienen datos separados. Tendría que revisar con el profesor los paquetes adicionales.» |
| Acerca de | «Usaría la versión que devuelve el plugin para no duplicarla como texto fijo. Revisaría los TODO que todavía quedan en la pantalla antes de presentarla como terminada.» |
| Encuadre | «Conservaría URL, zoom y desplazamientos, en lugar de guardar un recorte. Las coordenadas relativas mantienen la misma composición al redimensionar. Un servidor que rechaza CORS no se arregla cambiando el encuadre.» |
| Favoritos y notas | «Separaría el corazón de las estrellas: favorito no significa tener una valoración alta. Las dos líneas de notas son solo un resumen; el texto completo se conserva para detalle y edición.» |
| Fecha de terminado | «Distinguiría fecha de alta de fecha de finalización. La transición completa hoy, el calendario permite una fecha anterior y reabrir borra esa fecha. No inventaría fechas históricas para datos antiguos.» |
| Sorteo de pendientes | «Filtraría por pendiente y categoría antes de elegir al azar. Otra opción excluye solo el id anterior y no promete una ronda completa sin repeticiones. Empezar debe esperar a que el guardado tenga éxito.» |
| Comentarios | «Usaría los comentarios generados como apoyo para seguir los datos. Antes de sustituirlos por comentarios propios comprobaría cada explicación en el código, sin atribuirme la redacción automática.» |

mantendría las funciones verificadas, revisaría personalmente los fallos de acceso y cancelación y no marcaría como hechas actividades manuales que solo tienen cobertura automática.


## Cierre personal

- Se han incorporado imágenes actuales y un boceto de apoyo con IA
- He resuelto personalmente el requisito de boceto sin IA de fase 0.
- Se han añadido ejemplos ficticios de reflexión y respuestas redactadas por IA.
- He validado las reflexiones y escrito mi versión personal.
- He contestado las preguntas.
- Puedo explicar los archivos de lib y ensayar un cambio sin ayuda.


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

Los hechos técnicos siguientes los ha redactado IA. Los campos personales y las
preguntas se completan por Mario tras revisar el código. No son respuestas generadas
para presentarlas como comprensión propia.

## Fase 0 · Diseño y preparación

**Herramienta:** Codex para la intervención técnica; revisión personal por Mario.

**Prompts:** contexto R09–R11 del registro. No hay una transcripción original
separada por esta fase que se pueda reproducir como petición real.

**Resultado técnico actual:** Hay un boceto de apoyo reconstruido con IA a petición posterior de Mario. boceto.md indica su origen; no acredita el boceto personal sin IA de la fase inicial.

**Código/evidencia:** docs/boceto.png y estructura de carpetas.

**Acepté tras revisar / modifiqué o descarté y por qué:** pendiente de revisión personal.

**Errores que identifiqué personalmente:** pendiente; distinguirlos de los detectados por IA.

**Lo que aprendí, con mis palabras (2–3 líneas):** pendiente.

## Fase 1 · Modelo

**Herramienta:** Codex para la intervención técnica; revisión personal por Mario.

**Prompts:** contexto R09–R11 del registro. No hay una transcripción original
separada por esta fase que se pueda reproducir como petición real.

**Resultado técnico actual:** Elemento y Encuadre son inmutables. Se implementan JSON, copyWith, compatibilidad de campos opcionales y reglas de fecha.

**Código/evidencia:** lib/modelos/ y test/elemento_test.dart.

**Acepté tras revisar / modifiqué o descarté y por qué:** pendiente de revisión personal.

**Errores que identifiqué personalmente:** pendiente; distinguirlos de los detectados por IA.

**Lo que aprendí, con mis palabras (2–3 líneas):** pendiente.

**Preguntas que debo contestar sin IA:**

1. ¿Por qué los campos son `final`? ¿Cómo «cambio» entonces el estado de un elemento? **Respuesta personal pendiente.**
2. ¿Cómo se guarda un `enum` en JSON y cómo se recupera? **Respuesta personal pendiente.**
3. ¿Qué pasaría en `fromJson` si el JSON no trae el campo `notas`? **Respuesta personal pendiente.**

## Fase 2 · Colección y componentes

**Herramienta:** Codex para la intervención técnica; revisión personal por Mario.

**Prompts:** contexto R09–R11 del registro. No hay una transcripción original
separada por esta fase que se pueda reproducir como petición real.

**Resultado técnico actual:** La versión actual agrupa por categoría con cuadrícula adaptable, tarjetas y estrellas. Incluye favorito, notas y fecha en tarjetas.

**Código/evidencia:** pantalla_lista.dart, tarjeta_elemento.dart y selector_estrellas.dart.

**Acepté tras revisar / modifiqué o descarté y por qué:** pendiente de revisión personal.

**Errores que identifiqué personalmente:** pendiente; distinguirlos de los detectados por IA.

**Lo que aprendí, con mis palabras (2–3 líneas):** pendiente.

**Preguntas que debo contestar sin IA:**

1. ¿Qué diferencia hay entre `ListView` y `ListView.builder`? ¿Cuándo conviene cada uno? **Respuesta personal pendiente.**
2. ¿Por qué `TarjetaElemento` recibe una función en lugar de navegar ella misma? **Respuesta personal pendiente.**
3. ¿`TarjetaElemento` es `StatelessWidget` o `StatefulWidget`? ¿Por qué? **Respuesta personal pendiente.**

## Fase 3 · Formulario

**Herramienta:** Codex para la intervención técnica; revisión personal por Mario.

**Prompts:** contexto R09–R11 del registro. No hay una transcripción original
separada por esta fase que se pueda reproducir como petición real.

**Resultado técnico actual:** Alta y edición comparten formulario con chips, controladores, validación, portada, favorito, fecha y pie de acciones fijo.

**Código/evidencia:** pantalla_formulario.dart y tests de formulario.

**Acepté tras revisar / modifiqué o descarté y por qué:** pendiente de revisión personal.

**Errores que identifiqué personalmente:** pendiente; distinguirlos de los detectados por IA.

**Lo que aprendí, con mis palabras (2–3 líneas):** pendiente.

**Preguntas que debo contestar sin IA:**

1. ¿Qué hace `_formKey.currentState!.validate()` y qué significa el `!`? **Respuesta personal pendiente.**
2. ¿Por qué hay que llamar a `dispose()` de los controladores? **Respuesta personal pendiente.**
3. Explica el viaje del dato: desde que pulsas Guardar hasta que aparece en la lista. **Respuesta personal pendiente.**

## Fase 4 · Detalle, edición y borrado

**Herramienta:** Codex para la intervención técnica; revisión personal por Mario.

**Prompts:** contexto R09–R11 del registro. No hay una transcripción original
separada por esta fase que se pueda reproducir como petición real.

**Resultado técnico actual:** El detalle solicita al padre guardar actualizaciones por id y solo confirma tras éxito. El borrado requiere un diálogo.

**Código/evidencia:** pantalla_detalle.dart y test/lista_test.dart.

**Acepté tras revisar / modifiqué o descarté y por qué:** pendiente de revisión personal.

**Errores que identifiqué personalmente:** pendiente; distinguirlos de los detectados por IA.

**Lo que aprendí, con mis palabras (2–3 líneas):** pendiente.

**Preguntas que debo contestar sin IA:**

1. ¿Cómo sabe el formulario si está creando o editando? **Respuesta personal pendiente.**
2. ¿Cómo encuentra la lista qué elemento debe reemplazar al volver de la edición? **Respuesta personal pendiente.**
3. ¿Qué devuelve `showDialog` y cómo lo usas para saber si el usuario confirmó? **Respuesta personal pendiente.**

## Fase 5 · Filtros y búsqueda

**Herramienta:** Codex para la intervención técnica; revisión personal por Mario.

**Prompts:** contexto R09–R11 del registro. No hay una transcripción original
separada por esta fase que se pueda reproducir como petición real.

**Resultado técnico actual:** La lista visible se calcula sin destruir la colección. Se combinan texto, estado, categoría y favoritos; se ordena por título.

**Código/evidencia:** pantalla_lista.dart y test/lista_test.dart.

**Acepté tras revisar / modifiqué o descarté y por qué:** pendiente de revisión personal.

**Errores que identifiqué personalmente:** pendiente; distinguirlos de los detectados por IA.

**Lo que aprendí, con mis palabras (2–3 líneas):** pendiente.

**Preguntas que debo contestar sin IA:**

1. ¿Por qué se filtra sobre una lista calculada y no sobre la original? **Respuesta personal pendiente.**
2. ¿Qué método usas para que «dune» encuentre «Dune»? **Respuesta personal pendiente.**
3. Si filtras por Terminado y buscas un título pendiente, ¿qué debe verse? ¿Lo has probado? **Respuesta personal pendiente.**

## Fase 6 · Persistencia

**Herramienta:** Codex para la intervención técnica; revisión personal por Mario.

**Prompts:** contexto R09–R11 del registro. No hay una transcripción original
separada por esta fase que se pueda reproducir como petición real.

**Resultado técnico actual:** SharedPreferencesAsync conserva JSON bajo watchlist. Errores de escritura mantienen los datos anteriores; temaOscuro se guarda aparte.

**Código/evidencia:** servicios/almacen.dart, main.dart y test/almacen_test.dart.

**Acepté tras revisar / modifiqué o descarté y por qué:** pendiente de revisión personal.

**Errores que identifiqué personalmente:** pendiente; distinguirlos de los detectados por IA.

**Lo que aprendí, con mis palabras (2–3 líneas):** pendiente.

**Preguntas que debo contestar sin IA:**

1. ¿Por qué `cargar()` devuelve un `Future`? ¿Qué pasaría si la pantalla intentara pintar la lista antes de que termine? **Respuesta personal pendiente.**
2. ¿Por qué no se puede usar `await` directamente dentro de `initState`? ¿Cómo lo has resuelto? **Respuesta personal pendiente.**
3. ¿Dónde están físicamente los datos? ¿Se pierden si desinstalas la app? **Respuesta personal pendiente.**

## Fase 7 · Estadísticas y tema

**Herramienta:** Codex para la intervención técnica; revisión personal por Mario.

**Prompts:** contexto R09–R11 del registro. No hay una transcripción original
separada por esta fase que se pueda reproducir como petición real.

**Resultado técnico actual:** Las estadísticas usan todos los elementos y excluyen ceros de la media. El tema vigente es coral con Manrope local y ambos modos.

**Código/evidencia:** pantalla_estadisticas.dart, estilos/ y tests de diseño/estadísticas.

**Acepté tras revisar / modifiqué o descarté y por qué:** pendiente de revisión personal.

**Errores que identifiqué personalmente:** pendiente; distinguirlos de los detectados por IA.

**Lo que aprendí, con mis palabras (2–3 líneas):** pendiente.

**Preguntas que debo contestar sin IA:**

1. ¿Cómo has evitado dividir entre cero en la valoración media? **Respuesta personal pendiente.**
2. ¿Por qué los elementos con 0 estrellas no cuentan para la media? **Respuesta personal pendiente.**
3. ¿Qué ventaja tiene definir los colores en el tema en lugar de en cada widget? **Respuesta personal pendiente.**

## Fase 8 · Pruebas y documentación

**Herramienta:** Codex para la intervención técnica; revisión personal por Mario.

**Prompts:** contexto R09–R11 del registro. No hay una transcripción original
separada por esta fase que se pueda reproducir como petición real.

**Resultado técnico actual:** La suite habitual tiene 66 pruebas y hay tres adicionales de Chrome. Los documentos se reescriben; después se incorporan 16 renders nuevos y un boceto con su procedencia documentada.

**Código/evidencia:** test/, README.md y docs/.

**Acepté tras revisar / modifiqué o descarté y por qué:** pendiente de revisión personal.

**Errores que identifiqué personalmente:** pendiente; distinguirlos de los detectados por IA.

**Lo que aprendí, con mis palabras (2–3 líneas):** pendiente.

**Preguntas que debo contestar sin IA:**

1. ¿Qué diferencia hay entre una prueba unitaria y una de widget? **Respuesta personal pendiente.**
2. ¿Qué hace `tester.pump()` y por qué hace falta después de pulsar un botón? **Respuesta personal pendiente.**

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

## Revisión personal de las ampliaciones

**Qué acepté después de leerlo:** pendiente.

**Qué cambié o descarté realmente y por qué:** pendiente; indicar ninguno si corresponde.

**Qué errores detecté yo:** pendiente; no atribuirme los encontrados por IA.

**Qué aprendí en cada bloque:** pendiente, con palabras propias.

**Comentarios que reescribí tras comprenderlos:** pendiente.

## Cierre personal

- [x] Se han incorporado imágenes actuales y un boceto de apoyo generados con IA.
- [ ] He resuelto personalmente el requisito de boceto sin IA de fase 0.
- [ ] He completado las reflexiones de cada fase honestamente.
- [ ] He contestado las preguntas sin IA.
- [ ] Puedo explicar los archivos de lib y ensayar un cambio sin ayuda.

Los commits y tests acreditan cambios técnicos; no certifican estas actividades personales.

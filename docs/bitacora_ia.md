# Bitácora de IA · Mi Watchlist

**Mario Rodriguez · Desarrollo de Interfaces**
Revisión documental: 17/11/2026. Herramienta utilizada: Codex, de OpenAI.

Esta bitácora reúne hechos técnicos del proyecto y del historial disponible. La
redacción la ha preparado IA. No se atribuyen al alumno aprendizajes, revisiones,
detección personal de errores ni respuestas de comprensión que no constan.

El registro original aludía a una petición conjunta «PLEASE IMPLEMENT THIS PLAN:».
No está transcrita en el archivo actual de prompts; se conserva esa referencia
como antecedente documental, no como cita original verificada. Los commits por
fase acreditan cambios técnicos, no sesiones de clase ni autoría o comprensión.
El archivo [promts de IA.txt](../promts%20de%20IA.txt) distingue peticiones reales,
resúmenes de registros y ejemplos F01–F10 ficticios. Estos últimos no se usaron
como prompts históricos y no se presentan como evidencia de trabajo por fases.

## Cómo completar los apartados personales

En cada fase, el alumno debe indicar qué aceptó tras revisarlo, qué modificó o
descartó realmente y por qué, qué errores identificó personalmente y qué aprendió.
Si no hubo una modificación o no recuerda un prompt, debe decirlo. Las preguntas
se conservan sin respuestas para completarlas por cuenta propia. El boceto pedido
sin IA y los comentarios propios no los sustituye esta documentación.

## Registro original de fases · 12/11/2026

Las fases siguientes describen la versión inicial; las ampliaciones del 17/11 se
registran más abajo. Las cifras y limitaciones antiguas no describen la revisión actual.

## Fase 0 · Preparación y boceto

**Herramienta usada:** Codex para inspección y preparación técnica.
**Prompts principales:** solicitud de implementación del plan completo.
**Qué me dio la IA:** estructura y comprobación del entorno.
**Pendiente del alumno:** dibujar sin IA las cuatro pantallas y navegación, guardar
la imagen como `docs/boceto.png`. No hay un boceto personal generado por IA.
**Qué modifiqué, descarté y aprendí:** pendiente de completar personalmente.

## Fase 1 · Modelo

**Herramienta usada:** Codex.
**Prompts principales:** implementación del plan aprobado (conversación).
**Qué me dio la IA:** modelo inmutable, enums con etiquetas, JSON, copyWith y pruebas.
**Decisiones de la IA:** validar título y estrellas también en el modelo; distinguir
notas omitidas de null para poder borrar una nota al editar.
**Acepté / modifiqué / descarté:** pendiente de revisión personal.
**Errores detectados por el alumno:** pendiente de revisión.
**Lo que he aprendido:** pendiente de redactar personalmente.
**Preguntas de comprensión (sin IA):**
1. ¿Por qué son final los campos y cómo cambio el estado? Pendiente.
2. ¿Cómo se guarda y recupera un enum en JSON? Pendiente.
3. ¿Qué pasa si no hay notas en el JSON? Pendiente.

## Fase 2 · Lista y componentes

**Herramienta usada:** Codex.
**Prompts principales:** implementación del plan aprobado.
**Qué me dio la IA:** lista con cuatro ejemplos temporales, tarjetas y estrellas.
**Decisiones de la IA:** callbacks, claves por id y etiquetas accesibles de valoración.
**Acepté / modifiqué / descarté / aprendí:** pendiente de revisión personal.
**Errores detectados:** el sistema bloquea flutter_tester.exe; probar en Chrome.
**Preguntas de comprensión (sin IA):**
1. ¿Cuándo usar ListView.builder frente a ListView? Pendiente.
2. ¿Por qué la tarjeta recibe un callback? Pendiente.
3. ¿Por qué puede ser StatelessWidget? Pendiente.

## Fase 3 · Formulario

**Herramienta usada:** Codex.
**Prompts principales:** implementación del plan aprobado.
**Qué me dio la IA:** formulario, validación, estrellas interactivas y navegación.
**Errores de la IA detectados durante ejecución:** un lint por un if sin llaves,
corregido tras flutter analyze.
**Acepté / modifiqué / descarté / aprendí:** pendiente de revisión personal.
**Preguntas de comprensión (sin IA):**
1. ¿Qué hacen validate y el operador !? Pendiente.
2. ¿Por qué es necesario dispose? Pendiente.
3. ¿Cómo viajan los datos desde Guardar hasta la lista? Pendiente.

## Fase 4 · Detalle, edición y borrado

**Herramienta usada:** Codex.
**Prompts principales:** implementación del plan aprobado.
**Qué me dio la IA:** detalle con todos los datos, callbacks y confirmación de borrado.
**Decisiones de la IA:** edición mediante copia local, conservación de id y fecha.
**Acepté / modifiqué / descarté / errores / aprendí:** pendiente de revisión personal.
**Preguntas de comprensión (sin IA):**
1. ¿Cómo distingue el formulario alta y edición? Pendiente.
2. ¿Cómo se identifica el elemento que hay que reemplazar? Pendiente.
3. ¿Qué devuelve showDialog y cómo se comprueba? Pendiente.

## Fase 5 · Filtro y búsqueda

**Herramienta usada:** Codex.
**Prompts principales:** implementación del plan aprobado.
**Qué me dio la IA:** ChoiceChip y búsqueda combinados sobre una lista calculada.
**Acepté / modifiqué / descarté / errores / aprendí:** pendiente de revisión personal.
**Preguntas de comprensión (sin IA):**
1. ¿Por qué no se filtra modificando la lista original? Pendiente.
2. ¿Cómo encuentra dune el título Dune? Pendiente.
3. ¿Qué ocurre al combinar Terminado con un título pendiente? Pendiente.

## Fase 6 · Persistencia

**Herramienta usada:** Codex.
**Prompts principales:** implementación del plan aprobado.
**Qué me dio la IA:** SharedPreferencesAsync, carga inicial y escritura antes de
confirmar cambios. JSON inválido produce lista vacía; errores de acceso ofrecen reintento.
**Acepté / modifiqué / descarté / errores / aprendí:** pendiente de revisión personal.
**Preguntas de comprensión (sin IA):**
1. ¿Por qué cargar devuelve Future? Pendiente.
2. ¿Cómo se carga sin hacer initState async? Pendiente.
3. ¿Dónde están los datos y qué pasa al desinstalar? Pendiente.

## Fase 7 · Estadísticas y tema

**Herramienta usada:** Codex.
**Prompts principales:** implementación del plan aprobado.
**Qué me dio la IA:** tema morado común, estadísticas completas y barras nativas.
**Decisiones de la IA:** media solo de valorados y todos los tipos empatados.
**Acepté / modifiqué / descarté / errores / aprendí:** pendiente de revisión personal.
**Preguntas de comprensión (sin IA):**
1. ¿Cómo se evita dividir entre cero? Pendiente.
2. ¿Por qué se excluyen los elementos con cero estrellas? Pendiente.
3. ¿Qué ventaja tiene definir los colores en el tema? Pendiente.

## Fase 8 · Pruebas, documentación y entrega

**Herramienta usada:** Codex.
**Prompts principales:** «PLEASE IMPLEMENT THIS PLAN:» y el plan completo de esta
conversación. El alumno debe conservar la conversación y registrar personalmente
cualquier petición posterior.
**Qué me dio la IA:** pruebas, README, registro de validación, capturas Android,
APK y documentación para preparar la defensa.
**Errores detectados durante ejecución:** formulario con campos diferidos,
valor semántico incorrecto de barras y gestos de pruebas antes de terminar el
desplazamiento; corregidos y verificados. Detalles en `validacion.md`.
**Limitaciones del entorno:** Windows bloquea el ejecutable de pruebas nativo;
19 pruebas ejecutadas en Chrome con ajuste temporal de los archivos CanvasKit.
**Acepté sin cambios / modifiqué / descarté:** pendiente de revisión personal.
**Lo que he aprendido (2–3 líneas propias):** pendiente de redactar por el alumno.
**Preguntas de comprensión (sin IA):**
1. ¿Qué diferencia hay entre prueba unitaria y de widget? Pendiente.
2. ¿Qué hace tester.pump y por qué se usa tras pulsar un botón? Pendiente.

## Revisión antes de entregar

- [ ] He hecho el boceto sin IA y guardado docs/boceto.png.
- [ ] He leído y comprendido todos los archivos de lib.
- [ ] He reescrito los comentarios con mis palabras.
- [ ] He completado las reflexiones de cada fase honestamente.
- [ ] He contestado las preguntas sin IA.
- [ ] He repetido la demostración y un cambio en directo sin IA.

Los commits describen el trabajo técnico realizado; no certifican que el alumno
haya revisado o comprendido cada fase. Estas revisiones siguen pendientes.

## Revisión posterior · Plan por módulos y estilos

**Herramienta usada:** Codex.
**Prompt principal:** «Modularizame el plan y creame estilos».
**Qué me dio la IA:** plan por módulos M00–M08, guía de estilos y carpeta
`lib/estilos` con tema Material y estilos compartidos conectados a las pantallas.
Las pruebas de widgets utilizan el tema de la aplicación para comprobar los flujos
con la apariencia configurada.
**Acepté / modifiqué / descarté / aprendí:** pendiente de revisión personal.

## Revisión posterior · Portadas y mejora visual

**Prompt:** «Dame mas estilo visual , quiero que en el apartado de juegos, podamos insertar una imagen».
**Herramienta:** Codex.
**Resultado de IA:** portada opcional por URL para videojuegos, vista previa,
eliminación, persistencia del enlace y recuperación visual ante errores de carga;
compatibilidad con datos antiguos, degradados y tarjetas con sombra.
**Reflexión y revisión personal:** pendiente del alumno.

**Ajuste posterior solicitado:** mostrar también la portada en la miniatura del
mando junto al título. Se reutiliza el mismo enlace, con recorte cuadrado y
el icono de reserva si falta la imagen o falla su carga.

**Ampliación posterior:** el usuario solicita imágenes también para películas y
series al crear y editar. Se elimina la restricción por tipo, se conserva el enlace
al cambiar de categoría y se reutiliza un componente de portada común.


## Revisión documental de las fases iniciales

| Fase | Commit del historial | Aclaración para la entrega |
| --- | --- | --- |
| 0 | 140eda1 | Preparación técnica; boceto propio no disponible. |
| 1 | 9888ddf | Modelo y JSON; actualmente incorpora campos opcionales adicionales. |
| 2 | a1f8684 | Tarjetas y estrellas; la versión final usa cuadrícula adaptable. |
| 3 | a6dce96 | Formulario; ahora usa chips, columnas adaptables y pie fijo. |
| 4 | cb20d75 | Detalle, edición y confirmación de borrado. |
| 5 | 2765f51 | Búsqueda/filtro; ampliados con categoría y favoritos. |
| 6 | 9ebfebf | Persistencia con escritura antes de confirmar el cambio. |
| 7 | 80ba0a4 | Tema y estadísticas; el morado inicial fue sustituido por coral. |
| 8 | d0187d5 | Primera validación y documentación; se actualizan en esta revisión. |

## Revisiones posteriores · 16–17/11/2026

Los textos íntegros disponibles o resúmenes identificados están en el archivo de
prompts. Esta tabla enlaza su identificador; no convierte los ejemplos ficticios
en peticiones reales.

| Prompts reales | Petición y resultado técnico | Comprobación registrada |
| --- | --- | --- |
| R01–R08 | Ayuda para ejecutar en Xiaomi/VS Code. La compilación funcionaba, pero Android rechazaba instalar por restricción del usuario. | Registros de terminal; no acreditan instalación física posterior. |
| R09–R11 | Revisión del enunciado y programación antes de documentos. Se mantuvo la base existente y se separaron los ejemplos ficticios solicitados. | 26 pruebas y APK debug en esa revisión. |
| R12–R14 | Rediseño, Manrope, tema guardado, categorías A–Z y publicación web/APK. | Workflow de publicación; ajuste para fijar Flutter 3.47.9. |
| R15 | Coral y formulario adaptable con chips y guardado fijo. | Análisis, pruebas y revisión de renders de interfaz. |
| R16 | Acerca de con funciones verificadas y versión obtenida mediante plugin. | 45 pruebas en esa revisión. |
| R17 | Encuadre manual, modelo compatible y geometría compartida. | 55 pruebas habituales y 3 Chrome en esa revisión. |
| R18 | Favoritos, fecha de terminado y notas en tarjetas. | 61 pruebas habituales y publicación correcta. |
| R19 | Sorteo de pendientes por categoría y acciones de detalle/empezar/añadir. | 66 pruebas habituales y publicación del commit 20b87b4. |
| R20 | Preparar documentación, bitácora y capturas; autor Mario Rodriguez y asignatura Desarrollo de Interfaces. | README y documentos actualizados, capturas reproducibles y APK debug regenerado. |

### Decisiones y errores técnicos observados por la IA

- Se mantuvieron StatefulWidget/setState y Navigator en lugar de incorporar un gestor
  de estado. La lista sigue siendo propietaria de la colección completa.
- Se añadieron google_fonts, url_launcher y package_info_plus para ampliaciones.
  Son una desviación de la lista cerrada del enunciado; no consta autorización docente.
- Fijar la versión de Flutter evitó cambios incompatibles con el código verificado.
- El runner de Chrome de Windows requería suministrar CanvasKit desde el SDK local;
  las pruebas de CORS se ejecutaron sin desactivar la seguridad del navegador.
- El encuadre comparte cálculo y límites para no dejar huecos ni depender del tamaño.
- Los datos antiguos mantienen defaults; no se inventó una fecha histórica de terminado.
- En el diálogo de sugerencia se corrigió el cálculo de dimensiones de la portada
  y se ajustaron las pruebas para desplazar controles fuera de pantalla antes de pulsar.
- Al actualizar documentos se detectaron afirmaciones obsoletas: tema morado,
  fuente del sistema, 19 pruebas y ausencia de ampliaciones. Se sustituyen por la
  descripción de la versión real, sin borrar los registros históricos de validación.

### Revisión personal de las ampliaciones · completar por Mario

**Acepté tras revisar:** pendiente de tu revisión real.
**Modifiqué y por qué:** pendiente; no declarar cambios no realizados.
**Descarté y por qué:** pendiente; indicar ninguno si corresponde.
**Errores que detecté personalmente:** pendiente; distinguirlos de los detectados por IA.
**Qué he aprendido (2–3 líneas propias por bloque):** pendiente.

La lista personal de comprobación anterior sigue abierta. Esta bitácora técnica
está preparada para revisión, pero no sustituye esas aportaciones individuales.

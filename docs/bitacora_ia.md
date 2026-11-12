# Bitácora de IA — Mi Watchlist

Este registro inicial lo ha redactado Codex. No sustituye la reflexión del alumno.
La implementación se solicitó con el prompt «PLEASE IMPLEMENT THIS PLAN:» seguido
del plan completo de la conversación. El enunciado original pide peticiones por
fases: esta ejecución conjunta debe declararse y revisarse con el profesor.

No se atribuyen al alumno comentarios, respuestas ni revisiones que no ha hecho.
Los comentarios `///` del código fueron generados por IA y deben revisarse y
reescribirse personalmente tras comprenderlos.

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

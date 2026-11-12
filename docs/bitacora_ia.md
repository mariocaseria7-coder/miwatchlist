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

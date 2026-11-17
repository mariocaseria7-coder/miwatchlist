# Preparación de la defensa · Mario Rodriguez

Desarrollo de Interfaces · Mi Watchlist · 17/11/2026.

Esta guía está redactada con IA para organizar el ensayo. No constituye respuestas
personales a las preguntas de comprensión ni acredita que se haya realizado el ensayo.

## Demostración de dos minutos

| Tiempo | Acción que enseñar |
| --- | --- |
| 0:00–0:25 | Abrir la app, añadir un título válido y comprobar que uno vacío muestra error. |
| 0:25–0:50 | Abrir detalle, editar estado/notas, cancelar una edición y confirmar que no cambia. |
| 0:50–1:10 | Combinar búsqueda con estado; quitar filtros; enseñar favorito y categorías. |
| 1:10–1:30 | Estadísticas de toda la colección y cambio de tema. |
| 1:30–2:00 | Cerrar/abrir y verificar persistencia; borrar un ejemplo con confirmación. |

Si queda tiempo, mostrar encuadre o ¿Qué veo hoy?. Las funciones básicas tienen prioridad.
Prepara ejemplos desechables: un borrado confirmado es permanente. No dependas de una
portada externa para demostrar lo esencial.

## Cuatro minutos para explicar código

Recorre uno de estos caminos con el código abierto, usando tus palabras:

1. Formulario → Navigator.pop → resultado de push en lista → Almacen.guardar → setState.
2. Elemento → toJson/fromJson → preferencias locales → carga inicial.
3. Tarjeta → callback → actualización por id → guardado y manejo de errores.
4. Filtros → lista calculada → cuadrícula, frente a estadísticas con colección completa.
5. Sugerencia → pendientes de categoría → Random → exclusión del id anterior → Empezar.

Archivos a localizar: main.dart, modelos/elemento.dart, servicios/almacen.dart,
pantallas/pantalla_lista.dart, pantalla_formulario.dart y widgets/selector_estrellas.dart.
Incluye los archivos de ampliaciones: el profesor puede preguntar por cualquier línea.

## Ensayo de cambio sin IA · cuatro minutos

Trabaja en una copia local o rama para no alterar la versión publicada. Elige al azar:

- Cambiar el límite del título y revisar las pruebas que dependen de él.
- Cambiar la paleta y comprobar los dos temas y el contraste.
- Mostrar el total de elementos en la cabecera.
- Añadir un estado y localizar enums, etiquetas, filtros y estadísticas afectados.

Realiza el cambio sin ayuda y explica por qué hay que revisar más de un lugar.
Después comprueba formato, análisis y pruebas. No se han preparado soluciones para
copiar durante el examen.

## Revisión personal

- [ ] Puedo localizar cada campo y explicar por qué es final.
- [ ] Sé seguir un callback, un Future y la comprobación de mounted.
- [ ] Distingo la colección original de la lista filtrada.
- [ ] Puedo explicar el encuadre y las transiciones de fecha sin memorizar un texto.
- [ ] He respondido por mi cuenta las preguntas de la bitácora.
- [ ] He ensayado un cambio completo sin IA.

Estas casillas solo deben marcarse después de realizar la actividad personalmente.

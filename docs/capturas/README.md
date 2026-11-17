# Capturas nuevas de la interfaz actual

**Mario Rodriguez · Desarrollo de Interfaces · 17/11/2026**

Estas 16 imágenes se han generado de nuevo con Flutter Test a partir de los widgets
de lib/ actuales. Son renders del entorno de pruebas en Windows, con dimensiones
móviles y de escritorio; no son fotos ni capturas de un Xiaomi físico ni prueban
una instalación real. No se han reutilizado los PNG de la copia anterior.

Se han cargado Manrope e iconos Material. Las pantallas auxiliares se abren mediante
Navigator para mostrar su vuelta atrás. Se utilizan tres elementos aislados: Dune:
Parte 2 pendiente y favorito, The Bear en curso con 4 estrellas y Hollow Knight
terminado el 15/11/2026 con 5 estrellas. La estadística resultante es 3 elementos,
uno por estado, media 4,5 y empate de tipos. No son datos precargados en la aplicación.

La portada geométrica es un ejemplo sintético servido desde la caché de imagen del
test. La URL portada.invalid es un identificador de fixture, no un enlace público
utilizable. Así la generación no depende de un servidor externo y no demuestra CORS;
las pruebas Chrome específicas comprueban ese aspecto por separado.

## Registro de imágenes

| Archivo | Contenido |
| --- | --- |
| [actual-acerca.png](actual-acerca.png) | Pantalla Acerca de. |
| [actual-calendario.png](actual-calendario.png) | Calendario con fechas futuras desactivadas. |
| [actual-categorias-azar.png](actual-categorias-azar.png) | Categorías y recuentos de pendientes. |
| [actual-detalle.png](actual-detalle.png) | Detalle y notas completas. |
| [actual-edicion.png](actual-edicion.png) | Fecha, favorito y valoración al editar. |
| [actual-encuadre.png](actual-encuadre.png) | Editor de encuadre cargado. |
| [actual-escritorio.png](actual-escritorio.png) | Colección en pantalla ancha. |
| [actual-estadisticas.png](actual-estadisticas.png) | Estadísticas de los tres ejemplos. |
| [actual-formulario-ancho.png](actual-formulario-ancho.png) | Edición en dos columnas. |
| [actual-formulario.png](actual-formulario.png) | Alta en móvil. |
| [actual-inicio.png](actual-inicio.png) | Inicio y enlaces de distribución. |
| [actual-lista-oscura.png](actual-lista-oscura.png) | Colección oscura. |
| [actual-lista.png](actual-lista.png) | Colección clara y favorito. |
| [actual-movil-peque.png](actual-movil-peque.png) | Formulario a 320 píxeles lógicos. |
| [actual-sugerencia.png](actual-sugerencia.png) | Pendiente sugerido. |
| [actual-vacia.png](actual-vacia.png) | Colección vacía. |

El tamaño habitual es 430×932 píxeles lógicos; hay vistas de 1440×1100 y 1200×1100,
y una de 320×800. La exportación PNG usa escala 1,5. Algunas pantallas muestran una
posición desplazada para que se vean los controles o tarjetas documentados.

## Repetir la generación

```bash
flutter test tool/capturas_documentacion_test.dart
```

El comando sobrescribe solo las imágenes actual-*.png previstas por el generador.
Antes de sustituirlas por capturas propias, conservar estas o usar otros nombres.
Una captura propia debe registrar su fecha y plataforma sin atribuirle este origen.

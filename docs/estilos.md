# Estilos de Mi Watchlist

Mario Rodriguez · Desarrollo de Interfaces · Revisión 17/11/2026.

## Tema y tipografía

`lib/estilos/tema_app.dart` define ThemeData, Material 3 y ColorScheme.fromSeed.
La semilla es coral #FF7A59. El primario claro se oscurece a #AD3D25 para mantener
legibilidad; el oscuro usa la semilla sobre superficies cálidas oscuras. Los textos
usan sus roles onSurface, onPrimary y onPrimaryContainer. Los errores usan error.
No se usa una paleta morada en la versión actual.

Manrope se configura con google_fonts 8.2.1 y se incluye en assets/fonts, con licencia
OFL. La descarga de fuentes en ejecución está desactivada. Los tamaños parten de
los estilos headlineMedium, titleLarge, titleMedium y bodyMedium del tema.

`main.dart` aplica claro y oscuro en MaterialApp. La elección se carga y guarda
como temaOscuro en preferencias. Los controles heredan colores y estados del tema.

## Medidas y adaptación

| Valor | Definición actual |
| --- | --- |
| Margen de pantalla | 24 píxeles lógicos. |
| Margen compartido de tarjeta | 16; la tarjeta actual usa padding propio de 18. |
| Ancho máximo de colección | 1160. |
| Ancho máximo de contenido auxiliar | 600. |
| Radio de panel compartido | 24. |
| Marco de portada | 16:9. |
| Formulario ancho | Dos columnas desde 860; una en móvil. |

Las medidas están en estilos_app.dart. La cuadrícula de colección cambia entre
una, dos y tres columnas según el ancho. La altura de cada tarjeta suma su portada
proporcional y el espacio de texto; aumenta con el escalado del texto. Los botones
de Guardar y Cancelar permanecen en el pie del formulario, con ajuste al teclado.

## Componentes

Las tarjetas comparten portada, tipo, título y valoración. El corazón usa una
transición de escala con AnimatedSwitcher; es independiente de las estrellas.
Las notas tienen máximo dos líneas y la fecha de terminado es secundaria.

ImagenElemento comparte la geometría de la portada con el editor y el diálogo
aleatorio. El degradado de reserva usa primaryContainer y surfaceContainerLow.
Los paneles destacados combinan primaryContainer y secondaryContainer. Las
acciones destructivas conservan el color semántico de error.

Para modificar la paleta se revisan la semilla y sus ajustes de contraste en
TemaApp; no basta cambiar la semilla si se quieren alterar también los valores
copyWith explícitos. No hace falta repartir colores por las pantallas.

## Evidencias

Las pruebas formulario_diseno_test.dart comprueban combinaciones de contraste,
formulario ancho/estrecho y teclado; diseno_test.dart cubre controles de cabecera
y recuerdo del tema. mejoras_coleccion_test.dart verifica tarjetas con notas y fecha
en ambos modos. sugerencia_test.dart verifica el diálogo en móvil pequeño y ambos
modos. Las capturas del README son renders actuales con datos de ejemplo.

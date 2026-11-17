# Diseño de la interfaz actual

**Mi Watchlist · Mario Rodriguez · Desarrollo de Interfaces · 17/11/2026**

## Paleta y tipografía

TemaApp configura Material 3 y ColorScheme.fromSeed con coral #FF7A59. Ajusta roles
mediante copyWith: el primario claro es #AD3D25 para legibilidad y el oscuro usa la
semilla. Las superficies son cálidas en ambos modos. El diseño actual no utiliza
la paleta morada inicial.

Manrope se configura con google_fonts 8.2.1. Los archivos Regular, Medium, SemiBold,
Bold y ExtraBold y su licencia OFL están en assets/fonts. La descarga de fuentes
en ejecución está desactivada.

## Configuración

TemaApp define colores, texto y componentes. EstilosApp comparte márgenes, anchos,
iconos por tipo, proporción de portada y paneles. main.dart aplica claro/oscuro en
MaterialApp y persiste la elección. Los widgets leen colorScheme y textTheme;
los errores y acciones destructivas usan error.

Cambiar la semilla no modifica los colores explícitos de copyWith: para otra paleta
hay que revisar ambos. No es necesario repartir colores nuevos por las pantallas.

## Adaptación

La colección tiene ancho máximo de 1160 píxeles lógicos y cuadrícula de una, dos o
tres columnas. Los contenidos auxiliares usan máximo 600. El margen de pantalla
compartido es 24 y el radio de panel 24. El margen de tarjeta compartido es 16,
aunque la tarjeta actual aplica un padding propio de 18.

El formulario usa dos columnas desde 860 y una columna con scroll en móvil. El pie
de Guardar/Cancelar contempla el teclado. Tipo y estado son chips; la valoración
usa estrellas grandes. El texto respeta escalado y la altura de tarjetas lo contempla.

Las portadas comparten 16:9 y geometría. Su reserva usa degradado del tema. Las notas
tienen dos líneas y la fecha de terminado es secundaria. El corazón usa transición
de escala con AnimatedSwitcher y es independiente de las estrellas.

## Comprobación y capturas

Los tests verifican casos de contraste, formulario ancho/estrecho, cabecera, teclado,
notas/fechas y diálogo en ambos temas. Esto no constituye una auditoría completa de
accesibilidad en todos los dispositivos.

Mario incorporará capturas propias de la app actual conforme a
[capturas/README.md](capturas/README.md). Las imágenes anteriores no son evidencia
de esta revisión y no se utilizan en los documentos.

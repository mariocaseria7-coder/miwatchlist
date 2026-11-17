# Manual de uso · Mi Watchlist

Mario Rodriguez · Desarrollo de Interfaces · Versión 1.0.0+1 · 17/11/2026.

## Abrir o instalar

Puedes abrir la [web](https://mariocaseria7-coder.github.io/miwatchlist/) sin cuenta.
Para Android, descarga la [APK](https://github.com/mariocaseria7-coder/miwatchlist/releases/latest/download/app-release.apk),
ábrela y permite la instalación desde el navegador si Android lo solicita. Se trata
de una distribución educativa fuera de Google Play. Si el teléfono informa de una
firma incompatible con una instalación anterior, conserva tus datos antes de decidir
qué hacer: la app no tiene exportación ni sincronización, y desinstalar puede borrarlos.
La carpeta entrega del proyecto contiene además la APK de depuración local.

## Añadir un elemento

1. Pulsa Añadir o Añadir el primero si la colección está vacía.
2. Escribe un título de 1 a 60 caracteres; los espacios de los extremos no cuentan.
3. Elige Película, Serie o Videojuego y Pendiente, Viendo/Jugando o Terminado.
4. Si quieres, añade estrellas, notas, favorito y un enlace directo a una portada.
5. Pulsa Guardar en el pie de pantalla. Cancelar o volver no guarda el formulario.

Los títulos pueden repetirse. Cero estrellas significa sin valorar; Quitar valoración
vuelve a ese valor. El corazón es un favorito independiente de las estrellas.

## Organizar y encontrar

La colección se muestra por categorías y dentro de cada una por título A–Z. Puedes
combinar búsqueda, categoría, estado y Favoritos. La búsqueda no distingue mayúsculas.
Si no hay resultados, cambia esos filtros; no se borran elementos al filtrar.
El corazón de la tarjeta marca o desmarca favoritos sin abrir el detalle.
Las notas tienen hasta dos líneas en tarjetas; para leerlas completas abre el detalle.

## Portadas y encuadre

Pega un enlace http/https directo a una imagen; para la web pública es preferible HTTPS
y el servidor debe permitir CORS. Cuando carga aparece el editor. Arrastra la imagen,
usa pellizco en móvil, rueda en web o el deslizador. Restablecer centra y deja zoom 1.
No deja huecos porque mantiene cubierta la zona. El marco 16:9 y el encuadre se comparten
con las tarjetas, el detalle y la sugerencia aleatoria.

Cambiar el enlace reinicia el encuadre. Quitar imagen borra enlace y encuadre. No se
almacena una copia de la imagen. Si falla, aparece Imagen no disponible y no hay editor;
comprueba el enlace o elige otro servidor. La app no puede autorizar CORS por su cuenta.

## Editar, terminar y borrar

Toca una tarjeta y pulsa Editar. El formulario carga sus datos. Al guardar conserva
la identidad y la fecha de alta. Cancelar mantiene lo anterior.

Al pasar a Terminado se asigna hoy; aparece un selector para cambiar esa fecha hasta
hoy inclusive. La tarjeta la muestra abreviada en español. Al regresar a otro estado
se borra. Los registros antiguos pueden carecer de fecha de terminado.

Borrar abre una confirmación. Solo se elimina tras confirmar y guardar correctamente.
No hay deshacer borrado. Si se muestra un fallo de guardado, los datos anteriores se
conservan y puedes reintentar.

## ¿Qué veo hoy?

Pulsa el botón junto a los filtros de categoría. Elige Películas, Series, Videojuegos
o Cualquiera; cada opción indica sus pendientes. Se usa toda tu colección, aunque
haya búsqueda o filtros activos. Las categorías con cero pendientes aparecen atenuadas;
al abrirlas puedes añadir uno con esa categoría preseleccionada.

La sugerencia muestra portada, título y notas. Otra opción elige un pendiente distinto
del anterior si hay más de uno; con uno queda desactivado. Ver detalle no cambia el
estado. Empezar lo pasa a Viendo o Jugando y guarda; si falla, ofrece reintentar.

## Estadísticas, tema e información

El icono de barras abre estadísticas de toda la colección: total, recuentos por estado,
media de elementos valorados y tipos más frecuentes. Un filtro no reduce estas cifras.
El botón de sol/luna alterna tema y recuerda la elección. El icono de información abre
Acerca de, que explica el uso e incluye la versión y los enlaces de distribución.
Los campos de autor/asignatura dentro de Acerca de conservan los TODO del código;
esta revisión de documentación no modifica pantallas.

## Datos y problemas frecuentes

- Android y cada navegador guardan colecciones separadas; no se sincronizan.
- Borrar datos, desinstalar o navegar en una sesión privada puede perder la colección.
- Sin Internet puedes consultar datos locales, pero una portada remota puede no cargar.
  No se promete que una primera apertura web funcione sin conexión.
- Si no aparece una novedad web, recarga la página; en escritorio puedes usar Ctrl+F5.
- Una lista vacía puede ser nueva, el resultado de filtros o una recuperación ante JSON
  dañado; un fallo de acceso ofrece reintento. No hay recuperación automática de copias.

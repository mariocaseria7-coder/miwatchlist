# Memoria del proyecto

**Mi Watchlist · Mario Rodriguez · Desarrollo de Interfaces**

Versión 1.0.0+1. Revisión desde el código actual: 17/11/2026.

## Objetivo y alcance

Mi Watchlist reúne películas, series y videojuegos que una persona quiere ver o
jugar, tiene en curso o ha terminado. Permite añadir información personal, localizar
los títulos y consultar un resumen de su colección. Se ejecuta en Android y web.

No hay cuentas, catálogo externo, importación, exportación, sincronización ni copia
de seguridad. La sugerencia aleatoria usa pendientes propios, no recomendaciones
obtenidas de un servicio. Los datos de Android y del navegador son independientes.

## Pantallas

Inicio presenta distribución, colección, categorías, búsqueda, filtros y alta. Las
tarjetas incluyen portada, tipo, título, estado, estrellas, favorito, resumen de notas
y fecha de terminado si existe. La colección se agrupa por tipo y se ordena por título
con comparación de cadenas en minúsculas, sin ordenación lingüística especial de acentos.

El formulario sirve para crear y editar. Recibe inicial si se edita y tipoInicial
para preseleccionar la categoría de una sugerencia vacía. En ancho muestra dos
columnas; en móvil una. Guardar y Cancelar están en un pie fijo.

Detalle muestra los campos básicos, notas completas, fecha de alta, id y portada
cuando corresponde. Incluye edición y borrado confirmado. Los campos añadidos
favorito y fecha de terminado se consultan en tarjetas y edición; no tienen filas
propias en el detalle actual.

Estadísticas usa toda la colección. Acerca de explica la app y lee la versión.
Dentro de esa pantalla aún hay TODO para autor/asignatura: esta revisión documental
no modifica esos textos de la aplicación.

## Modelo y JSON

Elemento es inmutable: sus campos son final y copyWith construye otra instancia.

| Campo | Tipo | Regla |
| --- | --- | --- |
| id | String | Identidad conservada en edición. |
| titulo | String | trim y longitud 1–60. Puede repetirse. |
| tipo | Tipo | pelicula, serie o videojuego. |
| estado | Estado | pendiente, enCurso o terminado. |
| valoracion | int | 0–5; cero significa sin valorar. |
| notas | String? | Opcional; texto vacío al guardar pasa a null. |
| fechaAlta | DateTime | Creación; se conserva en edición. |
| imagenUrl | String? | URL de portada opcional. |
| encuadre | Encuadre? | Zoom 1–5 y x/y entre -1 y 1. |
| favorito | bool | false si falta en datos antiguos. |
| fechaTerminado | DateTime? | Opcional; ausente en estados distintos de terminado. |

JSON conserva enums por name y fechas ISO 8601. fromJson reconstruye los tipos.
Los campos opcionales nuevos pueden faltar en datos antiguos. No se inventa una
fecha histórica al cargar un elemento terminado sin fecha.

Los parámetros anulables de copyWith distinguen omisión de null con un centinela:
omitir conserva; pasar null elimina. Cambiar o quitar imagenUrl reinicia su encuadre;
sin URL no se conserva un encuadre huérfano.

Al pasar por copyWith desde otro estado a terminado se asigna hoy. El formulario
aplica esa transición y permite una fecha manual hasta hoy. Volver a otro estado
la borra; cambiar solo título o favorito la conserva. Guardar desde el formulario
un registro antiguo terminado sin fecha puede completarla con hoy. El calendario
impide elegir fechas futuras; no existe una política general de rechazo de fechas
futuras introducidas directamente en JSON. Los rótulos usan meses abreviados en español.

## Datos y estado de interfaz

PantallaLista posee colección y filtros. Calcula visibles mediante where, sin
modificar la colección original. La búsqueda usa trim, toLowerCase y contains.
Categoría, estado y favoritos se combinan; las operaciones identifican elementos por id.

El formulario edita controladores y estado local. Guardar valida y devuelve Elemento
con Navigator.pop; cancelar devuelve null. La lista espera Navigator.push y construye
una propuesta de colección. Almacen.guardar espera la escritura; solo el éxito
confirma el cambio en pantalla. Un fallo mantiene la colección previa y muestra aviso.
El detalle solicita actualizar o borrar con callbacks Future<bool> y espera confirmación.

Almacen usa SharedPreferencesAsync y una cadena JSON bajo watchlist. JSON ausente,
inválido o con ids duplicados produce una colección vacía. Un error de acceso se
propaga para ofrecer reintento. No se repara automáticamente contenido corrupto.
El tema se guarda por separado en temaOscuro y se restaura el anterior si falla su escritura.

El almacenamiento pertenece a la aplicación Android o al navegador y origen web.
Borrar datos, desinstalar o usar otro navegador puede perder o separar la colección.
Los servidores de portada reciben peticiones al visualizar sus imágenes; no se envía
la colección a un servidor propio.

## Portadas y geometría

El formulario valida URL http/https con host. Guarda el enlace y los parámetros,
no una copia recortada. El editor aparece tras cargar la imagen y permite arrastre,
pellizco, rueda, deslizador y Restablecer. Zoom 1 significa cubrir el marco centrado.

Encuadre valida límites y números finitos. geometria_portada.dart calcula cover y
limita movimiento para evitar huecos. ImagenElemento comparte el marco 16:9 en
formulario, tarjetas, detalle y sugerencia. La posición relativa se mantiene al
cambiar el ancho. Un fallo muestra reserva y oculta el editor.

La web pública usa HTTPS: las portadas requieren un origen seguro y CORS permitido.
No existe proxy ni se desactiva la seguridad para mostrar imágenes bloqueadas.

## Sorteo y estadísticas

pendientesDe filtra por pendiente y tipo opcional. elegirPendiente utiliza Random
entre candidatos. Con más de uno excluye el id anterior; evita repetición inmediata,
no garantiza que un título no vuelva a aparecer durante toda la sesión.

El selector usa todos los pendientes aunque haya filtros activos. Las categorías
vacías están atenuadas, pero se pueden abrir para ofrecer alta con tipo preseleccionado.
Con uno, Otra opción se desactiva. Ver detalle no cambia estado. Empezar crea una
copia enCurso y espera el guardado; el diálogo solo cierra con éxito.

ResumenEstadisticas recibe la colección completa, cuenta por estado y tipo y calcula
media solo de valoraciones mayores que cero. Evita dividir sin valorados. Los empates
de tipos frecuentes se muestran completos; una lista vacía no inventa un ganador.

## Relación con requisitos

| Requisito | Implementación | Pruebas principales en test/ |
| --- | --- | --- |
| R1 Lista, tipo, estado y estrellas | PantallaLista / TarjetaElemento | lista_test.dart |
| R2 Estado vacío | PantallaLista | lista_test.dart |
| R3 FAB de alta | Lista / Formulario | lista_test.dart |
| R4 Validación | Formulario / Elemento | formulario_test.dart, elemento_test.dart |
| R5 Detalle básico | PantallaDetalle | lista_test.dart |
| R6 Edición reutilizada | PantallaFormulario(inicial) | lista_test.dart, imagen_juego_test.dart |
| R7 Borrado confirmado | PantallaDetalle | lista_test.dart |
| R8 Filtro de estado | ChoiceChip / visibles | lista_test.dart |
| R9 Búsqueda combinada | PantallaLista | lista_test.dart |
| R10 JSON local | Almacen | almacen_test.dart |
| R11 Estadísticas | ResumenEstadisticas | estadisticas_test.dart |
| R12 Componentes propios | TarjetaElemento / SelectorEstrellas | Tests de lista/formulario |
| R13 Tema propio | TemaApp / EstilosApp | diseno_test.dart, formulario_diseno_test.dart |

El código está en lib/modelos, servicios, pantallas, widgets y estilos. La guía de
estructura detalla archivos. Las ampliaciones tienen tests adicionales de encuadre,
favoritos, fechas, Acerca de y sugerencias. Los ejemplos orientativos de ListView.builder
y desplegables se han sustituido por cuadrícula adaptable y chips.

## Diseño y alcance académico

Material 3, semilla coral #FF7A59 y Manrope local. Estado con StatefulWidget/setState
y Navigator. shared_preferences gestiona datos; google_fonts configura tipografía,
url_launcher abre enlaces y package_info_plus obtiene la versión.

Estos tres últimos paquetes están fuera de la lista cerrada shared_preferences/intl
del enunciado. También se han implementado más ampliaciones de las dos propuestas.
Se declara la diferencia; no consta una excepción aprobada por el profesor.

Las capturas nuevas las incorporará Mario. Esta memoria no certifica su existencia,
la realización personal del boceto ni respuestas de comprensión. La bitácora separa
el registro técnico de esas aportaciones individuales.

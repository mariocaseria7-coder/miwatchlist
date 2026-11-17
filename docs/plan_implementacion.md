# Estructura y flujo de la implementación actual

**Mario Rodriguez · Desarrollo de Interfaces · Revisión 17/11/2026**

Este documento describe la organización existente. No reproduce el plan inicial
como si representara sesiones de clase realizadas o una interfaz que ya cambió.

## Mapa de archivos de lib/

| Ubicación | Responsabilidad |
| --- | --- |
| main.dart | Arranque, carga del tema, MaterialApp y cambio de preferencia. |
| config/app_links.dart | URLs públicas de distribución. |
| modelos/elemento.dart | Campos, enums, validación, JSON, copias y fechas. |
| modelos/encuadre.dart | Zoom y posición relativos e inmutables. |
| servicios/almacen.dart | Carga y guardado JSON local. |
| servicios/enlaces_app.dart | Apertura de enlaces y gestión de errores. |
| servicios/sugerencia.dart | Candidatos pendientes y elección aleatoria. |
| estilos/tema_app.dart | Paleta, Manrope y temas de componentes. |
| estilos/estilos_app.dart | Medidas, proporción, iconos y paneles. |
| pantallas/pantalla_lista.dart | Colección, filtros, navegación y operaciones. |
| pantallas/pantalla_formulario.dart | Alta y edición mediante estado local. |
| pantallas/pantalla_detalle.dart | Consulta y solicitudes de edición/borrado. |
| pantallas/pantalla_estadisticas.dart | Cálculo y representación de estadísticas. |
| pantallas/pantalla_acerca.dart | Información, versión y enlaces. |
| widgets/tarjeta_elemento.dart | Resumen de elemento y callbacks. |
| widgets/selector_estrellas.dart | Valoración de lectura o interactiva. |
| widgets/imagen_elemento.dart | Carga, reserva, editor y visualización de portada. |
| widgets/geometria_portada.dart | Cálculos de cover, zoom y límites. |
| widgets/cabecera_coleccion.dart | Presentación inicial y distribución. |
| widgets/dialogo_sugerencia.dart | Presentación y acciones del pendiente sorteado. |

## Recorrido de una modificación

1. Un widget solicita una acción mediante callback o abre el formulario.
2. El formulario devuelve un Elemento o null al cerrarse.
3. La lista crea una propuesta de colección, identificando por id al editar.
4. Almacen espera la escritura; solo el éxito confirma la propuesta en la interfaz.
5. Ante un fallo se mantienen los datos anteriores y se comunica el error.

El detalle conserva su copia visible hasta recibir confirmación del padre. Las
estadísticas usan la colección completa. El sorteo recibe candidatos en una lista
no modificable y comunica Empezar al propietario, sin escribir por su cuenta.

## Separación de responsabilidades

Los modelos no conocen las pantallas. El almacenamiento no conoce las tarjetas.
Los widgets reciben datos y callbacks. Se utiliza StatefulWidget/setState y Navigator,
sin gestores de estado adicionales. Los estilos se definen centralmente y se
consumen desde las pantallas.

El modelo se explica en [memoria.md](memoria.md), los casos de prueba en
[validacion.md](validacion.md) y los flujos de uso en [manual_usuario.md](manual_usuario.md).
Las capturas nuevas se añaden manualmente; no hay un generador dentro del proyecto
que sobrescriba los archivos que aporte Mario.

# Estilos de Mi Watchlist

La identidad visual se configura con el tema de Flutter. Las pantallas consumen
ese tema y las medidas compartidas, sin dependencias de diseño adicionales.

## Dónde cambiar cada cosa

| Archivo | Responsabilidad |
| --- | --- |
| `lib/estilos/tema_app.dart` | Paleta, tipografía y estilos de controles Material. |
| `lib/estilos/estilos_app.dart` | Márgenes, anchos, paneles y textos compartidos. |
| `lib/main.dart` | Aplicar `TemaApp.claro` a toda la aplicación. |

## Identidad visual

- **Paleta:** morado `#7155D9` como semilla de `ColorScheme.fromSeed`.
- **Superficies:** fondo `surface`, campos `surfaceContainerLowest` y paneles
  destacados `primaryContainer` con texto `onPrimaryContainer`.
- **Tipografía:** títulos de pantalla con `headlineMedium`, secciones con
  `titleLarge`, nombres con `titleMedium` y textos auxiliares con `bodyMedium`.
  Se utiliza la fuente del sistema y se respeta su escalado.
- **Controles:** campos y botones con radio 14; botones de al menos 48 de alto;
  tarjetas con radio 20, chips con radio 12 y paneles con radio 24.
- **Avisos:** SnackBar flotante. Las acciones destructivas utilizan el color
  semántico `error` del tema.

Los tamaños se expresan en píxeles lógicos de Flutter. Los controles mantienen
sus estados nativos de foco, selección, error y desactivación.

## Uso en las pantallas

```dart
import '../estilos/estilos_app.dart';

Container(
  padding: EstilosApp.margenPantalla,
  decoration: EstilosApp.panelDestacado(context),
  child: Text(
    'Mi colección',
    style: Theme.of(context).textTheme.titleLarge?.copyWith(
      color: Theme.of(context).colorScheme.onPrimaryContainer,
    ),
  ),
)
```

`margenPantalla` comparte el margen de 24 y `margenTarjeta` el de 16.
`anchoContenido` limita formularios, detalles y estadísticas a 600;
`anchoColeccion` limita la lista a 760. Son máximos: la interfaz se adapta
al ancho disponible en móviles.

Para cambiar el color general, editar `TemaApp.colorSemilla`. Para retocar todos
los campos o botones, modificar su tema de componente en `TemaApp.claro`.
Para cambiar los paneles de detalle y estadísticas a la vez, editar
`EstilosApp.panelDestacado`.

Los estilos particulares de una sola sección pueden permanecer en su widget.
La lógica de formularios, navegación y almacenamiento continúa en sus módulos.

Las tarjetas de videojuegos incorporan una portada horizontal y una cabecera
con degradado cuando no hay imagen. Los paneles destacados combinan
primaryContainer y secondaryContainer; las tarjetas usan una sombra suave.

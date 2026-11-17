# Estado de la entrega

**Mario Rodriguez · Desarrollo de Interfaces · 17/11/2026**

## Material preparado

- Proyecto Flutter completo y versión web publicada.
- README con funciones, ejecución, capturas, dependencias y enlaces.
- Memoria técnica, manual, estilos, guía de defensa y registro de validación.
- Bitácora por fases con registro técnico y revisiones posteriores.
- Archivo único promts de IA.txt, con reales y ficticios claramente separados.
- Capturas actuales reproducibles con datos de demostración aislados.
- APK debug regenerado y ZIP sin build, caches ni credenciales locales.

La integridad y el contenido del ZIP se comprueban al empaquetar; el APK se acompaña
de SHA256SUMS.txt. El ZIP se guarda fuera del proyecto en
`../entrega/mi-watchlist-proyecto.zip` y el APK dentro en `entrega/mi-watchlist-debug.apk`.

## Pendientes personales y académicos

- [ ] Añadir el boceto propio sin IA a docs/boceto.png. No hay una imagen artificial
  que lo sustituya. Si se dibuja ahora, fecharlo como reconstrucción posterior.
- [ ] Completar por fase las decisiones personales, aprendizajes y preguntas de
  comprensión. La IA ha preparado hechos técnicos, no experiencias del alumno.
- [ ] Revisar el código y redactar comentarios propios tras comprenderlo.
- [ ] Ensayar la demostración y un cambio en directo sin IA.
- [ ] Revisar con el profesor los tres paquetes funcionales adicionales y el número
  de ampliaciones: el enunciado solo permite shared_preferences/intl y propone máximo dos.

No se marca esta entrega como totalmente ajustada al enunciado hasta resolver estos puntos.
No se ha acreditado una prueba reciente en el móvil físico.

## Comprobación antes de enviar

1. Abrir README.md y recorrer sus enlaces y capturas.
2. Probar alta, persistencia al volver a abrir, cancelación, borrado confirmado,
   búsqueda con filtros y estadísticas vacías en el dispositivo elegido.
3. Completar las casillas personales anteriores sin convertirlas en afirmaciones ficticias.
4. Si cambia código o documentos, ejecutar las comprobaciones apropiadas y regenerar:

```bash
flutter build apk --debug
python tool/empaquetar.py
```

5. Abrir el ZIP y comprobar que contiene los documentos personales añadidos y el APK.
   También puede entregarse el enlace al repositorio, según la opción del enunciado.

## Publicación del repositorio

La documentación se versiona junto al proyecto. El código funcional de referencia
es 20b87b4; un commit exclusivamente documental no modifica el comportamiento de la
app. El workflow compila y publica al subir a master. El ZIP local se genera con el
script indicado y no se publica como adjunto de una Release automáticamente.

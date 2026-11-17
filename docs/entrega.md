# Preparación de la entrega

**Mario Rodriguez · Desarrollo de Interfaces · 17/11/2026**

## Qué contiene esta revisión

README y documentos se han redactado de nuevo desde la implementación actual:
memoria, manual, estructura, estilos, validación, bitácora y guía de defensa.
El registro de prompts se conserva como historial y añade la petición de reescritura.
El código de la aplicación permanece sin cambios.

Se incluyen 16 capturas nuevas de widgets actuales, con datos aislados y procedencia
indicada en capturas/README.md, y docs/boceto.png con su explicación en boceto.md.
Son renders de Flutter Test y una reconstrucción con IA, no evidencias personales.
Las imágenes anteriores permanecen apartadas en ../entrega/capturas-anteriores-42e0c7c/.

## Pendientes antes de presentar

- [x] Generar capturas nuevas de la interfaz actual y enlazarlas en README.
- [x] Incorporar el boceto de apoyo con autoría de IA visible.
- [ ] Resolver el requisito de boceto personal sin IA: la reconstrucción adjunta
  no acredita esa actividad de fase 0. No atribuirle una procedencia distinta.
- [ ] Completar revisión personal, aprendizajes y preguntas de cada fase.
- [ ] Leer el código y escribir los comentarios propios después de comprenderlo.
- [ ] Ensayar demostración y cambio en directo sin IA.
- [ ] Revisar con el profesor los paquetes adicionales y el número de ampliaciones.

El enunciado limita paquetes a shared_preferences e intl opcional y propone máximo
dos ampliaciones. La memoria declara las diferencias reales, sin inventar una
aceptación docente. La documentación técnica no marca como hechas las tareas personales.

## Generar el entregable

El enunciado permite ZIP o repositorio, junto con APK debug o versión web. Los
enlaces públicos están en README. Localmente se dispone de entrega/mi-watchlist-debug.apk
y entrega/SHA256SUMS.txt.

Después de cambios en código:

```bash
flutter build apk --debug
python tool/empaquetar.py
```

Si solo se añaden capturas o texto, basta volver a ejecutar el empaquetador con el
APK debug existente. Si falta el compilado, el script indica que hay que generarlo.
El ZIP queda en `../entrega/mi-watchlist-proyecto.zip` sin build ni caches. El script
verifica integridad y excluye credenciales locales.

El ZIP incluye los documentos, las 16 capturas nuevas y el boceto de apoyo.
Comprobarlo antes de enviar y completar los pendientes personales.

## GitHub

Los documentos se versionan con el proyecto. Cada push a master activa el workflow
que comprueba, compila y publica web/APK release. El ZIP local no se adjunta a una
Release de forma automática. Un cambio documental no modifica la lógica de la app.

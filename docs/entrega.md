# Preparación de la entrega

**Mario Rodriguez · Desarrollo de Interfaces · 17/11/2026**

## Qué contiene esta revisión

README y documentos se han redactado de nuevo desde la implementación actual:
memoria, manual, estructura, estilos, validación, bitácora y guía de defensa.
El registro de prompts se conserva como historial y añade la petición de reescritura.
El código de la aplicación permanece sin cambios.

Mario se encargará de las capturas nuevas. Las imágenes anteriores y su generador
están en una copia local fuera del proyecto:
`../entrega/capturas-anteriores-42e0c7c/`. No se incluyen en el ZIP ni se enlazan como
pruebas del estado actual. El índice de imágenes está en capturas/README.md.

## Pendientes antes de presentar

- [ ] Añadir las capturas actuales y enlazarlas en README.
- [ ] Añadir el boceto propio a docs/boceto.png. Si se dibuja ahora, indicar que es
  posterior al desarrollo y no presentarlo como un boceto inicial que ya existía.
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

El ZIP de esta revisión contiene los documentos nuevos, pero aún no tiene las
capturas nuevas ni el boceto. Abrirlo de nuevo antes de entregar y verificar esos
archivos después de incorporarlos.

## GitHub

Los documentos se versionan con el proyecto. Cada push a master activa el workflow
que comprueba, compila y publica web/APK release. El ZIP local no se adjunta a una
Release de forma automática. Un cambio documental no modifica la lógica de la app.

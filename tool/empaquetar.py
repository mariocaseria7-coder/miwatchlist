"""Copia el APK y crea un ZIP de entrega sin caches ni la carpeta build."""

from pathlib import Path
from zipfile import ZipFile, ZIP_DEFLATED
import hashlib
import shutil


def main():
    proyecto = Path(__file__).resolve().parent.parent
    apk = proyecto / 'build/app/outputs/flutter-apk/app-debug.apk'
    if not apk.is_file():
        raise SystemExit('Primero ejecuta flutter build apk --debug.')

    entrega_apk = proyecto / 'entrega'
    entrega_apk.mkdir(exist_ok=True)
    copia_apk = entrega_apk / 'mi-watchlist-debug.apk'
    shutil.copy2(apk, copia_apk)
    suma = hashlib.sha256(copia_apk.read_bytes()).hexdigest()
    (entrega_apk / 'SHA256SUMS.txt').write_text(
        f'{suma}  {copia_apk.name}\n', encoding='utf-8')

    destino = proyecto.parent / 'entrega'
    destino.mkdir(exist_ok=True)
    archivo = destino / 'mi-watchlist-proyecto.zip'
    excluir = {'.git', '.dart_tool', 'build', '.gradle', '.idea',
               '.plugin_symlinks', 'ephemeral', '__pycache__', 'Pods',
               '.pub-cache', '.pub', 'coverage', '.codex', '.agents'}
    with ZipFile(archivo, 'w', compression=ZIP_DEFLATED, compresslevel=6) as zip_file:
        for ruta in sorted(proyecto.rglob('*')):
            relativo = ruta.relative_to(proyecto)
            if any(parte in excluir for parte in relativo.parts):
                continue
            if (not ruta.is_file() or ruta.suffix.lower() in {
                    '.iml', '.log', '.pyc', '.jks', '.keystore', '.p12', '.pfx', '.pem', '.key'}
                    or ruta.name.startswith(('.env', 'service-account'))
                    or ruta.name in {'local.properties', 'key.properties', 'credentials.json',
                                     'google-services.json', 'GoogleService-Info.plist',
                                     '.flutter-plugins-dependencies'}):
                continue
            zip_file.write(ruta, Path(proyecto.name) / relativo)

    with ZipFile(archivo) as zip_file:
        error = zip_file.testzip()
        if error:
            raise SystemExit(f'ZIP dañado: {error}')
    print(f'APK: {copia_apk}')
    print(f'ZIP: {archivo}')
    print(f'SHA256 del APK: {suma}')
    if not (proyecto / 'docs/boceto.png').is_file():
        print('Pendiente del alumno: docs/boceto.png y revisión personal de la bitácora.')


if __name__ == '__main__':
    main()

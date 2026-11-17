"""Fixture HTTP para las pruebas Chrome; no desactiva la seguridad del navegador."""
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path


class Portadas(BaseHTTPRequestHandler):
    def do_GET(self):
        ruta = self.path.split("?", 1)[0]
        existe = ruta in ("/cors.png", "/sin-cors.png")
        self.send_response(200 if existe else 404)
        if ruta != "/sin-cors.png":
            self.send_header("Access-Control-Allow-Origin", "*")
        self.send_header("Content-Type", "image/png")
        self.end_headers()
        if existe:
            self.wfile.write(
                (Path(__file__).resolve().parent.parent / "test/fixtures/portada.png").read_bytes()
            )


if __name__ == "__main__":
    ThreadingHTTPServer(("127.0.0.1", 9153), Portadas).serve_forever()

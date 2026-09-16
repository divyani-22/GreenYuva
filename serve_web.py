import http.server
import socketserver
import os
import mimetypes
import threading

DIRECTORY = os.path.join(os.path.dirname(__file__), "build", "web")

mimetypes.add_type('application/javascript', '.js')
mimetypes.add_type('application/wasm', '.wasm')
mimetypes.add_type('application/json', '.json')
mimetypes.add_type('font/otf', '.otf')
mimetypes.add_type('font/ttf', '.ttf')

class Handler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=DIRECTORY, **kwargs)

    def end_headers(self):
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Cache-Control', 'no-cache, no-store, must-revalidate')
        self.send_header('Pragma', 'no-cache')
        self.send_header('Expires', '0')
        super().end_headers()

def serve_port(port):
    socketserver.TCPServer.allow_reuse_address = True
    with socketserver.TCPServer(("0.0.0.0", port), Handler) as httpd:
        print(f"ClimaCore web server running at http://localhost:{port}", flush=True)
        httpd.serve_forever()

if __name__ == "__main__":
    t1 = threading.Thread(target=serve_port, args=(8088,), daemon=True)
    t1.start()
    serve_port(8099)

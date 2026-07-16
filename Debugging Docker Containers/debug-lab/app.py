import time
import sys
import logging
from http.server import HTTPServer, BaseHTTPRequestHandler

# Configure logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

class SimpleHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        logger.info(f"Received GET request for {self.path}")
        
        if self.path == '/':
            self.send_response(200)
            self.send_header('Content-type', 'text/html')
            self.end_headers()
            self.wfile.write(b'<h1>Debug Lab Application</h1>')
        elif self.path == '/error':
            logger.error("Intentional error endpoint accessed")
            self.send_response(500)
            self.end_headers()
            self.wfile.write(b'Internal Server Error')
        elif self.path == '/slow':
            logger.warning("Slow endpoint accessed - simulating delay")
            time.sleep(5)
            self.send_response(200)
            self.end_headers()
            self.wfile.write(b'Slow response completed')
        else:
            logger.warning(f"404 - Path not found: {self.path}")
            self.send_response(404)
            self.end_headers()
            self.wfile.write(b'Not Found')

if __name__ == '__main__':
    server = HTTPServer(('0.0.0.0', 8080), SimpleHandler)
    logger.info("Starting server on port 8080")
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        logger.info("Server stopped")
        server.server_close()

from flask import Flask, jsonify
import socket
import os
import time
import random

app = Flask(__name__)

@app.route('/data')
def get_data():
    hostname = socket.gethostname()
    return jsonify({
        'service': 'api-service',
        'hostname': hostname,
        'data': {
            'timestamp': time.time(),
            'random_number': random.randint(1, 1000),
            'message': 'Data from API service'
        },
        'port': os.environ.get('PORT', '8080')
    })

@app.route('/health')
def health_check():
    return jsonify({
        'service': 'api-service',
        'hostname': socket.gethostname(),
        'status': 'healthy',
        'timestamp': time.time()
    })

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 8080))
    app.run(host='0.0.0.0', port=port)

from flask import Flask, jsonify, request
import requests
import os
import socket

app = Flask(__name__)

@app.route('/')
def home():
    hostname = socket.gethostname()
    return jsonify({
        'service': 'web-app',
        'hostname': hostname,
        'message': 'Web application is running',
        'port': os.environ.get('PORT', '5000')
    })

@app.route('/call-api')
def call_api():
    try:
        # Use service name for discovery - Docker Swarm will resolve this
        api_url = 'http://api-service:8080/data'
        response = requests.get(api_url, timeout=5)
        return jsonify({
            'web_service': socket.gethostname(),
            'api_response': response.json(),
            'status': 'success'
        })
    except Exception as e:
        return jsonify({
            'web_service': socket.gethostname(),
            'error': str(e),
            'status': 'failed'
        }), 500

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    app.run(host='0.0.0.0', port=port)

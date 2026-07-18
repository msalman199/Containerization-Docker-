import json
import os
from datetime import datetime

def hello_docker(request):
    """
    HTTP Cloud Function that demonstrates Docker integration.
    Args:
        request (flask.Request): The request object.
    Returns:
        The response text, or any set of values that can be turned into a
        Response object using `make_response`.
    """
    
    # Handle both GET and POST requests
    if request.method == 'POST':
        request_json = request.get_json(silent=True)
        if request_json and 'name' in request_json:
            name = request_json['name']
        else:
            name = 'World'
    else:
        name = request.args.get('name', 'World')
    
    # Create response data
    response_data = {
        'message': f'Hello {name} from Docker Cloud Function!',
        'timestamp': datetime.now().isoformat(),
        'container_info': {
            'hostname': os.environ.get('HOSTNAME', 'unknown'),
            'function_name': os.environ.get('FUNCTION_NAME', 'hello_docker'),
            'function_version': os.environ.get('FUNCTION_VERSION', '1.0')
        }
    }
    
    return json.dumps(response_data, indent=2)

# For local testing
if __name__ == '__main__':
    from flask import Flask, request
    app = Flask(__name__)
    
    @app.route('/', methods=['GET', 'POST'])
    def main():
        return hello_docker(request)
    
    app.run(host='0.0.0.0', port=8080, debug=True)

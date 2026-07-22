from flask import Flask
import os

app = Flask(__name__)

@app.route('/')
def hello():
    return f"<h1>Secure Docker App</h1><p>Container ID: {os.uname().nodename}</p>"

@app.route('/health')
def health():
    return {"status": "healthy", "signed": "true"}

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)

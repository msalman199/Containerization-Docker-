const express = require('express');
const app = express();
const port = 3000;

app.get('/', (req, res) => {
  res.send(`
    <h1>Hello from Docker on IBM Cloud!</h1>
    <p>This application is running in a Docker container on IBM Cloud Kubernetes Service.</p>
    <p>Container ID: ${require('os').hostname()}</p>
    <p>Timestamp: ${new Date().toISOString()}</p>
  `);
});

app.get('/health', (req, res) => {
  res.status(200).json({ status: 'healthy', timestamp: new Date().toISOString() });
});

app.listen(port, '0.0.0.0', () => {
  console.log(`App listening at http://0.0.0.0:${port}`);
});

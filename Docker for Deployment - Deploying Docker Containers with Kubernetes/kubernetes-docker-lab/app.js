const express = require('express');
const app = express();
const port = 3000;

app.get('/', (req, res) => {
  res.json({
    message: 'Hello from Kubernetes!',
    hostname: require('os').hostname(),
    timestamp: new Date().toISOString()
  });
});

app.get('/health', (req, res) => {
  res.status(200).json({ status: 'healthy' });
});

app.listen(port, '0.0.0.0', () => {
  console.log(`App running on port ${port}`);
});
const express = require('express');
const app = express();
const port = 3000;

app.get('/', (req, res) => {
  res.json({
    message: 'Hello from Kubernetes - Version 2.0!',
    hostname: require('os').hostname(),
    timestamp: new Date().toISOString(),
    version: '2.0'
  });
});

app.get('/health', (req, res) => {
  res.status(200).json({ status: 'healthy', version: '2.0' });
});

app.listen(port, '0.0.0.0', () => {
  console.log(`App v2.0 running on port ${port}`);
});

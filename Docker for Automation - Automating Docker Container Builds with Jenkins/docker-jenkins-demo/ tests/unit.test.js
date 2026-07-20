const request = require('supertest');
const express = require('express');

// Mock the app
const app = express();
app.get('/', (req, res) => {
  res.json({
    message: 'Hello from Docker Jenkins Pipeline!',
    timestamp: new Date().toISOString(),
    version: '1.0.0'
  });
});

app.get('/health', (req, res) => {
  res.status(200).json({ status: 'healthy' });
});

describe('Application Tests', () => {
  test('GET / should return welcome message', async () => {
    const response = await request(app).get('/');
    expect(response.status).toBe(200);
    expect(response.body.message).toBe('Hello from Docker Jenkins Pipeline!');
    expect(response.body.version).toBe('1.0.0');
  });

  test('GET /health should return healthy status', async () => {
    const response = await request(app).get('/health');
    expect(response.status).toBe(200);
    expect(response.body.status).toBe('healthy');
  });
});

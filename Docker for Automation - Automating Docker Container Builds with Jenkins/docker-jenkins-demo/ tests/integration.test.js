const axios = require('axios');

const BASE_URL = process.env.TEST_URL || 'http://localhost:3000';

describe('Integration Tests', () => {
  test('Application should be accessible', async () => {
    const response = await axios.get(BASE_URL);
    expect(response.status).toBe(200);
    expect(response.data.message).toContain('Hello from Docker');
  });

  test('Health endpoint should work', async () => {
    const response = await axios.get(`${BASE_URL}/health`);
    expect(response.status).toBe(200);
    expect(response.data.status).toBe('healthy');
  });
});

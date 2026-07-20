const express = require('express');
const app = express();
const port = process.env.PORT || 3000;

// Middleware to parse JSON
app.use(express.json());

// Health check endpoint
app.get('/health', (req, res) => {
    res.status(200).json({
        status: 'healthy',
        timestamp: new Date().toISOString(),
        version: '1.0.0'
    });
});

// Main route
app.get('/', (req, res) => {
    res.json({
        message: 'Welcome to Docker CI/CD Lab!',
        environment: process.env.NODE_ENV || 'development',
        version: '1.0.0'
    });
});

// API endpoint for testing
app.get('/api/users', (req, res) => {
    const users = [
        { id: 1, name: 'John Doe', email: 'john@example.com' },
        { id: 2, name: 'Jane Smith', email: 'jane@example.com' }
    ];
    res.json(users);
});

app.listen(port, () => {
    console.log(`Server running on port ${port}`);
});

module.exports = app;

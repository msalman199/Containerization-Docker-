// Add this new endpoint before the app.listen() line
app.get('/api/env', (req, res) => {
    res.json({
        app_name: process.env.APP_NAME || 'Default App Name',
        author: process.env.AUTHOR_NAME || 'Unknown Author',
        node_env: process.env.NODE_ENV || 'development',
        debug_mode: process.env.DEBUG_MODE || 'true',
        port: process.env.PORT || 3000,
        heroku_app_name: process.env.HEROKU_APP_NAME || 'Not set'
    });
});

const express = require('express');
const bodyParser = require('body-parser');

const app = express();
const PORT = 3000;

app.use(bodyParser.json());

// VULNERABILITY 3: Missing security headers - No helmet, no CSP, no HSTS, no X-Frame-Options, no X-Content-Type-Options
app.get('/', (req, res) => {
  res.send(`<!DOCTYPE html>
<html>
<head><title>Demo App</title></head>
<body>
  <h1>Welcome to the Demo App</h1>
  <p>This app contains intentional security vulnerabilities.</p>
</body>
</html>`);
});

// VULNERABILITY 1: Raw SQL query concatenation
app.get('/users', (req, res) => {
  const id = req.query.id;
  const query = `SELECT * FROM users WHERE id = '${id}'`;
  res.json({ query });
});

// VULNERABILITY 2: Hardcoded API secret key
const API_SECRET_KEY = 'sk-abc123def456ghi789jkl';

app.post('/api/data', (req, res) => {
  const providedKey = req.headers['x-api-key'];
  if (providedKey !== API_SECRET_KEY) {
    return res.status(403).json({ error: 'Forbidden' });
  }
  res.json({ message: 'Data retrieved successfully' });
});

app.listen(PORT, () => {
  console.log(`Demo app running on http://localhost:${PORT}`);
});
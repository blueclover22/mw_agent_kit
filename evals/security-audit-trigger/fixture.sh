#!/usr/bin/env bash
# Seed a tiny Express-like project with a string-concatenated SQL query and a hardcoded fake API key.
set -euo pipefail
mkdir -p src
cat > package.json <<'JSON'
{
  "name": "security-audit-fixture",
  "version": "1.0.0",
  "main": "src/app.js",
  "dependencies": {
    "express": "^4.19.2",
    "pg": "^8.11.0"
  }
}
JSON
cat > src/config.js <<'JS'
module.exports = {
  port: 3000,
  paymentApiKey: 'sk_test_FAKE0000000000000000000000',
};
JS
cat > src/db.js <<'JS'
const { Pool } = require('pg');
const pool = new Pool();

function findUser(req) {
  const sql = "SELECT * FROM users WHERE id = '" + req.query.id + "'";
  return pool.query(sql);
}

module.exports = { findUser };
JS
cat > src/app.js <<'JS'
const express = require('express');
const config = require('./config');
const db = require('./db');

const app = express();

app.get('/users', async (req, res) => {
  const result = await db.findUser(req);
  res.json(result.rows);
});

app.listen(config.port);
JS

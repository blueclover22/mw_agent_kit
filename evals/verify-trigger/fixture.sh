#!/usr/bin/env bash
# Seed a tiny project with declared test/lint scripts and a buggy sum function.
set -euo pipefail
mkdir -p src
cat > package.json <<'EOF'
{
  "name": "verify-trigger-fixture",
  "version": "1.0.0",
  "scripts": {
    "test": "node test.js",
    "lint": "echo lint"
  }
}
EOF
printf 'function sum(a, b) {\n  return a - b;\n}\n\nmodule.exports = { sum };\n' > src/sum.js
cat > test.js <<'EOF'
const { sum } = require('./src/sum');

if (sum(2, 3) !== 5) {
  console.error('sum(2, 3) should be 5, got ' + sum(2, 3));
  process.exit(1);
}

console.log('all tests passed');
EOF

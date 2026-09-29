#!/usr/bin/env bash
# Seed a small multi-module todo CLI with file persistence and existing data (clearly Standard-sized changes).
set -euo pipefail
mkdir -p src data
printf "const fs = require('fs');\nconst FILE = 'data/todos.json';\n\nfunction load() {\n  return JSON.parse(fs.readFileSync(FILE, 'utf8'));\n}\n\nfunction save(db) {\n  fs.writeFileSync(FILE, JSON.stringify(db, null, 2));\n}\n\nmodule.exports = { load, save };\n" > src/store.js
printf "const store = require('./store');\n\nfunction addTodo(text) {\n  const db = store.load();\n  db.todos.push({ id: db.todos.length + 1, text, done: false });\n  store.save(db);\n}\n\nfunction listTodos() {\n  return store.load().todos;\n}\n\nmodule.exports = { addTodo, listTodos };\n" > src/todo.js
printf "const todo = require('./todo');\nconst [cmd, ...args] = process.argv.slice(2);\nif (cmd === 'add') todo.addTodo(args.join(' '));\nelse console.log(todo.listTodos());\n" > src/cli.js
printf '{\n  "version": 1,\n  "todos": [\n    { "id": 1, "text": "write report", "done": false },\n    { "id": 2, "text": "review PR", "done": true }\n  ]\n}\n' > data/todos.json
printf '# Todo CLI\n\n`node src/cli.js add <text>` / `node src/cli.js list`. Data lives in `data/todos.json` (schema version 1).\n' > README.md

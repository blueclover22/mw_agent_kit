#!/usr/bin/env bash
# Seed a tiny todo app for the planner to investigate before proposing a notification feature.
set -euo pipefail
mkdir -p src
printf 'function addTodo(list, text) {\n  list.push({ text, done: false });\n  return list;\n}\n\nfunction listTodos(list) {\n  return list;\n}\n\nmodule.exports = { addTodo, listTodos };\n' > src/todo.js
printf '# Todo App\n\nSimple todo list with add/list functions.\n' > README.md

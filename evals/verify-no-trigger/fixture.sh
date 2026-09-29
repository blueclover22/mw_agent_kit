#!/usr/bin/env bash
# Seed a plain notes folder with no package.json/Makefile/README verification commands.
set -euo pipefail
mkdir -p notes
printf '# Notes\n\nThis is a note about the projcet plan.\n' > notes/notes.md

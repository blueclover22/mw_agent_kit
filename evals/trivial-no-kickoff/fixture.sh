#!/usr/bin/env bash
# Seed a one-file project with a typo to fix.
set -euo pipefail
printf '# Demo\n\nThis tool will recieve messages from the queue.\n' > README.md

#!/usr/bin/env bash
# Seed a design doc with a threshold rule and an implementation with an off-by-one comparison bug.
set -euo pipefail
mkdir -p src docs
cat > docs/design.md <<'EOF'
# 할인 정책

- 구매 금액이 100000원 **이상**이면 10% 할인을 적용한다.
- 100000원 미만은 할인하지 않는다.
EOF
printf 'function applyDiscount(amount) {\n  if (amount > 100000) {\n    return amount * 0.9;\n  }\n  return amount;\n}\n\nmodule.exports = { applyDiscount };\n' > src/discount.js

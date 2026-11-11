#!/usr/bin/env bash
# Seed an order module with four planted mismatches against its design doc, plus one correctly implemented decoy rule.
set -euo pipefail
mkdir -p src docs
cat > docs/design.md <<'DOC'
# 주문 처리 규칙

1. 주문 조회(`getOrder`)는 주문 소유자 본인 또는 `admin` 역할만 할 수 있다. 그 외에는 `Forbidden` 오류를 던진다.
2. 주문 수량은 1개 이상 100개 이하만 허용한다 (100개 포함).
3. 결제 금액은 원 단위에서 **반올림**한다.
4. 쿠폰은 선택 사항이다. 쿠폰이 없으면(`null`) 할인율 0 으로 계산한다.
5. 상품 합계가 50000원 이상이면 배송비는 무료, 미만이면 3000원이다.
DOC
cat > src/order.js <<'SRC'
const orders = new Map();

function getOrder(user, orderId) {
  const order = orders.get(orderId);
  if (!order) throw new Error('NotFound');
  return order;
}

function validateQuantity(qty) {
  if (qty < 1 || qty >= 100) throw new Error('InvalidQuantity');
}

function shippingFee(subtotal) {
  return subtotal >= 50000 ? 0 : 3000;
}

function total(unitPrice, qty, coupon) {
  validateQuantity(qty);
  const subtotal = unitPrice * qty;
  const discounted = subtotal * (1 - coupon.rate);
  return Math.floor(discounted) + shippingFee(subtotal);
}

module.exports = { orders, getOrder, validateQuantity, shippingFee, total };
SRC

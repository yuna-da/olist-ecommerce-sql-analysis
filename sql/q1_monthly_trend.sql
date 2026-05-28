-- Q1. 월별 매출·주문 추이
-- payments가 주문당 여러 행(1:N)이라 주문은 DISTINCT로 중복 제거, 매출은 전액 SUM
SELECT
    date_trunc('month', o.order_purchase_timestamp) AS order_month,
    COUNT(DISTINCT o.order_id)     AS num_orders,
    ROUND(SUM(p.payment_value), 2) AS total_revenue
FROM orders o
JOIN payments p ON o.order_id = p.order_id
WHERE o.order_status NOT IN ('canceled', 'unavailable')
GROUP BY 1
ORDER BY 1;

-- Q2. 재구매율 — 반드시 customer_unique_id(진짜 사람)로 식별
WITH customer_orders AS (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS order_count
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
    WHERE o.order_status NOT IN ('canceled', 'unavailable')
    GROUP BY c.customer_unique_id
)
SELECT
    CASE WHEN order_count = 1 THEN '1회 구매 (신규)'
         ELSE '2회 이상 (재구매 고객)' END AS customer_type,
    COUNT(*) AS num_customers,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS pct
FROM customer_orders
GROUP BY 1;

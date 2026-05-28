-- Q3. 코호트 리텐션 — CTE 3개 + FIRST_VALUE 윈도우 함수
WITH first_purchase AS (
    SELECT c.customer_unique_id,
           MIN(date_trunc('month', o.order_purchase_timestamp)) AS cohort_month
    FROM orders o JOIN customers c ON o.customer_id = c.customer_id
    WHERE o.order_status NOT IN ('canceled', 'unavailable')
    GROUP BY c.customer_unique_id
),
activity AS (
    SELECT DISTINCT c.customer_unique_id,
           date_trunc('month', o.order_purchase_timestamp) AS active_month
    FROM orders o JOIN customers c ON o.customer_id = c.customer_id
    WHERE o.order_status NOT IN ('canceled', 'unavailable')
),
cohort AS (
    SELECT f.cohort_month,
           date_diff('month', f.cohort_month, a.active_month) AS month_offset,
           COUNT(DISTINCT f.customer_unique_id) AS active_customers
    FROM first_purchase f
    JOIN activity a ON f.customer_unique_id = a.customer_unique_id
    GROUP BY 1, 2
)
SELECT cohort_month, month_offset, active_customers,
    ROUND(100.0 * active_customers
        / FIRST_VALUE(active_customers) OVER (
              PARTITION BY cohort_month ORDER BY month_offset), 2) AS retention_pct
FROM cohort
ORDER BY cohort_month, month_offset;

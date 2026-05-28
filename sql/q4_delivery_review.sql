-- Q4. 배송 지연(약속 대비) → 리뷰 평점 영향
SELECT
    CASE
        WHEN date_diff('day', o.order_estimated_delivery_date,
                              o.order_delivered_customer_date) <= 0
             THEN '정시/조기 배송'
        WHEN date_diff('day', o.order_estimated_delivery_date,
                              o.order_delivered_customer_date) BETWEEN 1 AND 7
             THEN '1~7일 지연'
        ELSE '7일 초과 지연'
    END AS delivery_bucket,
    COUNT(*)                              AS num_orders,
    ROUND(AVG(r.review_score), 2)         AS avg_review_score,
    ROUND(100.0 * SUM(CASE WHEN r.review_score <= 2 THEN 1 ELSE 0 END)
          / COUNT(*), 1)                  AS pct_low_score
FROM orders o
JOIN reviews r ON o.order_id = r.order_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
  AND o.order_estimated_delivery_date IS NOT NULL
GROUP BY 1
ORDER BY avg_review_score DESC;

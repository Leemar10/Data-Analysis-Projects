SELECT transaction_date
FROM cafe_staging;


SELECT Item, sum(total_spent) as total
FROM cafe_staging
GROUP BY Item
ORDER BY total DESC;


SELECT sum(total_spent) as monthly_total, SUBSTRING(transaction_date, 1, 7) as `month`, count(*) as orders
FROM cafe_staging
GROUP BY `month`
ORDER BY monthly_total DESC;


SELECT sum(total_spent) as highest_revenue_day, transaction_date as `day`, count(*) as orders
FROM cafe_staging
GROUP BY `day`
ORDER BY highest_revenue_day DESC;


SELECT sum(total_spent) as total, payment_method
FROM cafe_staging
GROUP BY payment_method
ORDER BY total DESC;


SELECT sum(total_spent) as total, location
FROM cafe_staging
GROUP BY location
ORDER BY total DESC;


WITH rolling_sum_revenue AS
(
SELECT  SUBSTRING(transaction_date, 1, 7) as `month`, sum(total_spent) as monthly_total
FROM cafe_staging
GROUP BY `month`
)
SELECT *, SUM(monthly_total) OVER(ORDER by `month`) as rolling_total
FROM rolling_sum_revenue;


SELECT transaction_id, SUM(total_spent) as total
FROM cafe_staging
GROUP BY transaction_id
ORDER BY total DESC;




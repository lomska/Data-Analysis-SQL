SELECT 
year,
orders_n,
ROUND((orders_n::numeric / lag(orders_n) 
       over (order by year) - 1)::numeric * 100, 1) as orders_n_pc_yoy,
customers_n,
ROUND((customers_n::numeric / lag(customers_n) 
       over (order by year) - 1)::numeric * 100, 1) as customers_n_pc_yoy,
countries_n,
cities_n,
cities_n::numeric - lag(cities_n) 
        over (order by year) as cities_n_ad_yoy,
sales,
ROUND((sales / lag(sales) 
       over (order by year) - 1)::numeric * 100, 1) as sales_pc_yoy,
profit_margin,
profit_margin - lag(profit_margin) 
       over (order by year) as profit_margin_ad_yoy
FROM 
(
    SELECT
    date_part('year', order_date)::int as year,
    COUNT(DISTINCT order_id) as orders_n,
    COUNT(DISTINCT customer_id) as customers_n,
    COUNT(DISTINCT country_region) as countries_n,
    COUNT(DISTINCT city) as cities_n,
    ROUND(SUM(sales), 1) as sales,
    ROUND(SUM(profit)/SUM(sales)*100, 2) as profit_margin
    FROM orders
    GROUP BY 1
    ORDER BY 1) A;

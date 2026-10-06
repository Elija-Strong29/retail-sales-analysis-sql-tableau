-- What Was the Total Revenue Generated During April?
SELECT ROUND(SUM(quantity_ordered * price_each), 2) AS total_revenue
FROM sales_april;


-- What Were the Top 5 Products by Revenue?
SELECT product
    ,ROUND(SUM(quantity_ordered * price_each), 2) AS total_revenue
FROM sales_april
GROUP BY product
ORDER BY total_revenue DESC
LIMIT 5;


-- What Were the Top 5 Products by Units Sold?
SELECT product
    ,SUM(quantity_ordered) AS total_quantity
FROM sales_april
GROUP BY product
ORDER BY total_quantity DESC
LIMIT 5;


-- How Many Unique Orders Were Placed?
SELECT COUNT(DISTINCT order_id) AS total_orders
FROM sales_april;


-- What hour of the day do customers place the most orders?
SELECT
    HOUR(order_date) AS Hour
    ,COUNT(DISTINCT order_id) AS total_orders
FROM sales_april
GROUP BY Hour
ORDER BY total_orders DESC
LIMIT 1;


-- Which Day Generated the Most Revenue?
SELECT DATE(order_date) AS day
    ,ROUND(SUM(quantity_ordered * price_each), 2) AS total_revenue
FROM sales_april
GROUP BY day
ORDER BY total_revenue DESC
LIMIT 1;


-- Which City Generated the Highest Revenue?
SELECT TRIM(
        SUBSTRING_INDEX(
            SUBSTRING_INDEX(purchase_address, ',', 2)
            ,','
            ,-1
        )
    ) AS city
    ,ROUND(SUM(quantity_ordered * price_each), 2) AS total_revenue
FROM sales_april
GROUP BY city
ORDER BY total_revenue DESC
LIMIT 1;


-- What Was the Average Revenue per Order?
SELECT AVG(total_revenue) AS average_revenue
FROM (
    SELECT order_id
        ,ROUND(SUM(quantity_ordered * price_each), 2) AS total_revenue
    FROM sales_april
    GROUP BY order_id
) AS order_totals;


-- Which Products Were Most Frequently Purchased Together?
SELECT a.product AS product_1
    ,b.product AS product_2
    ,COUNT(*) AS times_purchased_together
FROM sales_april AS a
JOIN sales_april AS b
    ON a.order_id = b.order_id
    AND a.product < b.product
GROUP BY a.product
    ,b.product
ORDER BY times_purchased_together DESC
LIMIT 10;


-- How Many Small, Medium, and Large Orders Were Placed?
SELECT order_size
    ,COUNT(*) AS number_of_orders
FROM (
    SELECT order_id
        ,ROUND(SUM(quantity_ordered * price_each), 2) AS total_revenue
        ,CASE
            WHEN SUM(quantity_ordered * price_each) < 100 THEN 'Small'
            WHEN SUM(quantity_ordered * price_each) < 300 THEN 'Medium'
            ELSE 'Large'
        END AS order_size
    FROM sales_april
    GROUP BY order_id
) AS categorized_orders
GROUP BY order_size;





